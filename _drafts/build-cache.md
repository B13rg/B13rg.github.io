---
layout: post
title:	"Build Caching Systems"
category: [Programming]
excerpt: A short description of the article
---

While working on [kr8+](https://github.com/ice-bergtech/kr8), I wanted to add a build cache to speed up building large projects, especially when changes only affect a small portion of the codebase.


## Docker Layers

On build cache I was already aware of was Docker layers.
As part of the docker build process, each layer of the image is hashed and cached.
If the same layer already exists as part of a previous build, it will be reused instead of recretaed.
It determines if a cached layer is valid by checking if the same command has been rn against the same context before.
The context contains the base image and files, along with build environment properties like env vars and image args.

During a build when, a cached layer is detected as invalid, it will also invalidate all layers that are placed on top.

As a result of this caching system, dockerfile often include idiomatic code to better separate layers and place more stable layers earlier in the build process.
One example often seen in python and golang images is pre-loading libraries/modules before the rest of the source code.
The library references are usually modified less than the code itself, leading better caching and faster image builds.

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

# Copy source files over and build
COPY . .
RUN go build
```


https://useful.codes/understanding-image-layers-and-caching-in-docker/

https://docs.docker.com/build/cache/

## General notes

* hash all input files
* hash output files?
* process each file once
* have way to clear/prune cache https://www.justanotherdot.com/posts/avoid-build-cache-bloat-by-sweeping-away-artifacts.html

https://rushjs.io/pages/maintainer/build_cache/

Things I liked:


* "output preservation" or "cache restoration".
* output preservation handles by incremental build analyzer
  * If no input files were modified compared to the previous build, then the project is skipped.
  * Violated by tampering with output files
* cache restoration
  * query cache based on inputs to determine if output files can be replaced by cache 
* separate cache folder, keeps it all in one place.
* Store in a single targz file?
* Also able to check in to source control
* consumes gitignore

incremental builds: https://rushjs.io/pages/advanced/incremental_builds/

* 

## Implementations in other languages

CMake https://otero.gitbooks.io/cmake-complete-guide/content/chapter-3.html - 
* stores at the variable level
* 


## What I Implemented








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
