---
layout: post
title:	"Network Latency as Delay-Line Memory"
category: [Networking]
excerpt: A short description of the article
image: public/images/buttons/large/ahmygod.gif
comment_id: 72374862398476
---

Concept: Use latency between servers as a memory buffer, similar to delay-line memory.

  * [Magnetostrictive delay line memory](https://en.wikipedia.org/wiki/Delay-line_memory#Magnetostrictive_delay_lines)
  * [optical delay line in optical computing](https://ieeexplore.ieee.org/document/10675424)

It would require two or more nodes, a primary "terminal" node for interacting with the data and reflector nodes to bounce it around.
The amount of data able to be stored is directly proportional to latency of the data path.

> Bandwidth (Gb/s) * Latency (s) == Storage Volume (Gb/s²)

UDP has better bandwidth, and we 
Encoding of UDP datastream should handle data integrity a la QUIC.
TCP ACKs would take up bandwidth, and 

Reflector nodes may be able to bounce traffic between other reflectors to store additional data, so we 

Slower links may be cheaper and create a better data capacity/cost ratio. 

Comes down to what's cheaper: vps memory or network transit?

