---
layout: post
title:	"Title"
category: [Games, Programming, Networking, DOS]
excerpt: A short description of the article
image: public/images/buttons/large/ahmygod.gif
comment_id: 72374862398476
---



### networking

use latency to upstream servers as a memory buffer, similar to delay-line memory
  * [magnetostrictive delay line memory](https://en.wikipedia.org/wiki/Delay-line_memory)
  * optical delay line in optical computing: https://ieeexplore.ieee.org/document/10675424


hmmm, what's cheaper, vps memory or network transit?

Two nodes, primary and reflector
maximal latency
UDP


### storage

Goals:

* Store data in original format
* Store additional metadata and updates

Flatten application layers where things run locally but delegate to upstream servers to enrich data.
data types:
  * primary: the raw data created by an application, data near the user.
  * secondary: meta-data generated from a single set of primary data
  * tertiary: combination and correlation across primary and secondary data sets

Folder Structure:

```
item
  data
    *.*
  metadata
    generated-index.json
    *.*
```








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
