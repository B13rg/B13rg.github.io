---
layout: post
title:	"Properties and Patterns of Good Algorithms"
category: [Programming]
excerpt: A short description of the article
image: public/images/buttons/large/ahmygod.gif
comment_id: 72374862398476
---

Algorithms should strive for balance.
Data should flow like water through the system software and hardware.

These properties may not apply to every algorithm created, but they are useful as considerations when attempting to derive an algorithm for a problem.

## Simple - Does only what it needs to

Avoid unnecessary features, but balance the minimalism with practicality.
Don't solve every problem, but enough that you can get things done.

* [Simplicity of IRC - Susam Pal](https://web.archive.org/web/20220815032635/https://susam.net/maze/wall/simplicity-of-irc.html)
* [htmx sucks - Carson Gross](https://htmx.org/essays/htmx-sucks/)

## Performant - Balance time/space efficiency and resource utilization

Adding more resources improves performance, to a point.

Parallelism, pipelining, and serialization are common design patterns to spread work across resources.

* “If you’re running out of memory, you can buy more. But if you’re running out of time, you’re screwed.” - Programming Perl
* [Simulating Time with Square-Root Space - Ryan Williams](https://arxiv.org/abs/2502.17779)

## Predictable - predictable performance and behavior characteristics _over runtime_

Best / Average / Worst performance of the algorithm should be similar over the range of possible inputs.

While processing the data, resource usage should be stable.
There shouldn't be choppy CPU usage, and 
Expensive operations like memory allocation and disk/network requests should be performed up front.
They should make data available to the core algorithm without hoarding CPU.

Example: Quick sort vs. Merge sort

Quick sort is simpler to program, and has Best: `O(n log(n))`, Average: `O(n log(n))`, Worst: `O(n2)` performance.

Merge sort is slightly more complex, but has Best: `O(n log(n))`, Average: `O(n log(n))`, Worst: `O(n log(n))` performance.

While their performance may be comparable in the best and average case, there is a drastic difference on worst case performance.
Algorithms may also perform differently on different scales of input data.

Despite this, a program could utilize both algorithms by detecting properties of the data before processing and using the right algorithm for the job.

Obversely, it may be advantageous to use a poorer-performing algorithm if it has other desirable qualities.

* [Best-Worst-Avg.: Sorting Algorithms](https://en.wikipedia.org/wiki/Best%2C_worst_and_average_case#Sorting_algorithms)

## Correctness - The output should be correct

Algorithms should produce accurate results under all valid inputs and adhere to specific constraints such as idempotency.

Outputs derived from data should be factually correct (see LLMs)
Processing the same set of data twice should result in the same output.

In sorting algorithms, there is the idea of stable vs unstable sort.
A stable algorithm will preserve the relative order of **equal elements**, while an unstable one may _or may not_ shuffle the order of equal elements.
While this may not matter for sorting raw values, it can be valuable when sorting data structures on a field.

* [Stable and Unstable Sorting: Why Stability Matters? - Siddharth Chandra](https://chandraji.dev/stable-and-unstable-sorting-why-stability-matters)

## Data Locality - Perform Operations on Subsets of Data

Algorithm should be able to perform tasks on a subset of the data.
It should not require processing all the data to get a result (processing everything required for the result).




Memory access patterns should be optimized to minimize cache misses and maximize reuse of data in memory.
Process the data as few times as possible, extracting what's needed for the lifetime of the algorithm.

Data stored with random access make it easier to batch and compartamentalize work.

At a programming level, this means utilizing hash maps and dicts to collate data.
Data storage-wise, this could mean s3 buckets with data spread across a folder tree.






## Data shapes - what data shapes are consumed and produced, pre-processing requirements/opportunities?

Data structures describe how data, metadata, and references are contained.

The organization of data to play to strengths of algorithm.
Don't want to over-index, or chop up data into too-fine pieces.
Analogy to min-maxing surface area and volume of a square.
Indexing shouldn't be overly specific.
Meaningful clustering of data.

Example: Graph Traversal

With just a raw list of nodes and edges, it can be expensive to determine paths between two nodes.

By storing the graph in a hash map, nodes can readily be hopped between.
The data will be able to be explored as a graph by hash lookups rather than iterating through a list. 

Having the raw data organized in a map is nice, but additional information about the data can be gathered to further improve task performance.
A "[directed hypergraph](https://en.wikipedia.org/wiki/Hypergraph)" ............... ??? on top of the existing data that groups sets of nodes by some desired property.

In path-finding algorithms, this can mean grouping nodes by location or travel cost.
Group 1x1 locations into say 64x64 tiles.
the algorithm can then first process the large tiles to get a rough estimate of a path, then explore more likely tiles before less likely ones resulting in less data processing overall.

* [Factorio Friday Facts #317 - New pathfinding algorithm](https://factorio.com/blog/post/fff-317)

Structure decisions control the way in which data is processed and interpreted.

The `ZIP-64` internal layout places the index of stored files or "General Directory" at the end of the archive structure.
This is advantageous for _writing_ a zip file, as the client only knows the data of the General Directory once all files are written.
This also can ease adding files, as they can overwrite the old General directory before writing the updated one.

This structure is _not_ helpful when attempting to read an archive.
A naive implementation could require processing the entire zip file to read the General Directory and provide it to the user.

Some systems can work around this, but others have hard constraints on how data can be accessed.
High-density tape drives provide large amounts of storage, but only read data sequentially.
This makes `ZIP-64` particularly bad, as the system must first seek to the end of the tape before being able to meaningfully access an archive.



## Preparation vs. work stages - 


## Composable - ability to integrate with itself and other tools

Instead of solving every problem, it is better to inter-operate with other tools.

## Bottleneck Awareness

Avoid system limitations through thoughtful design.

## Data Hierarchy and Scalability

Performance should be maintained across orders of magnitude of input.
The varying data sizes should be able to be handled with sacrificing efficiency (linear vs. quadratic growth).

Algorithms should have a clear model for describing how data moves through the system and utilizes awareness of caching, buffers, network and physical location.

Compute should be placed near the input data.
Data should be processed near where it is stored to minimize latency side-effects.
This means cross-AZ and cross-Region data movement is kept to a minimum, which helps lessen monetary costs as well.

* [The Architecture of Serverless Data Systems - Jack Vanlightly](https://jack-vanlightly.com/blog/2023/11/14/the-architecture-of-serverless-data-systems)

## Fault tolerance

Handle errors gracefully, through design patterns like like retries and fallbacks

## Adaptability

Able to easily adjust to changing inputs and environments.

This doesn't need to happen "on the fly", but the code describing the algorithm should be contained enough to be easily applied to other problems.

## Documentation / Usability

Algorithms do not operate in a vacuum.
They must be cared for and maintained like any living thing.
Documentation should outline the use case for the algorithm and how to apply it.

It should also have information on how it fails.
Users should be able to easily determine the cause of errors, 

* [The Art of README](https://github.com/hackergrrl/art-of-readme)

