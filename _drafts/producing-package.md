---
layout: post
title:	"Title"
category: [Programming]
excerpt: A short description of the article
image: public/images/buttons/large/ahmygod.gif
comment_id: 72374862398476
---

Notes on developing and releasing a package.

Based on things done to setup [kr8+](https://github.com/ice-bergtech/kr8).


## Building

### scripting common tasks

Setup taskfile to capture setup and common commands.
Similar to a makefile, but a little more verbose.

### Generating documentation

Writing documentation is difficult because of how quickly it can become out of date.
By generating documentation directly from source code it will accurately reflect the current state of the code.

[Godoc]() is useful for documenting go code, extracts descriptions via comments.
Lots of tools in how it parses, [reference docs]()


generate further documentation for specific modules, like cobra command line.

package all documentation up and publish into docs site for easy consumption.

### Tests

go test.
integration tests.
examples generated with tool

organizing code

## formatting

`.editorconfig` to standardize spacing.

automated formatters in editors and part of build process.

## linting

attributing

licenses

## Releasing

### Setting up homebrew tap

official docs

repo naming convention

### configuring goreleaser

https://webinstall.dev/goreleaser/

#### Github Personal Access Token (PAT)

Fine-grained.

Read access to:

* actions
* variables
* environments
* issues
* metadata
* secrets

Read and Write access to:

* actions
* code
* commit statuses
* pull requests 

Also limited repository access to just the repos that matter

### Actions and Workflows Automation















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
