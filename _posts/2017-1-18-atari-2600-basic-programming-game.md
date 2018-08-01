---
layout: post
title: Atari 2600 "Basic Programming" Game
---

An interesting game of the Atari 2600 era was the game “Basic programming”, written by Warren Robinett.  This game was released in 1979, and was touted to allow the player to talk to their computer, and program a variety of things.  Though it may seem like it would allow players to write in BASIC code, it instead used its own limited instruction set.

![Ad from Atari Game Catalog]({{ site.baseurl }}/images/Atari_Basic_Programming_Leaflet.jpg)

It was also one of the few games that actually used the Atari keypad.  It came with inserts that you’d put in the controllers to type out text and navigate the screen.  It utilized both keypads, having the player slide them together using a tongue and groove system.  From here the player can begin programming.

![Controller Inserts]({{ site.baseurl }}/images/Basic_Programming_Inserts.jpg)

The game gave you five regions that showed different parts of your program.  The “Program” region is where instructions were inputted.  The “Stack” region gave you temporary results as the computer was running it.  Next the “Output” region showed the output of the written code.  The “status region showed the amount of memory available, and the speed of execution.  Finally, the “Graphics” region showed two colored squares that could be manipulated under program control.  By switching the difficulty switches, you could hide the titles of the regions and show the display region.

![Game Screen with 5 regions]({{ site.baseurl }}/images/Basic_Programming_Screen.png)

Sadly, the game only allowed 9 lines of code, severely restricting the complexity of programs that could be made. By removing the “Status”, “Program” and “Stack” regions a player could add another two lines of code.  Being so limited, the instruction booklet outlined just about all the programs you could write.  For example, the game Pong could be programmed using the following instructions:

```basic
Hor 2 ← Hor 2+Key
If Ver 1>90 Then Ver 1 ← 88
If Hit Then Ver 1 ← 9
Ver 1 ← Ver 1+If Ver 1 Mod 2 Then 8 Else 92
Hor 1 ← Hor 1+7
Goto 1
```

One of the most difficult parts of the programming process was cycling through to the correct character.  Overall, it was a good introductory to programming, but by no means a masterpiece of game design.  Though it can be easily overshadowed by anything today, it is still interesting to see an extremely basic programming game run on the constrictive hardware of the 2600.

The transcribed manual for the game can be found at [https://atariage.com/manual_html_page.html?SoftwareLabelID=15](https://atariage.com/manual_html_page.html?SoftwareLabelID=15)