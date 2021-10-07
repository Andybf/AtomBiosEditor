/*
* Name:          AtomBiosEditor > Model > FirmwareInfo.h
* Created By:    Anderson Bucchianico
* Date:          22/sep/2019
* Description:   FirmwareInfo table Logic Definitions
*/

#include "FirmwareInfo.h"

struct FIRMWARE_INFO LoadFirmwareInfo (struct ATOM_DATA_AND_CMMD_TABLES abstractTable) {
    
    // Initializing the firmwareinfo structure
    struct FIRMWARE_INFO firmwareInfo = *(struct FIRMWARE_INFO *) malloc(sizeof(struct FIRMWARE_INFO *));
    
    // struct   |    property                                    |       content      |        Initial Offset        | size
    firmwareInfo.defaultEngineClock    = HexToDec(GetContentData(abstractTable.content, OFFSET_DEFAULT_ENGINE_CLOCK,   0x2))/100;
    firmwareInfo.defaultMemoryClock    = HexToDec(GetContentData(abstractTable.content, OFFSET_DEFAULT_MEMORY_CLOCK,   0x2))/100;
    firmwareInfo.deftDispEngineClk     = HexToDec(GetContentData(abstractTable.content, OFFSET_DEFT_DISP_ENGINE_CLK,   0x2))/100;
    firmwareInfo.bootUpVDDCVoltage     = HexToDec(GetContentData(abstractTable.content, OFFSET_BOOT_VDDC_VOLTAGE,      0x2));
    firmwareInfo.LcdMinPixelClock      = HexToDec(GetContentData(abstractTable.content, OFFSET_LCD_MIN_PIXEL_CLOCK,    0x2));
    firmwareInfo.LcdMaxPixelClock      = HexToDec(GetContentData(abstractTable.content, OFFSET_LCD_MAX_PIXEL_CLOCK,    0x2));
    firmwareInfo.maxPixelClock         = HexToDec(GetContentData(abstractTable.content, OFFSET_MAX_PIXEL_CLOCK,        0x2))/100;
    firmwareInfo.minPixelClockPLLInput = HexToDec(GetContentData(abstractTable.content, OFFSET_MIN_PIXEL_CLK_INPUT,    0x2));
    firmwareInfo.maxPixelClockPLLInput = HexToDec(GetContentData(abstractTable.content, OFFSET_MAX_PIXEL_CLK_INPUT,    0x2));
    firmwareInfo.coreReferenceClock    = HexToDec(GetContentData(abstractTable.content, OFFSET_CORE_REFERENCE_CLOCK,   0x2));
    firmwareInfo.memoryReferenceClock  = HexToDec(GetContentData(abstractTable.content, OFFSET_MEMORY_REFERENCE_CLOCK, 0x2));
    
    return firmwareInfo;
}

void SaveFirmwareInfo (FILE * firmware, struct ATOM_DATA_AND_CMMD_TABLES abstractTable, struct FIRMWARE_INFO firmwareInfo) {
    
    //Function  | target | Big Endian to Little |              property          |     table offset    | Size Multiplier by 2
    SetFileData(firmware, BigToLittleEndian(firmwareInfo.defaultEngineClock*100), abstractTable.offset + OFFSET_DEFAULT_ENGINE_CLOCK  , 2);
    SetFileData(firmware, BigToLittleEndian(firmwareInfo.defaultMemoryClock*100), abstractTable.offset + OFFSET_DEFAULT_MEMORY_CLOCK  , 2);
    SetFileData(firmware, BigToLittleEndian(firmwareInfo.deftDispEngineClk *100), abstractTable.offset + OFFSET_DEFT_DISP_ENGINE_CLK  , 2);
    SetFileData(firmware, BigToLittleEndian(firmwareInfo.bootUpVDDCVoltage     ), abstractTable.offset + OFFSET_BOOT_VDDC_VOLTAGE     , 2);
    SetFileData(firmware, BigToLittleEndian(firmwareInfo.LcdMinPixelClock      ), abstractTable.offset + OFFSET_LCD_MIN_PIXEL_CLOCK   , 2);
    SetFileData(firmware, BigToLittleEndian(firmwareInfo.LcdMaxPixelClock      ), abstractTable.offset + OFFSET_LCD_MAX_PIXEL_CLOCK   , 2);
    SetFileData(firmware, BigToLittleEndian(firmwareInfo.maxPixelClock     *100), abstractTable.offset + OFFSET_MAX_PIXEL_CLOCK       , 2);
    SetFileData(firmware, BigToLittleEndian(firmwareInfo.minPixelClockPLLInput ), abstractTable.offset + OFFSET_MIN_PIXEL_CLK_INPUT   , 2);
    SetFileData(firmware, BigToLittleEndian(firmwareInfo.maxPixelClockPLLInput ), abstractTable.offset + OFFSET_MAX_PIXEL_CLK_INPUT   , 2);
    SetFileData(firmware, BigToLittleEndian(firmwareInfo.coreReferenceClock    ), abstractTable.offset + OFFSET_CORE_REFERENCE_CLOCK  , 2);
    SetFileData(firmware, BigToLittleEndian(firmwareInfo.memoryReferenceClock  ), abstractTable.offset + OFFSET_MEMORY_REFERENCE_CLOCK, 2);
    
}
