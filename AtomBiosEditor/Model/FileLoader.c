//
//  Loader.m
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 18/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#include "FileLoader.h"

struct FIRMWARE_FILE FW;

short CheckFirmwareSize(struct stat fileInfo) {
    //Verificando tamanho do arquivo
    if (fileInfo.st_size < QUANTITY_64KB || fileInfo.st_size > QUANTITY_256KB) {
        //DisplayAlert(@"Invalid File Size!",@"The firmware file size is invalid, only files betweeen 64KB and 256KB are supported.");
        return 0;
    } else {
        printf("Info: Size:  %lli bytes\n",fileInfo.st_size);
        return 1;
    }
}

short CheckFirmwareSignature(FILE * file) {
    //Verificando validade do firmware
    if (strcmp(STATIC_ROM_MAGIC_NUMBER, GetFileData(file, 0x0, 0x2, 0)) != 0) {
        return 0;
    } else {
        return 1;
    };
}

short CheckFirmwareArchitecture(FILE * file) {
    printf("Info: Architecture:  ");
    FW.architecture = malloc(sizeof(char*) * 8);
    if (strcmp(STATIC_ROM_ARCH_TERASCALE2,GetFileData(file, 0x2, 2, 0)) == 0 ) {
        strcpy(FW.architecture, "TERASCALE 2");
        printf("TeraScale 2\n       Warning:  Architecture is not supported!\n");
        return 1;
    } else if (strcmp(STATIC_ROM_ARCH_CGN1,GetFileData(file, 0x2, 2, 0)) == 0 ) {
        printf("CGN 1.0 - 2.0\n");
        strcpy(FW.architecture, "CGN 1.0/2.0");
        return 1;
    } else if (strcmp(STATIC_ROM_ARCH_CGN3,GetFileData(file, 0x2, 2, 0)) == 0 ) {
        printf("CGN 3.0\n");
        strcpy(FW.architecture, "CGN 3.0");
        return 1;
    } else if (strcmp(STATIC_ROM_ARCH_CGN4,GetFileData(file, 0x2, 2, 0)) == 0 ) {
        printf("CGN 4.0\n       Warning:  Architecture is not supported!\n");
        strcpy(FW.architecture, "CGN 4.0");
        return 1;
    } else {
        printf("\n");
        return 0;
    }
    return 0;
}


//Metodos Acessores
struct FIRMWARE_FILE getFirmwareStruct() {
    return FW;
}

FILE * getFile() {
    return FW.file;
}

const char* getFileName() {
    return FW.pathName;
}

