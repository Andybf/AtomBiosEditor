/*
 * Nome:        AtomBiosReader > Modules > PowerPlay > PowerPlay.h
 * Criado por:  Anderson Bucchianico
 * Criação:     15 de julho de 2019
 * Descrição:   Estruturas de dados da table PowerPlay
 */

#ifndef PowerPlay_h
#define PowerPlay_h

#include "AtomBios.h"

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
    ushort clockInfoOffset;
    ushort numberOfStates;
    ushort lengthPerState;
    ushort * gpuClock;
    ushort * memClock;
    ushort * voltage;
    
    ushort overDriveOffset;
    ushort maxGpuClock;
    ushort maxMemClock;
    
    ushort gpuFreqOffset;
    ushort numberOfGpuStates;
    ushort * gpuFreqState;
    
    ushort memFreqOffset;
    ushort numberOfMemStates;
    ushort * memFreqState;
    
    ushort fanInfoOffset;
    char hysteresis;
    ushort tempTarget[3];
    ushort fanSpeed[3];
    ushort maxTemp;
    char maxFanSpeed;
    
    ushort minTdp;
    ushort maxTdp;
};

struct POWERPLAY_DATA LoadPowerPlayData  (struct ATOM_DATA_AND_CMMD_TABLES);
void SavePowerPlayData (FILE * firmware, struct ATOM_DATA_AND_CMMD_TABLES abstractTable, struct POWERPLAY_DATA powerPlay);

#endif /* PowerPlay_h */
