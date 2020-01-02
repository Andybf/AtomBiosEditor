//
//  AtomBios.c
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 22/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#include "AtomBios.h"

const char * CompanyNames[12][2] = {
    {"0000","Unknown"},
    {"1002","AMD/ATI"},
    {"106B","Apple"},
    {"1043","Asus"},
    {"1849","ASRock"},
    {"1028","Dell"},
    {"1458","Gigabyte"},
    {"1787","HIS"},
    {"1462","MSI"},
    {"148C","PowerColor"},
    {"174B","Sapphire"},
    {"1682","XFX"},
};

const char * tableNames[] = {
    // Command table names
    "ASIC_Init",                   "GetDisplaySurfaceSize",             "ASIC_RegistersInit",
    "VRAM_BlockVenderDetection",   "SetClocksRatio/DIGxEncoderControl", "MemoryControllerInit",
    "EnableCRTCMemReq",            "MemoryParamAdjust",                 "DVOEncoderControl",
    "GPIOPinControl",              "SetEngineClock",                    "SetMemoryClock",
    "SetPixelClock",               "DynamicClockGating",                "ResetMemoryDLL",
    "ResetMemoryDevice",           "MemoryPLLInit",                     "AdjustDisplayPll",
    "AdjustMemoryController",      "EnableASIC_StaticPwrMgt",           "ASIC_StaticPwrMgtStatusChange/SetUniphyInstance",
    "DAC_LoadDetection",           "LVTMAEncoderControl",               "LCD1OutputControl",
    "DAC1EncoderControl",          "DAC2EncoderControl",                "DVOOutputControl",
    "CV1OutputControl",            "GetConditionalGoldenSetting/SetCRTC_DPM_State", "TVEncoderControl",
    "TMDSAEncoderControl",         "LVDSEncoderControl",                "TV1OutputControl",
    "EnableScaler",                "BlankCRTC",                         "EnableCRTC",
    "GetPixelClock",               "EnableVGA_Render",                  "EnableVGA_Access/GetSCLKOverMCLKRatio",
    "SetCRTC_Timing",              "SetCRTC_OverScan",                  "SetCRTC_Replication",
    "SelectCRTC_Source",           "EnableGraphSurfaces",               "UpdateCRTC_DoubleBufferRegisters",
    "LUT_AutoFill",                "EnableHW_IconCursor",               "GetMemoryClock",
    "GetEngineClock",              "SetCRTC_UsingDTDTiming",            "ExternalEncoderControl",
    "LVTMAOutputControl",          "VRAM_BlockDetectionByStrap",        "MemoryCleanUp",
    "ReadEDIDFromHWAssistedI2C/ProcessI2cChannelTransaction",           "WriteOneByteToHWAssistedI2C",
    "ReadHWAssistedI2CStatus/HPDInterruptService",                      "SpeedFanControl",
    "PowerConnectorDetection",     "MC_Synchronization",                "ComputeMemoryEnginePLL",
    "MemoryRefreshConversion",     "VRAM_GetCurrentInfoBlock",          "DynamicMemorySettings",
    "MemoryTraining",              "EnableSpreadSpectrumOnPPLL",        "TMDSAOutputControl",
    "SetVoltage",                  "DAC1OutputControl",                 "DAC2OutputControl",
    "SetupHWAssistedI2CStatus",    "ClockSource",                       "MemoryDeviceInit",
    "EnableYUV",                   "DIG1EncoderControl",                "DIG2EncoderControl",
    "DIG1TransmitterControl/UNIPHYTransmitterControl",                  "DIG2TransmitterControl/LVTMATransmitterControl",
    "ProcessAuxChannelTransaction", "DPEncoderService",                 "Unknown",
    // Data Table Names
    "UtilityPipeLine",             "MultimediaCapabilityInfo",          "MultimediaConfigInfo",
    "StandardVESA_Timing",         "FirmwareInfo",                      "DAC_Info",
    "LVDS_Info",                   "TMDS_Info",                         "AnalogTV_Info",
    "SupportedDevicesInfo",        "GPIO_I2C_Info",                     "VRAM_UsageByFirmware",
    "GPIO_Pin_LUT",                "VESA_ToInternalModeLUT",            "ComponentVideoInfo",
    "PowerPlayInfo",               "CompassionateData",                 "SaveRestoreInfo/DispDevicePriorityInfo",
    "PPLL_SS_Info/SS_Info",        "OemInfo",                           "XTMDS_Info",
    "MclkSS_Info",                 "Object_Info/Object_Header",         "IndirectIOAccess",
    "MC_InitParameter/AdjustARB_SEQ", "ASIC_VDDC_Info",                 "ASIC_InternalSS_Info/ASIC_MVDDC_Info",
    "TV_VideoMode/DispOutInfo",    "VRAM_Info",                         "MemoryTrainingInfo/ASIC_MVDDQ_Info",
    "IntegratedSystemInfo",        "ASIC_ProfilingInfo/ASIC_VDDCI_Info",
    "VoltageObjectInfo/VRAM_GPIO_DetectionInfo",
    "PowerSourceInfo"
};

