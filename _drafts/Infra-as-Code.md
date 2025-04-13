---
layout: post
title:	"Infrastructure as Code at Scale"
category: [Programming]
excerpt: A short description of the article
image: public/images/buttons/large/ahmygod.gif
---

## Layers

The OSI is the usual model for network

As part of every layer there are monitors


### Layer -1: Billing

Someone's getting paid somewhere.
The billing underlies all the layers.
Most of the time this requires a credit card, but there are growing crypto-backed options.
This will include:

* Cloud provider accounts
* Domain name registry
* AS/IP Registry

While there are ways to manage these with IaC, it often needs manual intervention and verification.
The best automation for this layer is email rules for getting your attention.

### Layer 0: Privilege

The privilege layer manages access to the cloud provider though Identity Access Management (IAM).
To use a service, you usually need an account to deploy resources into.

For 1-2 accounts, this can be done manually, but for any more you should require IaC.
While changes are made very rarely, changes here effect core pieces of how all other layers operate.
It also helps version control the changes for easy reference and rollback.

### Layer 1: Cluster Network

This network is used for private communication between nodes and resources.
For very simple deployments this may be contained within a single node or VPC.

For anything more complex you'll start using tunnels to create your network.
Traditionally IPSec tunnels were used, but more recently Wireguard tunnels have become popular for being simpler and more effecient.

* [Tailscale](https://tailscale.com/kb/1151/what-is-tailscale)
* [Netmaker](https://docs.netmaker.io/docs/about)
* [Aviatrix](https://docs.aviatrix.com/documentation/latest/getting-started/platform-overview/index.html?expand=true)

### Layer 2: Permissions


Setup authentication and _operational_ access to cloud resources.

Setup API access for yourself and automation.


### Layer 3: Compute

Raw instances

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

This supports the application by linking it to the greater network.
It manages how your "customers" access your application.
A customer can be actual, paying customers, internal teams, 

This is separate from [Cluster Network](#layer-1-cluster-network).
This layer focuses on more application-centric networking concerns, including:

* Application DNS
* Load balancers
* Ingress gateways
* Certificate management
* Filtering ([Anubis](https://github.com/TecharoHQ/anubis/#setting-up-anubis))

### Layer 6: Application

These are the actual applications that run on the infrastructure.
There is an extreme variety of deployment methods, so it is usually best to focus on a way that is ergonomic for both the application and maintainer.

Docker containers seem to have become the most popular, but can be overkill depending on the purpose of the application deployment.

### Layer 7: Integrating Applications Together

## Architectural Design Considerations

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
