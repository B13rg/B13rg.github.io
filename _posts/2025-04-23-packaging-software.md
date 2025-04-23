---
layout: post
title:	"Packaging and Releasing a Software Project"
category: [Programming]
excerpt: This is a collection of notes and thoughts on developing and releasing an open source software package.
---

![Le Quai des Pâquis à Genève - Jean-Baptiste-Camille Corot - 1842](/images/softwarePkg/Le-Quai-des-Pâquis-à-Genève.jpg)

This is a collection of notes and thoughts on developing and releasing an open source software package.
It is based on the process I went through releasing [kr8+](https://github.com/ice-bergtech/kr8), a golang tool that processes jsonnet into output files.

## Readme.md

The readme is usually the first thing a module consumer sees.

It should provide a simple, succinct summary of what the tools does and who it is meant for.
It should funnel the dense information from code and docs into an easy-to-understand format.
Writing a readme is an entire process, beyond this article.

[Art of README](https://github.com/hackergrrl/art-of-readme) describes the properties of a good readme and goals it should try to achieve.
A useful guide/spec that digs into key element is [Richart Litt's standard-readme spec](https://github.com/RichardLitt/standard-readme/blob/main/spec.md).

Form a high-level, the important sections are:

* Description - what it is, what it does, what it solves
* Background - why it exists
* User Installation and usage - How to install and use
* Documentation links - Where to learn more about functionality
* Developer Setup - How to get the repo setup locally and contribute
* License information - Note licenses used by the code.

## Building

### Scripting Common Tasks

Any common commands that a developer runs should be committed alongside the code.
It helps make sure everyone is running the same tests and commands and (hopefully) getting the same results.

In the case of kr8+, I setup a taskfile to capture setup and common commands.
It is similar to a makefile, but a little more verbose and structured as a yaml file.

When documenting these common commands, make sure you capture:

* Dev environment setup - tools, submodules
* Building - code, docs
* Testing - unit / integration tests

[kr8+ example](https://github.com/ice-bergtech/kr8/blob/main/Taskfile.yml)

### Generating documentation

Writing documentation is difficult because of how quickly it can become out of date.
By generating documentation directly from source code it will accurately reflect the current state of the code.
It should be treated as an additional artifact of the code, and always generated along with binaries.

[Godoc](https://pkg.go.dev/golang.org/x/tools/cmd/godoc) is useful for documenting Golang code.
It extracts comments and formats then into a friendly html file.

There are sometimes tool or framework-specific tool that can generate further documentation.
In golang, cobra has tools to generate docs for commands.
This is great for creating documentation targeted towards end users.
Once generated, the documentation should be published in a way that is easy to consume for the intended audience.
Tools like [MkDocs](https://www.mkdocs.org/getting-started/) package up markdown files into a standard website.

Here's example of generating package docs for [kr8+](https://github.com/ice-bergtech/kr8/blob/main/docs/docs.go).

## Organizing Code

Organize into logical partitions.
Group similar functionality together, and 
Create clear boundaries of ownership within the code and helps reduce mental load when reasoning about functionality.

Separate user-facing code from internal logic.

Extract functions
Keep function short and to the point.

### Tests

Tests ensure the program is doing what you think it does.
They should be created at different points horizontally across functions and vertically across code layers.

Starting from 0 is difficult, 
Focus on package "root" and "leaf" functions and work your way in.

* Packages and functions that provide core functionality
* User-interaction layer, to compare inputs to expected outputs.

Test outside of the code with integration tests.
Make sure the built tool operates as expected on a basic level.
Test the interactions users and other tools will make.
They can also verify assumptions the code makes like the existence of certain external resources.

This provides a final check to make sure the tool operates as it's supposed to.
In the case of kr8+ it was valuable to generate examples with the tool.
It showed how to actually use the tool and ensures the tool is working as expected.

## Formatting

Standard formatting makes it easier to read code through a consistent style throughout the codebase.
It can also act as a "soft barrier" to change requests, ensuring basic checks have been made.

Automated formatters in editors and part of build process to keep things standard.
It frees up the writer to focus on the code instead of properly balancing tabs and braces.

An [.editorconfig](https://editorconfig.org/) file can help "maintain consistent coding styles for multiple developers working on the same project across various editors and IDEs".
It is mostly editor-agnostic, though some like vscode require a [plugin](https://open-vsx.org/extension/EditorConfig/EditorConfig).

[kr8+ example](https://github.com/ice-bergtech/kr8/blob/main/.editorconfig)

### Linting

Use tools that can be easily configured and ran.
Very language specific,
For golang there's [golangci-lint](https://golangci-lint.run/welcome/install/) which packages up various tools.

I find it is useful to have the linting tool generate a summary output file, and check that into source control.
It's not always reasonable to fix every single issue, especially on a WIP branch.
If you create exceptions, make them as specific as possible to avoid swallowing unrelated issues.

Some of the golang ones I found most useful:

* `exhaustruct` - makes sure struct fields are all initialized.  Enabled as needed to check.
* `funlen`/`cyclop`/`gocognit` - help identify complex functions that should be refactored and split up.
*  `dupl` - detect duplicate fragments of code
*  `gochecknoglobals` - minimize global variables
*  `gosec`/`govet` - find potential security problems

[kr8+ example](https://github.com/ice-bergtech/kr8/blob/main/.golangci.yml)

## Attributing/Licenses

Properly attribute sources of code.
Call out contributors.

Code references.
Add links to references for code.
Even once the links rot, they can still provide some context for confusing chunks of code.

Finally, it can be useful to link to other similar projects.
good for comparing functionality, and provides easy links in the future to discover ways to improve your own project.

True OSS licenses are preferred.

## Releasing

With the code done up with a bow, it's time to consider making it widely available.
Packages can be published in a variety of formats, so choose one that is more ergonomic for your end users.

In the case of kr8+, I opted for a homebrew tap to enable easy installation on Mac and Linux.

### Setting up Homebrew Tap

A tap is just a repo with some special files in it.
[official docs](https://docs.brew.sh/How-to-Create-and-Maintain-a-Tap)

Homebrew taps do have a special naming convention, where if a repo is hosted on github "we recommend that the repository’s name start with `homebrew-` so the short `brew tap` command can be used".
Unless you are making multiple taps, it is easiest to just name the repo `homebrew-tap`.

Use the `brew tap-new` command to initialize a starter repo.
Update the readme and license as needed.
In the case of publishing kr8+, I never interact with the repo directly, instead it is used as a target for GoReleaser builds.

Once setup, users will reference the tap in the format `brew install <username>/tap/<formula>` (in the case of github>) or the longer `brew install <repo url>/<formula>`.

[kr8+ example](https://github.com/ice-bergtech/homebrew-tap)

### Configuring GoReleaser

GoReleaser "is a release automation tool.
It currently supports Go, Rust, Zig, and TypeScript (with Bun and Deno)."a tool that packages and releases Golang code in a variety of output formats."
Documentation for configuring is [here](https://goreleaser.com/customization/).

For kr8+ it was configured to produce:

* Build packages for `linux` and `darwin`
* `tar.gz` archives 
* `rpm`, `deb`, and `apk` packages.
* SBOM and Checksums
* Publish package to homebrew

Additionally, automation was setup to only run the full build+publish when a new git tag is added.

[kr8+ example](https://github.com/ice-bergtech/kr8/blob/main/.goreleaser.yml)

#### Github Personal Access Token (PAT)

For publishing on github with automation, you should create a [Personal Access Token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens).
It can be stored as a repo secret and be consumed by automation to enable publishing release artifacts.
In the case of kr8+, it uses GoReleaser to publish the artifacts to a [homebrew tap](https://github.com/ice-bergtech/homebrew-tap) in a separate repo.

To create the fine-grained token, navigate to [github.com/settings/personal-access-tokens](https://github.com/settings/personal-access-tokens).

the token will require:

Read access to:

* metadata
* secrets
* variables* environments
* issues

Read _and_ Write access to:

* code
* pull requests 
* commit statuses
* actions

Also valuable to limit what repositories the token can access to limit blast radius if things go sideways.
When in doubt, it's often easier to create a new token instead of trying to get an existing one to work properly.

### Actions and Workflows Automation

Run same tests and checks a developer would run.
Make sure everything checks out, especially after merging into main.
In cases of formatting actions, it can be valuable to allow modifying PRs to provide quick fixes to an annoying issue.

### Golang pkgsite

Part of the golang ecosystem is part of the golang documentation system.
It allows publishing package documentation in a central place.
It will parse the project repo and extract documentation just like Godoc.
You can learn more on it's [about page](https://pkg.go.dev/about).

To add a package, navigate to https://pkg.go.dev/<repo> and you can click a button to have the repo scraped.
You can also sync it by using `proxy.golang.org` as a proxy when fetching a module.
For example:

```sh
GOPROXY=https://proxy.golang.org GO111MODULE=on go install github.com/ice-bergtech/kr8@v0.0.8
```

[kr8+ example](https://pkg.go.dev/github.com/ice-bergtech/kr8)

## Other Random Things

* Project logo - A image to associate with the project
* Changelog.md - A list of past changes between version - [kr8+ example](https://github.com/ice-bergtech/kr8/blob/main/CHANGELOG.md)
* Features.md - A list of current project features and functionality - [kr8+ example](https://github.com/ice-bergtech/kr8/blob/main/FEATURES.md)
* Roadmap.md - A list of future planned projects and improvements - [kr8+ example](https://github.com/ice-bergtech/kr8/blob/main/ROADMAP.md)
* Project domain - A custom domain to host docs
* Funding - github sponsors, librepay, patreon etc.

## Conclusion

Releasing a project includes a lot of things beyond the raw code.
There are a lot of supporting pieces that should be in place to best service the end user.
When preparing a project it is important to analyze it through different perspectives.
You should consider all the types of end users that may view the project and what they find important.
The added context and documentation helps users solve their issues faster and hopefully on their own.

Finally, always be improving a project but also know when to move on.
It is better to whole-ass one thing instead of half-assing two things.

## References

* [kr8+](https://github.com/ice-bergtech/kr8)
* [EditorConfig](https://editorconfig.org/)
* [MkDocs](https://www.mkdocs.org/getting-started/)
* [Kube Documentation Style guide](https://kubernetes.io/docs/contribute/style/style-guide/)
* [Golangci-lint](https://golangci-lint.run/)
* [GoReleaser](https://goreleaser.com/customization/)
* [Using GoReleaser - Carlos Becker](https://carlosbecker.com/posts/goreleaser-rust-zig/)
* [Homebrew docs](https://docs.brew.sh/)

