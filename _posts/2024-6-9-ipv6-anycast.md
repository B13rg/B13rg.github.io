---
layout: post
title:	"IPv6 Addressing"
category: [Networking]
excerpt: WIP> Anaylsis of the different types of IPv6 addresses, specifically anycast.
image: public/images/buttons/large/ahmygod.gif
#comment_id: 72374862398476
---

IPv6 address types:
* unicast - `1` to `1`
* multicast - `1` to `all`
* anycast - `1`-`1 of many` (special unicast)

Allows for rough load balancing at the IP layer.
Works by advertising the same CIDR from two different places.
Allows traffic to be routed to nearest service endpoint based on BGP advertised routes instead of a solution higher in the system stack, such as [GeoIP/GeoList](https://dev.maxmind.com/geoip?lang=en), [AWS Global Accelerator](https://docs.aws.amazon.com/global-accelerator/latest/dg/introduction-benefits-of-migrating.html), or load balancing manually.

Anycast Motivation snippet[^rfc1546]:

> A host transmits a datagram to an anycast address 
> and the internetwork is responsible for providing best effort delivery of the datagram to at least one, and preferably only one, 
> of the servers that accept datagrams for the anycast address.

Two types:

* Within a network: reserved subnet anycast address (RFC 2526)
* Between two networks: shared unicast address (requires application support? BGP?)

7 bit anycast ID

Limited by route sharing mechanism, so (externally) the most specific route entry is a /48. (BGP)

have to devote an entire allocation, makes entire range anycast.

Internally, could advertise more specific routes, so only a /56 or /64 is anycast.


## Scenarios

![Scenario base image](/images/anycast/IPv6-anycast-scenarios.svg)

CIDRs:
* unicast region a - `2001:db8:6000::/48`
  * Services present and accessible in region a
* unicast region b - `2001:db8:6001::/48`
  * Services present and accessible in region b
* unicast region c - `2001:db8:6002::/48`
  * Services present and accessible in region c
* anycast a - `2001:db8:7000::/48`
  * Services duplicated across all regions (stateless)
* anycast b - `2001:db8:8000::/48`
  * Services present in 1 region, but accessible from all



## RFCs

[^rfc1546]: [RFC 1546](https://www.rfc-editor.org/rfc/rfc1546.html) - Host Anycasting Service, 1993
[^rfc2526]: [RFC 2526](https://www.rfc-editor.org/rfc/rfc2526.html) - Reserved IPv6 Subnet Anycast Addresses, 1999
[^rfc4291]: [RFC 4291](https://www.rfc-editor.org/rfc/rfc4291) - IP Version 6 Addressing Architecture, 2006
[^rfc6996]: [RFC 6996](https://www.rfc-editor.org/rfc/rfc6996) -  Autonomous System (AS) Reservation for Private Use, 2013
[^rfc7094]: [RFC 7094](https://www.rfc-editor.org/rfc/rfc7094.html) - Architectural Considerations of IP Anycast, 2014
[^rfc7108]: [RFC 7108](https://www.rfc-editor.org/rfc/rfc7108.html) - A Summary of Various Mechanisms Deployed at L-Root for the Identification of Anycast Nodes, 2014

## Other references

* https://www.potaroo.net/ispcol/2024-04/ipv6-prefixes.html
* https://docs.vultr.com/configuring-ipv6-on-your-vps
* https://blog.apnic.net/2022/01/19/ip-addressing-in-2021/
* https://www.researchgate.net/publication/334073114_In_the_IP_of_the_Beholder_Strategies_for_Active_IPv6_Topology_Discovery
* https://quantum5.ca/2023/12/21/bgp-route-selection-high-availability-anycast/
* http://www.iana.org/assignments/ipv6-address-space/ipv6-address-space.xhtml

BGP tools:

* https://bgp.tools/

Communities:

* Vultr communities guide: https://github.com/vultr/vultr-docs/tree/main/faq/as20473-bgp-customer-guide#readme
* Cloudlfare communities: https://bgp.tools/communities/13335
* https://blog.cloudflare.com/prepends-considered-harmful/
