https://datatracker.ietf.org/doc/html/rfc4838



Close reading of RFC-4838: Delay-Tolerant Networking Architecture.
It summarizes the design decisions that go into designing and implementing a delay-tolerant network (DTN).
The protocol described is meant to facilitate communication of application state between systems in multi-path with significant delay.
It also has links to many other papers and RFCs which go deeper into some of the ideas presented.
This document is meant to be my notes from reading it.


Before reading, it's good to review the OSI model.
Even though it's not entirely accurate to how things operate in practice,
Implementing a delay-tolerant network must consider more layers than normal, internet style networking.

|     | Layer        | Protocol               | Protocol Data Unit | Function                                                                                                            |
| --- | ------------ | ---------------------- | ------------------ | ------------------------------------------------------------------------------------------------------------------- |
| 7   | Application  | FTP, HTTP, Telnet, DNS | Data               | High-level APIs, including resource sharing and remote file access                                                  |
| 6   | Presentation | JPEG, JSON etc.        | Data               | Translation between networking service and application, including encoding, compression, and encryptio/decryption   |
| 5   | Session      | NFS, SQL, QUIC         | Data               | Managing continuous exchange of information through multiple back-and-forth transmissions between two nodes         |
| 4   | Transport    | TCP, UDP               | Segment, Datagram  | Reliable transmission of data between points on a network, including segmentation, acknowledgement and multiplexing |
| 3   | Network      | IPv4, IPv6             | Packet             | Structuring and managing a multi-node network, including addressing routing and traffic control                     |
| 2   | Data link    | MAC, ARP, LLC          | Frame              | Reliable transmission of data between two nodes that are connected                                                  |
| 1   | Physical     | Ethernet, Wi-Fi        | Bit, Symbol        | Transmission and reception of data through a physical medium                                                        |
|     |              |                        |                    | Source: https://en.wikipedia.org/wiki/OSI_model                                                                     |

This is a guide, not a hard set of rules.
Some protocols, like QUIC, have feet in multiple layers.


---

Released April 2007

Abstract:

> This document describes an architecture for delay-tolerant and disruption-tolerant networks, and is an evolution of the architecture originally designed for the Interplanetary Internet, a communication system envisioned to provide Internet-like services across interplanetary distances in support of deep space exploration.
> This document describes an architecture that addresses a variety of problems with internetworks having operational and performance characteristics that make conventional (Internet-like) networking approaches either unworkable or impractical.
> We define a message- oriented overlay that exists above the transport (or other) layers of the networks it interconnects.
> The document presents a motivation for the architecture, an architectural overview, review of state management required for its operation, and a discussion of application design issues.
> This document represents the consensus of the IRTF DTN research group and has been widely reviewed by that group.


## 1. Introduction

Looks into network design considerations for networking in space, a high-delay environment.

> Embraces concept of occasionally-connected networks

> Other networks to which we believe this architecture applies include sensor-based networks using scheduled intermittent connectivity, terrestrial wireless networks that cannot ordinarily maintain end-to-end connectivity, satellite networks with moderate delays and periodic connectivity, and underwater acoustic networks with moderate delays and frequent interruptions due to environmental factors.

Design document for networks that experience high amounts of delay or not always connected to other networks.
This is a departure from the normal networking we use today, where devices connected to the network expect an immediate response (see TCP).
This obviously works for our current workloads, but for workloads where things aren't always able to connect as they please, this poses a problem.
For example, communication in space introduces large amounts of latency.
Even at the speed of light, the distances in space between objects is so great that it can take minutes or hours for a message to travel from sender to receiver.
It takes around 14 minutes for a message from earth to reach mars, meaning it is impossible for us to rapidly respond to robots on mars.

To solve this problem, this RFC defines an "end-to-end message-oriented overlay called the 'bundle layer' that exists at a layer above the transport (or other) layers of the networks on which it is hosted and below applications".
This layer uses persistent storage to store messages as it receives them and forward messages to the next hop when able.

