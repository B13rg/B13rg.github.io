---
layout: post
title:	"Re-Zeroing the Z Axis with BLTouch on Ender 5 Pro  "
category: [3DPrinting]
excerpt: This guide walks through re-zeroing the Z-axis using a BLTouch probe on an Ender 5 Pro with Marlin firmware.

---

Setup:

* Ender 5 pro hardware w/ direct feed and non-default nozzle bracket
* BIGTREETECH SKR Mini E3 control board
  * **Marlin**-based firmware; BIGTREETECH build: [firmware-ender5-bltouch.bin](https://github.com/bigtreetech/BIGTREETECH-SKR-mini-E3/tree/master/firmware/V3.0/Marlin)
* [Octopi](https://docs.octoprint.org/en/master/) via Rasperberry Pi Zero W

The new part: [BLTouch Probe](https://www.antclabs.com/bltouch-v3)

NOT wired for Z-homing.
Still uses switch triggered by the bed.

## Re-Zeroing the Z Axis

G-Code lookup: https://marlinfw.org/meta/gcode/

From [M851 - XYZ Probe Offset](https://marlinfw.org/docs/gcode/M851.html) docs:

> ... the easiest way to get the Z offset value (assuming your homed Z = `0.0`) is to:
>
>    * Home the Z axis.
>    * Raise Z and deploy the probe.
>    * Move Z down slowly until the probe triggers.
>    * Take the current Z position (as reported by `M119`) and negate it. (`5.2` => `-5.2`)
>    * Set with `M851 Z-5.2` and save it with `M500`.



### Get Current settings: [**M503**](https://marlinfw.org/docs/gcode/M503.html)

<details>
  <summary>Example M503 Output</summary>
  <div markdown="1">

```yml
Send: M503
Recv: echo:; Linear Units:
Recv: echo:  G21 ;
Recv:  (mm)
Recv: echo:; Temperature Units:
Recv: echo:  M149 C ; Units in Celsius
Recv: echo:; Filament settings (Disabled):
Recv: echo:  M200 S0 D1.75
Recv: echo:; Steps per unit:
Recv: echo:  M92 X80.00 Y80.00 Z800.00 E130.00
Recv: echo:; Max feedrates (units/s):
Recv: echo:  M203 X500.00 Y500.00 Z5.00 E25.00
Recv: echo:; Max Acceleration (units/s2):
Recv: echo:  M201 X500.00 Y500.00 Z100.00 E10000.00
Recv: echo:; Acceleration (units/s2) (P<print-accel> R<retract-accel> T<travel-accel>):
Recv: echo:  M204 P500.00 R500.00 T500.00
Recv: echo:; Advanced (B<min_segment_time_us> S<min_feedrate> T<min_travel_feedrate> J<junc_dev>):
Recv: echo:  M205 B20000.00 S0.00 T0.00 J0.01
Recv: echo:; Home offset:
Recv: echo:  M206 X0.00 Y0.00 Z0.00
# --- Bed leveling coordinate values
Recv: echo:; Auto Bed Leveling:
Recv: echo:  M420 S1 Z0.00 ; Leveling ON
Recv: echo:  G29 W I0 J0 Z0.20875
Recv: echo:  G29 W I1 J0 Z0.16500
Recv: echo:  G29 W I2 J0 Z0.13000
Recv: echo:  G29 W I3 J0 Z0.10375
Recv: echo:  G29 W I4 J0 Z0.16625
Recv: echo:  G29 W I0 J1 Z0.17000
Recv: echo:  G29 W I1 J1 Z0.18375
Recv: echo:  G29 W I2 J1 Z0.13500
Recv: echo:  G29 W I3 J1 Z0.14750
Recv: echo:  G29 W I4 J1 Z0.18375
Recv: echo:  G29 W I0 J2 Z0.16000
Recv: echo:  G29 W I1 J2 Z0.12000
Recv: echo:  G29 W I2 J2 Z0.12750
Recv: echo:  G29 W I3 J2 Z0.09875
Recv: echo:  G29 W I4 J2 Z0.17500
Recv: echo:  G29 W I0 J3 Z0.13750
Recv: echo:  G29 W I1 J3 Z0.15250
Recv: echo:  G29 W I2 J3 Z0.12875
Recv: echo:  G29 W I3 J3 Z0.12000
Recv: echo:  G29 W I4 J3 Z0.14250
Recv: echo:  G29 W I0 J4 Z0.09125
Recv: echo:  G29 W I1 J4 Z0.12125
Recv: echo:  G29 W I2 J4 Z0.12000
Recv: echo:  G29 W I3 J4 Z0.11000
Recv: echo:  G29 W I4 J4 Z0.20125
# ---
Recv: echo:; Material heatup parameters:
Recv: echo:  M145 S0 H185.00 B45.00 F255
Recv: echo:  M145 S1 H240.00 B110.00 F255
Recv: echo:; Hotend PID:
Recv: echo:  M301 P21.73 I1.54 D76.55
Recv: echo:; Bed PID:
Recv: echo:  M304 P41.78 I7.32 D158.93
Recv: echo:; Controller Fan:
Recv: echo:  M710 S255 I0 A1 D60 ; (100% 0%)
# --- Probe Offset from Nozzle 
Recv: echo:; Z-Probe Offset:
Recv: echo:  M851 X-40.00 Y-10.00 Z-3.85 ; (mm)
# ---
Recv: echo:; Stepper driver current:
Recv: echo:  M906 X580 Y580 Z580
Recv: echo:  M906 T0 E650
Recv: 
Recv: echo:; Driver stepping mode:
Recv: echo:  M569 S1 X Y Z
Recv: echo:  M569 S1 T0 E
Recv: echo:; Linear Advance:
Recv: echo:  M900 K0.00
Recv: echo:; Filament load/unload:
Recv: echo:  M603 L350.00 U400.00 ; (mm)
Recv: ok
```
  </div>
</details>


### Adjust Z-Probe Offset: [**M851**](https://marlinfw.org/docs/gcode/M851.html)

<details>
  <summary>Example M503 Output</summary>
  <div markdown="1">

```yml
Send: M851 X-40.00 Y-10.00 Z-3.94
Recv: ok
```
  </div>
</details>

### Save Settings: [**M500**](https://marlinfw.org/docs/gcode/M500.html)

<details>
  <summary>Example M500 Output</summary>
  <div markdown="1">

```yml
Send: M500
Recv: echo:Settings Stored (685 bytes; crc 53261)
Recv: //action:notification Settings Stored
Recv: ok
```

  </div>
</details>
