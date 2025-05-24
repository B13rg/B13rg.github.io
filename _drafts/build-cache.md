---
layout: post
title:	"Build Caching Systems"
category: [Programming]
excerpt: "This post explores Docker's build caching system using BuildKit and LLB to optimize layer reuse via metadata-based hashing, alongside RushJS's incremental builds and cache restoration for monorepos, emphasizing strategies to minimize redundant work. Key takeaways include metadata-driven caching, context management, and tools for efficient artifact reuse across complex projects."
---

While working on [kr8+](https://github.com/ice-bergtech/kr8), I wanted to add a build cache to speed up building large projects, especially when changes only affect a small portion of the codebase.


## Docker Build Caching

One build cache system I was already aware of was Docker layers.
A docker image result and build cache can be represented as a singly linked list of layers.
Each layer is a dockerfile instruction that is dependent on the layers that come before it.
As part of the docker build process, each layer is cached.
If the same layer is already cached, it can be reused instead of recreated.

From the Duckduckgo:

  * Docker Docs: [Build Cache](https://docs.docker.com/build/cache/)
  * Useful.codes: [Understanding Image Layers and Caching in Docker](https://useful.codes/understanding-image-layers-and-caching-in-docker/)

Docker determines if a cached layer is valid by checking:

* layer instruction: `FROM`, `RUN`, `COPY`, etc.
* layer build context
* layers that came before
* build arguments

The layer build context documentation seemed rather vague, with the [Context docs](https://docs.docker.com/build/concepts/context/) stating the context is made up of the files and directories sent to the builder.
I was curious

Based on the [Docker Image Specification v1.2.0](https://github.com/moby/docker-image-spec/blob/v1.2.0/v1.2.md).
Each layer is tracked based on it's `DiffID`, then the layer diff IDs are stored in the image's `rootfs` field, "in order from bottom-most to top-most":

> Layers are referenced by cryptographic hashes of their serialized representation.
> This is a SHA256 digest over the tar archive used to transport the layer, represented as a hexadecimal encoding of 256 bits, e.g., sha256:a9561eb1b190625c9adb5a9513e72c4dedafc1cb2d4c5236c9a6957ec7dfd5a9.
> Layers must be packed and unpacked reproducibly to avoid changing the layer ID, for example by using tar-split to save the tar headers.
> Note that the digest used as the layer ID is taken over an uncompressed version of the tar. 

The Docker documentation references using [Buildx](https://github.com/docker/buildx) as the default image building backend, which provides files and input to BuildKit which performs the actual image build.
The Docker docs [Build Overview](https://docs.docker.com/build/concepts/overview/) and [BuildKit](https://docs.docker.com/build/buildkit/) cover these topics from a high-level perspective.

I was curious what specific data was processed by Buildx and BuildKit to create the cache layers so I dug into them to see how it was implemented in practice.
After getting lost in the buildx code and not seeing any actual caching happening, I found that the actual caching operation was is performed by [BuildKit](https://github.com/moby/buildkit), separate from Buildx.
The [Buildkit intro post](https://blog.mobyproject.org/introducing-buildkit-17e056cc5317) provides an overview of BuildKit's methodologies early capabilities.

While being built, the image data is converted into a "build definition format" [LLB](https://pkg.go.dev/github.com/moby/buildkit/client/llb) (low-level builder).
LLB allows defining complex build definitions through a content-addressable dependency DAG (directed, acyclic graph).
The protobuf definition is located at [buildkit/solver/pb/ops.proto](https://github.com/moby/buildkit/blob/master/solver/pb/ops.proto).
As the graph is being created, "branches" can be pruned based on cache validity.
To perform the build, the program simply walks the graph visiting all nodes.

<details>
<summary>Getting sidetracked and lost in Buildx state structs</summary>
  <div markdown="1">

At the "edge" of the docker build code, build context seems to be represented by the `Inputs` struct in [buildx/build/build.go](https://github.com/docker/buildx/blob/542bda49f2b25f32fa424c3dc50f5b9b5c50d280/build/build.go#L106) as a set of paths, file info, and context states.

The definition of a state from [buildx/localstate/localstate.go](https://github.com/docker/buildx/blob/542bda49f2b25f32fa424c3dc50f5b9b5c50d280/localstate/localstate.go#L23), and is created from the same `buildOpts` that are used to create the layer.

```golang
// https://github.com/docker/buildx/blob/542bda49f2b25f32fa424c3dc50f5b9b5c50d280/localstate/localstate.go#L23
type State struct {
	// Target is the name of the invoked target (default if empty)
	Target string
	// LocalPath is the absolute path to the context or remote context
	LocalPath string
	// DockerfilePath is the absolute path to the Dockerfile or relative if
	// context is remote
	DockerfilePath string
	// GroupRef is the ref of the state group that this ref belongs to
	GroupRef string `json:",omitempty"`
}

// Stored as GroupRef in State struct
type StateGroup struct {
	// Targets are the targets invoked
	Targets []string `json:",omitempty"`
	// Refs are used to track all the refs that belong to the same group
	Refs []string
}
```

The refs are first allocated during the "baking" process, as part of the `saveLocalStateGroup` function.
This takes place _before_ the layer is built.
The function is passed the same parameters used to create the layer:

```golang
// https://github.com/docker/buildx/blob/542bda49f2b25f32fa424c3dc50f5b9b5c50d280/commands/bake.go#L526
func saveLocalStateGroup(dockerCli command.Cli, in bakeOptions, targets []string, buildOpts map[string]build.Options) error {
	l, err := localstate.New(confutil.NewConfig(dockerCli))

  // ... checks + metadata provenance mode settings ...

	groupRef := identity.NewID() // <--------- state group identifier
	refs := make([]string, 0, len(buildOpts))
	for k, b := range buildOpts {
		b.Ref = identity.NewID()  // <--------- state group item identifier
		refs = append(refs, b.Ref)
		// ... update build options ...
	}

  // ... checks ...

	return l.SaveGroup(groupRef, localstate.StateGroup{
		Refs:    refs,
		Targets: targets,
	})
}
```

The cache entry is defined as a `localstate.StateGroup`, with each `buildOpt` used to create the layer stored as well.

The identity is generated by [moby/buildkit/identity](https://github.com/moby/buildkit/blob/5d47024a21ec128c8caf7af2ab4b83d63d9a4094/identity/randomid.go#L43), which is  just a `big.Int` of random bytes: (with consts applied) `(&big.Int{}).SetBytes(p[:]).Text(36)[1 : 25+1]`.

A core piece of build (and cache context state) is the `buildOpts` var, which contains most of the inputs used to build the layer.
It is defined as an `Options` struct in [buildx/build/build.go](https://github.com/docker/buildx/blob/542bda49f2b25f32fa424c3dc50f5b9b5c50d280/build/build.go#L62).

The `buildOpt`s for each layer is generated by `tobuildOpt()` in [buildx/bake/bake.go](https://github.com/docker/buildx/blob/542bda49f2b25f32fa424c3dc50f5b9b5c50d280/bake/bake.go#L1298).

For each layer the `Options` struct used to configure the build is used to [construct a `BuildOpt`](https://github.com/docker/buildx/blob/542bda49f2b25f32fa424c3dc50f5b9b5c50d280/bake/bake.go#L1298), which in turn is used to generate the cache entry.

This is all for initializing the cache entry, which takes place before the build happens.
The cache ends up actually being created as part of the build managed by [Buildkit](https://github.com/moby/buildkit).

</div>
</details>

### BuildKit/LLB File Hashing

Each layer of the docker image contains an instruction to execute.
A [Stack Overflow](https://stackoverflow.com/questions/71887067/how-are-docker-buildx-layer-cache-hashes-calculated) answer pointed out different instructions have different cache considerations.
The aspect I was most interested in was discovering how file hashes were calculated.
Modifying a file used in a layer will invalidate the layer, but from experience I've found not all properties of a file are considered.
For example, after a `docker build` takes place, you can `touch` referenced files to update their timestamp without invalidating the layer cache.

Generating context entries for files and directories is performed in [buildkit/cache/contenthash/checksum.go](https://github.com/moby/buildkit/blob/5d47024a21ec128c8caf7af2ab4b83d63d9a4094/cache/contenthash/checksum.go#L868) is used to calculate the file checksums.
`Checksum()` calls [`prepareDigest(fp, p string, fi os.FileInfo)`](https://github.com/moby/buildkit/blob/5d47024a21ec128c8caf7af2ab4b83d63d9a4094/cache/contenthash/checksum.go#L1206).
Using file info derived from `os.LStat()`, it passes this to [`NewFileHash(path string, fi os.FileInfo) hash.Hash`](https://github.com/moby/buildkit/blob/5d47024a21ec128c8caf7af2ab4b83d63d9a4094/cache/contenthash/filehash.go#L16).

This function copies parts of the `fi` param into a `fsutil.types.Stat` struct which in turn is placed into a `archive/tar` [`Header`](https://cs.opensource.google/go/go/+/refs/tags/go1.24.3:src/archive/tar/common.go;drc=bc7c35a6d3bb0074d07beebedc0afcbdcebb8d3f;l=147) struct by [`tar.FileInfoHeader()`](https://cs.opensource.google/go/go/+/refs/tags/go1.24.3:src/archive/tar/common.go;drc=bc7c35a6d3bb0074d07beebedc0afcbdcebb8d3f;l=647).

An interesting aspect of this conversion (and why we can `touch` files) is that only a portion of the `Header` fields are set by BuildKit.
A hash is then generated from this header and a [tarsumHash struct](https://github.com/moby/buildkit/blob/5d47024a21ec128c8caf7af2ab4b83d63d9a4094/cache/contenthash/filehash.go#L79) is returned.
The header that is hashed is generated by [`WriteV1TarsumHeader()`](https://github.com/moby/buildkit/blob/5d47024a21ec128c8caf7af2ab4b83d63d9a4094/cache/contenthash/tarsum.go#L12), which generates a `v1TarHeader` from file [GNU tar Extended File Attributes](https://www.gnu.org/software/tar/manual/html_node/Extended-File-Attributes.html) and `v0TarHeader` information:

```golang
// https://github.com/moby/buildkit/blob/5d47024a21ec128c8caf7af2ab4b83d63d9a4094/cache/contenthash/tarsum.go#L21C1-L36C2
func v0TarHeaderSelect(h *tar.Header) (orderedHeaders [][2]string) {
	return [][2]string{
		{"name", h.Name},
		{"mode", strconv.FormatInt(h.Mode, 10)},
		{"uid", strconv.Itoa(h.Uid)},
		{"gid", strconv.Itoa(h.Gid)},
		{"size", strconv.FormatInt(h.Size, 10)},
		{"mtime", strconv.FormatInt(h.ModTime.UTC().Unix(), 10)},
		{"typeflag", string([]byte{h.Typeflag})},
		{"linkname", h.Linkname},
		{"uname", h.Uname},
		{"gname", h.Gname},
		{"devmajor", strconv.FormatInt(h.Devmajor, 10)},
		{"devminor", strconv.FormatInt(h.Devminor, 10)},
	}
}
```

The `tarsumHash` struct is interesting, in that it is a customized `hash.Hash` implementation.
It has a special [`Reset()`](https://github.com/moby/buildkit/blob/5d47024a21ec128c8caf7af2ab4b83d63d9a4094/cache/contenthash/filehash.go#L85) function that when called resets the hash state to default, then "primes" the hash object with header properties in the V1 tarsum format.

This code flow is interesting because only the file metadata is processed, not the contents of the file.
Only once the header hash been generated then the file contents are hashed.

---

### Docker Takeaways

Docker builds are processes by BuildKit, which creates a DAG of build steps and layers.
The resources and properties required to generate the layer, including references to the previous layer, are included in the graph of a docker image build.
BuildKit is able to prune subgraphs (layers/work) from the graph by comparing nodes to stored cache entries.

As a result of the build graph caching system, dockerfile often include idiomatic code to better separate layers and place more stable (unchanging) layers earlier in the build process.
One example often seen in python and golang images is pre-loading libraries/modules before the rest of the source code.
The library references are usually modified less than the code itself, leading better caching and faster image builds.

<details>
<summary>Dockerfile bind mount examples</summary>
  <div markdown="1">

```dockerfile
FROM python:3
WORKDIR /src

# Temporarily use requirements.txt
RUN --mount=type=bind,source=requirements.txt,target=/tmp/requirements.txt \
    pip install --requirement /tmp/requirements.txt

# Now copy over rest of code in a new layer
COPY . .
# continue...
```

and in golang:

```dockerfile
FROM go:1.24
WORKDIR /src

# Download modules first
RUN --mount=type=bind,source=go.mod,target=/src/go.mod \
    # including the go.sum file ensures the downloaded modules match what we expect.
    --mount=type=bind,source=go.sum,target=/src/go.sum \
    go mod download

# Copy project files over and build
COPY . .
RUN go build
```

</div>
</details>

As part of the build-level caching, files are a core part of the cache.
I found that not all aspects of the file are considered when cached.

Specific to docker's file caching:

* File contents
* File name, mode, size, type, 
* File _Modified Time_
* uid/gid, uname/gname
* Any additional [GNU tar Extended File Attributes](https://www.gnu.org/software/tar/manual/html_node/Extended-File-Attributes.html) (custom name-value pairs associated with file)

To help inform developers on how to best interact with the cache, the docker doc [Optimize cache usage in builds](https://docs.docker.com/build/cache/optimize/#keep-the-context-small) exists.
It covers a few ways to improve cache performance, including:

* [layer ordering](https://docs.docker.com/build/cache/optimize/#order-your-layers)- things with more frequent changes should be placed nearer to the end of the dockerfile.
* [minimizing context](https://docs.docker.com/build/cache/optimize/#keep-the-context-small) - Use `.dockerignore` to minimize files included in the build context.
* [use bind mounts](https://docs.docker.com/build/cache/optimize/#use-bind-mounts) - minimize extra copy instructions prepping files for later instructions
* [Use cache mounts](https://docs.docker.com/build/cache/optimize/#use-cache-mounts) - cache mounts allow adding  specific files to the cache.  This cache is interesting because unlike the layer cache, it does not depend on previous layers.  It is stored outside the build, and sharable across multiple builds.
* [Use external cache](https://docs.docker.com/build/cache/optimize/#use-an-external-cache) - By default, the cache is specific to the builder instance being used.  An external cache allows defining a remote cache source.  This is most often seen in CI/CD pipelines, and allows easy reuse across workflows.  More information can be found in the [Cache storage backends](https://docs.docker.com/build/cache/backends/) doc.

## RushJS Build Caching

Another build tool I investigated was [RushJS](https://rushjs.io/pages/intro/welcome/), a tool used to building and managing many NPM packages from a single repo.
It is part of the [Rush Stack](https://rushstack.io/) family of projects, which is managed by [Microsoft](https://github.com/microsoft/rushstack).
Along with managing dependencies, it uses caching and incremental builds to speed up building projects, especially those with complex dependency chains.

The article [Enabling the build cache](https://rushjs.io/pages/maintainer/build_cache/) describes the caching design and methodology.
Rush uses two types of strategies for limiting build work:

* [Incremental build](https://rushjs.io/pages/advanced/incremental_builds/) analyzer that enables skipping projects whose file contents have not changed since the last build.  This does not preserve build output.
* "cache restoration", where tar archives of project build artifacts are restored from cache.

### Incremental Builds

incremental builds: https://rushjs.io/pages/advanced/incremental_builds/

The incremental build system allows `rush build` to skip projects that are up to date.
The "update to date" rules are:

1. The project has already been built locally, AND
2. Its input files and NPM dependencies have not changed since then, AND
3. If the project depends on any other Rush projects, those projects are up to date as well, AND
4. The command line parameters haven't changed. (For example, invoking `rush build --production` after `rush build` would require rebuilding.)

It respects and `.gitignore` files in the project folder
Configuration options are stored in [<your project>/config/rush-project.json](https://rushjs.io/pages/configs/rush-project_json/) 

Changes to input files are determined by file content hashes.
All other file metadata seems to be completely ignored.
Since modifying a filename would require modifying the files that references it, creating a soft-requirement to have matching filenames.

This feature does not concern itself with build outputs, so if all the inputs match the cache then the rest of the build for that piece is skipped.
If the build artifacts are modified outside of the build process they will remain modified even if a build is skipped.

### Cache Restoration

The cache storage is file-based and stored separate from source control.
It is default-disabled, and is configured by [common/config/rush/build-cache.json](https://rushjs.io/pages/configs/build-cache_json/).
Since Rush is designed for large monorepos, the cache is stored in `common/temp/build-cache` by default.
They do note that the folder can be manually placed outside the repository to share between projects.
Cache is also able to be centrally stored in a "cloud-hosted storage container" that can be accessed by users.
The options are `azure-blog-storage`, `amazon-s3`, and `http`.
It seems to be compatible with any storage that speaks `aws-s3`.
The `http` provider allows using a normal webserver to serve cache objects.

The cache entry is keyed on various project inputs:

* Hashes of source files that are under the project's folder, ignoring any files excluded by `.gitignore`
* Hashes of source files under other workspace projects that are dependencies of the project. This applies to cache restoration strategy but not output preservation strategy
* the versions of all external NPM packages that your project depends on, including indirect dependencies
* the Rush command-line parameters used to perform the operation

It also allows for fine-grained configuration of the cache key in the [<your project>/config/rush-project.json](https://rushjs.io/pages/configs/rush-project_json/) and [common/config/rush/build-cache.json](https://rushjs.io/pages/configs/build-cache_json/) files.
This allows one to specify environment variables and additional files/glob patterns that should be considered.
The `cacheEntryNamePattern`is able to configured to also include tokens such as `[os]` or`[arch]`, but must always contain a `[hash]` token.

### RushJS Takeaways

Things I liked:

* multi-pronged approach to analyze different parts of the build
  * separate incremental build and output caching actions
* output preservation calculated by the incremental build analyzer, and applied by the build cache.
  * If no _input_ files were modified compared to the previous build, then the project is skipped.
  * Doesn't concern itself with build artifacts
* cache restoration
  * query cache based on inputs to determine if output files can be replaced by cached+compressed build artifacts
* file-based cache storage
  * separate cache folder that can be shared across projects
  * provides integrations to remote storage options
  * Also able to check in to source control
  * Build cache artifacts stored in compressed tar files
* Cache is keyed on input file hashes, lib versions, build parameters, and optional ENV vars.
* respects `.gitignore` files

## Additional thoughts

* hash all input files, ignoring most file metadata 
* hash output files?
* process each file once
* have way to clear/prune cache https://www.justanotherdot.com/posts/avoid-build-cache-bloat-by-sweeping-away-artifacts.html

https://rushjs.io/pages/maintainer/build_cache/



## Other build caching systems of note

* CMake https://otero.gitbooks.io/cmake-complete-guide/content/chapter-3.html - cache keyed to the variable level





<!-- Image example
![MS-DOS Family Tree](/images/folder/filename.png){:width="700px"}
-->
<!-- Link example -->
[Link to full-size image](/images/buttons/large/ahmygod.gif)

Footnote[^1]

<details>
  <summary>One more quick hack? 🎭</summary>
  <div markdown="1">
  → Easy  
  → And simple
  </div>
</details>


<!-- Separator -->
---

[^1]: Further information here


