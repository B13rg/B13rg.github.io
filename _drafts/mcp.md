---
layout: post
title:	"Title"
category: [Games, Programming, Networking, DOS]
excerpt: A short description of the article
image: public/images/buttons/large/ahmygod.gif
comment_id: 72374862398476
---

## MCP Goals

https://modelcontextprotocol.io/docs/concepts/architecture

* provide context to AI agents
* local first (ish).

audience: non-technical builders (vibers).
3rd-party hosted, but user-centric design (stdin).

Should it target understanding for users or llm?
How verbose should the endpoint be?
single "Query" endpoint or an endpoint for each thing?


complexity - layers for layers sake

"zero re-use of existing api surfaces"[^3]. - https://www.reddit.com/r/mcp/comments/1jr8if3/comment/mlfqkl7/


can't use existing api, instead have to wrap in mcp.
Even if there exists some swagger or openapi definition.

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

It shouldn't matter how many transports are defined, it is used to simply pass `JSON-RPC 2.0` format messaged. [^5]

some agents have independentaly implimented websockets:

Internal websicket upgrade for hiberation: [cloudflare/agents McpAgent](https://github.com/cloudflare/agents/issues/172)


---


Runs counter to good de-coupled design practices
Adds additional mental load

observability and control
MCP is a guide for building a single pipe, with fuzzy boundaries of transport, session and control.
It really should be a set of 2 or 3 protocols to better define and delineate the layers of the MCP tech stack.
Improper boundaries in the transport design don't properly separate the session data and transport method.
The session taking place between the client and server should not care what transport is being used, at it's core it is meant to model `stdio`.

authentication

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

[^1]: [MCP Transports](https://modelcontextprotocol.io/docs/concepts/transports)
[^2]: [MCP Message Spec](https://modelcontextprotocol.io/specification)
[^3]: [Tao of Mac: Notes on MCP](https://taoofmac.com/space/notes/2025/03/22/1900)
[^4]: [The "S" in MCP stands for Security](https://elenacross7.medium.com/%EF%B8%8F-the-s-in-mcp-stands-for-security-91407b33ed6b) - [HN](https://news.ycombinator.com/item?id=43600192)
[^5]: [A critical look at MCP](https://raz.sh/blog/2025-05-02_a_critical_look_at_mcp) - [HN](https://news.ycombinator.com/item?id=43945993)










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
