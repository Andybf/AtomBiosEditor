/*
 * Nome:        PowerPlay.c
 * Criado por:  Anderson Bucchianico
 * Criação:     09 de julho de 2019
 * Descrição:   Contém funçoes para pegar informações de dentro das data tables.
 */

#include "PowerPlay.h"

struct POWERPLAY_DATA LoadPowerPlayData (FILE * firmware, struct ATOM_DATA_AND_CMMD_TABLES abstractTable) {
    struct POWERPLAY_DATA powerPlay = *(struct POWERPLAY_DATA *) malloc(sizeof(struct POWERPLAY_DATA *));
    
    // Property                                        file                    offset                                  size | endian | chars
    powerPlay.overDriveOffset   = HexToDec(GetFileData(firmware, abstractTable.offset + OFFSET_SUBTABLE_LIMITS,         0x2,    0),    4);
    powerPlay.maxGpuClock       = HexToDec(GetFileData(firmware, abstractTable.offset + powerPlay.overDriveOffset   +2, 0x3,    0),    6)/100;
    powerPlay.maxMemClock       = HexToDec(GetFileData(firmware, abstractTable.offset + powerPlay.overDriveOffset   +6, 0x3,    0),    6)/100;
    powerPlay.maxTdp            = HexToDec(GetFileData(firmware, abstractTable.offset + OFFSET_INFO_MAX_TDP,            0x1,    0),    2);
    powerPlay.minTdp            = HexToDec(GetFileData(firmware, abstractTable.offset + OFFSET_INFO_MIN_TDP,            0x1,    0),    2);
    powerPlay.clockInfoOffset   = HexToDec(GetFileData(firmware, abstractTable.offset + OFFSET_SUBTABLE_CLOCK,          0x2,    0),    4);
    powerPlay.numberOfStates    = HexToDec(GetFileData(firmware, abstractTable.offset + powerPlay.clockInfoOffset,      0x1,    0),    2);
    powerPlay.lengthPerState    = HexToDec(GetFileData(firmware, abstractTable.offset + powerPlay.clockInfoOffset   +1, 0x1,    0),    2);
    powerPlay.gpuFreqOffset     = HexToDec(GetFileData(firmware, abstractTable.offset + OFFSET_SUBTABLE_GPU_FREQ,       0x2,    0),    4);
    powerPlay.numberOfGpuStates =         *GetFileData(firmware, abstractTable.offset + powerPlay.gpuFreqOffset,        0x1,    1);
    powerPlay.memFreqOffset     = HexToDec(GetFileData(firmware, abstractTable.offset + OFFSET_SUBTABLE_MEM_FREQ,       0x2,    0),    4);
    powerPlay.numberOfMemStates =         *GetFileData(firmware, abstractTable.offset + powerPlay.memFreqOffset,        0x1,    1);
    powerPlay.fanInfoOffset     = HexToDec(GetFileData(firmware, abstractTable.offset + OFFSET_SUBTABLE_FAN,            0x2,    0),    4);
    powerPlay.hysteresis        = HexToDec(GetFileData(firmware, abstractTable.offset + powerPlay.fanInfoOffset     +1, 0x1,    0),    2);
    powerPlay.maxTemp           = HexToDec(GetFileData(firmware, abstractTable.offset + powerPlay.fanInfoOffset    +14, 0x2,    0),    4)/100;
    powerPlay.maxFanSpeed       = HexToDec(GetFileData(firmware, abstractTable.offset + powerPlay.fanInfoOffset    +17, 0x1,    0),    2);
    powerPlay.memFreqState      = malloc(powerPlay.numberOfMemStates * sizeof(char *));
    powerPlay.gpuFreqState      = malloc(powerPlay.numberOfGpuStates * sizeof(unsigned char*));
    powerPlay.gpuClock          = malloc(powerPlay.numberOfStates    * sizeof(unsigned char*));
    powerPlay.memClock          = malloc(powerPlay.numberOfStates    * sizeof(unsigned char*));
    powerPlay.voltage           = malloc(powerPlay.numberOfStates    * sizeof(unsigned char*));
    int step = 0;
    for (int c=0; c<powerPlay.numberOfStates; c++) {
        if (c == 0) { step = 2; } else { step += powerPlay.lengthPerState;}
        powerPlay.gpuClock[c] = HexToDec(GetFileData(firmware, abstractTable.offset + powerPlay.clockInfoOffset + step,       0x3, 0),6)/100;
        powerPlay.memClock[c] = HexToDec(GetFileData(firmware, abstractTable.offset + powerPlay.clockInfoOffset + step + 0x3, 0x3, 0),6)/100;
        powerPlay.voltage[c]  = HexToDec(GetFileData(firmware, abstractTable.offset + powerPlay.clockInfoOffset + step + 0x6, 0x2, 0),4);
    }
    step = 0;
    for (int c=0; c<powerPlay.numberOfGpuStates; c++) {
        if (c == 0) { step = 1; } else { step += 5;}
        powerPlay.gpuFreqState[c] = HexToDec(GetFileData(firmware, powerPlay.gpuFreqOffset + abstractTable.offset + step, 0x3, 0),6)/100;
    }
    for (int c=0; c<powerPlay.numberOfMemStates; c++) {
        if (c == 0) { step = 0; } else { step += 5;}
        powerPlay.memFreqState[c] = HexToDec(GetFileData(firmware, +powerPlay.memFreqOffset+abstractTable.offset+0x1+step, 0x3, 0),6)/100;
    }
    for (short c=0; c<3; c++) {
        if (c == 0) { step = 0; } else { step += 2;}
        powerPlay.tempTarget[c] = HexToDec(GetFileData(firmware, abstractTable.offset + powerPlay.fanInfoOffset+2+step, 0x2, 0),4)/100;
        powerPlay.fanSpeed[c]   = HexToDec(GetFileData(firmware, abstractTable.offset + powerPlay.fanInfoOffset+8+step, 0x2, 0),4)/100;
    }
    return powerPlay;
}

