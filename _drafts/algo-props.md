---
layout: post
title:	"Properties and Patterns of Elegant Systems"
category: [Programming]
excerpt: A short description of the article
image: public/images/buttons/large/ahmygod.gif
---

Algorithms exist within a system, and usually process one or more inputs to produce an output.
These principles can be applied across all levels of computing abstraction, from hardware and software to cloud and .
This post explores foundational patterns in system design that ensure algorithms and architectures are efficient, predictable, and scalable.

---

> [[流れ](https://www.japandict.com/%E6%B5%81%E3%82%8C#entry-1552130)]
>
> Data flows through space
>
> Systems revel in balance
> 
> The enmeshed gates sing

---

- [Core Principles of System Design](#core-principles-of-system-design)
  - [Simplicity: Minimize Complexity](#simplicity-minimize-complexity)
  - [Performance: Balance Efficiency \& Resources](#performance-balance-efficiency--resources)
  - [Predictability: Consistent Behavior Over Time](#predictability-consistent-behavior-over-time)
  - [Correctness: Reliable Output Under All Conditions](#correctness-reliable-output-under-all-conditions)
- [Data Handling Strategies](#data-handling-strategies)
  - [Data Locality and Movement](#data-locality-and-movement)
  - [Data Shapes and Structure](#data-shapes-and-structure)
  - [Pre-Processing for Efficiency](#pre-processing-for-efficiency)
  - [Composable Across systems](#composable-across-systems)
  - [Data Hierarchy and Latency Reduction Scalability](#data-hierarchy-and-latency-reduction-scalability)
- [Scalability \& Performance Optimization](#scalability--performance-optimization)
  - [Cost Awareness: Balancing Tradeoffs](#cost-awareness-balancing-tradeoffs)
  - [System Bottlenecks and Design Avoidance](#system-bottlenecks-and-design-avoidance)
- [Adaptability and Usability](#adaptability-and-usability)
  - [Graceful Failure: Handling Errors](#graceful-failure-handling-errors)
  - [Documentation \& User Experience](#documentation--user-experience)
- [Conclusion: Building Elegant Systems](#conclusion-building-elegant-systems)
- [Appendix I - Case Studies \& Practical Examples](#appendix-i---case-studies--practical-examples)
  - [Factorio's Pathfinding Algorithm](#factorios-pathfinding-algorithm)
  - [Zip-64 and Tape Storage Limitations](#zip-64-and-tape-storage-limitations)
  - [Rainbow Tables in Cryptoanalysis](#rainbow-tables-in-cryptoanalysis)
- [Appendix II - Links to More](#appendix-ii---links-to-more)
  - [Core Principles](#core-principles)
  - [Data Handling](#data-handling)
  - [Adaptability and Usability](#adaptability-and-usability-1)

## Core Principles of System Design


### Simplicity: Minimize Complexity

Avoid unnecessary features, but balance the minimalism with practicality.
Don't solve every problem, but enough that you can get things done.

Minimize the amount of stateful components in the system.
[If you’re storing any kind of information for any amount of time, you have a lot of tricky decisions to make about how you save, store and serve it.](https://www.seangoedecke.com/good-system-design/)
Stateless systems can more easily be tested and verified.
The fewer edge cases, the easier it is to reason about functionality.

### Performance: Balance Efficiency & Resources

Adding more resources improves performance, to a point.
The various limits of hardware and software all scale differently from each other, so performance characteristics will differ across scales.
Properly accounting for the the complexity of changes is difficult, but helps extract additional performance from slack in the system.

Power usage should also be considered in determining the efficiency of an algorithm.

Parallelism, pipelining, and serialization are common design patterns to spread work across resources.

### Predictability: Consistent Behavior Over Time

Best / Average / Worst performance of the algorithm should be similar over the range of possible inputs.

While processing the data, resource usage should be stable.
There shouldn't be choppy CPU usage, and 
Expensive operations like memory allocation and disk/network requests should be performed up front.
They should make data available to the core algorithm without hoarding CPU.

Quick sort first partitions the array and then make two recursive calls.
Merge sort first makes recursive calls for the two halves, and then merges the two sorted halves.

While their performance may be comparable in the best and average case, there is a drastic difference on worst case performance.
Algorithms may also perform differently on different scales of input data.

Despite this, a program could utilize both algorithms by detecting properties of the data before processing and using the right algorithm for the job.

### Correctness: Reliable Output Under All Conditions

Algorithms should produce accurate results under all valid inputs and adhere to specific constraints such as idempotency.

Outputs derived from data should be factually correct (see LLMs)
Processing the same set of data twice should result in the same output.

In sorting algorithms, there is the idea of stable vs unstable sort.
A stable algorithm will preserve the relative order of **equal elements**, while an unstable one may _or may not_ shuffle the order of equal elements.
While this may not matter for sorting raw values, it can be valuable when sorting data structures on a field.

Accuracy vs. precision

## Data Handling Strategies

### Data Locality and Movement

Algorithm should be able to perform tasks on a subset of the data.
It should not require processing all the data to get a result (processing everything required for the result).

Data should be stored in a way that's conducive to how it will be processed.
The algorithms data access patterns should integrate cleanly with how the data stored.
Usually, algorithms fall into either being message or stream oriented.
Data stored with random access make it easier to batch and compartmentalize work.

Algorithms that require random data access do _NOT_ perform well with stream-oriented data sets

Memory access patterns should be optimized to minimize cache misses and maximize reuse of data in memory.
Individual, discrete units of data should be processed as few times as possible, extracting what's needed for the lifetime of the algorithm in minimal passes.

At a programming level, this could mean utilizing hash maps and dicts to group data instead of using un-indexed lists.
Data storage-wise, this could mean s3 buckets with data spread across a folder tree that groups files on some valuable property.

### Data Shapes and Structure

What data shapes and structures are consumed and produced

Data structures describe how data, metadata, and references are contained.

The organization of data to play to strengths of algorithm.
Don't want to over-index, or chop up data into too-fine pieces.
Analogy to min-maxing surface area and volume of a square.
Indexing shouldn't be overly specific.
Meaningful clustering of data.

Graph traversal is a core computing problem where storage structure can drastically reduce work.
With just a raw list of nodes and edges, it can be expensive to determine paths between two nodes.

By storing the graph in a hash map, nodes can readily be hopped between.
The data will be able to be explored as a graph by hash lookups rather than iterating through a list. 

Having the raw data organized in a map is nice, but additional information about the data can be gathered to further improve task performance.
"Regularization" of the input data can help simplify the problem you're trying to solve.

Structure decisions control the way in which data is processed and interpreted.


### Pre-Processing for Efficiency

Pre-processing data before it enters parts of the subsystem.
Key information about the data can be extracted before the primary processing takes place to better inform and optimize the processing.

For example, the speed of a search algorithm on a list will vary wildly depending on if the list is sorted or not.
Over an unsorted list, an algorithm would need to analyze each list item on it's own.
By sorting the list beforehand, the algorithm can rely on guarantees inherent in the data being processed and utilize better algorithms.

The pre-processing can take place during or outside of the algorithm's execution lifecycle.
Lookup tables are a common example of using pre-computing to improve task performance.
Before computers there were used to speed up calculation of complex functions in trigonometry, logarithms, statistics and more.

### Composable Across systems

Instead of solving every problem, it is better to inter-operate with other tools.
The algorithm and tool that encases it should readily integrate with other applications and systems.

In the *nix world, most terminal applications are line-of-text oriented.
Tools like `awk`, `grep`, `cat`, and `find` are able to be easily chained together to solve a task by iteratively operating on lines and passing it to the next in the chain via pipe.

### Data Hierarchy and Latency Reduction Scalability

Performance should be maintained across orders of magnitude of input.
The varying data sizes should be able to be handled with sacrificing efficiency (linear vs. quadratic growth).

Algorithms should have a clear model for describing how data moves through the system and utilizes awareness of caching, buffers, network and physical location.

Compute should be placed near the input data.
Data should be processed near where it is stored to minimize latency side-effects.

In a cloud architecture settings, this looks like cross-AZ and cross-Region data movement.
In machine code this could be optimizing data slices for L1 and L2 processor cache.
Each layer from the processor doing the work is a magnitude of difference

The more copies of the data that exist makes it easier for them to become out of sync.
Cache layers can solve problems, but also create potential for many more.
Data Lifetimes

## Scalability & Performance Optimization

### Cost Awareness: Balancing Tradeoffs

Computing costs money.
Every layer of abstraction has it's own costs and benefits.



Resources should optimize for cost per operation.

### System Bottlenecks and Design Avoidance

Avoid system limitations through thoughtful design.

## Adaptability and Usability

Able to easily adjust to changing inputs and environments.

This doesn't need to happen "on the fly", but the code describing the algorithm should be contained enough to be easily applied to other problems.

Many advances in science and engineering have been made by applying an old tool to a new problem.
By 

### Graceful Failure: Handling Errors

Errors will always happen.
Even if all inputs, states and outputs are accounted for, there are factors outside of the system.
Links go down, hardware fails, and cosmic rays love flipping bits.
When encountering unrecoverable issues, plan for a graceful landing and exit instead of plowing a burning path of faults, errors, and corruptions.

It is often better to fail out early rather then trying to continue and create bigger issues.
In databases, design patterns like transactions and Write-Ahead-Logging (WAL) help minimize erroneous writes from failing clients and servers.
By taking steps to preserve state before work is done the system can guarantee (to a degree) the atomicity of actions taken.

User-facing errors should be actionable and explain what went wrong.
They should communicate what the system was doing and what input was being operated on.
The message should cover the "who what when where" parts of the problem, the "why" and "how" are usually left to the user to solve.

Error codes and the like are valuable as an index, but they require external resources to index against.
Most systems aren't constrained by bits and bytes so messages can be more verbose.
In programming I prefer to return errors instead of exception-ing out of the main control flow.
Exceptions are expensive, and forces core parts of the system to be ready to "play catch" from potentially disparate sub-systems.


### Documentation & User Experience

Algorithms do not operate in a vacuum.
They must be cared for and maintained like any living thing.
Documentation should outline the use case for the algorithm and how to apply it.

It should also have information on how it fails.
Users should be able to easily determine the cause of errors, and have the tools/knowledge available to solve it themselves.

Even if it is the most optimal algorithm ever constructed for a task, if it is not ergonomic to users than it will be forked or forgotten.

## Conclusion: Building Elegant Systems

Everything old is new again.
The questions of how to design a computing system have been asked and answered innumerable ways over the decades.
Most of the problems we strive to solve are echoes of those faced by our computing progenitors.
We as engineers face physical and digital constraints that design is bound to.




"Be vicariously lazy." - [Programming Perl 1991](https://archive.org/details/programmingperl000wall/page/374/)




---

## Appendix I - Case Studies & Practical Examples

### Factorio's Pathfinding Algorithm

[Factorio Friday Facts #317 - New pathfinding algorithm](https://factorio.com/blog/post/fff-317) describes their process in developing an npc algorithm.

In path-finding algorithms, this can mean grouping nodes by location or travel cost.
Group 1x1 locations into say 64x64 tiles.
the algorithm can then first process the large tiles to get a rough estimate of a path, then explore more likely tiles before less likely ones resulting in less data processing overall.

### Zip-64 and Tape Storage Limitations

![ZIP-64 Internal Layout](/images/algo-props/zip-64-layout.png)
[Original](https://en.wikipedia.org/wiki/ZIP_(file_format)#/media/File:ZIP-64_Internal_Layout.svg)

The [ZIP-64](https://en.wikipedia.org/wiki/ZIP_(file_format)#Structure) internal layout places the index of stored files or "General Directory" at the end of the archive structure.
This is advantageous for _writing_ a zip file, as the client only knows the data of the General Directory once all files are written.
This also can ease adding files, as they can overwrite the old General directory before writing the updated one.

This structure is _not_ helpful when attempting to read an archive.
A naive implementation could require processing the entire zip file to read the General Directory and provide it to the user.

Some systems can work around this, but others have hard constraints on how data can be accessed.
High-density tape drives provide large amounts of storage, but only read data sequentially.
This makes `ZIP-64` particularly bad, as the system must first seek to the end of the tape before being able to meaningfully access an archive.

### Rainbow Tables in Cryptoanalysis

![Rainbow Table illustration presented at Crypto 2003](/images/algo-props/rainbow-tables.png)
[Original](https://en.wikipedia.org/wiki/Rainbow_table#/media/File:Dr._Oechslin_Rainbow_Table_Crypto_2003_Illustration.png)

[Rainbow Tables](https://en.wikipedia.org/wiki/Rainbow_table) are pre-computed chains of password hashes.

are another, more modern form of lookup tables.
They help drastically improve hash cracking performance.
Instead of storing every single plaintext and hash, "chains" of hashes are created and only the ends are stored.
The target hash is repeatedly hashed using the same method to create the chains.
If the result matches one of the chain "ends", the algorithm can then hash from the head of the chain to determine the input that generates the matching hash.

## Appendix II - Links to More

### Core Principles

#### Simplicity

* [Simplicity of IRC - Susam Pal](https://web.archive.org/web/20220815032635/https://susam.net/maze/wall/simplicity-of-irc.html)
* [htmx sucks - Carson Gross](https://htmx.org/essays/htmx-sucks/)
* [Great software design looks underwhelming - Sean Goedecke](https://www.seangoedecke.com/great-software-design/)

#### Performance

* [Simulating Time with Square-Root Space - Ryan Williams](https://arxiv.org/abs/2502.17779)
* [Exploring the Power of Parallelized CPU architectures - meekochii](https://research.meekolab.com/exploring-the-power-of-parallelized-cpu-architectures)

#### Predicatability

* [Best-Worst-Avg.: Sorting Algorithms](https://en.wikipedia.org/wiki/Best%2C_worst_and_average_case#Sorting_algorithms)
* [Quick Sort vs Merge Sort](https://www.geeksforgeeks.org/quick-sort-vs-merge-sort/)

#### Correctness

* [Stable and Unstable Sorting: Why Stability Matters? - Siddharth Chandra](https://chandraji.dev/stable-and-unstable-sorting-why-stability-matters)

### Data Handling

* [Make a Faster Cryptanalytic Time-Memory TradeOff - Philippe Oechslin](https://web.archive.org/web/20230409151031/https://lasecwww.epfl.ch/pub/lasec/doc/Oech03.pdf)
* [Hash-Based Improvements to A-Priori](http://infolab.stanford.edu/~ullman/cs345notes/cs345-7.pdf)
* [Regularization - ](https://cscheid.net/writing/data_science/regularization/index.html)
* [undirected hypergraph](https://en.wikipedia.org/wiki/Hypergraph) ............... ??? on top of the existing data that groups sets of nodes by some desired property.


* [The Architecture of Serverless Data Systems - Jack Vanlightly](https://jack-vanlightly.com/blog/2023/11/14/the-architecture-of-serverless-data-systems)

### Adaptability and Usability

* [The Art of README](https://github.com/hackergrrl/art-of-readme)


