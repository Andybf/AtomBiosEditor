//
//  Loader.m
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 18/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#include "FileLoader.h"

struct FIRMWARE_FILE FW;

//Verificando tamanho do arquivo
short CheckFirmwareSize(struct stat fileInfo) {
    if (fileInfo.st_size < QUANTITY_64KB || fileInfo.st_size > QUANTITY_256KB) {
        return 0;
    } else {
        return 1;
    }
}

//Verificando validade do firmware
short CheckFirmwareSignature(FILE * file) {
    if (strcmp(STATIC_ROM_MAGIC_NUMBER, GetFileData(file, 0x0, 0x2, 0)) != 0) {
        return 0;
    } else {
        return 1;
    };
}

short CheckFirmwareArchitecture(FILE * file) {
    if (strcmp(STATIC_ROM_ARCH_TERASCALE2,GetFileData(file, 0x2, 2, 0)) == 0 ) {
        return 1;
    } else if (strcmp(STATIC_ROM_ARCH_CGN1,GetFileData(file, 0x2, 2, 0)) == 0 ) {
        return 2;
    } else if (strcmp(STATIC_ROM_ARCH_CGN3,GetFileData(file, 0x2, 2, 0)) == 0 ) {
        return 3;
    } else if (strcmp(STATIC_ROM_ARCH_CGN4,GetFileData(file, 0x2, 2, 0)) == 0 ) {
        return 4;
    } else {
        return 0;
    }
    return 0;
}