void ExtractTable(struct ATOM_DATA_AND_CMMD_TABLES abstractTable, const char * extractedTableFilePath) {
    FILE * output = fopen(extractedTableFilePath, "wb");
    fwrite( abstractTable.content, sizeof(char), abstractTable.size, output );
    fclose(output);
}

//Load base information of the firmware
struct ATOM_MAIN_TABLE loadMainTable(struct ATOM_BIOS * atomBios) {
    
    fseek(atomBios->firmware.file, 0x0, SEEK_SET);
    atomBios->firmware.fileContent = malloc(sizeof(char*) * atomBios->firmware.fileInfo.st_size);
    for (int c=0; c<atomBios->firmware.fileInfo.st_size; c++){
        sprintf(&atomBios->firmware.fileContent[c], "%c", fgetc(atomBios->firmware.file));
    }
    struct ATOM_MAIN_TABLE mainTable;
           //property                           |                  file              | initial address         |  bytes | Endian | hexbytes
           mainTable.size             = HexToDec(GetFileData(atomBios->firmware.file, OFFSET_ROM_BASE_TABLE,           2,     0),     4);
           mainTable.checksum         = HexToDec(GetFileData(atomBios->firmware.file, OFFSET_ROM_CHECKSUM,             1,     0),     2);
           mainTable.romInfoOffset    = HexToDec(GetFileData(atomBios->firmware.file, OFFSET_ROM_TABLE_PTR,            2,     0),     4);
           mainTable.romMsgOffset     = HexToDec(GetFileData(atomBios->firmware.file, mainTable.romInfoOffset +0x10,   2,     0),     4);
    strcpy(mainTable.romMessage,                 GetFileData(atomBios->firmware.file, mainTable.romMsgOffset  +0x02,  58,     1)       );
    
           mainTable.partNumberOffset = HexToDec(GetFileData(atomBios->firmware.file, OFFSET_STR_START,                1,     0),     2);
           mainTable.partNumSize      = GetNumBytesBeforeZero(atomBios->firmware.file, mainTable.partNumberOffset);
    strcpy(mainTable.partNumber,                 GetFileData(atomBios->firmware.file,  mainTable.partNumberOffset,    mainTable.partNumSize, 1) );
    
           mainTable.archOffset       = mainTable.partNumberOffset + mainTable.partNumSize+1;
           mainTable.archSize         = GetNumBytesBeforeZero(atomBios->firmware.file, mainTable.archOffset);
           mainTable.architecture     = malloc(sizeof(char*) * mainTable.archSize+1);
    strcpy(mainTable.architecture,               GetFileData(atomBios->firmware.file,  mainTable.archOffset,          mainTable.archSize,    1) );
    
           mainTable.conTypeOffset    = mainTable.archOffset + mainTable.archSize+1;
           mainTable.conTypeSize      = GetNumBytesBeforeZero(atomBios->firmware.file, mainTable.conTypeOffset);
           mainTable.connectionType   = malloc(sizeof(char*));
    strcpy(mainTable.connectionType,            GetFileData(atomBios->firmware.file,   mainTable.conTypeOffset,       mainTable.conTypeSize, 1) );
    
           mainTable.memGenOffset     = mainTable.conTypeOffset + mainTable.conTypeSize+1;
           mainTable.memGenSize       = GetNumBytesBeforeZero(atomBios->firmware.file, mainTable.memGenOffset);
           mainTable.memoryGen        = malloc(sizeof(char*));
    strcpy(mainTable.memoryGen,                 GetFileData(atomBios->firmware.file,   mainTable.memGenOffset,        mainTable.memGenSize,  1) );
    
    strcpy(mainTable.biosVersion,                GetFileData(atomBios->firmware.file, mainTable.romMsgOffset  +0x95,  22,     1) );
    strcpy(mainTable.compTime,                   GetFileData(atomBios->firmware.file, OFFSET_COMPILATION_TIME,        14,     1) );
    strcpy((char*)mainTable.subsystemId,         GetFileData(atomBios->firmware.file, mainTable.romInfoOffset +0x1A,   2,     0) );
    strcpy((char*)mainTable.subsystemVendorId,   GetFileData(atomBios->firmware.file, mainTable.romInfoOffset +0x18,   2,     0) );
    strcpy(mainTable.vendorName, CompanyNames[ VerifySubSysCompany(&mainTable) ][1]);
    strcpy((char*)mainTable.deviceId,            GetFileData(atomBios->firmware.file, mainTable.romInfoOffset +0x28,   4,     0) );
    