The RFC draws comparisons between these Delay-Tolerant Networking (DTN) gateways to the internet layer of gateways as described in the original ARPANET/Internet designs[^CK74].
The gateways allow two separate networks to interface with each other, without requiring hosts within the networks to be aware of the network separation.
The gateways manage the connection between the two networks, and create a solid foundation on which the hosts of the networks can operate, without requiring them to individually manage the connectivity between the two networks themselves.
The gateways manage the "streets and lights" on which the hosts "drive" on, without each host needing to manage it themselves.
The gateways provide interoperability between two networks, meaning that the two networks could use completely different protocols, as long as the gateways of each network are able to agree on a method of communication.

> However, both [DTN Gateways and ARPANET Gateways] generally provide interoperability between underlying protocols specific to one environment and those protocols specific to another, and both provide a store-and-forward forwarding service (with the bundle layer employing persistent storage for its store and forward function).

In a sentence, "the DTN architecture provides a common method for interconnecting heterogeneous gateways or proxies that employ store- and-forward message routing to overcome communication disruptions".

## 2. Why an Architecture for Delay-Tolerant Networking

This section describes reasons why existing traditional internet protocols have inherent design flaws that make them unsuitable for high-delay environments.

One of the biggest assumptions is that the source and destination will be connected for the duration of the session, and that they are able to communicate back and forth to find and fix errors in communication (SYN/ACK).
It also points out how networking has been designed to be abstracted away from the application, meaning that the application doesn't need to know about or care about how data is being transported.
Things like packet switching, routing, and retransmission are handled outside of the application, letting the application focus on it's own operations and not have to worry exactly *how* it's communicating with another host.

Traditional networking protocols have fundamental assumptions about the behavior of traffic.
By relaxing some of the constraints a protocol can better provide delay-tolerant properties to applications.
The design principles that lead the design of DTN are described in [^KF03]
Two key design principles that stuck out to me:

* discarding unauthorized traffic _early_
* support for store-and-forward operations over multiple paths and timescales (along with a way for applications to express their needs)

Both modify the security model in different ways.
Traffic is discarded early by utilizing public-key certificate style cryptography to verify senders.
Routers on the traffic path are able to verify message properties and layer on their own authentication layers.
If route is unable to verify the sender of a message, the traffic can be discarded early instead of at the destination.
This is done in part to make denial-of-service attacks more difficult to execute.

Storing data "in" the network allows buffering to take place along the traffic path.
To properly store and secure network client data, similar cryptographic controls to verifying senders would be used.

Since this RFC has been written more complex cryptographic properties like forward secrecy and certificate revocation have become more mainstream and would integrate nicely with these principles.

## 3. DTN Architectural Description

```
+-----------+                                         +-----------+
|   BP app  |                                         |   BP app  |
+---------v-|   +->>>>>>>>>>v-+     +->>>>>>>>>>v-+   +-^---------+
|   BP    v |   | ^    BP   v |     | ^   BP    v |   | ^   BP    |
+---------v-+   +-^---------v-+     +-^---------v-+   +-^---------+
| T1      v |   + ^  T1/T2  v |     + ^  T2/T3  v |   | ^ T3      |
+---------v-+   +-^---------v-+     +-^---------v +   +-^---------+
| N1      v |   | ^  N1/N2  v |     | ^  N2/N3  v |   | ^ N3      |
+---------v-+   +-^---------v +     +-^---------v-+   +-^---------+
|         >>>>>>>>^         >>>>>>>>>>^         >>>>>>>>^         |
+-----------+   +-------------+     +-------------+   +-----------+
|                     |                     |                     |
|<---- A network ---->|                     |<---- A network ---->|
|                     |                     |                     |
```
> Figure 1: The Bundle Protocol in the Protocol Stack Model 
> https://www.rfc-editor.org/rfc/rfc9171.html#section-1-7

The architecture description is split into the following sections:

