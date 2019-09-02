//
//  MainTableLoader.m
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 22/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#include "TableLoader.h"

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

//Carrega as informações do firmware na memória. Necessário para fazer as demais operações no programa
struct ATOM_BASE_TABLE loadMainTable(struct FIRMWARE_FILE FW) {
    struct ATOM_BASE_TABLE atomTable;
    //propriedade                                          arquivo      endereço inicial            quant bytes        Endianness
    atomTable.size           = HexToDec(GetFileData(FW.file, OFFSET_ROM_BASE_TABLE,           2,              0),4);
    atomTable.checksum       = HexToDec(GetFileData(FW.file, OFFSET_ROM_CHECKSUM,             1,              0),2);
    atomTable.romInfoOffset  = HexToDec(GetFileData(FW.file, OFFSET_ROM_INFO,                 2,              0),4);
    atomTable.romMsgOffset   = HexToDec(GetFileData(FW.file, atomTable.romInfoOffset+0x10,    2,              0),4);
    strcpy(atomTable.romMessage,               GetFileData(FW.file, atomTable.romMsgOffset +0x2,     58,             1));
    strcpy(atomTable.partNumber,               GetFileData(FW.file, HexToDec(GetFileData(FW.file,OFFSET_STR_START,1,0),2), 39, 1));
    strcpy(atomTable.biosVersion,              GetFileData(FW.file, atomTable.romMsgOffset +0x95,    22,             1));
    strcpy(atomTable.compTime,                 GetFileData(FW.file, OFFSET_COMPILATION_TIME,         14,             1));
    strcpy((char*)atomTable.subsystemId,       GetFileData(FW.file, atomTable.romInfoOffset+0x1A,    2,              0));
    strcpy((char*)atomTable.subsystemVendorId, GetFileData(FW.file, atomTable.romInfoOffset+0x18,    2,              0));
    strcpy((char*)atomTable.deviceId,          GetFileData(FW.file, atomTable.romInfoOffset+0x28,    4,              0));
    
    //Checking Architecture
    if (FW.archType == 1) {
        strcpy(atomTable.architecture, "TERASCALE 2");
    } else if (FW.archType == 2) {
        strcpy(atomTable.architecture, "CGN 1.0/2.0");
    } else if (FW.archType == 3) {
        strcpy(atomTable.architecture, "CGN 3.0");
    } else if (FW.archType == 4) {
        strcpy(atomTable.architecture, "CGN 4.0");
    } else {
        exit(8);
    }
    
    // Checking UEFI Support
    if( strcmp(GetFileData(FW.file, QUANTITY_64KB, 0x2, 0), STATIC_ROM_MAGIC_NUMBER) == 0 ) {
        atomTable.uefiSupport = 1;
    } else {
        atomTable.uefiSupport = 0;
    }
    loadOffsetsTable(     FW, &atomTable);
    loadCmmdAndDataTables(FW, &atomTable);
    return atomTable;
}

// Carrega a tabela onde se localiza os endereços das data e command tables
void loadOffsetsTable (struct FIRMWARE_FILE FW, struct ATOM_BASE_TABLE * atomTable) {
    int step = 0;
    for (int a=0; a<2; a++) { // 0 = CMMD | 1 = DATA
        if (a == 0) { step = 0x1e; } else { step += 2;} //         arquivo      endereço inicial            bytes | Endianness
        atomTable->tblOffsets[a].offset     = HexToDec(GetFileData(FW.file, atomTable->romInfoOffset+step,    2,       0),     4);
        atomTable->tblOffsets[a].size       = HexToDec(GetFileData(FW.file, atomTable->tblOffsets[a].offset,  2,       0),     4);
    }
}

