---
layout: post
title:	"Future of Special Purpose Hardware Part 2: Application Specific"
category: [Hardware]
excerpt: A short description of the article
image: public/images/plugin.png
#comment_id: 72374862398476
---

While general-purpose add-in cards would be useful, they would be focused on achieving "ok" performance on a variety of tasks instead of excelling at a single, specific task.
Instead of creating a card that acts as a co-computer for the host, there could instead be application-specific cards that are intended to run a single application really well.
These cards would be focused toward supporting application that require high performance, like photo/video editing, ML training, or even operating systems.

They would be custom-designed for each application.
For certain programs, instead of downloading the program and running it on your own hardware you would purchase the add-in card that program and everything you need to run it.
As a user, you could be confident in your computer's ability to run a program, and not have to worry about costly upgrades to your PC, only the (costly) add-in card.

From a programming perspective, programs could be more deeply integrated with the hardware.
With a tighter coupling to hardware, software will be able to achieve higher performance and enable greater security.
The "distance" between the transistors on the CPU and the application code running can be large, especially with the popularization of virtualization.

The hardware can also be designed with the program/task in mind.
One of the more cost-effective ways of mining cryptocurrency is using an ASIC, application-specific integrated circuit.
By using ASICs designed for a coin's hashing algorithm, the hardware can perform more quickly and efficiently than a normal CPU or GPU.

Value proposition to company:
* Full control of tech stack
* Full control over hardware
* more security for code
* extract better performance

### Examples on a card

#### Adobe Cloud Suite

This card would enable a much wider range of computers the ability to run the different editors.
It would provide a minimum level of performance, no matter what computer the user is using.
While editing simple things like photos and simple videos isn't too taxing, render times rapidly explode as the complexity of a project increases.

The card could have an FPGA that could be re-programmed on the fly as the user performs different tasks.
For example, many processors today contain dedicated hardware traces to handle h.264 or h.265 encoding/decoding tasks.
Because it is implemented in hardware rather than software, there is a huge performance benefit.
The card could be able to dynamically configure the FPGA depending on what codecs are in use while editing.
That way, you could easily get the same hardware performance benefit no matter what type of video is being edited/rendered.[^PERF]

By implementing codecs and other high-performance-liking code in the FPGA, it allows the hardware to be dynamically adjusted and updated as needed.
Hardware is always difficult because of there's an error in the implementation, you're stuck with it (see Spectre and Meltdown vulns.).
By designing everything with FPGAs, you give up some amount of performance and chip density *but* you are also able to update and change the code to fix bugs and issues after things are shipped.
This also means that a bad actor could also hack in and change things, but that is a risk with anything that runs code.

#### Kubernetes

* provides compact, reliable platform to run container clusters
* interact through container api
* Add more cards for more power

As more and more people have their own computers, instead of companies sending laptops/computers to WFH employees, instead send "Job card" which is pre-programmed by company it with everything you need.

### Placing OS on hardware

Instead of buying a license and installing normally, buy a "Windows Card".

A PCI-E card that has windows installed on it.
Comes with co-processor, 8gb of memory, 2x500G nvme.

Boot from PCIe card, card handles running windows, has built in hardware for kvm/windows processes etc.

User programs can run on the main hardware of the PC.

Allows more of the computers resources to be used for applications rather than sharing with host OS.
Move OS, simple networking, simple graphics support to add on card.

Sell different models of cards with different specs.

Like a second computer that controls you're main computer.

On card coprocessor works together with the primary motherboard processor to work better.

### Security

Each can have it's own TPM for signing, rng etc.



### Cost



---

[^PERF]: Software vs. variety of hardware render performance comparison: [https://www.pugetsystems.com/labs/articles/Premiere-Pro-14-2-H-264-H-265-Hardware-Encoding-Performance-1778/](https://www.pugetsystems.com/labs/articles/Premiere-Pro-14-2-H-264-H-265-Hardware-Encoding-Performance-1778/)


[^GPTJ]: GPT-j model training blog post: [https://arankomatsuzaki.wordpress.com/2021/06/04/gpt-j/](https://arankomatsuzaki.wordpress.com/2021/06/04/gpt-j/)
[^GTPU]: Google TPU info: [https://cloud.google.com/tpu/docs/types-zones#europe](https://cloud.google.com/tpu/docs/types-zones#europe)
[^BENCH]:  Intl core i9 9900k benchmark: [https://gadgetversus.com/processor/intel-core-i9-9900ks-gflops-performance/](https://gadgetversus.com/processor/intel-core-i9-9900ks-gflops-performance/)
[^pciHD]: Normal, run-of-the-mill PCI-e hard drive: [https://www.newegg.com/western-digital-1tb-black-an1500-nvme/p/N82E16820250159](https://www.newegg.com/western-digital-1tb-black-an1500-nvme/p/N82E16820250159)
[^pciRAM]: Use RAM as a hard drive: [https://www.newegg.com/gigabyte-gc-ramdisk-others/p/N82E16815168001](https://www.newegg.com/gigabyte-gc-ramdisk-others/p/N82E16815168001)
[^pciFPGA]: $10,119.38 FPGA card: [https://www.mouser.com/ProductDetail/BittWare/XUPVV8-0001?qs=vmHwEFxEFR%252BvJu%2FaBspDgw%3D%3D](https://www.mouser.com/ProductDetail/BittWare/XUPVV8-0001?qs=vmHwEFxEFR%252BvJu%2FaBspDgw%3D%3D)
