---
layout: post
title:	"Infrastructure as Code at Scale"
category: [Programming]
excerpt: A short description of the article
image: public/images/buttons/large/ahmygod.gif
---

The Open Systems Interconnection (OSI) model is a conceptual model created by ISO that describes how information flows through different layers in a network system.
This post describes a similar model that applies to architecting Infrastructure as Code (IaC) at scale.
The layers do not correspond 1-1 to tools and practices used today, but they provide a useful guide for deploying and managing a diverse set of of applications with conflicting needs.

This is meant to be applied to large deployments, beyond a cluster or two.
A "normal" deployment under this model could have `n regions * m types * r replicas * z Disaster Recovery ratio`.
Outside of the deployment there are undoubtedly regulatory and contractual requirements that also influence the design.
Despite this, the same principles and considerations can be applied to simpler deployments to simplify complexity.

By partitioning IaC into layers, we can better understand how different aspects of are configured,  monitored, and secured.
Each layer will have a difference balance of manual vs. "codified" actions.
IaC should aim to be ergonomic and scalable for the operators and maintainers.
It's about building a string, solid foundation for applications to be built on top of.

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

When architecting a system,

For anything more complex you'll start using tunnels to create your network.
Traditionally IPSec tunnels were used, but more recently Wireguard tunnels have become popular for being simpler and more efficient.

* [Tailscale](https://tailscale.com/kb/1151/what-is-tailscale)
* [Netmaker](https://docs.netmaker.io/docs/about)
* [Aviatrix](https://docs.aviatrix.com/documentation/latest/getting-started/platform-overview/index.html?expand=true)

#### Structure

Separate "tiers" of cluster networks statically define network with varying levels of internal and external access.
Resources in the other layers should be able to reference these tiers for baseline configuration.  

* Core - Command and Control resources, including internal-facing [Application Networks](#layer-5-application-network)
* Internal - [Applications](#layer-6-application) and client services
* External - DMZ-type tier, containing external-facing [Application Network](#layer-5-application-network) pieces 

### Layer 2: Permissions

Setup authentication and _operational_ access to cloud resources.
This set of access permissions allow API access for yourself and automation.
It is distinct from the operational access permissions in Layer 1 in that this layer focuses on _operational_ access rather than management access.

This encompasses managing authentication and authorization for your cloud resources and applications.
It usually ends up being a conglomeration of a few different tools that manage different pieces of that auth like SSH keys, SSO, and IAM roles.

Centralize authentication, authorization, accounting.


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
Filesystems like Zfs or Btrfs can be configured to deduplicate and compress data at the block level.
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

### Layer 7: Inter-Applications Integration

Beyond the application is 
Applications can be integrated together
Application awareness

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

Unless there are regulatory or contract requirements, "lossy logging" .
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

Flatten abstractions

References instead of copies.

Configuration should be derived from the applications needs in a standard way to **minimize snowflakes**.
Applications should "opt-in" to sets of properties instead of being assigned a single application type.
By defining the properties as sets, features from [set theory algebra](https://en.wikipedia.org/wiki/Set_(mathematics)#Basic_operations) can be applied.

### Lifecycle

All applications and resources will have a lifecycle.
Anything you create will be different in a year.
It will probably be different in 3 months, if not the application itself then the supporting infrastructure around it.

Resources are in a constant state of flux, and the IaC should strive to describe and codify these changes.

#### Rate of Change

## Conclusion





---

https://leebriggs.co.uk/blog/2023/08/17/structuring-iac
---

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