void SavePowerPlayData (FILE * firmware, struct ATOM_DATA_AND_CMMD_TABLES abstractTable, struct POWERPLAY_DATA powerPlay) {
    // Necesary to implement 32bit big to little endian converters
    //SetFileDataNumber(firmware, BtoL16(powerPlay.maxGpuClock*100), abstractTable.offset + powerPlay.overDriveOffset + 0x02, 3);
    //SetFileDataNumber(firmware, BtoL16(powerPlay.maxMemClock*100), abstractTable.offset + powerPlay.overDriveOffset + 0x06, 3);
    SetFile16bitValue(firmware, powerPlay.maxTdp                 , abstractTable.offset + OFFSET_INFO_MAX_TDP,          1);
    SetFile16bitValue(firmware, powerPlay.minTdp                 , abstractTable.offset + OFFSET_INFO_MIN_TDP,          1);
    SetFile8bitValue (firmware, &powerPlay.hysteresis            , abstractTable.offset + powerPlay.fanInfoOffset +  1, 1);
    SetFile16bitValue(firmware, BigToLittleEndian(powerPlay.maxTemp    *100), abstractTable.offset + powerPlay.fanInfoOffset + 14, 2);
    SetFile8bitValue (firmware, &powerPlay.maxFanSpeed           , abstractTable.offset + powerPlay.fanInfoOffset + 17, 1);
    int step = 0;
    for (short c=0; c<3; c++) {
        if (c == 0) { step = 0; } else { step += 2;}
        SetFile16bitValue(firmware, BigToLittleEndian(powerPlay.tempTarget[c]*100), abstractTable.offset + powerPlay.fanInfoOffset +2+step, 0x2);
        SetFile16bitValue(firmware, BigToLittleEndian(powerPlay.fanSpeed[c]*100)  , abstractTable.offset + powerPlay.fanInfoOffset +8+step, 0x2);
    }
}
