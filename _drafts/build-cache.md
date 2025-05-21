---
layout: post
title:	"Title"
category: [Programming]
excerpt: A short description of the article
---

## Before knowledge

Docker-layers
hash each layer and the result to tell when it needs to re-generate

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
