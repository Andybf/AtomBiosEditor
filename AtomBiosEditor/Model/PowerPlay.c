/*
 * Nome:        PowerPlay.c
 * Criado por:  Anderson Bucchianico
 * Criação:     09 de julho de 2019
 * Descrição:   Contém funçoes para pegar informações de dentro das data tables.
 */

#include "PowerPlay.h"

struct POWERPLAY_DATA LoadPowerPlayData (struct ATOM_DATA_AND_CMMD_TABLES abstractTable) {
    struct POWERPLAY_DATA powerPlay = *(struct POWERPLAY_DATA *) malloc(sizeof(struct POWERPLAY_DATA *));
    
    //            property                                 content of the table |        initial offset      | size | chars
    powerPlay.overDriveOffset   = HexToDec(GetContentData(abstractTable.content, OFFSET_SUBTABLE_LIMITS,       0x2),   4);
    powerPlay.maxGpuClock       = HexToDec(GetContentData(abstractTable.content, powerPlay.overDriveOffset +2, 0x3),   6)/100;
    powerPlay.maxMemClock       = HexToDec(GetContentData(abstractTable.content, powerPlay.overDriveOffset +6, 0x3),   6)/100;
    powerPlay.maxTdp            = HexToDec(GetContentData(abstractTable.content, OFFSET_INFO_MAX_TDP,          0x1),   2);
    powerPlay.minTdp            = HexToDec(GetContentData(abstractTable.content, OFFSET_INFO_MIN_TDP,          0x1),   2);
    powerPlay.clockInfoOffset   = HexToDec(GetContentData(abstractTable.content, OFFSET_SUBTABLE_CLOCK,        0x2),   4);
    powerPlay.numberOfStates    = HexToDec(GetContentData(abstractTable.content, powerPlay.clockInfoOffset,    0x1),   2);
    powerPlay.lengthPerState    = HexToDec(GetContentData(abstractTable.content, powerPlay.clockInfoOffset +1, 0x1),   2);
    powerPlay.gpuFreqOffset     = HexToDec(GetContentData(abstractTable.content, OFFSET_SUBTABLE_GPU_FREQ,     0x2),   4);
    powerPlay.numberOfGpuStates = HexToDec(GetContentData(abstractTable.content, powerPlay.gpuFreqOffset,      0x1),   2);
    powerPlay.memFreqOffset     = HexToDec(GetContentData(abstractTable.content, OFFSET_SUBTABLE_MEM_FREQ,     0x2),   4);
    powerPlay.numberOfMemStates = HexToDec(GetContentData(abstractTable.content, powerPlay.memFreqOffset,      0x1),   2);
    powerPlay.fanInfoOffset     = HexToDec(GetContentData(abstractTable.content, OFFSET_SUBTABLE_FAN,          0x2),   4);
    powerPlay.hysteresis        = HexToDec(GetContentData(abstractTable.content, powerPlay.fanInfoOffset   +1, 0x1),   2);
    powerPlay.maxTemp           = HexToDec(GetContentData(abstractTable.content, powerPlay.fanInfoOffset  +14, 0x2),   4)/100;
    powerPlay.maxFanSpeed       = HexToDec(GetContentData(abstractTable.content, powerPlay.fanInfoOffset  +17, 0x1),   2);
    powerPlay.memFreqState      = malloc(powerPlay.numberOfMemStates * sizeof(unsigned char*));
    powerPlay.gpuFreqState      = malloc(powerPlay.numberOfGpuStates * sizeof(unsigned char*));
    powerPlay.gpuClock          = malloc(powerPlay.numberOfStates    * sizeof(unsigned char*));
    powerPlay.memClock          = malloc(powerPlay.numberOfStates    * sizeof(unsigned char*));
    powerPlay.voltage           = malloc(powerPlay.numberOfStates    * sizeof(unsigned char*));
    int step = 0;
    for (int c=0; c<powerPlay.numberOfStates; c++) {
        if (c == 0) { step = 2; } else { step += powerPlay.lengthPerState;}
        powerPlay.gpuClock[c]     = HexToDec(GetContentData(abstractTable.content, powerPlay.clockInfoOffset + step,       0x3),6)/100;
        powerPlay.memClock[c]     = HexToDec(GetContentData(abstractTable.content, powerPlay.clockInfoOffset + step + 0x3, 0x3),6)/100;
        powerPlay.voltage[c]      = HexToDec(GetContentData(abstractTable.content, powerPlay.clockInfoOffset + step + 0x6, 0x2),4);
    }
    step = 0;
    for (int c=0; c<powerPlay.numberOfGpuStates; c++) {
        if (c == 0) { step = 1; } else { step += 5;}
        powerPlay.gpuFreqState[c] = HexToDec(GetContentData(abstractTable.content, powerPlay.gpuFreqOffset   + step,       0x3),6)/100;
    }
    for (int c=0; c<powerPlay.numberOfMemStates; c++) {
        if (c == 0) { step = 0; } else { step += 5;}
        powerPlay.memFreqState[c] = HexToDec(GetContentData(abstractTable.content, powerPlay.memFreqOffset   + step + 0x1, 0x3),6)/100;
    }
    for (short c=0; c<3; c++) {
        if (c == 0) { step = 0; } else { step += 2;}
        powerPlay.tempTarget[c]   = HexToDec(GetContentData(abstractTable.content, powerPlay.fanInfoOffset   + step + 0x2, 0x2),4)/100;
        powerPlay.fanSpeed[c]     = HexToDec(GetContentData(abstractTable.content, powerPlay.fanInfoOffset   + step + 0x8, 0x2),4)/100;
    }
    return powerPlay;
}

