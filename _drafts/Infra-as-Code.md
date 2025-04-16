---
layout: post
title:	"Infrastructure as Code at Scale"
category: [Programming]
excerpt: A layered model for describing Infrastructure as Code (IaC) at scale.
image: public/images/buttons/large/ahmygod.gif
---

The Open Systems Interconnection (OSI) model is a conceptual model created by ISO that describes how information flows through different layers in a network system.
This post describes a similar model that applies to architecting Infrastructure as Code (IaC) at Scale.
The layers do not correspond 1-1 to tools and practices used today, but they provide a useful guide for deploying and managing a diverse set of of applications with distinct compute and data requirements.

This is meant to be applied to large deployments, beyond a single cluster or two.
The model attempts to encompass most aspects of managing complex deployments of applications and services across multiple environments.
A "normal" deployment under this model could have `n regions * m stack types * a applications * r replicas * z Disaster Recovery ratio`.
Beyond the deployment there are also security, regulatory and contractual requirements that influence the design.

By partitioning IaC into layers, we can better understand how different aspects of are configured,  monitored, and secured.
Each layer will have a difference balance of manual vs. "codified" actions.
IaC should aim to be ergonomic and scalable for the operators and maintainers.
It should be thought of as weaving together different threads of infrastructure into a cohesive fabric that provides a stable foundation for applications to be built on.

## IaC Reference Model

### Layer -1: Billing

Someone's getting paid somewhere.
The billing underlies all the layers.
To cost to participate in modern "IP Networks" can vary wildly depending on your needs and how you execute.
Most of the time this requires a credit card, but there are growing crypto-backed operations that have greater separation from the traditional financial systems.
There is always self-hosted intranet options, but there are still raw resource requirements.

This will include things like:

* Cloud provider accounts
* Domain name registry
* ASN/IP Registry
* Self-hosted electricity/internet/hardware

#### Monitoring / Security

While there are ways to manage these with IaC, it often needs manual intervention and verification.
The best automation for this layer is email rules for getting your attention.
Core accounts should trigger emails when logged into or updated.

Strong passwords are extremely important.
Make them as long as possible, and use a password manager.

