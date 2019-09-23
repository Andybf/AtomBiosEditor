# AtomBiosEditor
AtomBiosEditor it's a firmware editor for AMD Radeon graphics cards, this utility allows to modify details of the component such as GPU core clocks, memory clocks, board Id, Fan Speed, Power consumption etc.

### How it Works?

Every modern graphics card have a small chip close to the GPU, this is the BIOS of the card, or more specifically, the firmware chip, this chip have a small space between 64KB and 256KB. it can be extracted to the main storage in many different ways, so it can be visible to us.
The file extracted is in binary form, the read it's difficult to humans, but not for the AtomBiosEditor, he haves the ability to read and write in this file in such way that the file it's still readable to GPU.

### Operating System Compatibility

The applciation was built with cross-platform support in mind, so, the main part of the program was wrote in C language, this permit to anyone compile the program in many different operating systems, the only effort necessary is to rebuild the graphical user interface.
For default, I wrote this program for macOS operating system, but, maybe in the near future, I can make a graphical interface for Windows and Linux platforms.

### Full GPU Firmware Compatibility

- CGN 1.0: AMD Radeon 7000 series and AMD Radeon R7XXX series

### Partial GPU Firmware Compatibility

With partial GPU compatibility, the utility still read the firmware, but, some information may be not correct due to different firmware architectures.

- TERASCALE 2: AMD Radeon 6000 series
- CGN 2.0 : AMD Radeon R9XXX series
- CGN 3.0 : AMD Radeon RX400 series
- CGN 4.0 : AMD Radeon RX500 series
