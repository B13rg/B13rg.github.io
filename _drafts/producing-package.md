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


### Formatting

`.editorconfig` to standardize spacing.

Add automated formatters in editors and part of build process.

Consistent function and variable naming.

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

### Organizing Code

the code may work correctly but it is important that it is organized.
This means grouping functions in a way that 

### Tests

Starting from 0 is difficult.
Start with the "edges" of the code:

* Packages and functions that provide core functionality
* User-interaction layer, to compare inputs to expected outputs.

Test outside of the code with integration tests.
Test the interactions users and other tools will make.

This provides a final check to make sure the tool operates as it's supposed to.
In the case of kr8+ it was valuable to generate examples with the tool.
It showed how to actually use the tool and ensures the tool is working as expected.


### Attributing

Properly attribute sources of code.
Call out contributors.
Code references.
Other projects.

### Licenses

True OSS licenses are preferred.

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

Run same tests developer would run.















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
