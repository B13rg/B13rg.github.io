---
layout: post
title: "Exploring the Gameboy Memory Bank Controller"
category: [Games, Gameboy]
excerpt: Without a game cartridge, a Gameboy is just displays "Gameboy" and freezes.  Once slotted in, the bits and bytes contained within a cartridge created countless worlds and memories.  How did a Gameboy cartridges store such a wide variety of games, while also enabling things like save files, rumble, and even infrared communication?
image: /images/MBC/header.JPG
comment_id: 105467824633648656
---

![Array of Carts](/images/MBC/header.JPG)

Without a game cartridge, a Gameboy is just displays "Gameboy" and freezes.
Once slotted in, the bits and bytes contained within a cartridge created countless worlds and memories.
How did a Gameboy cartridges store such a wide variety of games, while also enabling things like save files, rumble, and even infrared communication?

In this article, we will examine the Memory Bank Controllers (MBC) contained inside the cartridge, and how they enabled the worlds of Pokemon, Zelda, and countless other to become a reality in the hands of children and adults everywhere.
To start, we will define what exactly a Memory Bank Controller is, and the different types that were available.
We'll also analyze some usage statistics about how common they were in cartridges, and what types were used the most.

Next we'll look at how the Gameboy determined the cartridge type by examining the game ROM header.
Finally, we'll take a look at some real examples from my own game collection and see how the MBC was applied in practice.

---

Table of Contents

