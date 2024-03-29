/*
* Name:          AtomBiosEditor > Model > FirmwareInfo.h
* Created By:    Anderson Bucchianico
* Date:          22/sep/2019
* Description:   FirmwareInfo table Data Definitions
*/

#ifndef FirmwareInfo_h
#define FirmwareInfo_h

#include "AtomBios.h"
#include "CoreFunctions.h"

// Addresses inside the table

#define OFFSET_DEFAULT_ENGINE_CLOCK   0x08
#define OFFSET_DEFAULT_MEMORY_CLOCK   0x0C
#define OFFSET_DEFT_DISP_ENGINE_CLK   0x28
#define OFFSET_BOOT_VDDC_VOLTAGE      0x2E

#define OFFSET_LCD_MIN_PIXEL_CLOCK    0x30
#define OFFSET_LCD_MAX_PIXEL_CLOCK    0x32
#define OFFSET_MAX_PIXEL_CLOCK        0x48
#define OFFSET_MIN_PIXEL_CLK_INPUT    0x4A
#define OFFSET_MAX_PIXEL_CLK_INPUT    0x4C

#define OFFSET_CORE_REFERENCE_CLOCK   0x52
#define OFFSET_MEMORY_REFERENCE_CLOCK 0x54

//Data Sctructure

struct FIRMWARE_INFO {
    
    ushort defaultEngineClock;
    ushort defaultMemoryClock;
    ushort deftDispEngineClk;
    ushort bootUpVDDCVoltage;
    
    ushort LcdMinPixelClock;
    ushort LcdMaxPixelClock;
    ushort maxPixelClock;
    ushort minPixelClockPLLInput;
    ushort maxPixelClockPLLInput;
    
    ushort coreReferenceClock;
    ushort memoryReferenceClock;
};

// Functions

struct FIRMWARE_INFO LoadFirmwareInfo (struct ATOM_DATA_AND_CMMD_TABLES abstractTable);
void                 SaveFirmwareInfo (FILE * firmware, struct ATOM_DATA_AND_CMMD_TABLES abstractTable, struct FIRMWARE_INFO firmwareInfo);

#endif /* FirmwareInfo_h */
