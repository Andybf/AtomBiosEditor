//
//  AtomBios.c
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 22/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#include "AtomBios.h"

const char * CompanyNames[11][2] = {
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

//Carrega as informações do firmware na memória. Necessário para fazer as demais operações no programa
struct ATOM_MAIN_TABLE loadMainTable(struct ATOM_BIOS * atomBios) {
    struct ATOM_MAIN_TABLE mainTable;
           //propriedade                                          arquivo               endereço inicial            bytes | Endian | hexbytes
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
    if( strcmp(GetFileData(atomBios->firmware.file, QUANTITY_64KB, 0x2, 0), ATOM_ROM_MAGIC) == 0 ) {
        mainTable.uefiSupport = 1;
    } else {
        mainTable.uefiSupport = 0;
    }
    return mainTable;
}

// Carrega a tabela onde se localiza os endereços das data e command tables
void loadOffsetsTable (struct ATOM_BIOS * atomBios) {
    int step = 0;
    for (int a=0; a<2; a++) { // 0 = CMMD | 1 = DATA
        if (a == 0) { step = 0x1e; } else { step += 2;} //     |         arquivo       |           endereço inicial              |  bytes  | Endianness | hexQuant
        atomBios->offsetsTable[a].offset = HexToDec(GetFileData(atomBios->firmware.file, atomBios->mainTable.romInfoOffset + step,    2,        0),          4);
        atomBios->offsetsTable[a].size   = HexToDec(GetFileData(atomBios->firmware.file, atomBios->offsetsTable[a].offset,            2,        0),          4);
    }
}

// Carrega na memória as datas e command tables
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
        atomBios->dataAndCmmdTables[b].name       = (char *) malloc(sizeof(char*) * sizeof(tableNames[b]));
        strcpy( atomBios->dataAndCmmdTables[b].name, tableNames[b]);
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

//substitui a tabela indicado por outra em um arquivo binario .bin
void ReplaceTable ( struct ATOM_DATA_AND_CMMD_TABLES * dataAndCmmdTables, ushort index, const char * tablePath) {
    FILE * tableBin;
    if ( !(tableBin = fopen(tablePath, "r")) ) {
        exit(1);
    } //Carregando o arquivo binário referenciado pelo usuario e colocando em um buffer
    struct stat tableFileInfo;
    stat(tablePath,&tableFileInfo);
    char * tableChar = malloc(sizeof(char*) * tableFileInfo.st_size);
    tableChar = GetFileData(tableBin, 0x0, (int)tableFileInfo.st_size, 1);
    
    if (tableFileInfo.st_size == dataAndCmmdTables[index].size ){
        strcpy(dataAndCmmdTables[index].content, tableChar);
    }
    else if (tableFileInfo.st_size <dataAndCmmdTables[index].size) {
        strcpy(dataAndCmmdTables[index].content, tableChar);
        ushort writingPoint = tableFileInfo.st_size + 1;
        for (int a=0; a<dataAndCmmdTables[index].size - (int)tableFileInfo.st_size; a++) {
            dataAndCmmdTables[index].content[writingPoint] = '\0';
            writingPoint++;
        }
    }
    else if (tableFileInfo.st_size > dataAndCmmdTables[index].size) {
//        abstractTable->size    = tableFileInfo.st_size;
//        abstractTable->content = realloc(abstractTable->content, abstractTable->size);
//        abstractTable->content = GetFileData(tableBin, 0, (int)tableFileInfo.st_size, 1);
//        short diff = (unsigned short)tableFileInfo.st_size - abstractTable->size;
//
//        for (int a=1; a<QUANTITY_TOTAL_TABLES; a++) { // Calculando a diferença no offset das tabelas seguintes
//            if (atomTable->atomTables[a].offset - atomTable->atomTables[a-1].offset+atomTable->atomTables[a-1].size < 0) {
//                atomTable->atomTables[a].offset += diff;
//            }
//        }
//        for (int a=1; a<QUANTITY_TOTAL_TABLES; a++) {
//            printf("%c", atomTable->atomTables[a].offset  );
//            //fprintf ( newBios, "%c", atomTable->atomTables[a].offset );
//            //fwrite(atomTable->atomTables[a].offset, sizeof(char), 0x2, newBios);
//            //atomTable->tblOffsets[1]->offset = atomTable->atomTables[a].offset;
//            // Falta mudar as tabelas com enedreços das tables
//        }
//
//        // e finalmente gravar tudo na nova bios
    }
    free(tableChar);
    fclose(tableBin);
    //FixChecksum(newBiosPath, FW->fileInfo.st_size , atomTable );
}

void SaveAtomBiosData(struct ATOM_BIOS * atomBios, FILE * firmware) {
    fwrite(GetFileData(atomBios->firmware.file, 0x0, (int)atomBios->firmware.fileInfo.st_size, 1), sizeof(char), atomBios->firmware.fileInfo.st_size, firmware);
    
    SetFile8bitValue(firmware, atomBios->mainTable.romMessage,     atomBios->mainTable.romMsgOffset+0x2, 58);
    SetFile8bitValue(firmware, atomBios->mainTable.partNumber,     atomBios->mainTable.partNumberOffset, atomBios->mainTable.partNumSize);
    SetFile8bitValue(firmware, atomBios->mainTable.architecture,   atomBios->mainTable.archOffset,       atomBios->mainTable.archSize);
    SetFile8bitValue(firmware, atomBios->mainTable.connectionType, atomBios->mainTable.conTypeOffset,    atomBios->mainTable.conTypeSize);
    SetFile8bitValue(firmware, atomBios->mainTable.memoryGen,      atomBios->mainTable.memGenOffset,     atomBios->mainTable.memGenSize);
    SetFile8bitValue(firmware, atomBios->mainTable.compTime,       OFFSET_COMPILATION_TIME,              14);
    SetFile8bitValue(firmware, atomBios->mainTable.biosVersion,    atomBios->mainTable.romMsgOffset +0x95, 22);
}

void SaveChecksum(FILE * firmware, const char * filePath) {
    fseek(firmware, 0x0, SEEK_SET);
    struct stat fileInfo;
    stat(filePath ,&fileInfo); //Carregando informações sobre o arquivo
    int checksum = 0;
    for (int c=0; c<fileInfo.st_size / 2; c++ ) {
        checksum += fgetc(firmware);
    }
    checksum = HexToDec(GetFileData(firmware, OFFSET_ROM_CHECKSUM, 1, 0),2) - checksum & 0xFF;
    char chkbyte = checksum;
    SetFile8bitValue(firmware, &chkbyte, OFFSET_ROM_CHECKSUM, 1);
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

// Vefirica o checksum do firmware
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
    for (int a=0; a<11; a++) {
        if ( strcmp((char*)atomTable->subsystemVendorId, CompanyNames[a][0]) == 0 ) {
            return a;
        }
    }
    return -1;
}
