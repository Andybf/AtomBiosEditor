//
//  FirmwareInfo.c
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 22/09/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#include "FirmwareInfo.h"

struct FIRMWARE_INFO LoadFirmwareInfo (FILE * firmware, struct ATOM_DATA_AND_CMMD_TABLES abstractTable) {
    
    // Initializing the firmwareinfo structure
    struct FIRMWARE_INFO firmwareInfo = *(struct FIRMWARE_INFO *) malloc(sizeof(struct FIRMWARE_INFO *));
    
    // struct   |    property                               |  file   |                           Offset                   | size | endian | chars
    firmwareInfo.defaultEngineClock    = HexToDec(GetFileData(firmware, abstractTable.offset + OFFSET_DEFAULT_ENGINE_CLOCK,   0x2,     0),     4)/100;
    firmwareInfo.defaultMemoryClock    = HexToDec(GetFileData(firmware, abstractTable.offset + OFFSET_DEFAULT_MEMORY_CLOCK,   0x2,     0),     4)/100;
    firmwareInfo.deftDispEngineClk     = HexToDec(GetFileData(firmware, abstractTable.offset + OFFSET_DEFT_DISP_ENGINE_CLK,   0x2,     0),     4)/100;
    firmwareInfo.bootUpVDDCVoltage     = HexToDec(GetFileData(firmware, abstractTable.offset + OFFSET_BOOT_VDDC_VOLTAGE,      0x2,     0),     4);
    firmwareInfo.LcdMinPixelClock      = HexToDec(GetFileData(firmware, abstractTable.offset + OFFSET_LCD_MIN_PIXEL_CLOCK,    0x2,     0),     4);
    firmwareInfo.LcdMaxPixelClock      = HexToDec(GetFileData(firmware, abstractTable.offset + OFFSET_LCD_MAX_PIXEL_CLOCK,    0x2,     0),     4);
    firmwareInfo.maxPixelClock         = HexToDec(GetFileData(firmware, abstractTable.offset + OFFSET_MAX_PIXEL_CLOCK,        0x2,     0),     4)/100;
    firmwareInfo.minPixelClockPLLInput = HexToDec(GetFileData(firmware, abstractTable.offset + OFFSET_MIN_PIXEL_CLK_INPUT,    0x2,     0),     4);
    firmwareInfo.maxPixelClockPLLInput = HexToDec(GetFileData(firmware, abstractTable.offset + OFFSET_MAX_PIXEL_CLK_INPUT,    0x2,     0),     4);
    firmwareInfo.coreReferenceClock    = HexToDec(GetFileData(firmware, abstractTable.offset + OFFSET_CORE_REFERENCE_CLOCK,   0x2,     0),     4);
    firmwareInfo.memoryReferenceClock  = HexToDec(GetFileData(firmware, abstractTable.offset + OFFSET_MEMORY_REFERENCE_CLOCK, 0x2,     0),     4);
    
    return firmwareInfo;
}

void SaveFirmwareInfo (FILE * firmware, struct ATOM_DATA_AND_CMMD_TABLES abstractTable, struct FIRMWARE_INFO firmwareInfo) {
    
    // Function | target | Big Endian to Little |       property     |                   offset                          | Size Multiplier by 2
    SetFile16bitValue(firmware, BigToLittleEndian(firmwareInfo.defaultEngineClock*100), abstractTable.offset + OFFSET_DEFAULT_ENGINE_CLOCK  , 2);
    SetFile16bitValue(firmware, BigToLittleEndian(firmwareInfo.defaultMemoryClock*100), abstractTable.offset + OFFSET_DEFAULT_MEMORY_CLOCK  , 2);
    SetFile16bitValue(firmware, BigToLittleEndian(firmwareInfo.deftDispEngineClk *100), abstractTable.offset + OFFSET_DEFT_DISP_ENGINE_CLK  , 2);
    SetFile16bitValue(firmware, BigToLittleEndian(firmwareInfo.bootUpVDDCVoltage     ), abstractTable.offset + OFFSET_BOOT_VDDC_VOLTAGE     , 2);
    SetFile16bitValue(firmware, BigToLittleEndian(firmwareInfo.LcdMinPixelClock      ), abstractTable.offset + OFFSET_LCD_MIN_PIXEL_CLOCK   , 2);
    SetFile16bitValue(firmware, BigToLittleEndian(firmwareInfo.LcdMaxPixelClock      ), abstractTable.offset + OFFSET_LCD_MAX_PIXEL_CLOCK   , 2);
    SetFile16bitValue(firmware, BigToLittleEndian(firmwareInfo.maxPixelClock     *100), abstractTable.offset + OFFSET_MAX_PIXEL_CLOCK       , 2);
    SetFile16bitValue(firmware, BigToLittleEndian(firmwareInfo.minPixelClockPLLInput ), abstractTable.offset + OFFSET_MIN_PIXEL_CLK_INPUT   , 2);
    SetFile16bitValue(firmware, BigToLittleEndian(firmwareInfo.maxPixelClockPLLInput ), abstractTable.offset + OFFSET_MAX_PIXEL_CLK_INPUT   , 2);
    SetFile16bitValue(firmware, BigToLittleEndian(firmwareInfo.coreReferenceClock    ), abstractTable.offset + OFFSET_CORE_REFERENCE_CLOCK  , 2);
    SetFile16bitValue(firmware, BigToLittleEndian(firmwareInfo.memoryReferenceClock  ), abstractTable.offset + OFFSET_MEMORY_REFERENCE_CLOCK, 2);
    
}
