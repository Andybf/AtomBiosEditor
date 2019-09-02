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
    powerPlay.overDriveOffset = HexToDec(GetFileData(firmware, abstractTable.offset + OFFSET_SUBTABLE_LIMITS,         0x2, 0),4);
    strcpy(powerPlay.maxGpuClock,               GetFileData(firmware, abstractTable.offset + powerPlay.overDriveOffset + 2, 0x3, 0));
    strcpy(powerPlay.maxMemClock,               GetFileData(firmware, abstractTable.offset + powerPlay.overDriveOffset + 6, 0x3, 0));
//    printf(" Max GPU speed:  %d MHz | Off. 0x%02X "  ,HexToDec(powerPlay.maxGpuClock,6)/100,abstractTable.offset + powerPlay.overDriveOffset + 2);
//    printf("\n Max Mem speed:  %d MHz | Off. 0x%02X \n\n",HexToDec(powerPlay.maxMemClock,6)/100,abstractTable.offset + powerPlay.overDriveOffset + 6);
    // TDP
    powerPlay.maxTdp = *GetFileData(firmware, abstractTable.offset+OFFSET_INFO_MAX_TDP, 0x2, 1);
    powerPlay.minTdp = *GetFileData(firmware, abstractTable.offset+OFFSET_INFO_MIN_TDP, 0x2, 1);
//    printf("       Min TDP:  %d Watts\n",powerPlay.minTdp);
//    printf("           TDP:  %d Watts\n",(powerPlay.minTdp+powerPlay.maxTdp)/2);
//    printf("       Max TDP:  %d Watts\n\n",powerPlay.maxTdp);
    
    powerPlay.clockInfoOffset    =   HexToDec(GetFileData(firmware, abstractTable.offset + OFFSET_SUBTABLE_CLOCK,           0x2, 0),4);
    powerPlay.numberOfStates     =   HexToDec(GetFileData(firmware, abstractTable.offset + powerPlay.clockInfoOffset,       0x1, 0),2);
    powerPlay.lengthPerState     =   HexToDec(GetFileData(firmware, abstractTable.offset + powerPlay.clockInfoOffset + 0x1, 0x1, 0),2);
    powerPlay.gpuClock           =   malloc(powerPlay.numberOfStates * sizeof(unsigned char*));
    powerPlay.memClock           =   malloc(powerPlay.numberOfStates * sizeof(unsigned char*));
    powerPlay.voltage            =   malloc(powerPlay.numberOfStates * sizeof(unsigned char*));
    int step = 0;
//    printf(" PowerPlay states: %d\n Id | GPU Clock | Mem Clock | Voltage\n",powerPlay.numberOfStates);
    for (int c=0; c<powerPlay.numberOfStates; c++) {
        if (c == 0) { step = 2; } else { step += powerPlay.lengthPerState;}
        powerPlay.gpuClock[c]    =   HexToDec(GetFileData(firmware, abstractTable.offset + powerPlay.clockInfoOffset + step,       0x3, 0),6)/100;
        powerPlay.memClock[c]    =   HexToDec(GetFileData(firmware, abstractTable.offset + powerPlay.clockInfoOffset + step + 0x3, 0x3, 0),6)/100;
        powerPlay.voltage[c]     =   HexToDec(GetFileData(firmware, abstractTable.offset + powerPlay.clockInfoOffset + step + 0x6, 0x2, 0),4);
//        printf("  %d |",c);
//        printf(" %d MHz   |",HexToDec((char*)powerPlay.gpuClock[c],6)/100);
//        printf(" %d MHz   |",HexToDec((char*)powerPlay.memClock[c],6)/100);
//        printf(" %d mV\n",HexToDec((char*)powerPlay.voltage[c],4));
    }
    
    // GPU
    powerPlay.gpuFreqOffset      =   HexToDec(GetFileData(firmware, abstractTable.offset + OFFSET_SUBTABLE_GPU_FREQ, 0x2, 0),4);
    powerPlay.numberOfGpuStates  =           *GetFileData(firmware, abstractTable.offset + powerPlay.gpuFreqOffset, 0x1, 1);
    powerPlay.gpuFreqState       =   malloc(powerPlay.numberOfGpuStates * sizeof(unsigned char*));
    step = 0;
//    printf("\n GPU states: %d\n Id | GPU Clock | Offset\n",powerPlay.numberOfGpuStates);
    for (int c=0; c<powerPlay.numberOfGpuStates; c++) {
        if (c == 0) { step = 1; } else { step += 5;}
        powerPlay.gpuFreqState[c] = HexToDec(GetFileData(firmware, powerPlay.gpuFreqOffset + abstractTable.offset + step, 0x3, 0),6)/100;
//        printf("  %d |",c);
//        printf(" %d MHz   | 0x%02X \n",HexToDec((char*)powerPlay.gpuFreqState[c], 6)/100, powerPlay.gpuFreqOffset+abstractTable.offset+0x1+step);
    }
    
    // Memory
    powerPlay.memFreqOffset      =   HexToDec(GetFileData(firmware, abstractTable.offset + OFFSET_SUBTABLE_MEM_FREQ, 0x2, 0),4);
    powerPlay.numberOfMemStates  =  *GetFileData(firmware, abstractTable.offset + powerPlay.memFreqOffset, 0x1, 1);
    powerPlay.memFreqState       =   malloc(powerPlay.numberOfMemStates * sizeof(char *));
//    printf("\n Mem states: %d\n Id | Mem Clock | Offset\n",powerPlay.numberOfMemStates);
    for (int c=0; c<powerPlay.numberOfMemStates; c++) {
        if (c == 0) { step = 0; } else { step += 5;}
        powerPlay.memFreqState[c] = HexToDec(GetFileData(firmware, +powerPlay.memFreqOffset+abstractTable.offset+0x1+step, 0x3, 0),6)/100;
//        printf("  %d | ",c);
//        printf("%d MHz   | 0x%02X\n",HexToDec((char*)powerPlay.memFreqState[c], 6)/100, powerPlay.memFreqOffset+abstractTable.offset+0x1+step);
    }

    // Fan Info
    powerPlay.fanInfoOffset = HexToDec(GetFileData(firmware, abstractTable.offset + OFFSET_SUBTABLE_FAN,       0x2, 0),4);
    powerPlay.hysteresis    =         *GetFileData(firmware, abstractTable.offset + powerPlay.fanInfoOffset+1, 0x1, 1);
//    printf("\n Id | Temperature | Fan Speed");
    for (short c=0; c<3; c++) {
        if (c == 0) { step = 0; } else { step += 2;}
        powerPlay.tempTarget[c] = HexToDec(GetFileData(firmware, abstractTable.offset + powerPlay.fanInfoOffset+2+step, 0x2, 0),4)/100;
        powerPlay.fanSpeed[c] = HexToDec(GetFileData(firmware, abstractTable.offset + powerPlay.fanInfoOffset+8+step, 0x2, 0),4)/100;
//        printf("\n  %d |    %dºC     |    %d%%",c,powerPlay.tempTarget[c],powerPlay.fanSpeed[c]);
    }
    return powerPlay;
}