    //Checking Generation
    if (atomBios->firmware.genType == 1) {
        strcpy(mainTable.generation, "TERASCALE 2");
    } else if (atomBios->firmware.genType == 2) {
        strcpy(mainTable.generation, "CGN 1.0/2.0");
    } else if (atomBios->firmware.genType == 3) {
        strcpy(mainTable.generation, "CGN 3.0");
    } else if (atomBios->firmware.genType == 4) {
        strcpy(mainTable.generation, "CGN 4.0");
    } else {
        exit(8);
    }
    
    // Checking UEFI Support
    if( strcmp(GetFileData(atomBios->firmware.file, QUANTITY_64KB, 0x2, 0), ATOM_BIOS_MAGIC) == 0 ) {
        mainTable.uefiSupport = 1;
    } else {
        mainTable.uefiSupport = 0;
    }
    return mainTable;
}

// Load the table where is located the addresses of data tables and command tables
void loadOffsetsTable (struct ATOM_BIOS * atomBios) {
    int step = 0;
    for (int a=0; a<2; a++) { // 0 = CMMD | 1 = DATA
        if (a == 0) { step = 0x1e; } else { step += 2;} //     |         arquivo       |           endereço inicial              |  bytes  | Endianness | hexQuant
        atomBios->offsetsTable[a].offset = HexToDec(GetFileData(atomBios->firmware.file, atomBios->mainTable.romInfoOffset + step,    2,        0),          4);
        atomBios->offsetsTable[a].size   = HexToDec(GetFileData(atomBios->firmware.file, atomBios->offsetsTable[a].offset,            2,        0),          4);
    }
}

// Load into memory the data tables and the command tables
void loadCmmdAndDataTables (struct ATOM_BIOS * atomBios) {
    long posOffTbl = 0;
    int c=0;
    fseek(atomBios->firmware.file, atomBios->offsetsTable[0].offset+4, SEEK_SET);
    for (int b=0; b< QUANTITY_TOTAL_TABLES; b++) {
        if (c >= QUANTITY_COMMAND_TABLES) {
            c = b - QUANTITY_COMMAND_TABLES;
            fseek(atomBios->firmware.file, atomBios->offsetsTable[1].offset+4, SEEK_SET);
        }
        posOffTbl = ftell(atomBios->firmware.file);
        atomBios->dataAndCmmdTables[b].index = c;
        atomBios->dataAndCmmdTables[b].tableName       = (char *) malloc(sizeof(char*) * sizeof(tableNames[b]));
        strcpy( atomBios->dataAndCmmdTables[b].tableName, tableNames[b]);
        atomBios->dataAndCmmdTables[b].offset     = HexToDec(GetFileData(atomBios->firmware.file, (int) ftell(atomBios->firmware.file),  2,  0),4);
        
        atomBios->dataAndCmmdTables[b].size = 0;
        atomBios->dataAndCmmdTables[b].formatRev = 0;
        atomBios->dataAndCmmdTables[b].contentRev = 0;
        atomBios->dataAndCmmdTables[b].content = NULL;
        
        if (atomBios->dataAndCmmdTables[b].offset > 32768 ) {
            atomBios->dataAndCmmdTables[b].size       = HexToDec(GetFileData(atomBios->firmware.file, atomBios->dataAndCmmdTables[b].offset,  2,    0),4);
            atomBios->dataAndCmmdTables[b].formatRev  = HexToDec(GetFileData(atomBios->firmware.file, atomBios->dataAndCmmdTables[b].offset+2,1,    0),2);
            atomBios->dataAndCmmdTables[b].contentRev = HexToDec(GetFileData(atomBios->firmware.file, atomBios->dataAndCmmdTables[b].offset+3,1,    0),2);
            atomBios->dataAndCmmdTables[b].content    = (char*)malloc(sizeof(char *) * atomBios->dataAndCmmdTables[b].size);
            atomBios->dataAndCmmdTables[b].content    = GetFileData(atomBios->firmware.file, atomBios->dataAndCmmdTables[b].offset, atomBios->dataAndCmmdTables[b].size, 1);
        }
        c++;
        fseek( atomBios->firmware.file, posOffTbl+2, SEEK_SET );
    }
}

