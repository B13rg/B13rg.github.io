---
layout: post
title:	"Title"
category: [Games, Programming, Networking, DOS]
excerpt: A short description of the article
image: public/images/buttons/large/ahmygod.gif
comment_id: 72374862398476
---

Spec: https://docs.mlcommons.org/croissant/docs/croissant-spec.html

Website: https://mlcommons.org/working-groups/data/croissant/

Intro:

> Datasets are the basis of machine learning (ML). However, a lack of standardization in the description and semantics of ML datasets has made it increasingly difficult for researchers and practitioners to explore, understand, and use all but a small fraction of popular datasets.
> 
> The Croissant metadata format simplifies how data is used by ML models. It provides a vocabulary for dataset attributes, streamlining how data is loaded across ML frameworks such as PyTorch, TensorFlow or JAX. In doing so, Croissant enables the interchange of datasets between ML frameworks and beyond, tackling a variety of discoverability, portability, reproducibility, and responsible AI (RAI) challenges.

The croissant format roughly consists of 3 parts:

| Type                | Desc.                                                                                 | Objects                            |
| ------------------- | ------------------------------------------------------------------------------------- | ---------------------------------- |
| metadata            | information about the dataset, including description, source, licensing, and keywords | `Dataset`                          |
| resources           | information about the raw files/filesets contained in the dataset                     | `FileObject`, `FileSet`,           |
| structure+semantics | data structure and resource processing guides                                         | `RecordSet`, `Field`, `DataSource` |


![alt text](images/croissant/croissant-1-spec.png)


Join

data structures possible and not possible













<!-- Kramdown syntax: https://kramdown.gettalong.org/syntax.html -->

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
