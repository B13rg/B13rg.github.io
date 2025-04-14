---
layout: post
title:	"Infrastructure as Code at Scale"
category: [Programming]
excerpt: A short description of the article
image: public/images/buttons/large/ahmygod.gif
---

## Layers

The OSI is the usual model for network

As part of every layer there are monitoring, security


### Layer -1: Billing

Someone's getting paid somewhere.
The billing underlies all the layers.
Most of the time this requires a credit card, but there are growing crypto-backed options.
This will include:

* Cloud provider accounts
* Domain name registry
* AS/IP Registry

#### Monitoring / Security

While there are ways to manage these with IaC, it often needs manual intervention and verification.
The best automation for this layer is email rules for getting your attention.
Core accounts should trigger emails when logged into or updated.

Strong passwords are extremely important.
Make them as long as possible, and use a password manager.

You should also take advantage of Whois (now [RDAP](https://openrdap.org/)) privacy and [RPKI services](https://www.arin.net/resources/manage/rpki/).
With enough of a reason these can be self hosted.

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

For anything more complex you'll start using tunnels to create your network.
Traditionally IPSec tunnels were used, but more recently Wireguard tunnels have become popular for being simpler and more efficient.

* [Tailscale](https://tailscale.com/kb/1151/what-is-tailscale)
* [Netmaker](https://docs.netmaker.io/docs/about)
* [Aviatrix](https://docs.aviatrix.com/documentation/latest/getting-started/platform-overview/index.html?expand=true)

#### Monitoring/Security

Separate "tiers" of cluster networks statically define network with varying levels of internal and external access.

* Core - Command and Control resources, includeing internal-facing [Application Networks](#layer-5-application-network)
* Internal - [Applications](#layer-6-application) and client services
* External - DMZ-type tier, containing external-facing [Application Network](#layer-5-application-network) pieces 

### Layer 2: Permissions

Setup authentication and _operational_ access to cloud resources.

Setup API access for yourself and automation.

Centralize authentication, authorization, accounting.


### Layer 3: Compute

Raw instances and services that run your applications.
Holistically, this can be anything that transforms an input to output but practically it's an internet-connected CPU with some amount of usable RAM.

* Physical Nodes: Servers, Raspberry Pis, Android phones
* Virtual Machines: EC2 Instances, Droplets, VMs
* Cluster-as a service: EKS, GKE, AKS
* Serverless: Lambda, 



Uptime
memory pressure
CPU mitigations (or not).

### Layer 4: Storage

Data locality is a key concern for performance and security.
Data locality is the practice of keeping data close to where it's needed, reducing latency and improving efficiency.
Storage resources are located:

1. Node/cluster local - Share compute with application
2. Cluster cluster - Clusters managed by you
3. Managed service - SaaS

Keeping data close to where it's needed also helps reduce costs, as you aren't burning egress fees shipping data around needlessly.

Depending on your planned applications, this layer can include:

* Block/object storage (cluster local or managed)
* databases
* backup+restore process

### Layer 5: Application Network

This layer manages application-external access.
selectively links parts of the application available to external networks.
You "target audience" may be the wider internet, internal clients/teams, or other cluster applications.

This is separate from [Cluster Network](#layer-1-cluster-network), in that it's focused on the application itself, rather than supporting the core communication of the cluster as a whole.

These pieces are deployed at levels in relation to the application they're supporting.

Configuration should be derived from the applications needs in a standard way to minimize snowflakes.
Applications should "opt-in" to sets of properties instead being assigned a single type to .

Here are some examples of components in this layer:


* Application DNS - Usually `A` and `AAAA` records, but includes `MX`, `TXT` and others
* Load balancers - Distributed balancers to route traffic to backend nodes
* Ingress gateways - Manages routing rules at L3(Layer 3) and L4(TCP/UDP/etc.) + L7(HTTP(S)/DNS)
* Proxy / Firewalls / Filtering Policy: Manages traffic flow and security at the application level 


([Anubis](https://github.com/TecharoHQ/anubis/#setting-up-anubis))

### Layer 6: Application

These are the actual applications that run on the infrastructure.
There is an extreme variety of deployment methods, so it is usually best to focus on a way that is ergonomic for both the application and maintainer.

Docker containers seem to have become the most popular, but can be overkill depending on the purpose of the application deployment.

As much of the configuration as possible should be statically defined.


### Layer 7: Integrating Applications Together

Applications can be integrated together

## Architectural Design Considerations

### Monitoring

### Security

Each layer has it's own security considerations.
Typically for an application to be at all usable there needs to be some sort of information exchanged two it.
The challenge is balancing usability and security.

Deeper layers 

Leads into...

### Lifecycle

### Rate of Change

### Source of Truth



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
