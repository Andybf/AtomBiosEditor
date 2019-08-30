//
//  MainTableLoader.h
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 22/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#ifndef MainTableLoader_h
#define MainTableLoader_h

#include "CoreFunctions.h"
#include "FileLoader.h"

//Endereços
#define OFFSET_ROM_BASE_TABLE     0x04
#define OFFSET_ROM_CHECKSUM       0x21
#define OFFSET_ROM_INFO           0x48
#define OFFSET_COMPILATION_TIME   0x50
#define OFFSET_STR_START          0x6E

//Informações Estáticas
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

// Estruturas de dados do firmware
struct ATOM_ABSTRACT_TABLE {
    
    char id[3];
    char * name;
    
    ushort offset;
    ushort size;
    
    byte formatRev[3];
    byte contentRev[3];
    
    char * content;
};

struct ATOM_OFFSETS_TABLE {
    
    ushort offset;
    ushort size;
    
    //byte formatRev[3];
    //byte contentRev[3];
};

struct ATOM_BASE_TABLE {
    
    ushort size;
    
    ushort checksum;
    short checksumStatus;
    
    ushort romInfoOffset;
    
    char partNumber[40];
    ushort partNumberSize;
    
    byte subsystemId[5];
    byte subsystemVendorId[5];
    byte deviceId[9];
    
    ushort romMsgOffset;
    char romMessage[77];
    
    char biosVersion[23];
    
    char compTime[15];
    
    short uefiSupport;
    
    struct ATOM_OFFSETS_TABLE tblOffsets[2];
    
    struct ATOM_ABSTRACT_TABLE atomTables[QUANTITY_TOTAL_TABLES];
};

//Definição de métodos
// Main Table
struct ATOM_BASE_TABLE loadMainTable         (struct FIRMWARE_FILE );
void                   loadCmmdAndDataTables (struct FIRMWARE_FILE , struct ATOM_BASE_TABLE * );
void                   loadOffsetsTable      (struct FIRMWARE_FILE , struct ATOM_BASE_TABLE * );
short                  VerifyChecksum        (struct FIRMWARE_FILE , struct ATOM_BASE_TABLE );
short                  VerifySubsystemCompanyName(struct ATOM_BASE_TABLE , char * CompanyNames[11][2]);
void                   ExtractTable(FILE * firmware, struct ATOM_ABSTRACT_TABLE abstractTable, const char * extractedTableFilePath);



#endif /* MainTableLoader_h */
