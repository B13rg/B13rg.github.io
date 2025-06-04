---
layout: post
title:	"Title"
category: [Anime, Dirty Pair, Video]
excerpt: A short description of the article
image: public/images/plugin.png
comment_id: 72374862398476
---


Title: RoFormer: Enhanced Transformer with Rotary Position Embedding
Link: [Local Copy](/files/roformer/2104.09864v5.pdf) [Arxiv](https://arxiv.org/abs/2104.09864) [HuggingFace](https://huggingface.co/papers/2104.09864)
Date: Submitted on 20 Apr 2021 (v1), last revised 8 Nov 2023 (this version, v5)
Subjects: Computation and Language (cs.CL); Artificial Intelligence (cs.AI); Machine Learning (cs.LG)

Originally referenced in https://github.com/kingoflolz/mesh-transformer-jax/ , which use Rotary position encodings (RoPE).

Abstract states "Position encoding in transformer architecture provides supervision for dependency modeling between elements at different positions in the sequence".
To me, this means that position encoding helps find connections and relations between elements of the input data.
In this paper, they investigate different methods of encoding these relationships in "transformer-based language models".

What is a "transformer-based language model"?
Transformers are models with an encoder-decoder structure that make use of the attention mechanism.[^transformer1] [^transformer2] [^transformer3]
An attention mechanism "allows the model to make predictions by looking at the entire input (not the most recent segment) and selectively attend to some parts of it".
What this means that before the input data is used, it first passes through an encoder that draws relationships between different parts of the input.
The encoder looks at the entire input and attempts to determine importance and relation between data points.
Because it doesn't need to "digest" the input sequentially, it is much easier to parallelize since transformers read the input all at once instead of separately considering each part of the input individually

For example, given the sentence "The dog ran after the toy.  It was a tennis ball that was it's favorite toy", the encoder would attempt to figure out what each "it" is referring to.
It's called an "attention mechanism" because it helps determine what parts of the input the model should be paying attention to.

Back to the paper.
After investigating methods "to encode positional information in transformer-based language models", the researchers came up with a new version named Rotary Position Embedding (RoPE).
"The proposed RoPE encodes absolute positional information with rotation matrix and naturally incorporates explicit relative position dependency in self-attention formulation. "

In linear algebra, a rotation matrix is a transformation matrix that is used to perform a rotation in Euclidean space. For example, using the convention below, the matrix.[^rotmat]
Given a set of points describing a location in space, a rotational matrix can apply an arbitrary degree rotation to those points.
The output describes the final location of the points after the rotation is applied.


They first looks at different methods that previously attempted to integrate position information into the model.

* absolute position encoding
* relative position encoding
* model position information in complex space

Paper roadmap:
* Background and Related work
  * "establish a formal description of the position encoding problem in self-attention architecture"
  * Look at previous attempts
* Proposed approach
* Experiment

### Questions

Could you find a "sentence structure describer" program (or model) that takes a sentence or phrase as an input and describes the nouns, adjectives, and interrelations between words.
Then encode that information in a way the transformer can understand and use it.
Additional "filter" between the raw data and the model itself.
Add additional descriptors as metadata to data points in input.[^modex]

Train neural nets to solve aspects of a problem instead of the entire problem.
May be difficult to split problem into chunks that can be used to train and test.
Maybe use input and perform memory/recall related information, matching subsequences from an index

Footnotes

[^transformer1]: https://techblog.ezra.com/an-overview-of-different-transformer-based-language-models-c9d3adafead8
[^transformer2]: https://jalammar.github.io/illustrated-transformer/
[^transformer3]: https://jalammar.github.io/visualizing-neural-machine-translation-mechanics-of-seq2seq-models-with-attention/
[^rotmat]: https://en.wikipedia.org/wiki/Rotation_matrix
[^modex]: Model example: https://techblog.ezra.com/an-overview-of-different-transformer-based-language-models-c9d3adafead8#c879