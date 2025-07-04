---
layout: post
title:	"Applications vs. Systems"
category: [Programming]
excerpt: An exploration of applications, systems, and a secret third option
---

Applications and systems both describe aspects of modern "computer-ing".
Application are usually user-facing programs designed to perform specific tasks while systems focus on the foundational infrastructure that enables applications to operate.
Protocols are the glue that allows applications and systems to communicate intent.

## Applications - The System-User Interface

Programs designed for end-users
Focused on specific tasks or providing value to users.

Provide a varied interface to interact with systems.
Presentation guides user interaction and places constraints of what the user is able to create.

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


## Protocols - Calls from Inside the Stack

Rules governing how applications and systems interact with each other.
Ensure interoperability, security, and efficiency across networks.

Provide guarantees that applications and systems can rely to communicate information.
Span multiple layers of the hardware/software abstraction stack.

Open protocols are more valuable than proprietary ones.
Accessability and visibility is important to be able to verify protocol guarantees.

Security properties should be integrated with protocols as a principle.
Aspects like checksums provide authentication and integrity guarantees that applications and systems can trust and rely on.

### Key properties of Protocols

* Standardization of structure and transport
* Security-focused: Define encryption, authentication, and data integrity mechanisms
* Adaptable: Able to evolve with technological advancements

## Interdependencies - Applications, Systems and Protocols Together

In a graph of computing, applications are leaves, systems are nodes and protocols are edges.
Application depend on systems to operate.
Systems rely on protocols to communicate with applications and other systems.
Protocols provide information communication guarantees, and enable applications to function and interact with diverse systems.
