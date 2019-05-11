---
layout: post
title:	"Checking out a 3COM 3C996B-T Gigabit NIC"

---

3Com was a networking product manufacturer that sold networking gear such as switches, routers, access points, and network interface cards.
The company was founded in 1979, and was eventually bought by HP in 2010, where they continue to work on networking products.

![Da Box](/images/3ComGigNic/the_box.jpg){:width="500px"}

The 3C996B-T Network Interface Card (NIC) was put on the market in late 2001/early 2002.
The earliest product page for the card on 3Com's website  was dated November 18, 2001.
Even though it supports consumer type operating systems, the cards were meant to be installed in servers.
The packaging states that the card "offloads transfer cycle-intensive checksum processing from the host CPU to the NIC".
It also supports Gigabit data transfer, which at the time was a fairly new and had just been established (1999).

The box declares the card to be a "Gigabit Fiber-SX Server Network Interface Card" and is labeled as a 3C996-SX, which is the fiber model of the NIC.
Inside was actually a 3C996B-T, which is the (much) cheaper ethernet model.

![NIC(e) card](/images/3ComGigNic/card_shot.jpg){:width="500px"}

When first released, the SX model sold for $695.00, while the ethernet model was only $169.
Today, the cards arn't quite in demand as they once may have been.
I was able to find the card on ebay selling for ~$10 + shipping.
The internet archive has an archive of 3Com's original product page for the cards which can be seen [here][1]
When I bought it the box was still sealed in plastic wrap, which had a label with the correct model on it so I figure it was either misboxed or the card was reboxed and sealed.

![Whatcha get](/images/3ComGigNic/box_contents.jpg){:width="500px"}

Once opened, there are a few different things included.
There is the card of course, contained within some plastic packaging.
Additionally, there is the warranty, a quickstart guide, a CD-Rom with drivers and test utilities, and a "Remote Wake-Up" cable.
The "Remote Wake-up" cable is meant to be installed in a supported connector on the motherboard, which allows the computer to be remotely started through the network.

For managing all that gigabit traffic this card uses a Broadcom BCM 5701TKHB chip whose datasheet can be found [here][2]

![Mr. Chip](/images/3ComGigNic/chip_shot.jpg){:width="500px"}

Interestingly, the chip is branded with both the 3Com and Broadcom logos, with the text "Technology Alliance" underneath.
After a cursory internet search, I found an article from December of 2000 detailing how 3Com and Broadcom teamed up to work on [deploying gigabit ethernet into business networks][3].
The release of this card came along about a year later, so this card must be a result of that partnership and why both companies are on the chip.

---

Included with the card is a CD-Rom with all the drivers needed to operate it.
The root of the disk is as follows:

![Da Box](/images/3ComGigNic/cd_dir.JPG){:width="500px"}

Testing utility tools were also included that allow the user to directly test the Broadcom chip on the card.
Though the SX and B-T models interface with different hardware, they both have very similar system requirements.
They were designed to be put in a PCI 2.2 or PCI-X 1.0 compliant server, and supported the following operating systems:

* Windows Microsoft XP
* Windows 2000 (Server)
* Windows NT (4.0)
* Novell NetWare 4.2, 5.x, 6.x
* Linux 2.2, 2.4
* UnixWare 7.0
* OpenServer 5.0
* Sun Solaris x86

Also included in the drivers disk is software to test the Broadcom chip.
It allows the user to poerform tests on the chip in two modes: manufacturing and engineering.
In manufacturing mode, it will run all tests defined in the config.
If it hits an error, it will display the error, and exit the testing program.
The engineering mode allows a user to interactivly run different tests.
Different commands can be entered to perform the different tests, whose results are printed to the screen.
Even though the card itself is targeted toward *nix and Windows Nt type operating systems, the testing utility is meant to be run on Dos 6.22.
The tests are split into 4 categories:

* Register Tests
* Memory Tests
* Miscellaneous Tests
* Data Tests

While in manufacturing mode, not all tests will be ran.
Some tests, like the hardware's Build-In-Self-Test, are disabled by default because of "intermittent failure" or other issues.
Only 4 other tests are not run by default.
The config files for the tests are stored in a binary format so it is difficult to see what the defaults are without the documentation.

The software also provides a way to modify data stored in the card's eeprom.
It allows an adminstrator modify things like MAC prefix, the asset tag, voltages, speeds and a few other settings.
In order to update the values, first you create `eeprom.txt` and specify each property in a `<keyword> = <argument>` format.
The utility program is then uses this file and a supplied password to generate a `.bin` file of the changes, which can then be applied to the card.

---

I still plan on testing the card in a real system once I am able to get one running.
I am interested to see how it performs compared to other, more modern computers with built in networking.
It would also be fun to dig into the testing utilities and see how well it performs after so many years.

If you would like a copy of the drivers included with the card, you can find a zipped up copy of it [here](/files/3ComGigNic/3C996B_T_drivers.zip).

[1]: https://web.archive.org/web/20020917225824/http://www.3com.com/products/en_US/prodlist.jsp?tab=cat&pathtype=purchase&cat=19&selcat=Network+Interface+Cards&family=110
[2]: https://pdf1.alldatasheet.com/datasheet-pdf/view/92603/BOARDCOM/BCM5701.html
[3]: https://www.edn.com/electronics-news/4342691/Broadcom-3Com-Unite-To-Deploy-Gigabit-Ethernet