- [The MBC](#the-mbc)
- [Usage Statistics](#usage-statistics)
- [The Cartridge Header](#the-cartridge-header)
- [Cartridge Hardware](#cartridge-hardware)
- [No MBC](#no-mbc)
	- [Alleyway](#alleyway)
	- [Dr. Mario](#dr-mario)
	- [Tetris](#tetris)
		- [Cart 1](#cart-1)
		- [Cart 2](#cart-2)
	- [Yakuman](#yakuman)
- [MBC1](#mbc1)
	- [Baseball](#baseball)
	- [Frogger](#frogger)
	- [Super Mario Land](#super-mario-land)
- [MBC3](#mbc3)
	- [Pokemon Gold Version](#pokemon-gold-version)
	- [Pokemon Silver Version USA](#pokemon-silver-version-usa)
	- [Pokemon Silver Version JP](#pokemon-silver-version-jp)
- [MBC5](#mbc5)
	- [Monster Rancher Battle Card GB](#monster-rancher-battle-card-gb)
	- [Pokemon Pinball](#pokemon-pinball)
- [Further Reading](#further-reading)

---

## The MBC

Memory Bank Controller were a part of many cartridge games developed for the Gameboy and Gameboy color.
It allowed the cartridge to not only address larger amounts of RAM and ROM, but to also have additional hardware that the Gameboy could utilize.
The MBCs were most commonly paired with larger ROM and additional RAM, but different MBCs also allowed the use of real time clocks, rumble, and even a light sensor.

A normal cartridge had 16 address lines, allowing the Gameboy to address a maximum of 64KB of ROM on the cartridge without an MBC.
In practice the maximum ROM size of a game without an MBC was 32KB.
Games like [Tetris](#tetris) and [Dr. Mario](#dr-mario) were 32KB or less in size, so didn't require a MBC to operate.
This allowed for very simple PCB layouts, as the single ROM chip would be directly connected to the cartridge pins.
By placing an MBC between the console and the cartridge ROM/RAM, it could translate special reads and writes to facilitate the bank switching.

ROM data on a cartridge would be split into 16KB "banks" that could be swapped out at will by the game.
The first bank, `00`, would be always mounted at `0x0000-0x3FFF` in the Gameboy's memory map.
This first bank usually contained code that was used commonly, as it would always be present and accessible by the program.
The game would be able to swap out any additional banks by writing values to special areas of the memory map, which would instruct the MBC what bank to switch to.
The selected bank would be mounted from `0x4000-0x7FFF`, right next to the area of memory that was bank `00`.

RAM banks behaved similarly, though it only mounted 8KB at a time.
That data was mounted at addresses `0xA000-0xBFFF` and was able to be both read and written to (as one would expect).
Many games took advantage of having extra RAM on the cartridge because the Gameboy DMG only had 8KB available internally.
The Gameboy color bumped that to 32KB, but that could still be constraining for larger titles.
For a deeper dive into the specifics of how games performed ROM and RAM bank switching, check out my article here: [Gameboy DMG ROM and RAM Bank Switching](Gameboy-Bank-Switching/).

When developing a game, it was and still is important to consider the size of the final product (unless you're Call of Duty).
The size of the game and add-ons like RAM controlled what type of memory bank controller would be required.
The following types of memory bank controllers were usually available for use:

|Type|Max ROM|Max RAM|Info|
|None|32KB|8KB|No bank controller, just a ROM chip and potentially 1 bank's worth of RAM|
|MBC1|2MB|32KB|The basic Gameboy MBC|
|MBC2|256KB|512x4 bits|Data in RAM consists of 4 bit values|
|MBC3|2MB|64KB|Similar to MBC1, also included addition of a real time clock|
|MBC5|8MB|1MB|Supported the light sensor, and a rumble motor|
|MBC6|1MB|32KB|Only used for one game: Net de Get: Minigame @ 100.  Had separate, switchable ROM and RAM sets plus flash memory.  ROM banks were 8KB and RAM banks were 4KB|
|MBC7|8MB|1MB|Contained additional 256 byte EEPROM and 2-axis accelerometer.  Similar to MBC5|
|MMM01|2MB|32KB|A "metamapper" for a game collection, which switches between sets of banks|
|Tama5|?|?|Custom MBC designed by Bandai for a single game, Tamagotchi 3|
|HuC-1|2MB|32KB|Customer MBC designed by Hudson, supports infrared LED input.|
|HuC-3|2MB|32KB|Customer MBC designed by Hudson that adds a RTC and piezo buzzer to the HuC-1|
||||[Source 1](https://mgba-emu.github.io/gbdoc) [Source 2](https://gbdev.io/pandocs/#memory-bank-controllers)|

A note about the MMM01, it is a “metamapper” that is used in the game collection (Momotarō Collection 2 and Taito Variety Pack).
It provides a boot menu that allows the user to select a game before locking itself down into a separate “normal” mapper mode that only exposes certain banks to the game inside the collection.
To read more about the specifics, including an interesting VHDL design, check out this [wiki page](https://wiki.tauwasser.eu/view/MMM01).

Gameboy cartridges most commonly used no MBC at all, or MBC type 1,2, and 5.
MBC 3, 6 and 7 were usually reserved for special circumstances and didn't see as much use.
The different types enabled developers to use hardware like real time clocks, RAM, batteries for saving, rumble, and even a light sensor.
Multiple memory controllers were made to help control the cost of producing the cartridge.
While it would be convenient to have a "One size fits all" controller that could dynamically accommodate add-ons and varying amounts of ROM and RAM, it would have been an expensive chip to produce.
By producing a variety of types, game developers could select the MBC that would best accommodate their game.

## Usage Statistics

The [Game Boy hardware database](https://gbhwdb.gekkio.fi) is a community-created database of gameboy cartridges.
It contains detailed information and photos of various cartridges and their internal components.
There are 316 distinct Gameboy game entries, out of 1,049 DMG + 576 GBC games (1,625 total).
There are many games missing, but I figure it should be a good enough sample that we should at least be able to discern some trends from the data.

I grabbed a data dump, loaded it into sqlite3 and ran some queries over it to get some more information about what types of bank controllers were used over time.
You can view the same dataset I used [here](/files/MBC/cartridges.csv), or grab the most up-to-date copy from [here](https://gbhwdb.gekkio.fi/static/export/cartridges.csv).
The query I used counted how many distinct game titles used each MBC type by year.
It gives a rough view of both the number of games released and the controller types used in those games each year.

![Chart of ](/images/MBC/MBC_Types_Year.png)
[Full size](/images/MBC/MBC_Types_Year.png)

|Year|None|MBC1A|MBC1B|MBC1B1|MBC2A|MBC3|MBC30|MBC3A|MBC3B|MBC5|MBC6|MBC7|TAMA5|MMM01|HuC-1|HuC-1A|HuC-3|Year|
|1989|4|2|1||1|||||||||||||1989|
|1990|9|2|12||2|||||||||||||1990|
|1991|3||21||1|||||||||||||1991|
|1992|||11|2||||||||||||||1992|
|1993|||4|7|2|||||||||||||1993|
|1994|||5|1||||||||||||||1994|
|1995|||7|8||||||||||||||1995|
|1996|1||9|6|1|||||||||1||||1996|
|1997|2||7|20|3|1|||||||1||1|||1997|
|1998|||15|12|1|6||7||6|||1||1|1|3|1998|
|1999|||2|1||||3||21|||||1||1|1999|
|2000|2||||||1|4|3|32||2||||||2000|
|2001|1||||||||9|13|1|1||||||2001|
|2002|||||||||2|4||||||||2002|
|2003|||||||||1|||||||||2003|

Query: `SELECT COUNT(DISTINCT "name"), COALESCE(NULLIF("mapper_kind",''), 'None'), "board_year" FROM cart WHERE DISTINCT "name" GROUP BY "mapper_kind", "board_year" ORDER BY "board_year", "mapper_kind";`

For the first 7 years, we really only see the MBC1 and MBC2 used.
The MBC2 was used sparingly.
In terms of ROM space, it had 1/8th the space of the MBC1 but 8x the space of just a ROM with no MBC.
It also had 128 Bytes of RAM that was split into 4-byte chunks.
It seems that it was the simplest MBC available to game developers, meant for games that required more storage than just a ROM chip, but didn't need all the capabilities of MBC1.

Between the different revisions of the MBC1, the MBC1B was used the most.
There are a few MBC1A entries, but they were only present in Japanese titles during the first two years of the gameboy.
The MBC1B probably fixed bugs present in the MBC1A, but I haven't been able to find any concrete evidence describing what those issues might be, I'm just going of the naming scheme.
I think the difference between the MBC1B and MBC1B1 was less severe, possibly something to do with power consumption or speed since it is only a "minor version" improvement.
The MBC1B1 seemed to be used interchangeably with the normal MBC1B, as shown by the mapper type entries for `Donkey Kong Land III (USA, Europe) (Rev 1) (SGB Enhanced)`, where we can see it using both types over a period of two years:

|MBC|PCB Date|
|---|---|
|MBC1B|Jul/1998|
|MBC1B1|Jul/1998|
|MBC1B1|Aug/1998|
|MBC1B|Jun/1999|

The MBC3 only started to be used in 1998, the same year the Gameboy Color was released.
Before that point, we really only see games use an MBC1, MBC2, or no MBC at all.
Once the MBC3 was released, it was used primarily for newer Gameboy Color games, but it also saw some use in games targeted for the Gameboy DMG, like [Mary Kate and Ashley's Pocket Planner](https://www.youtube.com/watch?v=jbbMLLPZNnU).

Similar to the MBC1, we can also see hardware lifecycle events for the MBC3 over the years it was used.
It seems that the change from MBC3 -> MBC3A -> MBC3B was much more absolute than MBC1A -> MBC1B -> MBC1B1.
After 1998, Nintendo seemed to transition fully to the MBC3A, as we don't see any MBC3 entries;  after 2000 we see the same trend with the MBC3A and MBC3B.
The fact that we don't see any use of a previous version in the year following the introduction of newer version leads me reason that the new versions fixed bugs in the hardware, instead of performance improvements like the MBC1B -> MBC1B1 update.

When a new console is released, it usually takes a little while for game developers to start using it to it's fullest potential.
We are able to see that practice here with the MBC1 and MBC5 in the two years following each of their releases.

In 1990, you can see an increase of use across the available MBC types: "None", MBC1, and MBC2.
Part of the growth in the year following the Gameboy DMG release can be contributed to the release dates of the Gameboy in April (JP), late July (USA), and late September (EU).
I assume that by waiting until the year following the release, developers have a bit more time with the hardware and can apply more polish to their games.
In 1991, we see a sharp drop off in games with just a ROM, and a large increase of MBC1 type games.
From 1992 to 1995, all the games end up using an MBC. with MBC1B and MBC1B1 seeing the bulk of the action.

There is a similar trend with the adoption of the MBC5 between 1998 and 2000.
Between 1998 and 1999, there was a large drop in MBC1 use, and a humongous increase in MBC5.
The MBC5 was a big improvement over the MBC1, and also had support for additional hardware additions to the cartridge.
1998 had about 50% of the games use a MBC1 style controller, with varied use across the other types.
In 1999 however, there is a huge drop in MBC1 use and a large jump in MBC5 use.
The MBC5 became available with the release of the Gameboy color (1998), and the sharp increase in use in 1999 and 2000 show how valuable the extra capabilities of the controller were.
After 1999, we don't see any more of the MBC1 and just a smattering of use of ROMs without an MBC.

In 2001, the Gameboy Advance was released, and with it a completely new cartridge called the GamePak.
The new cartridge was incompatible with the old type, primarily because the Gameboy Advance used an ARM processor instead of a Z-80 clone like the Gameboy DMG and CGB.
This is the same reason the Nintendo DS is only able to play Advance games, nothing prior.
The new cartridge had 24 address lines instead of 16, and the entire cartridge ROM was in the memory map presented to the game, removing the need for bank switching.
You can read more about the GamePak cartridge [here](https://reinerziegler.de.mirrors.gg8.se/GBA/gba.htm).

With the release of the Gameboy Advance, we see a sharp decline in the number of titles released.
Games were still released for the Gameboy Color up until 2003.
Surprisingly, the last Gameboy DMG games were released in Japan in 2001, over a decade since the handheld was first released.

---

## The Cartridge Header

When a cartridge is inserted into a Gameboy, it needs some way to communicate it's hardware properties to the boot loader.
This is done through the cartridge header.
When preparing a game to be placed on a cartridge, a header is placed at the start of the ROM.
This header is present on all cartridges at addresses `0x100-0x14F`.
It's the first thing that is read by the Gameboy and contains bits of information describing different properties of software and hardware.

The cartridge header stores information like the first 16 characters of the game's title (`0x134-0x143`), region (`0x14a`), and even the nintendo logo (`0x104-0x133`).
This is the same logo that is stored in the Gameboy's boot loader, and is used to check if the cartridge is legitimate.
If it is not correct, the game won't load.
It also allowed Nintendo to have a stronger case against 3rd party companies making their own cartridges, as the nintendo logo is copyrighted.

The cartridge type is stored as a hex code at address `0x147`.
The hex code described the hardware configuration of the game cartridge.
Not only did it accommodate all the MBC plus hardware configurations, it also had codes for special cartridges like the pocket camera and 3rd party MBCs.

|Code|Type|Code|Type
|00h|ROM Only|19h|MBC5|
|01h|MBC1|1Ah|MBC5+RAM|
|02h|MBC1+RAM|1Bh|MBC5+RAM+Battery|
|03h|MBC1+RAM+Battery|1Ch|MBC5+Rumble|
|05h|MBC2|1Dh|MBC5+Rumble+RAM|
|06h|MBC2+Battery|1Eh|MBC5+Rumble+RAM+Battery|
|08h|ROM+RAM|20h|MBC6|
|09h|ROM+RAM+Battery|22h|MBC7+Sensor+Rumble+RAM+Battery|
|0Bh|MMM01|||
|0Ch|MMM01+RAM|||
|0Dh|MMM01+RAM+Battery|||
|0Fh|MBC3+Timer+Battery|||
|10h|MBC3+Timer+RAM+Battery|FCh|Pocket Camera|
|11h|MBC3|FDh|BANDAI TAMA5|
|12h|MBC3+RAM|FEh|HuC3|
|13h|MBC3+RAM+Battery|FFh|HuC1+RAM+Battery|
||[Source](https://gbdev.io/pandocs/#_0147-cartridge-type)|||

Given a cartridge ROM and this chart, it is very easy to find the cartridge type of a game by grabbing bytes at the right addresses.
If you have ROMs of games, you can peek these values using `xxd` in the terminal.
Here are some examples of the cart title and type from a few different games:

```
$ xxd -seek 0x134 -len 16  pokecrystal.gbc 
00000134: 504d 5f43 5259 5354 414c 0042 5954 45c0  PM_CRYSTAL.BYTE.

$ xxd -plain -seek 0x147 -len 1 pokecrystal.gbc 
10
$ # MBC3+TIMER+RAM+BATTERY
```

```
$ xxd -seek 0x134 -len 16  'Pokemon Trading Card Game (U) [C][!].gbc' 
00000134: 504f 4b45 4341 5244 0000 0041 5851 4580  POKECARD...AXQE.

$ xxd -plain -seek 0x147 -len 1 'Pokemon Trading Card Game (U) [C][!].gbc' 
1b
$ # MBC5 + RAM + Battery
```

```
$ xxd -seek 0x134 -len 16  'SpongeBob SquarePants - Legend of the Lost Spatula (USA).gbc' 
00000134: 5342 5350 204c 4f54 4c53 2142 5150 45c0  SBSP LOTLS!BQPE.

$ xxd -plain -seek 0x147 -len 1 'SpongeBob SquarePants - Legend of the Lost Spatula (USA).gbc' 
19
$ # MBC5
```

```
$ xxd -seek 0x134 -len 16  'Game de Hakken!! Tamagotchi - Osutchi to Mesutchi (Japan) (SGB Enhanced).gb' 
00000134: 4742 2054 414d 4147 4f54 4348 4920 3300  GB TAMAGOTCHI 3.

$ xxd -plain -seek 0x147 -len 1 'Game de Hakken!! Tamagotchi - Osutchi to Mesutchi (Japan) (SGB Enhanced).gb' 
fd
$ # Bandai Tama5 (Built in alarm for when to feed your Tamagotchi!)
```

---

## Cartridge Hardware

In this next section, I took pictures of most of my Gameboy games and recorded the different chips on the cart.
They've been split into sections based on the MBC type the cartridge uses.
For each game, there is a picture of the cartridge and the PCB.
For webpage size reasons, there is a link below each image to the full size original.
There is also a table below each game that notates the board and chip labels.

The cases contain two bits of interesting info: the game ID and a case stamp.
The game ID is in the format `[Handheld type]{3}-[Game identifier]{3,4}-[Region]{2,3}-[Revision]{0,1}`.
For the games below, the handheld type is usually `DMG` for the original Gameboy and `CGB` for the Gameboy Color.
The game identifier is usually 3 or 4 characters long, and is similar to the ID on the ROM chip.
It uniquely identifies what game it is.
The region is 2 or 3 characters and describes the intended region of the game.
The most common that I've seen is `USA` and `JP`, but `EUR` for Europe and `AUS` for Australia also exist.
Some carts also include a optional number at the end, most likely corresponding to the revision number of the game.

The case stamp is a label imprinted on the label of the case consisting of two digits and a letter.
It can be hard to see in some cases, but I've done my best to record it here.
I'm not sure what it means, but I suspect it may have something to do with the cartridge manufacturing.
They follow the format `[0-3]{1}[0-4]{1}[A-D]{0,1}`

Inside the cart, the PCB also has special marking on both the PCB itself and the ROM chip that contains the game code.
PCB board is in the format `[Handheld type]{3}-[PCB type]{4}-[Revision]{2}`.
The handheld type on the case, cartridge and ROM chip should all match.
The PCB type depends on the hardware configuration required by the game.
Games that had the same MBC and extra hardware usually had the same type, but not always.
Finally, the revision declared what revision the board was.
For example, [Frogger](#frogger) (revision `10`) and [Super Mario Land](#super-mario-land) (revision `01`) and see that despite having the same MBC and hardware, the boards are slightly different.
Only revisions I've seen here and in the Gameboy hardware database are `01` and `10`, binary 1 and 2.

The ROM chips follow a similar format to the game cartridge, only leaving off the region code.
ROM chips use the format `[Handheld type]{3}-[Game identifier]{3,4}-[Revision]{1}`.

Now on to the pictures!

## No MBC

### Alleyway

![DMG-AW-USA](/images/MBC/alleyway_case.JPG){:width="500px"}
[Original](/images/MBC/originals/alleyway_case.JPG)

Release: DMG-AW-USA

Case Stamp: 05

![DMG-AAA-03](/images/MBC/alleyway_pcb.JPG){:width="500px"}
[Original](/images/MBC/originals/alleyway_pcb.JPG)

Board Type: DMG-AAA-03

ROM Type: DMG-AWA-0

||Chip|Board Label|Mfr.|Date|Chip Label|
|---|---|---|---|---|---|
|U1|ROM|PRG|Sharp|Week 34 1990|DMG-AWA-0|

### Dr. Mario

![DMG-VU-USA](/images/MBC/dr_mario_case.JPG){:width="500px"}
[Original](/images/MBC/originals/dr_mario_case.JPG)

Release: DMG-VU-USA

Case Stamp: 22

![DMG-AAA-03](/images/MBC/dr_mario_pcb.JPG){:width="500px"}
[Original](/images/MBC/originals/dr_mario_pcb.JPG)

Board Type: DMG-AAA-03

ROM Type: DMG-VUA-0

||Chip|Board Label|Mfr.|Date|Chip Label|
|---|---|---|---|---|---|
|U1|ROM|PRG|Sharp|Week 34 1990|DMG-VUA-0|

### Tetris

#### Cart 1

![DMG-TR-USA](/images/MBC/tetris_case_1.JPG){:width="500px"}
[Original](/images/MBC/originals/tetris_case_1.JPG)

Release: DMG-TR-USA

Case Stamp: 23 A

![DMG-AAA-03](/images/MBC/tetris_pcb_1.JPG){:width="500px"}
[Original](/images/MBC/originals/tetris_pcb_1.JPG)

Board Type: DMG-AAA-03

ROM Type: DMG-TRA-1

||Chip|Board Label|Mfr.|Date|Chip Label|
|---|---|---|---|---|---|
|U1|ROM|PRG|Sharp|Week 14 1990|DMG-TRA-1|

#### Cart 2

![DMG-TR-USA](/images/MBC/tetris_case_2.JPG){:width="500px"}
[Original](/images/MBC/originals/tetris_case_2.JPG)

Release: DMG-TR-USA

Case Stamp: 23 A

![DMG-AAA-03](/images/MBC/tetris_pcb_2.JPG){:width="500px"}
[Original](/images/MBC/originals/tetris_pcb_2.JPG)

Board Type: DMG-AAA-03

ROM Type: DMG-TRA-1

||Chip|Board Label|Mfr.|Date|Chip Label|
|---|---|---|---|---|---|
|U1|ROM|PRG|Sharp|Week 9 1991|DMG-TRA-1|

### Yakuman

![DMG-MJJ](/images/MBC/yakuman_case.JPG){:width="500px"}
[Original](/images/MBC/originals/yakuman_case.JPG)

Release: DMG-MJJ

Case Stamp: 22 A

![DMG-AAA-03](/images/MBC/yakuman_pcb.JPG){:width="500px"}
[Original](/images/MBC/originals/yakuman_pcb.JPG)

Board Type: DMG-AAA-03

ROM Type: DMG-MJJ-1

||Chip|Board Label|Mfr.|Date|Chip Label|
|---|---|---|---|---|---|
|U1|ROM|PRG|Sharp|Week 14 1990|DMG-MJJ-1|

## MBC1

### Baseball

![DMG-BS-USA](/images/MBC/baseball_case.JPG){:width="500px"}
[Original](/images/MBC/originals/baseball_case.JPG)

Release: DMG-BS-USA

Case Stamp: 22

![DMG-BBA-02](/images/MBC/baseball_pcb.JPG){:width="500px"}
[Original](/images/MBC/originals/baseball_pcb.JPG)

Board Type: DMG-BBA-02

ROM Type: DMG-BSA-0

||Chip|Board Label|Mfr.|Date|Chip Label|
|---|---|---|---|---|---|
|U1|ROM|PRG|Sharp|Week 51 1989|DMG-BSA-0|
|U2|Mapper|MBC1/1A/1B|Nintendo|Week 41 1989|MBC1A|

### Frogger

![DMG-AFGE-USA](/images/MBC/frogger_case.JPG){:width="500px"}
[Original](/images/MBC/originals/frogger_case.JPG)

Release: DMG-AFGE-USA

Case Stamp: 12

![DMG-BEAN-10](/images/MBC/frogger_pcb.JPG){:width="500px"}
[Original](/images/MBC/originals/frogger_pcb.JPG)

Board Type: DMG-BEAN-10

ROM Type: DMG-AFGE-0

||Chip|Board Label|Mfr.|Date|Chip Label|
|---|---|---|---|---|---|---|
|U1|ROM|PRG|Sharp|Week 4 1999|DMG-AFGE-0|
|U2|Mapper|MBC1/1B/1B1|Nintendo|Week 51 1998|DMG MBC1B1|

### Super Mario Land

![DMG-ML-USA](/images/MBC/super_mario_land_case.JPG){:width="500px"}
[Original](/images/MBC/originals/super_mario_land_case.JPG)

Release: DMG-ML-USA

Case Stamp: 23 A

![DMG-BEAN-01](/images/MBC/super_mario_land_pcb.JPG){:width="500px"}
[Original](/images/MBC/originals/super_mario_land_pcb.JPG)

Board Type: DMG-BEAN-01

ROM Type: DMG-MLA-1

||Chip|Board Label|Mfr.|Date|Chip Label|
|---|---|---|---|---|---|
|U1|ROM|PRG|Nintendo|Week 37 1990|DMG-MLA-1|
|U2|Mapper|MBC1/1A/1B|Nintendo|---|DMG-MBC1B|

## MBC3

### Pokemon Gold Version

![GMD-AAUE-USA](/images/MBC/pokemon_gold_case.JPG){:width="500px"}
[Original](/images/MBC/originals/pokemon_gold_case.JPG)

Release: GMD-AAUE-USA

Case Stamp: 20

![DMG-KGDU-10](/images/MBC/pokemon_gold_pcb.JPG){:width="500px"}
[Original](/images/MBC/originals/pokemon_gold_pcb.JPG)

Board Type: DMG-KGDU-10

ROM Type: DMG-AAUE-0

||Chip|Board Label|Mfr.|Date|Chip Label|
|---|---|---|---|---|---|
|U1|ROM|PRG|MX|Date|DMG-AAUE-0|
|U2|Mapper|MBC3A|Nintendo|Date|MBC3 A|
|U3|RAM|RAM|Hyundai|Week 29 2000|GM76C256CLLFW70|
|U4|RAM Protector|MM1134|Mitsumi|Week 7 1973|6735|

### Pokemon Silver Version USA

![DMG-AAXE-USA](/images/MBC/pokemon_crystal_usa_case.JPG){:width="500px"}
[Original](/images/MBC/originals/pokemon_crystal_usa_case.JPG)

Release: DMG-AAXE-USA

Case Stamp: 13

![DMG-KGDU-10](/images/MBC/pokemon_crystal_usa_pcb.JPG){:width="500px"}
[Original](/images/MBC/originals/pokemon_crystal_usa_pcb.JPG)

Board Type: DMG-KGDU-10

ROM Type: DMG-AAXE-0

||Chip|Board Label|Mfr.|Date|Chip Label|
|---|---|---|---|---|---|
|U1|ROM|PRG|MX|---|DMG-AAXE-0|
|U2|Mapper|MBC3A|Nintendo|---|MBC-3 B|
|U3|RAM|RAM|BSI|Week 42 2000|BS62LV256SC-70|
|U4|RAM Protector|MM1134|Mitsumi|---|6735|

### Pokemon Silver Version JP

![DMG-AAXJ-JPN](/images/MBC/pokemon_silver_jp_case.JPG){:width="500px"}
[Original](/images/MBC/originals/pokemon_silver_jp_case.JPG)

Release: DMG-AAXJ-JPN

Case Stamp: 12 A

![DMG-KFDN-10](/images/MBC/pokemon_silver_jp_pcb.JPG){:width="500px"}
[Original](/images/MBC/originals/pokemon_silver_jp_pcb.JPG)

Board Type: DMG-KFDN-10

ROM Type: DMG-AAXJ-1

||Chip|Board Label|Mfr.|Date|Chip Label|
|---|---|---|---|---|---|
|U1|ROM|PRG|MX|---|MX23C8003-20 DMG-AAXJ-1|
|U2|Mapper|MBC3A|Nintendo|---|MBC-3 A|
|U3|RAM|RAM|Sharp|Week 5 2000|LH52256CN-10LL|
|U4|RAM Protector|MM1134|Mitsumi|Week 40 1990|6735|

## MBC5

### Monster Rancher Battle Card GB

![DMG-A6TE-USA](/images/MBC/monster_rancher_case.JPG){:width="500px"}
[Original](/images/MBC/originals/monster_rancher_case.JPG)

Release: DMG-A6TE-USA

Case Stamp: 00

![DMG-A08-01](/images/MBC/monster_rancher_pcb.JPG){:width="500px"}
[Original](/images/MBC/originals/monster_rancher_pcb.JPG)
Board Type: DMG-A08-01

ROM Type: DMG-A6TE-0

||Chip|Board Label|Mfr.|Date|Chip Label|
|---|---|---|---|---|---|
|U1|ROM|16M/32M/64M-MROM|MX|---|MX23C1603-12A DMG-A6TE-0|
|U2|Mapper|MBC-5|Nintendo|---|MBC5|
|U3|RAM|64K-SRAM|Sharp|Week 21 2000|LH5164AN-10L|
|U4|RAM Protector|MM1134A|Atmel|---|028 134A|

### Pokemon Pinball

![DMG-VPHE-USA Front](/images/MBC/pokemon_pinball_case_front.JPG){:width="500px"}
[Original](/images/MBC/originals/pokemon_pinball_case_front.JPG)

![DMG-VPHE-USA Back](/images/MBC/pokemon_pinball_case_back.JPG){:width="500px"}
[Original](/images/MBC/originals/pokemon_pinball_case_back.JPG)

Release: DMG-VPHE-USA

Case Stamp: 22

![DMG-A04-01](/images/MBC/pokemon_pinball_pcb.JPG){:width="500px"}
[Original](/images/MBC/originals/pokemon_pinball_pcb.JPG)

Board Type: DMG-A04-01

ROM Type: DMG-VPHE-0

||Chip|Board Label|Mfr.|Date|Chip Label|
|---|---|---|---|---|---|
|U1|ROM|4M/8M MROM|MX|---|DMG-VPHE-0|
|U2|MBC|MBC5|---|Week 33 1999|LZ9GB31|
|U3|RAM|64K SRAM|Sharp|Week 9 1999|LH5164AN-10L|
|U4|RAM Protector|MM1134A|Atmel|---|---|


## Further Reading

* [My article on Gameboy Bank Switching](Gameboy-Bank-Switching/)
* [My article on the Gameboy DMG](Gameboy_DMG/)

* [Info about MBC6](https://gbdev.gg8.se/forums/viewtopic.php?id=544)
* [Info about MBC7](https://gbdev.gg8.se/forums/viewtopic.php?id=448)
* [Info about MMM01](https://wiki.tauwasser.eu/view/MMM01)
* [Info about HuC-3](https://gbdev.gg8.se/forums/viewtopic.php?id=744)
* [Official Nintendo Gameboy family technical data](https://www.nintendo.co.uk/Support/Game-Boy-Pocket-Color/Product-information/Technical-data/Technical-data-619585.html)
* [Open Gameboy Documentation](https://mgba-emu.github.io/gbdoc/#memory-bank-controllers)
* [Pan Docs cart info](https://gbdev.io/pandocs/#the-cartridge-header)
* [GiiBii Advance emulator docs](https://github.com/AntonioND/giibiiadvance/tree/master/docs)
* [Gameboy Hardware Database](https://gbhwdb.gekkio.fi/)
* [Gameboy Architecture](https://www.copetti.org/projects/consoles/game-boy/)