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