// Replace the table selected by user to another table located in a binary file .bin on the system
void ReplaceTable ( struct ATOM_DATA_AND_CMMD_TABLES * dataAndCmmdTables, ushort index, const char * tableFilePath) {
    FILE * tableBin;
    if ( !(tableBin = fopen(tableFilePath, "r")) ) {
        exit(1);
    }
    struct stat tableFileInfo;
    stat(tableFilePath,&tableFileInfo);
    char * tableChar = malloc(sizeof(char*) * tableFileInfo.st_size);
    tableChar = GetFileData(tableBin, 0x0, (int)tableFileInfo.st_size, 1);
    fclose(tableBin);
    
    if (tableFileInfo.st_size == dataAndCmmdTables[index].size) {
        for (int a=0; a<tableFileInfo.st_size; a++) {
            dataAndCmmdTables[index].content[a] = tableChar[a];
        }
    } else if (tableFileInfo.st_size < dataAndCmmdTables[index].size) {
        for (int a=0; a<tableFileInfo.st_size; a++) {
            dataAndCmmdTables[index].content[a] = tableChar[a];
        }
        ushort writingPoint = tableFileInfo.st_size + 1;
        for (int a=0; a<dataAndCmmdTables[index].size - (int)tableFileInfo.st_size; a++) {
            dataAndCmmdTables[index].content[writingPoint] = '\0';
            writingPoint++;
        }
    } else if (tableFileInfo.st_size > dataAndCmmdTables[index].size) {
        // Verify if we have space for aditional bytes
        if (QUANTITY_64KB - (dataAndCmmdTables[31].offset + dataAndCmmdTables[31].size) > 0 ) {
            dataAndCmmdTables[index].content = realloc(dataAndCmmdTables[index].content, tableFileInfo.st_size);
            //Replacing the content
            for (int a=0; a<tableFileInfo.st_size; a++) {
                dataAndCmmdTables->content[a] = tableChar[a];
            }
            for (int b=0; b<QUANTITY_TOTAL_TABLES; b++) {
                if (dataAndCmmdTables[b].offset > dataAndCmmdTables[index].offset) {
                    dataAndCmmdTables[b].offset += (tableFileInfo.st_size - dataAndCmmdTables[index].size);
                }
            }
            dataAndCmmdTables[index].size = tableFileInfo.st_size;
        }
    }
    for (int c=0; c<2; c++){
        dataAndCmmdTables[index].content[c] = BigToLittleEndian(dataAndCmmdTables[index].size)[c];
    }
    dataAndCmmdTables[index].formatRev  = dataAndCmmdTables[index].content[2];
    dataAndCmmdTables[index].contentRev = dataAndCmmdTables[index].content[3];
    free(tableChar);
}

void SaveAtomBiosData(struct ATOM_BIOS * atomBios, FILE * firmware) {
    
    fwrite(atomBios->firmware.fileContent, sizeof(char), atomBios->firmware.fileInfo.st_size, firmware);
    
    //Writing Address table, without writing size and content rev
    fseek(firmware, atomBios->offsetsTable[0].offset+0x4, SEEK_SET);
    for (int a=0; a<QUANTITY_TOTAL_TABLES; a++) {
        if (a == 81) {
            fseek(firmware, atomBios->dataAndCmmdTables[a].offset+0x4, SEEK_CUR);
        }
        fwrite(BigToLittleEndian(atomBios->dataAndCmmdTables[a].offset), sizeof(char), 0x2, firmware);
    }
    // Writing the data content in data tables and command tables
    for (int a=0; a<QUANTITY_TOTAL_TABLES; a++) {
        if (atomBios->dataAndCmmdTables[a].size > 0) {
            fseek(firmware, atomBios->dataAndCmmdTables[a].offset, SEEK_SET);
            for (int b=0; b<atomBios->dataAndCmmdTables[a].size; b++) {
                fwrite(&atomBios->dataAndCmmdTables[a].content[b], sizeof(char), 0x1, firmware);
            }
        }
    }
    SetFileData(firmware,                   (unsigned char*)atomBios->mainTable.romMessage,            atomBios->mainTable.romMsgOffset      +  0x2, 58);
    SetFileData(firmware,                   (unsigned char*)atomBios->mainTable.architecture,          atomBios->mainTable.archOffset,               atomBios->mainTable.archSize);
    SetFileData(firmware,                   (unsigned char*)atomBios->mainTable.connectionType,        atomBios->mainTable.conTypeOffset,            atomBios->mainTable.conTypeSize);
    SetFileData(firmware,                   (unsigned char*)atomBios->mainTable.memoryGen,             atomBios->mainTable.memGenOffset,             atomBios->mainTable.memGenSize);
    SetFileData(firmware,                   (unsigned char*)atomBios->mainTable.partNumber,            atomBios->mainTable.partNumberOffset,         atomBios->mainTable.partNumSize);
    SetFileData(firmware,                   (unsigned char*)atomBios->mainTable.compTime,              OFFSET_COMPILATION_TIME,                      14);
    SetFileData(firmware,                   (unsigned char*)atomBios->mainTable.biosVersion,           atomBios->mainTable.romMsgOffset      + 0x95, 22);
    SetFileData(firmware, BigToLittleEndian(HexToDec((char*)atomBios->mainTable.deviceId,8)),          atomBios->mainTable.romInfoOffset     + 0x28, 4);
    SetFileData(firmware, BigToLittleEndian(HexToDec((char*)atomBios->mainTable.subsystemId,4)),       atomBios->mainTable.romInfoOffset     + 0x1A, 2);
    SetFileData(firmware, BigToLittleEndian(HexToDec((char*)atomBios->mainTable.subsystemVendorId,4)), atomBios->mainTable.romInfoOffset     + 0x18, 2);
}