void SavePowerPlayData (FILE * firmware, struct ATOM_DATA_AND_CMMD_TABLES abstractTable, struct POWERPLAY_DATA * powerPlay) {
    
    //PowerPlay Part
    int step = 0;
    for (int a=0; a<powerPlay->numberOfStates; a++) {
        if (a == 0) { step = 2; } else { step += powerPlay->lengthPerState;}
        //       FILE * fileOutput,               char * data,                                            ushort offset                  | size
        SetFileData(firmware, BigToLittleEndian(powerPlay->gpuClock[a]*100), abstractTable.offset + powerPlay->clockInfoOffset + step,       0x3);
        SetFileData(firmware, BigToLittleEndian(powerPlay->memClock[a]*100), abstractTable.offset + powerPlay->clockInfoOffset + step + 0x3, 0x3);
        SetFileData(firmware, BigToLittleEndian(powerPlay->voltage[a]     ), abstractTable.offset + powerPlay->clockInfoOffset + step + 0x6, 0x2);
    }
    step = 0;
    for (int c=0; c<powerPlay->numberOfGpuStates; c++) {
        if (c == 0) { step = 1; } else { step += 5;}
        SetFileData(firmware, BigToLittleEndian(powerPlay->gpuFreqState[c]*100), abstractTable.offset + powerPlay->gpuFreqOffset + step, 0x3);
    }
    for (int c=0; c<powerPlay->numberOfMemStates; c++) {
        if (c == 0) { step = 0; } else { step += 5;}
        SetFileData(firmware, BigToLittleEndian(powerPlay->memFreqState[c]*100), abstractTable.offset + powerPlay->memFreqOffset + step + 0x1, 0x3);
    }
    
    //Overdrive Part
    //       FILE * fileOutput,               char * data,                                            ushort offset, ushort size
    SetFileData(firmware, BigToLittleEndian(powerPlay->maxGpuClock*100), abstractTable.offset + powerPlay->overDriveOffset +  2, 3);
    SetFileData(firmware, BigToLittleEndian(powerPlay->maxMemClock*100), abstractTable.offset + powerPlay->overDriveOffset +  6, 3);
    SetFileData(firmware, BigToLittleEndian(powerPlay->maxTdp)         , abstractTable.offset + OFFSET_INFO_MAX_TDP,         1);
    SetFileData(firmware, BigToLittleEndian(powerPlay->minTdp)         , abstractTable.offset + OFFSET_INFO_MIN_TDP,         1);
    SetFileData(firmware, BigToLittleEndian(powerPlay->hysteresis)     , abstractTable.offset + powerPlay->fanInfoOffset   +  1, 1);
    SetFileData(firmware, BigToLittleEndian(powerPlay->maxTemp    *100), abstractTable.offset + powerPlay->fanInfoOffset   + 14, 2);
    SetFileData(firmware, BigToLittleEndian(powerPlay->maxFanSpeed)    , abstractTable.offset + powerPlay->fanInfoOffset   + 17, 1);
    step = 0;
    for (short c=0; c<3; c++) {
        if (c == 0) { step = 0; } else { step += 2;}
        SetFileData(firmware, BigToLittleEndian(powerPlay->tempTarget[c]*100), abstractTable.offset + powerPlay->fanInfoOffset +2+step, 0x2);
        SetFileData(firmware, BigToLittleEndian(powerPlay->fanSpeed[c]*100)  , abstractTable.offset + powerPlay->fanInfoOffset +8+step, 0x2);
    }
}
