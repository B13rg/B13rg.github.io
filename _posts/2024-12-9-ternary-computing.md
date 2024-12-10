---
layout: post
title:	"Ternary Performance for the Modern Age"
category: [Programming]
excerpt: Using ternary to improve computing performance
image: public/images/linkers/regular/last.gif
---

wip

## ternary computing

Ternary computing uses 3 states instead of 2.
A ternary system is able to store information more densely than a binary due to its increased state capacity. 
This density allows for more efficient data handling and potentially higher performance in specific applications compared to binary systems. 
However, it also introduces new challenges such as the need for specialized hardware and algorithms designed to operate within the ternary framework.

Ternary logic has performance benefits for certain types of computations like matrix multiplication.

Balanced ternary computing uses three states (-1, 0, +1) instead of two (0, 1).
Unbalanced ternary (0, 1, 2) could also be applied to some applications.
These systems allow a value to be represented multiple ways, e.g. 3 can be represented as (1, 0, -1) or (0, 1, 1).
The encoding of the value allows certain computations to be performed more efficiently

Modern ternary-native hardware: https://www.ternary-computing.com/history/CPU-History.html

## ternary llms

1-bit llms show better efficiency in terms of speed and energy use compared the usual fp16 type format. [1-bit AI Infra: Part 1.1, Fast and Lossless BitNet b1.58 Inference on CPUs ](https://arxiv.org/html/2410.16144v2).

1-bit model architectures can very cleanly be mapped onto ternary logic, which can in turn be implemented using FPGAs.

To integrate with existing binary-native hardware, a hybrid approach could be used where the ternary logic is implemented on FPGAs using 2 bits that provide the normal (-1, 0, +1) values along with a hardware "null" or special purpose flag value.


## architecting hardware to data

Goals:

* move calculations as deep into hardware as possible for performance and power efficiency
* moldable - have hardware adapt to required computations 

Use fpga to encode model weights directly into hardware, allowing for efficient computation and storage.
Limited by fpga density and llm model size.
With onboard memory caching, the fpga could reconfigure itself for each stage of model evaluation.

FPGAs are computationally efficient, but not as space efficient as harder hardware.
Adopting a blade server type form factor would increase compute density.

Use pcie lanes to connect multiple fpga cards to each other, and spread model layers across cards.
This would allow for a distributed system where each card handles a different stage of model evaluation for scalability.
Management could be performed by separate attached compute ( a la [raspberry pi](https://www.jeffgeerling.com/blog/2023/testing-pcie-on-raspberry-pi-5)) or on the FPGAs themselves (FPGA-netes, F9s? ).