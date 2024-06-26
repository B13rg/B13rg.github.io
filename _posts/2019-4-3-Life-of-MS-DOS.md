---
layout: post
title:	"The Life of MS-DOS"
categories: [DOS]
excerpt: First released on August 12, 1981, MS-DOS became the foundation for business computing for almost two decades.  This article details different versions and releases that all stemmed from Gary Kildall's QDOS.
image: /images/MSDOS/MSDOS_family_tree.png
comment_id: 105477644244489198
---
First released on August 12, 1981, MS-DOS became the foundation for business computing for almost two decades.
MS-DOS stood for Microsoft Disk Operating System and was often referred to simply as "DOS".
It is the software that helped build Microsoft, becoming the foundation Microsoft built the Windows operating system on.
It went through 8 (and a half-ish) major revisions, with the final version being shipped with Windows ME in September, 2000.
Before I talk about MS-DOS proper, I talk about it's "grandparents" if you will, Digital Research's CP/M and Seattle Computer Product's 86-DOS.

In addition to writing this article, I also made the following cladogram chart showing the relationships of different DOS "flavors".
I hope to use it in other articles to walk through the history of Digital Research's DOS, DR DOS and the many transformations it went through.

The code for the chart can be found in my `Projects` repository, under the [Dos Lineage Cladogram](https://github.com/B13rg/Projects/tree/master/Dos%20Lineage%20Cladogram) folder.

![MS-DOS Family Tree](/images/MSDOS/MSDOS_family_tree.png){:width="700px"}

[Link to full-size image](/images/MSDOS/MSDOS_family_tree.png)

---

## CP/M

CP/M was a operating system designed by Gary Kildall for Digital Research.  
It was designed for 8-Bit computers, so it ran on Intel 8080/85 and Z80 processors.
CP/M originally stood for "Control Program/Monitor" and later "Control Program for Microcomputers".
CP/M 1.4 was the first major version released, later followed by version 2.2.
CP/M was even able to run on the Commodore 64, though it required a specialized cartridge that housed a Z80 processor.
At the time, IBM was looking for an operating system to use with their IBM PC line of products.
IBM discussed licensing CP/M from Digital Research, but they were unable to come to an agreement.
IBM looked elsewhere for an operating system and in July of 1980 began talks with Microsoft about their development of MS-DOS, which was based on 86-DOS by Seattle Computer Products.

While IBM moved on, Digital Research went on to develop their own version of DOS based on CP/M 86 that eventually became DR DOS.
As ownership of Digital Research changed, later versions had different names like Novell DOS and Caldera DR-OpenDOS (what a mouthful).
This branch of the DOS family is still somewhat alive under the name DR-DOS (with the hyphen) with the last real update being back in 2011.
The website for the project is now seemingly dead but it can still be viewed on archive.org.
More about this project can be found [here](https://web.archive.org/web/20160425031024/http://www.drdosprojects.de/index.cgi/download.htm).

## QDOS / 86-DOS

86-DOS was originally developed by Seattle Computer Products (SCP) beginning in April of 1980.
It was originally named QDOS (Quick and Dirty Operating System), but was changed to 86-DOS once they began shipping in August of 1980.
It was first developed to be packaged with CPM's 8086 computer kit.
SCP originally wanted to simply use Digital Research's 8086 version of CP/M, but with an uncertain release date SCP made the decision to develop an OS themselves.
While writing it, the programmer Tim Paterson referenced the manual for CP/M-80 which explains why CP/M and QDOS were so alike.
Because of its similarity to CP/M, it was easy to port programs originally designed for CP/M on 8080 and Z80 processors to QDOS, which targeted 8086 processors.
Development of the software ended up taking only 6 weeks.

QDOS 0.11 was released in August of 1980, which is when it was renamed to 86-DOS.
Microsoft ended up licensing it from SCP in December of 1980 and in May of the following year hired Tim Patterson to assist in porting it to the IBM PC.
A month before Microsoft's new operating system was release, they purchased all rights to 86-DOS from SCP for only $50,000.
After settling a lawsuit over the deal with SCP, Microsoft later ended up paying a total $1 million.
Microsoft took it's adapted 86-DOS 1.14, created MS-DOS 1.10/1.14, and licensed it to IBM who sold by IBM under the name PC DOS 1.0.

## MS-DOS and PC DOS

PC DOS versions 1.0, 1.1, 2.0, 2.1, 3.0, 3.1, 3.2, 5.0, and 6.0 were developed primarily by Microsoft, though IBM made additions of their own specific to their computers.
For some versions, Microsoft didn't directly contribute to development but IBM based their changes on existing code.[2]
This was one of the few instances where Microsoft licensed MS-DOS to another company and had allowed the company to rebrand it.
A few other versions that were licensed and rebranded were SB-DOS, COMPAQ-DOS, NCR-DOS AND Z-DOS.
Eventually, it started enforcing the MS-DOS name for all OEM's except IBM.

While the development of different MS-DOS versions was fairly standard, version 4.0 and 4.1 were interesting.
MS-DOS 4.0 was based on MS-DOS 2.0 and was developed in paralell with MS-DOS 3.0.
This version was designed as a multitasking version of DOS.
It was designed to allow specially written programs to run in the background while the user continued to interact in the foreground, similar to services in Windows.
While being developed, IBM and other OEM's weren't interested in it so Microsoft instead had a limited release in Europe.
Interestingly, the same developers who worked on this multitasking version moved on to work on what became OS/2, an operating system for IBM PC's.

Though MS-DOS 4.1 was worked on and developed, it never really saw a wider release.
It was interesting as an operating system, but "Microsoft at the time was a 100% OEM shop – we didn’t sell operating systems, we sold operating systems to hardware vendors who sold operating systems with their hardware."[3]
Instead, the next "real" version of MS-DOS released was 4.00 which distinguished itself with an extra "0" in the version number.
This was the version that was also rebranded as PC DOS 4.0 for IBM.

## The Final Years

MS-DOS 6.3 was the last version that was released as a stand alone program.
The next version, MS-DOS 7.0 was released as part of Windows 95.
Both Windows 95 Revision 2 and the first release of Windows 98 were equipped with MS-DOS 7.1 running things behind the scenes.
These were the first major versions of MS-DOS that were completely separate from PC DOS, whose version 7.0 was developed by IBM alone.

The final version of MS-DOS was released as a part of Windows ME in September of 2000.
This was the last version of windows that used MS-DOS as a foundation.
Windows XP moved to the NT kernel, whose primary difference was moving away from a monolithic kernel to a hybrid kernel.
With MS-DOS, the kernel and operating system exists completely within the kernel space.
Windows NT uses a safer structure, where the kernel is split between the kernel space and the user space.

![Windows 9.x Kernel Design](/images/MSDOS/win9xKernel.gif)

A diagram of Windows 95 Kernel Structure

---

## Further reading

A writeup by Tim Patterson looking at the design decisions of MS-DOS: [http://www.patersontech.com/dos/byte%E2%80%93inside-look.aspx](http://www.patersontech.com/dos/byte%E2%80%93inside-look.aspx)

Writing about an early pre-release version of PC DOS: [https://thestarman.pcministry.com/DOS/ibm090/](https://thestarman.pcministry.com/DOS/ibm090/)

The released source code of MS-DOS 1.25 and 2.0: [https://github.com/microsoft/ms-dos](https://github.com/microsoft/ms-dos)

A page describing the changes in each version of MS-DOS and PC DOS: [https://web.archive.org/web/20181006120605/https://sites.google.com/site/pcdosretro/doshist](https://web.archive.org/web/20181006120605/https://sites.google.com/site/pcdosretro/doshist)

An archive of an MSDN article about multitasking DOS: [https://web.archive.org/web/20190118134253/https://blogs.msdn.microsoft.com/larryosterman/2004/03/22/did-you-know-that-os2-wasnt-microsofts-first-non-unix-multi-tasking-operating-system/](https://web.archive.org/web/20190118134253/https://blogs.msdn.microsoft.com/larryosterman/2004/03/22/did-you-know-that-os2-wasnt-microsofts-first-non-unix-multi-tasking-operating-system/)

A history of the personal computer.  Chapter 12 (Microsoft in the 1980s) and Appendix B (Versions of DOS) are especially interesting: [http://www.retrocomputing.net/info/allan/](http://www.retrocomputing.net/info/allan/)

A collection of old operating systems, including disk images of many different DOS versions: [https://winworldpc.com/library/operating-systems#](https://winworldpc.com/library/operating-systems#)

A history of MS-DOS written by Digital Research: [http://www.digitalresearch.biz/HISZMSD.HTM](http://www.digitalresearch.biz/HISZMSD.HTM)

A description of the different features of MS-DOS 8.0, the last official release: [http://www.multiboot.ru/msdos8.htm](http://www.multiboot.ru/msdos8.htm)