- 3.1 [Virtual Message Switching Using Store-and-Forward Operation](#31-virtual-message-switching-using-store-and-forward-operation)
- 3.2 [Nodes and Endpoints](#32-nodes-and-endpoints)
- 3.3 [Endpoint Identifiers (EIDs) and Registrations](#33-endpoint-identifiers-eids-and-registrations)
- 3.4 [Anycast and Multicast](#34-anycast-and-multicast)
- 3.5 [Priority Classes](#35-priority-classes)
- 3.6 [Postal-Style Delivery Options and Administrative Records](#36-postal-style-delivery-options-and-administrative-records)
- 3.7 [Primary Bundle Fields](#37-primary-bundle-fields)
- 3.8 [Routing and Forwarding](#38-routing-and-forwarding)
- 3.9 [Fragmentation and Reassembly](#39-fragmentation-and-reassembly)
- 3.10 [Reliability and Custody Transfer](#310-reliability-and-custody-transfer)
- 3.11 [DTN Support for Proxies and Application Layer Gateways](#311-dtn-support-for-proxies-and-application-layer-gateways)
- 3.12 [Timestamps and Time Synchronization](#312-timestamps-and-time-synchronization)
- 3.13 [Congestion and Flow Control at the Bundle Layer](#313-congestion-and-flow-control-at-the-bundle-layer)
- 3.14 [Security](#314-security)

### 3.1 Virtual Message Switching Using Store-and-Forward Operation

Message based architecture.
The top level message abstraction is an Application Data Unit (ADU), present at the application layer.
Some ADU properties:

* Arbitrary length
* Order of messages in not preserved
* typically handled/transferred in complete units

An ADU "transformed by the bundle layer into one or more protocol data units called 'bundles', which are forwarded by DTN nodes".
Bundles are the basic transport block, akin to packets in IP protocols.
Bundles consist of a mandatory primary block, a payload block containing the ADU data, and a set of optional extension blocks.
They serve a similar purpose to the header-payload design of traditional protocols, except order is not controlled.
The bundle format is expounded upon in section 3.7, and formally defined in [RFC9171: Bundle Protocol Version 7](https://www.rfc-editor.org/rfc/rfc9171.html).


Bundles can be split up into multiple constituent bundles or "bundle fragments" while being transmitted.


Traditional networks are based on the store-and-forward" operation, but typical expectations of traffic lifetime is in the order of a few seconds at best.
In [Bundle Version 7](https://www.rfc-editor.org/rfc/rfc9171.html#section-4.2.6-1), a DTN time is an unsigned integer indicating the number of milliseconds that have elapsed since the DTN Epoch, `2000-01-01 00:00:00 +0000 (UTC)`.
Structures are encoded in CBOR format for transmission, which has a max `uint` of 2<sup>64</sup>−1 or about 584.9 million years worth of milliseconds.

Bundles are integrated closer to the application layer than packets, allowing network nodes to make more informed routing decisions based on the resource requirements of the bundle and application.

#### 3.3.1 URI Schemes

> dtn-uri = "dtn:" ("none" / dtn-hier-part)
> dtn-hier-part = "//" node-name name-delim demux ; a path-rootless
> node-name = reg-name
> name-delim = "/"
> demux = *VCHAR
>
> https://www.rfc-editor.org/rfc/rfc9171.html#section-4.2.5.1.1-2.2

#### 3.3.2 Late Binding

### 3.2 Nodes and Endpoints

DTN nodes implement the bundle layer and are utilized by applications to send and receive ADUs.
Nodes may be members of one or more groups called "DTN endpoints", which coordinate storage of bundles.
These groups consider a message successfully delivered once the "minimum receptive group" (MRG) of the endpoint has been met.
An MRG can be:

* one node (unicast)
* one of a group (anycast)
* all of a group (multicast / broadcast)


### 3.3 Endpoint Identifiers (EIDs) and Registrations

An EID is a name that identifies a DTN endpoint.
It can refer to either a node or a group of nodes.
Each node has at least one EID that uniquely identifies it.
An application is able to register with a node to receive ADUs sent to a particular EID.
This application registration information is stored on the node, independent of the application.

A DTN endpoint identifier is expressed as a URI ([RFC3986](https://datatracker.ietf.org/doc/html/rfc3986)).
It it up to the creator to choose the format of the EID.
Through IANA, the schema identifier `dtn` has been assigned.

### 3.4 Anycast and Multicast

Because an EID can refer to a single node or a group of nodes, there are two types of "delivery semantics" used:

* anycast: delivery to one node
* multicast (broadcast): delivery to all nodes of a group

Anycast ensures a minimum delivery metric, while multicast ensures replication of the bundle within a group.
It would be useful for data that needs to be stored long-term with availability guarantees.
It is also useful as traditional broadcast type delivery, where a single source of data is referenced by multiple clients.

A key behavior pointed out is when a node 
If a node joins a group _after_ some bundle has been multicast delivered (and it hasn't expired) then the new node should receive and store the bundle.
This ensures that the multicast delivery guarantee of a bundle to a group is maintained.

### 3.5 Priority Classes

The spec defines 3 relative priority classes to "imply some relative scheduling prioritization among bundles in queue at a sender":

* Bulk - "least effort", shipped when all other class queues are empty
* Normal - 
* Expedited - 

The priority is meant to relate to all bundles sent by a single sender, so they shouldn't be used to 

### 3.6 Postal-Style Delivery Options and Administrative Records
### 3.7 Primary Bundle Fields

The bundle protocol is defined in [RFC9171: Bundle Protocol Version 7](https://www.rfc-editor.org/rfc/rfc9171.html)

All bundles contain information about:

* Source + Destination EIDs (3.3)
* "Report-to" EID: command/control endpoint
* Custodian EID
* Originating timestamp
* Useful life indicator
* class of service designator
* length
* CRC

### 3.8 Routing and Forwarding

> The DTN architecture provides a framework for routing and forwarding
> at the bundle layer for unicast, anycast, and multicast messages.

The nodes in a DTN network can use a variety of protocols to communicate, potentially more than one at a time, so a *multigraph* (a graph where vertices may be interconnected with more than one edge) model is used.
The edge weight is determined by delay, capacity, and direction (support for DTN [over Avian Carriers](https://www.rfc-editor.org/rfc/rfc1149)!).

Nodes may come in and out of connectivity.
The time period where two nodes are connected is called a "contact".
The volume of traffic over that time period is based on the connection capacity.
With the intended applications (inter-stellar communication), some contacts may be able to be predicted and can be included in the routing calculation.

The spec groups contacts into the following categories:

* Persistent Contacts: 'always-on' connection; Normal internet connection
* On-Demand Contacts: Requires an action to instantiate, then acts as a persistent or opportunistic contacts; VPN login connection
* Intermittent - Scheduled Contacts: Scheduled at a particular time for a particular duration; Satellite orbit
* Intermittent - Opportunistic Contacts: Unexpected contacts for an undetermined amount of time; two phones passing, a la airtag
* Intermittent - Predicted Contacts: no fixed schedule, but can be predicted based on history or other information with some level of confidence; work/home type travel, referenced [DTN Routing in a Mobility Pattern Space](https://arxiv.org/pdf/cs/0504040)

### 3.9 Fragmentation and Reassembly

Proactive and reactive!
Because of the wealth of information available to make transfer decisions between nodes, there are opportunities fragment and re-assemble bundles for more-efficient transmission.
When the amount of bundles to transfer is greater than the contact volume, nodes can take actions to best use the communication medium.

Proactive fragmentation is performed by the sender to split application data into multiple smaller blocks that are transmitted as bundles independently.
When performed, it is the responsibility of the *final destination(s)* to reassemble them into the original ADU.
This type of fragmentation is used when contact volumes are known in advance.

Reactive fragmentation takes place cooperatively between two nodes sharing an edge.
This fragmentation takes place when communication of a bundle is unexpectedly terminated, after an attempted transmission.
It provides a way for the receiver to continue delivery of a portion of a bundle instead of discarding it.

The original sender may or may not be aware of the fragmentation.
If it is, it can form a smaller bundle fragment of the untransmitted data to forward when appropriate.

This behavior is pointed out as extra complex, and partially reliant on the properties of the underlying transport protocol.
As such, it's not _required_ to be available.
It also notes complexities with handling security properties of bundles and fragments.

### 3.10 Reliability and Custody Transfer
### 3.11 DTN Support for Proxies and Application Layer Gateways
### 3.12 Timestamps and Time Synchronization
### 3.13 Congestion and Flow Control at the Bundle Layer
### 3.14 Security

Discarding unauthorized traffic early is a departure from normal network behavior.
Traditional networks labor to maintain continuous connectivity and low queuing and transmission delay.

## 4. State Management Considerations

This section considers state managed at the bundle layer.


### 4.1 Application Registration State

The spec suggests an asynchronous application interface.
To initiate a registration the application specifies an Endpoint ID for which it wishes to receive ADUs and a optional registration timeout value.

The process to the application is similar "to the bind() operation in the common sockets API".
Applications _should_ register and remove themselves, but the state is managed by the DTN node.
That isn't to say an application can't also be a node.
The protocol could be integrated directly into the application or provided by resources outside the application.

> In cases where applications are not
> automatically restarted but application registration state remains
> persistent, a method must be provided to indicate to the system what
> action to perform when the triggering event occurs (e.g., restarting
> some application, ignoring the event, etc.)

It doesn't specify what exactly the application is registering with.
The system managing the DTN state could be beside (another application) or below (managed by host system).
I could see this extended where DTN protocols are integrated with application platforms to dynamically manage applications based on requests.
In a kubernetes the local DTN group would be a part of the core system and provide bindings to deployed applications.
The controller could dynamically spin up and and down applications based on DTN events.

### 4.2 Custody Transfer State

### 4.3 Bundle Routing and Forwarding State

### 4.4 Security-related State

### 4.5 Policy and configuration State

## 5. Application Structuring Issues

## 6. Convergence Layer Considerations for Use of Underlying Protocols


---

## Further Thoughts

### TCP vs UDP Over DTN

The back-and-forth of TCP is NOT condusive to performant DTN.

### Comparison to Apple Airtag protocol

### Mobile Computing

### Delivery Options

Potential for other delivery semantics beyond anycast and multicast.
Groups of nodes must perform some amount of replication among themselves when handling multicast bundles.
The delivery type must be preserved alongside the bundle, so new nodes are properly synced with the group.

There is an opportunity for Conflict Free Replicated Datatypes (CRDTs) to manage bundles among nodes in a group.
The bundles aren't being modified though, a given bundle should remain stable through the lifetime of the bundle.

Maybe the CRDT needs to take place at the application level as part of the ADU.
Applications aware of bundling could logically partition and transmit data.
There is a current draft for [Bundle-in-Bundle Encapsulation](https://datatracker.ietf.org/doc/html/draft-ietf-dtn-bibect-05), which would allow nesting one or more source bundles in an encapsulating outbound bundle.
By overlapping what source bundles are placed in encapsulating bundles we can ensure some level of redundancy and potentially allow the true destination to reconstruct the original bundles from a limited set of received, encapsulating bundles.

One question I have is whether an MRG can be more specific, such as a minimum of `n` nodes or a minimum percentage of nodes in a group.
Performing a bunch of group-destination logic could partition a bigger group into "striped" subgroups, al la RAID, 

## Glossary

Simple lookup of terms

* Application Data Unit (ADU)
* Bundle
* Endpoint ID (EID)
* Node
* Delivery
  * Anycast
  * Multicast (Broadcast)
* Contact
* Contact Volume
* Fragmentation
  * Reactive
  * Proactive
* Convergence layer

---

[^CK74]: V. Cerf, R. Kahn, "A  Protocol for Packet Network Intercommunication", IEEE Trans. on Comm., COM-22(5), May 1974. - https://web.archive.org/web/20210506194430/https://www.cs.princeton.edu/courses/archive/fall06/cos561/papers/cerf74.pdf

[^KF03]: K. Fall, "A Delay-Tolerant Network Architecture for Challenged Internets", Proceedings SIGCOMM, Aug 2003. - https://dl.acm.org/doi/10.1145/863955.863960


---

https://basil.dsg.cs.tcd.ie/code/n4c

https://web.archive.org/web/20080214194737/http://www.dtnrg.org/wiki