// Carrega na memória as datas e command tables
void loadCmmdAndDataTables (struct FIRMWARE_FILE FW, struct ATOM_BASE_TABLE * atomTable) {
    long posOffTbl = 0;
    int c=0;
    fseek(FW.file, atomTable->tblOffsets[0].offset+4, SEEK_SET);
    for (int b=0; b<QUANTITY_TOTAL_TABLES; b++) {
        if (c >= QUANTITY_COMMAND_TABLES) {
            c = b-QUANTITY_COMMAND_TABLES;
            fseek(FW.file, atomTable->tblOffsets[1].offset+4, SEEK_SET);
        }
        posOffTbl = ftell(FW.file);
        atomTable->atomTables[b].id = c;
        atomTable->atomTables[b].name       = (char *) malloc(sizeof(char*) * sizeof(tableNames[b]));
        strcpy( atomTable->atomTables[b].name, tableNames[b]);
        atomTable->atomTables[b].offset     = HexToDec(GetFileData(FW.file, (int) ftell(FW.file),  2,  0),4);
        
        atomTable->atomTables[b].size = 0;
        strcpy((char*)atomTable->atomTables[b].formatRev,"  ");
        strcpy((char*)atomTable->atomTables[b].contentRev,"  ");
        atomTable->atomTables[b].content = NULL;
        
        if (atomTable->atomTables[b].offset > 30000 ) {
            atomTable->atomTables[b].size                     = HexToDec(GetFileData(FW.file, atomTable->atomTables[b].offset,  2,    0),4);
            strcpy((char*)atomTable->atomTables[b].formatRev,            GetFileData(FW.file, atomTable->atomTables[b].offset+2,1,    0));
            strcpy((char*)atomTable->atomTables[b].contentRev,           GetFileData(FW.file, atomTable->atomTables[b].offset+3,1,    0));
            atomTable->atomTables[b].content = (char*)malloc(sizeof(char *) * atomTable->atomTables[b].size);
            atomTable->atomTables[b].content = GetFileData(FW.file, atomTable->atomTables[b].offset, atomTable->atomTables[b].size, 1);
        }
        c++;
        fseek(  FW.file, posOffTbl+2, SEEK_SET);
    }
}

// Vefirica o checksum do firmware
short VerifyChecksum(struct FIRMWARE_FILE FW, struct ATOM_BASE_TABLE atomTable) {
    fseek(FW.file, 0x0, SEEK_SET);
    int chksum = 0;
    for (int c=0; c<FW.fileInfo.st_size / 2; c++ ) {
        chksum += fgetc(FW.file);
    }
    chksum = atomTable.checksum - chksum & 0xFF;
    if (chksum == atomTable.checksum){
        return 1;
    } else {
        return 0;
    }
}

short VerifySubsystemCompanyName(struct ATOM_BASE_TABLE atomTable, char * CompanyNames[11][2]) {
    for (int a=0; a<11; a++) {
        if ( strcmp((char*)atomTable.subsystemVendorId, CompanyNames[a][0]) == 0 ) {
            return a;
        }
    }
    return -1;
}

// Extrai a table selecionada pelo usuário e coloca em um arquivo binário.
void ExtractTable(FILE * firmware, struct ATOM_ABSTRACT_TABLE abstractTable, const char * extractedTableFilePath) {
    //Criando arquivo binario contendo a tabela
    FILE * output = fopen(extractedTableFilePath, "wb");
    fwrite( abstractTable.content, sizeof(char), abstractTable.size, output );
    fclose(output);
}

//substitui a tabela indicado por outra em um arquivo binario .bin
void ReplaceTable (struct FIRMWARE_FILE * FW, struct ATOM_BASE_TABLE * atomTable, ushort index, const char * tablePath) {
    FILE * tableBin;
    if ( !(tableBin = fopen(tablePath, "r")) ) {
        printf(" Error: Table not found! '%s'\n",tablePath);
        exit(1);
    } //Carregando o arquivo binário referenciado pelo usuario e colocando em um buffer
    struct stat tableFileInfo;
    stat(tablePath,&tableFileInfo);
    char * tableChar = malloc(sizeof(char*) * tableFileInfo.st_size);
    tableChar = GetFileData(tableBin, 0x0, (int)tableFileInfo.st_size, 1);
    
    if (tableFileInfo.st_size == atomTable->atomTables[index].size ){
        strcpy(atomTable->atomTables[index].content, tableChar);
    }
    else if (tableFileInfo.st_size < atomTable->atomTables[index].size) {
        strcpy(atomTable->atomTables[index].content, tableChar);
        ushort writingPoint = tableFileInfo.st_size + 1;
        for (int a=0; a<atomTable->atomTables[index].size - (int)tableFileInfo.st_size; a++) {
            atomTable->atomTables[index].content[writingPoint] = '\0';
            writingPoint++;
        }
    }
    else if (tableFileInfo.st_size > atomTable->atomTables[index].size) {
        printf("Error: Under Construction\n");
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
    //FixChecksum(newBiosPath, FW->fileInfo.st_size , atomTable );
}
