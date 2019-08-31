/*
 * Nome:        AtomBiosReader > Modules > PowerPlay > PowerPlay.h
 * Criado por:  Anderson Bucchianico
 * Criação:     15 de julho de 2019
 * Descrição:   Estruturas de dados da table PowerPlay
 */

#ifndef PowerPlay_h
#define PowerPlay_h
#include "../../TableLoader.h"

// Addresses
#define OFFSET_SUBTABLE_CLOCK     0x0B
#define OFFSET_SUBTABLE_UNKNOWN   0x26
#define OFFSET_SUBTABLE_FAN       0x2A
#define OFFSET_SUBTABLE_LIMITS    0x2C
#define OFFSET_SUBTABLE_VCE       0x00
#define OFFSET_SUBTABLE_GPU_FREQ  0x36
#define OFFSET_SUBTABLE_MEM_FREQ  0x38

#define OFFSET_INFO_MAX_TDP       0x42
#define OFFSET_INFO_MIN_TDP       0x46

// Data Structures
struct POWERPLAY_DATA {
    unsigned short clockInfoOffset;
    unsigned short numberOfStates;
    unsigned short lengthPerState;
    char ** gpuClock;
    char ** memClock;
    char ** voltage;
    
    unsigned short overDriveOffset;
    char maxGpuClock[7];
    char maxMemClock[7];
    
    unsigned short gpuFreqOffset;
    unsigned short numberOfGpuStates;
    char ** gpuFreqState;
    
    unsigned short memFreqOffset;
    unsigned short numberOfMemStates;
    char ** memFreqState;
    
    unsigned short fanInfoOffset;
    unsigned short hysteresis;
    unsigned short tempTarget[3];
    unsigned short fanSpeed[3];
    unsigned short maxTemp;
    unsigned short maxFanSpeed;
    
    int minTdp;
    int maxTdp;
};

struct POWERPLAY_DATA ShowPowerPlayData (FILE * , struct ATOM_ABSTRACT_TABLE);

#endif /* PowerPlay_h */
