---
layout: post
title:	"Applications vs. Systems"
category: [Programming]
excerpt: An exploration of applications, systems, and a secret third option
---

Applications and systems both describe aspects of modern "computer-ing".
Application are usually user-facing programs designed to perform specific tasks while systems focus on the foundational infrastructure that enables applications to operate.

## Applications - The System-User Interface

Programs designed for end-users
Focused on specific tasks or providing value to users.

Provide a varied interface to interact with systems.

### Key Properties of Applications

* User-centric: Focuses on direct interaction with users through GUIs, APIs, CLIs, etc.
* Task-specific: Often aimed at solving a particular problem
* External Dependencies: Relies on systems such as web browsers, operating systems, databases, etc. to function.
* Modular: Often composed of small components such as plugins or libraries that can be updated or replaced.

## Systems - Infrastructure at large

Underlying hardware and software that manages resources, executes code, and enables applications.

### Key Properties of Systems

* Resource management: Control processing, memory, disk, network 
* Abstraction Layers: Provides APIs or interfaces to simplify interacting with other components
* Foundational: Create the base for applications to run
* Scalable: Designed to handle large-scale operations


## Protocol - Calls from Inside the Stack

Rules governing how applications and systems interact with each other.
Ensure interoperability, security, and efficiency across networks.

Provide guarantees that applications and systems can rely to communicate information.
Span multiple layers

## Key properties of Protocols

* Standardization
* Security-focused: Define encryption, authentication, and data integrity mechanisms
* Adaptable: Able to evolve with technological advancements

Proprietary vs open protocols

value of security as a principle
Best when deeply integrated, instead of tacked on.


## Interdependencies - Applications, Systems and Protocols Together

In a graph of computing, applications are leaves, systems are nodes and protocols are edges.
Application depend on systems to operate.
Systems rely on protocols to communicate with applications and other systems.
Protocols provide information communication guarantees, and enable applications to function and interact with diverse systems.






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
