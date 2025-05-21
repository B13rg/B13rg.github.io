---
layout: post
title:	"Title"
category: [Games, Programming, Networking, DOS]
excerpt: A short description of the article
image: public/images/buttons/large/ahmygod.gif
comment_id: 72374862398476
---

## MCP Goals


https://modelcontextprotocol.io/specification/2025-03-26/architecture
https://modelcontextprotocol.io/specification/2025-03-26

* Enable seamless communication between LLM applications and external data sources and tools
* Integrate with LLM applications (such as IDEs, chats, workflows)
* Enable applications to connect to LLMs and share contextual information
* Expose tools and capabilities to AI systems

audience: non-technical builders (vibers).
3rd-party hosted, but user-centric design (stdin).

## The Spec


https://modelcontextprotocol.io/docs/concepts/architecture

Inspiration from https://microsoft.github.io/language-server-protocol/

It is meant to be a 1-1, client-server architecture
Applications create a "Client" for each MCP server
I expect applications would create a client separate of the application features utilizing MCP, in order to group requests to a matching server.



Should it target understanding for users or llm?
How verbose should the endpoint be?
single "Query" endpoint or an endpoint for each thing?


complexity - layers for layers sake


can't use existing api, instead have to wrap in mcp.
Even if there exists some swagger or openapi definition.

## Transport

Two primary methods:

* STDIO
* HTTP-based

mixes transport (stdio, http+sse, ) and session protocol
Initially meant to be local first, but more "RPC" type practices were bolted on.

web transport acts as an api, but lacks things we've come to expect from an api.


https://github.com/modelcontextprotocol/modelcontextprotocol/pull/206#issuecomment-2766559523

* HTTP: request-response
* SSE: 1-way server push
* Websocket: two


SSE vs Websockets
HTTP+SSE:
* initiated from:
  * empty GET to `/message`
  * Requests upgraded _by the server_
* Does not support resumability
* Requires the server to maintain a long-lived connection with high availability
* Can only deliver server messages over SSE
* mostly stateful
Recently updated to add "streamable http" transport: https://github.com/modelcontextprotocol/specification/pull/206

Streamable HTTP:
* Stateless with optional session ID (server responsibility)

Why not websockets?

Reasoning: 

1. 0-RTT, RPC like operation, without requiring websocket creation for each call
2. No way to attach headers
3. Only GET requests can be transparently upgraded to websocket

4. Quic has 0-RTT, and design principles from it could be applied TODO
5. Opportunity to define a MCP control protocol, that enables clients and servers to communicate capability and metadata in a structured way.
6. Why does automated upgrades need to be a thing?  Define a way for client or servers to communicate the want to upgrade/modify the transport.

> We're also avoiding making WebSocket an additional option in the spec, because we want to limit the number of transports officially specified for MCP, to avoid a combinatorial compatibility problem between clients and servers. (Although this does not prevent community adoption of a non-standard WebSocket transport.)

It shouldn't matter how many transports are defined, it is used to simply pass `JSON-RPC 2.0` format messaged. [^6]

some agents have independently implemented websockets:

Internal websocket upgrade for hiberation: [cloudflare/agents McpAgent](https://github.com/cloudflare/agents/issues/172)


---


Runs counter to good de-coupled design practices
Adds additional mental load

observability and control
MCP is a guide for building a single pipe, with fuzzy boundaries of transport, session and control.
It really should be a set of 2 or 3 protocols to better define and delineate the layers of the MCP tech stack.
Improper boundaries in the transport design don't properly separate the session data and transport method.
The session taking place between the client and server should not care what transport is being used, at it's core it is meant to model `stdio`.

## Authentication and Authorization

https://modelcontextprotocol.io/specification/2025-03-26/basic/authorization

Authorization is designed for HTTP-based transports.
STDIO should "retrieve credentials from the environment".
Optional.

OAuth 2.1 based, made up of multiple parts:

* [OAuth 2.1 IETF Draft](https://datatracker.ietf.org/doc/html/draft-ietf-oauth-v2-1-12)
  * Required
* OAuth 2.0 Authorization Server Metadata protocol ([RFC8414](https://datatracker.ietf.org/doc/html/rfc8414))
  * Required for clients, optional for servers. If not implemented, then the "default URI schema" must be followed.
* OAuth 2.0 Dynamic Client Registration Protocol, optional ([RFC7591](https://datatracker.ietf.org/doc/html/rfc7591))


### Metadata Discovery and Default URI schema

Use OAuth 2.0 Authorization Server Metadata to communicate 


If OAuth 2.0 Auth Server Metadata is not implemented, then some endpoints must be created _relative to the authorization base URL_.







Untrustworthy client, or untrustworthy server
Prompt injection
[Principal-agent problem](https://www.doc.ic.ac.uk/~mjs/publications/msras.pdf)
Confused deputy attack - 
Depends on trust boundary, who owns the compute.
Wrong side of airlock? - https://devblogs.microsoft.com/oldnewthing/20060508-22/?p=31283

poisoning attacks: https://invariantlabs.ai/blog/mcp-security-notification-tool-poisoning-attacks


least-privilege

combining control instructions and data
no way of defining relationships between mcp endpoints.
Difficult to communicate server capabilities as well.


client-server architecture vs client + server-server arch.

Local or remote or both poorly?


communicating and controlling server abilities: read files install things.
how fast can it move, how much user approval is needed?


https://github.com/Puliczek/awesome-mcp-security


How does MCP confront ai owasp?
https://genai.owasp.org/llm-top-10/

Hubris

## Protocol aging

Will see developed security and observability as time goes on.




### Fears:

becoming commonplace and ingrained, leaving us to build more on top of it trying to fix core issues as has been repeated throughout time: x86(-64), IoT

---

codifying agent architecture
codify way for software/other people to act in your stead.



## alternatives

`agent.json`: https://docs.wild-card.ai/agentsjson/introduction








## References

[^1]: [MCP Architecture](https://modelcontextprotocol.io/docs/concepts/architecture)
[^2]: [MCP Message Spec](https://modelcontextprotocol.io/specification)
[^3]: [MCP Transports](https://modelcontextprotocol.io/docs/concepts/transports)
[^4]: [The "S" in MCP stands for Security](https://elenacross7.medium.com/%EF%B8%8F-the-s-in-mcp-stands-for-security-91407b33ed6b) - [HN](https://news.ycombinator.com/item?id=43600192)
[^5]: [Tao of Mac: Notes on MCP](https://taoofmac.com/space/notes/2025/03/22/1900)
[^6]: [A critical look at MCP](https://raz.sh/blog/2025-05-02_a_critical_look_at_mcp) - [HN](https://news.ycombinator.com/item?id=43945993)










<!-- Image example
![MS-DOS Family Tree](/images/folder/filename.png){:width="700px"}
-->
<!-- Link example -->
[Link to full-size image](/images/buttons/large/ahmygod.gif)

Footnote[^4]

<details>
  <summary>One more quick hack? 🎭</summary>
  <div markdown="1">
  → Easy  
  → And simple
  </div>
</details>


<!-- Separator -->
---
