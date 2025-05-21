---
layout: post
title:	"Title"
category: [Games, Programming, Networking, DOS]
excerpt: A short description of the article
image: public/images/buttons/large/ahmygod.gif
comment_id: 72374862398476
---

## MCP Goals

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

mixes transport (stdio, http+sse) and protocol
Initially meant to be local first, but more "RPC" type practices were bolted on.

web transport acts as an api, but lacks things we've come to expect from an api.

mostly stateful, recently updated: https://github.com/modelcontextprotocol/specification/pull/206?utm_source=taoofmac.com&utm_medium=web&utm_campaign=unsolicited_traffic&utm_content=external_link

observability

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

client-server architecture vs client + server-server arch.

Local or remote or both poorly?


controlling abilities: read files install things
how fast can it move, how much user approval is needed?



https://github.com/Puliczek/awesome-mcp-security


How does MCP confront ai owasp?
https://genai.owasp.org/llm-top-10/



## Fears:

becoming commonplace and ingrained, leaving us to build more on top of it trying to fix core issues as has been repeated throughout time: x86(-64), IoT

---

codifying agent architecture
codify way for software/other people to act in your stead.




## alternatives

`agent.json`: https://docs.wild-card.ai/agentsjson/introduction








## References

[^1]: [The "S" in MCP stands for Security](https://elenacross7.medium.com/%EF%B8%8F-the-s-in-mcp-stands-for-security-91407b33ed6b) - [HN](https://news.ycombinator.com/item?id=43600192)
[^2]: [A critical look at MCP](https://raz.sh/blog/2025-05-02_a_critical_look_at_mcp) - [HN](https://news.ycombinator.com/item?id=43945993)
[^3]: [Tao of Mac: Notes on MCP](https://taoofmac.com/space/notes/2025/03/22/1900)










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