You should also take advantage of Whois (now [RDAP](https://openrdap.org/)) privacy and [RPKI services](https://www.arin.net/resources/manage/rpki/).
With enough justification, these can be self-hosted but this is not a common approach.

### Layer 0: Privilege

The privilege layer manages access to the cloud provider though Identity Access Management (IAM).
To use a service, you usually need an account to deploy resources into.

For 1-2 accounts, this can be done manually, but for any more you should require IaC.
While changes are made very rarely, changes here effect core pieces of how all other layers operate.
It also helps version control the changes for easy reference and rollback.

Constructing a tree of least-privilege.

### Layer 1: Cluster Network

This network is used for private communication between nodes and resources.
For very simple deployments this may be contained within a single node or VPC.
For larger deployments, this will encompass multiple nodes, networks, and cloud providers.

For anything more complex than a single VPC you will need to start using tunnels to create your network.
Traditionally IPSec tunnels were used, but more recently Wireguard tunnels have become popular for being simpler and more efficient.

* [Tailscale](https://tailscale.com/kb/1151/what-is-tailscale)
* [Netmaker](https://docs.netmaker.io/docs/about)
* [Aviatrix](https://docs.aviatrix.com/documentation/latest/getting-started/platform-overview/index.html?expand=true)
* [Raw Wireguard](https://www.wireguard.com/quickstart/#command-line-interface)

#### Structure

Separate "tiers" of cluster networks statically define network with varying levels of internal and external access.
Resources in the other layers should be able to reference these tiers for baseline configuration.
The tiers should help reinforce secure resource isolation to limit attack surface.  

* Core - Command and Control resources, including internal-facing [Application Networks](#layer-5-application-network)
* Internal - [Applications](#layer-6-application) and client services
* External - DMZ-type tier, containing external-facing [Application Network](#layer-5-application-network) pieces 

### Layer 2: Permissions

Setup authentication and _operational_ access to cloud resources.
This set of access permissions allow API access for yourself and automation.
It is distinct from the operational access permissions in Layer 1 in that this layer focuses on _operational_ access rather than management access.

This encompasses managing authentication and authorization for your cloud resources and applications.
It usually ends up being a conglomeration of a few different tools that manage different pieces of that auth like SSH keys, SSO, and IAM roles.

Centralize management of authentication, authorization, accounting.

### Layer 3: Compute

Raw instances and services that run your applications.
Holistically, this can be anything that transforms an input to output but practically it's an internet-connected CPU with some amount of usable RAM.

* Physical Nodes - Servers, Raspberry Pis, Android phones
* Virtual Machines - EC2 Instances, Droplets, VMs
* Cluster-as a service - EKS, GKE, AKS
* Serverless - Lambda, FaaS

Broadly organize work to minimize resources needed to complete task, but don't over-optimize.
For clusters, consider consolidate or split up nodes to keep average utilization high while also absorbing spikes.

With modern cloud computing, the bottleneck is often memory but this is directly tied to workloads being ran.
With enough integration of information about the infrastructure, you can optimize for $/mem, $/cpu, or $/egress.

### Layer 4: Storage

Applications often need to persist data beyond the lifetime of the program.
Each one has it's own special way and practices, but they can be roughly grouped into:

* Block/File/Object storage (cluster-local or managed)
* Databases
* Backup+Restore process
* Caching

Data locality is also a key concern for performance and security.
Data locality is the practice of keeping data close to where it's needed, reducing latency and improving efficiency.
Storage resources are located:

1. Node/cluster local - Share compute with application
2. Cluster cluster - Clusters managed by you, backed by raw provider 
3. Managed service - DB-as-a-Service

Keeping data close to where it's needed also helps reduce costs, as you aren't burning egress fees shipping bits around needlessly.

#### Persistence

Data is large, arbitrary, and often unstructured.
Data should be stored in a way that is scalable, durable, and secure.
It should also attempt to minimize duplication.
Filesystems like ZFS or Btrfs can be configured to deduplicate and compress data at the block level.
Backups should also follow the incremental "snapshot" paradigm, with full backups being taken at regular intervals.

When storing the data long-term, `3-2-1` principle should be followed:

* 3 copies of the data 
* across 2 mediums
* with 1 copy off site

This ensures data is available even if one of the mediums fails.
Of course in the event of some incident, the issue becomes is restoring data in a timely predictable manner.

### Layer 5: Application Network

This layer manages application-external access.
selectively links parts of the application available to external networks.
You "target audience" may be the wider internet, internal clients/teams, or other cluster applications.

This is separate from [Cluster Network](#layer-1-cluster-network), in that it's focused on the application itself, rather than supporting the core communication of the cluster as a whole.
These pieces are usually deployed alongside the application resources they are supporting.

Here are some examples of components in this layer:

* Application DNS - Usually `A` and `AAAA` records, but includes `MX`, `TXT` and others
* Load balancers - Distributed balancers to route traffic to backend nodes
* Ingress gateways - Manages routing rules at L3(Layer 3) and L4(TCP/UDP/etc.) + L7(HTTP(S)/DNS)
* Proxy / Firewalls / Filtering Policy - Manages traffic flow and security at the application level 

### Layer 6: Application

These are the actual applications that run on the infrastructure.
There is an extreme variety of deployment methods, so it is usually best to focus on a way that is ergonomic for both the application and maintainer.

The application itself is beyond the purview of this article, but it should aim to be encapsulated in a easy-to-consume manner.
Docker containers seem to have become the most popular, but can be overkill depending on the purpose of the application deployment.
Whatever solution used, as much of the configuration as possible should be statically defined.

Documentation **needs** to be included.
If something isn't documented, it doesn't exist.
The same configuration used to prep and deploy the application can be used to provide greater documentation context.

### Layer 6.5: Inter-Applications Integrations

With multiple applications comes the interaction of applications with each other.
This layer encodes the services and resources an application makes available, and how they can be consumed.
The configuration is highly application-dependent and involves creating "glue" configuration between applications, often through a service mesh or API gateway.

Resources in this layer can encroach deeply into the applications and infrastructure, making them difficult to manage.
The configuration may also end up located with the application UI, and not easily accessible via IaC config.

If there is a lot of investment in this area of configuration, it may be worth considering "pushing down" the configuration into lower layers so that it can be more easily managed and maintained.


## Architectural Design Considerations

### Security

Each layer has it's own security considerations.
Typically for an application to be at all usable there needs to be some sort of information exchanged two it.
The challenge is balancing usability and security.

Management of the infrastructures security should follow [Tenants of Zero Trust](https://web.archive.org/web/20210421022121/https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-207.pdf):

* **Data and compute are resources**:  The raw data and compute are treated the same as application from a security perspective.  Properties like region and provider are aspects to be considered.
* **All communication is secured**: All communication between data and compute should utilize secured communication at multiple layers with Wireguard tunnels, network policy, https etc.
* **Per-resource, per-session access**: The trust boundary should be as close to the application as possible.  
* **Determine access through collection of client and env properties**: Raw credentials should obviously be considered, but additional bits of information can be used to make a more informed determination like source IP or session event timings.
* **Monitor the security**: Red team yourself to constantly verify the protections in place are operational and effective.  In that vein, security pieces that do have issues should most often fail closed.
* **Security is a cycle of scanning, analysis, adjustment**: Threats are constantly evolving, and your security needs to as well. Patching should automated to the point of approval to make it as frictionless as possible.
* **Use system state information to improve security posture**: At a minimum all auth should be logged.  Collect what you will use.  While it may be inviting to mirror, decrypt and analyze complete netflow data, that quickly becomes cost-prohibitive.  There are sharp diminishing returns, so the volume should be calibrated to your security posture.

### Monitoring

Unless there are regulatory or contract requirements, "lossy logging" can be an effective way to extract value from logs while minimizing the volume processed and stored.
High volume logging close to the source and pass on less information as the logs are transferred within the system.
As that data is replicated further from the source, funneling the data is important.
The amount of log traffic can be funneled/reduced by various means:

* Minimize logging: Who needs debug?  Make it easy to enable, but if no ones looking then limiting logging to warning and above reduces log chatter
* Deduplication - Capture logs in a window only pass on changes in values. 
* Summarization - Collect sets of logs and perform light 
* Sampling - pass on a percentage of logs, simply dropping anything thats not passed on.  This is under tha assumption that the logs are not critical and can be lost without consequence.

### Source of Truth

Idempotent definitions.
Take advantage and templating and configuration management to minimize the amount of manual intervention required.

There are innumerable methods to organize code, whether it a mono-repo, component repos, or monoliths.
The key is to choose one that fits your organization's needs and stick with it.
What's really important is that it is consistent and repeatable.

Configuration should be derived from the applications needs in a standard way to **minimize snowflakes**.
Code should be built on references to standard pieces instead of copies to minimize drift and decay.

Shared, application-level configurations should additive, allowing resources to selectively "opt-in" to sets of properties instead of being assigned a single, restrictive application type.
By defining the properties as sets, features from [set theory algebra](https://en.wikipedia.org/wiki/Set_(mathematics)#Basic_operations) can be applied.

### Lifecycle

All applications and resources will have a lifecycle scale and rate.
Like documentation, any resource deployed is almost immediately out of date.
Resources are in a constant state of flux making IaC a dynamic and evolving process.

While it is impossible to capture all aspects of a system as code, getting things "good enough" is good enough.
By virtue of being code, it can also be updated and improved over time.
Writing (describing?) resources is no different than writing regular business-logic-type code, there are just a lot more moving pieces.

* Keep it organized - flatten abstractions behind configurable, sensible defaults
* Keep it simple - Minimize complex dependencies that cross resource boundaries.
* Use tools available - linting, perf analysis, and testing.
* Design for scale - Consider how the system will grow and adapt to change.

## Conclusion

The easy part is deploying the service.
The application developer environment has changed greatly since even just a decade ago.
There are many more tools, libraries, and frameworks available to developers leading to more standard, predictable applications.
The advent of broader generative AI has made it easier to write code, but also more difficult to reason about the system as a whole.

Architecting the platform and integrations around the service is the real challenge.
The platform is like any other product, and needs to provide guarantees to the applications running on it.
It does not operate in a vacuum, it is a living system that needs to be maintained and adapted over time.
Like growing a tree, it takes care and patience to create a solid system.
Unlike a tree, everything is moldable, replicate-able, and roll-back-able (mostly).
By keeping the lifecycle of the resource in mind you can better anticipate and negate issues that may arise.

## Further Reading

* [Lee Briggs - Structuring IaC](
https://leebriggs.co.uk/blog/2023/08/17/structuring-iac)
* [Nathan Peck - Rethinking Infrastructure as Code from Scratch](https://nathanpeck.com/rethinking-infrastructure-as-code-from-scratch/)
* [OWASP - Cloud Architecture Cheatsheet](https://cheatsheetseries.owasp.org/cheatsheets/Secure_Cloud_Architecture_Cheat_Sheet.html)
* [Hacker](https://news.ycombinator.com/item?id=30904019) [News](https://news.ycombinator.com/item?id=36812848) [Comments](https://news.ycombinator.com/item?id=19652376)
