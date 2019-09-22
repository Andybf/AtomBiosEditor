//
//  AtomBios.h
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 22/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#ifndef AtomBios_h
#define AtomBios_h

#include <stdio.h>
#include <sys/stat.h>

#include "CoreFunctions.h"

//Addresses
#define OFFSET_ROM_BASE_TABLE     0x04
#define OFFSET_ROM_CHECKSUM       0x21
#define OFFSET_ROM_INFO           0x48
#define OFFSET_COMPILATION_TIME   0x50
#define OFFSET_STR_START          0x6E

//static information found in firmware files
#define STATIC_ROM_MAGIC_NUMBER    "AA55"
#define STATIC_ROM_ARCH_TERASCALE2 "E97E"
#define STATIC_ROM_ARCH_CGN1       "E980"
#define STATIC_ROM_ARCH_CGN3       "E977"
#define STATIC_ROM_ARCH_CGN4       "E974"
#define STATIC_ROM_MESSAGE_BEGIN   "000D0A"
#define STATIC_ROM_SIGNATURE       "373631323935353230"  //761295520
#define STATIC_ROM_TYPE            "41544F4D"            //ATOM

// Definições de tipos de dados
// an integer value between 0 and 65.535 (2 bytes of size)
typedef unsigned short ushort;
// an integer value between 0 and 255 (1 byte of size)
typedef unsigned char byte;

struct FIRMWARE_FILE {
    FILE * file;
    char * filePath;
    char * fileName;
    struct stat fileInfo;
    ushort genType;
};

// firmware data structure
struct ATOM_DATA_AND_CMMD_TABLES {
    
    ushort index;
    char * name;
    ushort offset;
    ushort size;
    ushort formatRev;
    ushort contentRev;
    char * content;
    
};

struct ATOM_OFFSETS_TABLE {
    
    ushort offset;
    ushort size;
    //byte formatRev[3];
    //byte contentRev[3];
    
};

struct ATOM_MAIN_TABLE {
    
    char   romMessage[59];
    ushort romMsgOffset;
    ushort romInfoOffset;
    
    char   generation[12];
    
    char * architecture;
    ushort archOffset;
    ushort archSize;
    
    char * connectionType;
    ushort conTypeOffset;
    ushort conTypeSize;
    
    char * memoryGen;
    ushort memGenOffset;
    ushort memGenSize;
    
    char   partNumber[40];
    ushort partNumberOffset;
    ushort partNumSize;
    
    char   biosVersion[23];
    char   compTime[15];
    byte   subsystemId[5];
    byte   subsystemVendorId[5];
    char   vendorName[11];
    byte   deviceId[9];
    ushort checksum;
    short  checksumStatus;
    ushort size;
    short  uefiSupport;
    
};

struct ATOM_BIOS {
    
    struct FIRMWARE_FILE             firmware;
    struct ATOM_MAIN_TABLE           mainTable;
    struct ATOM_OFFSETS_TABLE        offsetsTable[2];
    struct ATOM_DATA_AND_CMMD_TABLES dataAndCmmdTables[QUANTITY_TOTAL_TABLES];
    
};

//Functions Definition

// Extract
void                   ExtractTable          (struct ATOM_DATA_AND_CMMD_TABLES abstractTable, const char * extractedTableFilePath);

//Load
void                   loadFirmwareFile      (struct ATOM_BIOS * atomBios);
struct ATOM_MAIN_TABLE loadMainTable         (struct ATOM_BIOS * atomBios);
void                   loadOffsetsTable      (struct ATOM_BIOS * atomBios);
void                   loadCmmdAndDataTables (struct ATOM_BIOS * atomBios);

//Replace
void                   ReplaceTable          (struct ATOM_DATA_AND_CMMD_TABLES * dataAndCmmdTables, ushort index, const char * tablePath);

//Save
void                   SaveModifiedAtomBios  (struct ATOM_BIOS * atomBios, const char * charNewFilePath);

//Verify
short                  VerifyFirmwareSize    (struct stat);
short                  VerifyFirmwareSignature    (FILE *);
short                  VerifyFirmwareArchitecture (FILE *);
short                  VerifyChecksum        (struct ATOM_BIOS * atomBios);
short                  VerifySubSysCompany   (struct ATOM_MAIN_TABLE *);

#endif /* AtomBios */
