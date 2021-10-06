# AtomBiosEditor
AtomBiosEditor it's a firmware editor for AMD Radeon graphics cards, this utility allows to show and modify details of the component such as GPU core clocks, memory clocks, board Id, Fan Speed, Power consumption etc.

### How it Works?

Every modern graphics card have a small chip close to the GPU, this is the BIOS of the card, or more specifically, the firmware chip, this chip have a small space between 64KB and 256KB. it can be extracted to the main storage in many different ways, so it can be visible to us.
The file extracted is in binary form, the read it's difficult to humans, but not for the AtomBiosEditor, he haves the ability to read and write in this file in such way that the file it's still readable to GPU.

### Features

 * Show analytic information about the graphics card (Device id, Vendor name, Compilation date etc.)
 * Verify for UEFI support
 * Verify and fixing checksum
 * Extract Data or Command tables individually
 * Replace Data or Command tables individually
 * Adjust Maximum GPU overclock value
 * Adjust Maximum Memory overclock value
 * Adjust boot VDDC voltage
 * Fan speed and temperature target control
 * Changing the minimum and maximum Thermal Design Power (TDP) values
 * Adjust various pixel clocks values
 * Default engine clock and default memory clock
 * Reference clocks
 * Change powerPlay GPU clocks
 * Change powerplay Memory clocks
 * Change powerPlay voltage values

### Warning

#### This tool is not meant to be used by people with very low knowledge about graphics processing mechanics, the application is not 100% reliable and bugs can occour during the execution.
#### Make sure that you will only change the values if you know what they are representing, and try to not insert absurd values.
#### Flashing a custom rom on your GPU is a dangerous process and if this are done in a bad way it may brick you graphics card or in extreme cases destroyng the internal components.
#### Before flashing the firmware in your GPU that has been modified by this tool, keep in mind that this software comes without any type of warranty, and the creator is not responsible for any type of damage or mal-function caused by bad flashing. Use this tool on your own risk.

### Operating System Compatibility

The application was built with cross-platform support in mind, so, the main part of the program was wrote in C language, this permit to anyone compile the program in many different operating systems with more easily, the only effort necessary is to rebuild the graphical user interface.
For default, I wrote this program for macOS operating system, but, maybe in the near future, I can make a port for Windows and Linux platforms.

### Full GPU Firmware Compatibility

- CGN 1.0: AMD Radeon 7000 series and AMD Radeon R7XXX series

### Partial GPU Firmware Compatibility

With partial GPU compatibility, the utility still read the firmware, but, some information may be not correct due to different firmware architectures.

- TERASCALE 2: AMD Radeon 6000 series
- CGN 2.0 : AMD Radeon R9XXX series
- CGN 3.0 : AMD Radeon RX400 series
- CGN 4.0 : AMD Radeon RX500 series