void SaveChecksum(FILE * firmware, const char * filePath) {
    fseek(firmware, 0x0, SEEK_SET);
    struct stat fileInfo;
    stat(filePath ,&fileInfo); // Loading informations about the file
    int checksum = 0;
    for (int c=0; c<fileInfo.st_size / 2; c++ ) {
        checksum += fgetc(firmware);
    }
    checksum = HexToDec(GetFileData(firmware, OFFSET_ROM_CHECKSUM, 1, 0),2) - checksum & 0xFF;
    char chkbyte = checksum;
    SetFileData(firmware, (unsigned char*)&chkbyte, OFFSET_ROM_CHECKSUM, 1);
}

void SaveExecutableBinaries(FILE * file, struct ATOM_BIOS * atomBios) {
    fseek(file, 0x0, SEEK_SET);
    for (int a=atomBios->mainTable.size+0x4; a<atomBios->offsetsTable[0].offset; a++) {
        fwrite(&atomBios->firmware.fileContent[a], sizeof(char), 0x1, file);
    }
}

void SaveUefiBinaries(FILE * file, struct ATOM_BIOS * atomBios) {
    fseek(file, 0x0, SEEK_SET);
    int uefiOffset = HexToDec(GetContentData(atomBios->firmware.fileContent, 65536 + 0x58, 0x2), 4);
    for (int a=65536; a<uefiOffset+65536+0x58; a++) {
        fwrite(&atomBios->firmware.fileContent[a], sizeof(char), 0x1, file);
    }
}

short VerifyFirmwareSize(struct stat fileInfo) {
    return (fileInfo.st_size < QUANTITY_64KB || fileInfo.st_size > QUANTITY_256KB ) ? 0 : 1;
}

short VerifyFirmwareSignature(FILE * file) {
    if ( strcmp(ATOM_BIOS_MAGIC, GetFileData(file, 0x0, 0x2, 0)) != 0) {
        return 0;
    } else {
        return 1;
    }
}

short VerifyFirmwareArchitecture(FILE * file) {
    if ( strcmp(ATOM_BIOS_ARCH_TERASCALE2, GetFileData(file, 0x2, 2, 0)) == 0 ) {
        return 1;
    } else if (strcmp(ATOM_BIOS_ARCH_CGN1, GetFileData(file, 0x2, 2, 0)) == 0 ) {
        return 2;
    } else if (strcmp(ATOM_BIOS_ARCH_CGN3, GetFileData(file, 0x2, 2, 0)) == 0 ) {
        return 3;
    } else if (strcmp(ATOM_BIOS_ARCH_CGN4, GetFileData(file, 0x2, 2, 0)) == 0 ) {
        return 4;
    } else {
        return 0;
    }
}

// checking checksum of the firmware
short VerifyChecksum(struct ATOM_BIOS * atomBios) {
    fseek(atomBios->firmware.file, 0x0, SEEK_SET);
    int chksum = 0;
    for (int c=0; c<atomBios->firmware.fileInfo.st_size / 2; c++ ) {
        chksum += fgetc(atomBios->firmware.file);
    }
    chksum = atomBios->mainTable.checksum - chksum & 0xFF;
    return (chksum == atomBios->mainTable.checksum);
}

short VerifySubSysCompany(struct ATOM_MAIN_TABLE * atomTable) {
    for (int a=0; a<12; a++) {
        if ( strcmp((char*)atomTable->subsystemVendorId, CompanyNames[a][0]) == 0 ) {
            return a;
        }
    }
    return 0;
}
