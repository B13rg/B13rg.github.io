https://datatracker.ietf.org/doc/html/rfc4838



Close reading of RFC-4838: Delay-Tolerant Networking Architecture.
It's a quick and relativly easy read.
It summarizes the design decisions that go into designing and implimenting a delay-tolerant network (DTN).
It also has links to many other papers and RFCs which go deeper into some of the ideas presented.
This document is meant to be my notes from reading it.


Before reading, it's good to review the OSI model.
Even though it's not entirely accurate to how things operate in practice,
Implementing a delay-tolerant network must consider more layers than normal, internet style networking.

| |Layer|Protocol|Protocol Data Unit|Function|
|---|---|---|---|---|
|7|Application|FTP, HTTP, Telnet, DNS|Data|High-level APIs, including resource sharing and remote file access|
|6|Presentation|JPEG, JSON etc.|Data|Translation between networking service and application, including encoding, compression, and encryptio/decryption|
|5|Session|NFS, SQL, QUIC|Data|Managing continuous exchange of information through multiple back-and-forth transmissions between two nodes|
|4|Transport|TCP, UDP|Segment, Datagram|Reliable transmission of data between points on a network, including segmentation, acknowledgement and multiplexing|
|3|Network|IPv4, IPv6|Packet|Structuring and managing a multi-node network, including addressing routing and traffic control|
|2|Data link|MAC, ARP, LLC|Frame|Reliable transmission of data between two nodes that are connected|
|1|Physical|Ethernet, Wi-Fi|Bit, Symbol|Transmission and reception of data through a physical medium|
| | | | |Source: https://en.wikipedia.org/wiki/OSI_model|

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

This sections the reasons why existing, more traditional internet protocols have some inherent design flaws that would make them unsuitable for high-delay environments.

One of the biggest assumptions is that the source and destination will be connected for the duration of the session, and that they are able to communicate back and forth to find and fix errors in communication (SYN/ACK).
It also points out how networking has been designed to be abstracted away from the application, meaning that the application doesn't need to know about or care about how data is being transported.
Things like packet switching, routing, and retransmission are handled outside of the application, letting the application focus on it's own operations and not have to worry exactly *how* it's communicating with another host.



---

[^CK74]: V. Cerf, R. Kahn, "A  Protocol for Packet Network Intercommunication", IEEE Trans. on Comm., COM-22(5), May 1974. - https://web.archive.org/web/20210506194430/https://www.cs.princeton.edu/courses/archive/fall06/cos561/papers/cerf74.pdf


---

https://basil.dsg.cs.tcd.ie/code/n4c

https://web.archive.org/web/20080214194737/http://www.dtnrg.org/wiki