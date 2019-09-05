/*
 * Nome:        AtomBiosReader > Modules > PowerPlay > PowerPlay.c
 * Criado por:  Anderson Bucchianico
 * Criação:     09 de julho de 2019
 * Descrição:   Contém funçoes para pegar informações de dentro das data tables.
 */

#include "PowerPlay.h"

struct POWERPLAY_DATA ShowPowerPlayData (FILE * firmware, struct ATOM_ABSTRACT_TABLE abstractTable) {
    struct POWERPLAY_DATA powerPlay = *(struct POWERPLAY_DATA *) malloc(sizeof(struct POWERPLAY_DATA *));
    
    // OverDrive
    powerPlay.overDriveOffset = HexToDec(GetFileData(firmware, abstractTable.offset + OFFSET_SUBTABLE_LIMITS,        0x2, 0),4);
    powerPlay.maxGpuClock     = HexToDec(GetFileData(firmware, abstractTable.offset + powerPlay.overDriveOffset + 2, 0x3, 0),6)/100;
    powerPlay.maxMemClock     = HexToDec(GetFileData(firmware, abstractTable.offset + powerPlay.overDriveOffset + 6, 0x3, 0),6)/100;
    // TDP
    powerPlay.maxTdp          = *GetFileData(firmware, abstractTable.offset+OFFSET_INFO_MAX_TDP, 0x2, 1);
    powerPlay.minTdp          = *GetFileData(firmware, abstractTable.offset+OFFSET_INFO_MIN_TDP, 0x2, 1);
    
    powerPlay.clockInfoOffset = HexToDec(GetFileData(firmware, abstractTable.offset + OFFSET_SUBTABLE_CLOCK,           0x2, 0),4);
    powerPlay.numberOfStates  = HexToDec(GetFileData(firmware, abstractTable.offset + powerPlay.clockInfoOffset,       0x1, 0),2);
    powerPlay.lengthPerState  = HexToDec(GetFileData(firmware, abstractTable.offset + powerPlay.clockInfoOffset + 0x1, 0x1, 0),2);
    powerPlay.gpuClock        = malloc(powerPlay.numberOfStates * sizeof(unsigned char*));
    powerPlay.memClock        = malloc(powerPlay.numberOfStates * sizeof(unsigned char*));
    powerPlay.voltage         = malloc(powerPlay.numberOfStates * sizeof(unsigned char*));
    int step = 0;
    for (int c=0; c<powerPlay.numberOfStates; c++) {
        if (c == 0) { step = 2; } else { step += powerPlay.lengthPerState;}
        powerPlay.gpuClock[c] = HexToDec(GetFileData(firmware, abstractTable.offset + powerPlay.clockInfoOffset + step,       0x3, 0),6)/100;
        powerPlay.memClock[c] = HexToDec(GetFileData(firmware, abstractTable.offset + powerPlay.clockInfoOffset + step + 0x3, 0x3, 0),6)/100;
        powerPlay.voltage[c]  = HexToDec(GetFileData(firmware, abstractTable.offset + powerPlay.clockInfoOffset + step + 0x6, 0x2, 0),4);
    }
    // GPU
    powerPlay.gpuFreqOffset      = HexToDec(GetFileData(firmware, abstractTable.offset + OFFSET_SUBTABLE_GPU_FREQ, 0x2, 0),4);
    powerPlay.numberOfGpuStates  = *GetFileData(firmware, abstractTable.offset + powerPlay.gpuFreqOffset, 0x1, 1);
    powerPlay.gpuFreqState       = malloc(powerPlay.numberOfGpuStates * sizeof(unsigned char*));
    step = 0;
    for (int c=0; c<powerPlay.numberOfGpuStates; c++) {
        if (c == 0) { step = 1; } else { step += 5;}
        powerPlay.gpuFreqState[c] = HexToDec(GetFileData(firmware, powerPlay.gpuFreqOffset + abstractTable.offset + step, 0x3, 0),6)/100;
    }
    // Memory
    powerPlay.memFreqOffset      = HexToDec(GetFileData(firmware, abstractTable.offset + OFFSET_SUBTABLE_MEM_FREQ, 0x2, 0),4);
    powerPlay.numberOfMemStates  = *GetFileData(firmware, abstractTable.offset + powerPlay.memFreqOffset, 0x1, 1);
    powerPlay.memFreqState       = malloc(powerPlay.numberOfMemStates * sizeof(char *));
    for (int c=0; c<powerPlay.numberOfMemStates; c++) {
        if (c == 0) { step = 0; } else { step += 5;}
        powerPlay.memFreqState[c] = HexToDec(GetFileData(firmware, +powerPlay.memFreqOffset+abstractTable.offset+0x1+step, 0x3, 0),6)/100;
    }
    // Fan Info
    powerPlay.fanInfoOffset = HexToDec(GetFileData(firmware, abstractTable.offset + OFFSET_SUBTABLE_FAN,       0x2, 0),4);
    powerPlay.hysteresis    =         *GetFileData(firmware, abstractTable.offset + powerPlay.fanInfoOffset+1, 0x1, 1);
    powerPlay.maxTemp       = HexToDec(GetFileData(firmware, abstractTable.offset + powerPlay.fanInfoOffset+14, 0x2, 0),4)/100;
    powerPlay.maxFanSpeed   = HexToDec(GetFileData(firmware, abstractTable.offset + powerPlay.fanInfoOffset+17, 0x1, 0),2);
    for (short c=0; c<3; c++) {
        if (c == 0) { step = 0; } else { step += 2;}
        powerPlay.tempTarget[c] = HexToDec(GetFileData(firmware, abstractTable.offset + powerPlay.fanInfoOffset+2+step, 0x2, 0),4)/100;
        powerPlay.fanSpeed[c] = HexToDec(GetFileData(firmware, abstractTable.offset + powerPlay.fanInfoOffset+8+step, 0x2, 0),4)/100;
    }
    
    return powerPlay;
}

