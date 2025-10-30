---
layout: post
title:	"Notes on the Croissant 1.0 Dataset Spec"
category: [Programming]
excerpt: The croissant spec is designed to provide a standard way to describe datasets properties, raw file relationships, and derived dataset attributes.

---

Spec: https://docs.mlcommons.org/croissant/docs/croissant-spec.html

Website: https://mlcommons.org/working-groups/data/croissant/

TRTL Lang Definition: [github.com/mlcommons/croissant/docs/croissant.ttl](https://github.com/mlcommons/croissant/blob/main/docs/croissant.ttl)

The Croissant spec is designed to provide a standard way to describe datasets properties, raw file relationships, and derived dataset attributes.

> The Croissant metadata format simplifies how data is used by ML models.
> It provides a vocabulary for dataset attributes, streamlining how data is loaded [...]
> Croissant enables the interchange of datasets between ML frameworks and beyond, tackling a variety of **discoverability**, **portability & reproducibility**, and **responsible AI** challenges.

For this post I mostly analyzed version 1.0

The Croissant format roughly consists of 3 parts:

| Type                | Desc.                                                                                 | Objects                            |
| ------------------- | ------------------------------------------------------------------------------------- | ---------------------------------- |
| metadata            | information about the dataset, including description, source, licensing, and keywords | `Dataset`                          |
| resources           | information about the raw files/filesets contained in the dataset                     | `FileObject`, `FileSet`,           |
| structure+semantics | data structure and resource processing guides                                         | `RecordSet`, `Field`, `DataSource` |


![A simplified diagram of the Croissant spec](/images/croissant/croissant-1-spec.png)
> A simplified diagram of the Croissant spec


## Metadata


Builds on [schema.org/Dataset](https://docs.mlcommons.org/croissant/docs/croissant-spec.html#schemaorgdataset).
<details>
  <summary>Croissant 1.0 Required Metadata Properties</summary>
  <div markdown="1">

>[Source](https://docs.mlcommons.org/croissant/docs/croissant-spec.html#required)

The following list of properties from schema.org must be specified for every Croissant dataset.

| Property       | ExpectedType         | Cardinality | Comments                                                                                                                                              |
| -------------- | -------------------- | ----------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| @context       | URL                  | ONE         | A set of JSON-LD context definitions that make the rest of the Croissant description less verbose. See the recommended JSON-LD context in Appendix 1. |
| @type          | Text                 | ONE         | The type of a Croissant dataset must be schema.org/Dataset.                                                                                           |
| dct:conformsTo | URL                  | ONE         | Croissant datasets must declare that they conform to the versioned schema: http://mlcommons.org/croissant/1.0                                         |
| description    | Text                 | ONE         | Description of the dataset.                                                                                                                           |
| license        | CreativeWork, URL    | MANY        | The license of the dataset. Croissant recommends using the URL of a known license, e.g., one of the licenses listed at https://spdx.org/licenses/.    |
| name           | Text                 | ONE         | The name of the dataset.                                                                                                                              |
| url            | URL                  | ONE         | The URL of the dataset. This generally corresponds to the Web page for the dataset.                                                                   |
| creator        | Organization, Person | MANY        | The creator(s) of the dataset.                                                                                                                        |
| datePublished  | Date, DateTime       | ONE         | The date the dataset was published.                                                                                                                   |

  </div>
</details>

The metadata for the dataset is stored in the root of the Croissant file.
A URL is required to link to where the dataset can be found.
While only one can be set, there is also a `sameAs` field that allows pointing to matching datasets with different URLs (http, s3, ipfs, onion, etc). 

A `keywords` field allows adding text and links about the dataset, perfect for tags or references.

Versioning and `isLiveDataset` attributes allow the dataset the change over time.
Changes to the dataset should be constrained to updating or creating, not deleting.
It is best utilized to add additional data and improve `RecordSet` information.
If the structure of the data is also changing it is probably better to create new, separate datasets.

## Resources

Resources refer to the actual files of the dataset.
Items are either a `FileObject` or a `FileSet`.
A `FileObject` is a single item, and `FileSet` is one or more items matching a glob pattern.

They are able to reference each other via the `containedIn` property.
This is useful for referencing compressed files like `.zip` and `.tar.gz`.
A `Fileset` entry and be created for the contents of a `.zip`, which is stored as a `FileObject`.
This allows for storing the dataset compressed with the Croissant file guiding individual file extraction.

## RecordSets

> A RecordSet describes a set of structured records obtained from one or more data sources (typically a file or set of files) and the structure of these records, expressed as a set of fields (e.g., the columns of a table). A RecordSet can represent flat or nested data.

`RecordSets` do not reference resources directly.
Instead, they group `Field`s together which in turn reference resources.
This allows `RecordSets` to span multiple files, though that  definitely introduces additional complexity.

The `Field` object encodes information about dataset fields such as name, types, and extraction method.
They are able to reference other `Field`s and `RecordSet`s to represent complex data relationships.
Each field has a `source` property that references either a `DataSource` object or a URL.
`DataSource` link a `Field` to associated `RecordSet`s and `File*` resources, acting as a focal point describing what's required to view a given `RecordSet`.

The `RecordSet`-related types are primarily designed for column data, but the referencing allows for describing more complex data structures.
An open-ended `data` field allows encoding data as JSON and reference it from `Field`s for properties like enums and categories.

## Ecosystem Tools

There is of course the [spec repository](https://github.com/mlcommons/croissant/tree/main) which contains the code for:

* [mlcroissant](https://github.com/mlcommons/croissant/tree/main/python/mlcroissant) Python library, with [cli tool](https://github.com/mlcommons/croissant/blob/main/python/mlcroissant/mlcroissant/scripts/validate.py)
* [web editor](https://github.com/mlcommons/croissant/tree/main/editor), which is live at [huggingface.co/spaces/MLCommons/croissant-editor](https://huggingface.co/spaces/MLCommons/croissant-editor) with login
* links to Croissant [tools integrations](https://github.com/mlcommons/croissant#integrations)

## Conclusion

Most of what I found focused on using Croissant files in data pipelines, not creating them.
Dataset management. tools and platforms integrate Croissant as plugins to the system instead of creating distinct Croissant tools.
A Croissant file is not the primary dataset management format for applications.
Instead, it is positioned as an interchange format for datasets. 


Potential changes:

* how to use with homomorphic encryption 

Planned changes: https://github.com/orgs/mlcommons/projects/44/views/1

* Make spec encompass the lifetime of the dataset instead of a snapshot.
* defining and using custom "data-level annotations" 
* Reference other  downstream/upstream datasets
* Add additional dataset structure vocabulary (n-dimensional arrays, geo-spacial, AV)
