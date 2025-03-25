---
layout: post
title:	"Enabling cloud-init on proxmox qcow2 images"
category: [Programing]
excerpt: A short guide on adding cloud-init options to an existing image.
---

Proxmox is a valuable virtualization platform tham makes it simple to manage and deploy VMs.
Cloud-init is an "industry standard multi-distribution method for cross-platform cloud instance initialization"[^1].

While Proxmox itself does not support cloud-init out-of-the-box, there are ways to integrate it with your Proxmox environment. 
There are some extra steps to configure a QEMU image format[^2].

On you proxmox host, you will first need to install `libguestfs-tools` and the image you want to modify and use.
In this example, I get debian 12 generic cloud image.

```bash
apt install libguestfs-tools
mkdir -p /var/lib/vz/template/qemu &&  cd /var/lib/vz/template/qemu
wget https://cloud.debian.org/images/cloud/bookworm/20250316-2053//debian-12-genericcloud-amd64-20250316-2053.qcow2
```

Now that the image is downloaded, we need to patch it with `virt-edit` to add the cloud-init files.

```bash
virt-edit debian-12-genericcloud-amd64-20250316-2053.qcow2  /etc/cloud/cloud.cfg
virt-edit debian-12-genericcloud-amd64-20250316-2053.qcow2  /etc/ssh/sshd_config
virt-edit debian-12-genericcloud-amd64-20250316-2053.qcow2  /etc/motd
```

Now we will import the raw image into proxmox, and mark it as having cloud-init support:

```bash
qm importdisk 100 ./debian-12-genericcloud-amd64-20250316-2053.qcow2 local-lvm
qm set 100 --ide2 local-lvm:cloudinit
```

[^1]: https://cloudinit.readthedocs.io/en/latest/index.html
[^2]: Proxmox Cloud-init docs: https://pve.proxmox.com/wiki/Cloud-Init_Support