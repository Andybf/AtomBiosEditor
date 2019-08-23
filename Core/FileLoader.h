//
//  Loader.h
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 18/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#ifndef Loader_h
#define Loader_h

#include <stdio.h>
#include <sys/stat.h>

#include "ABELibrary.h"

// Estruturas da dados auxiliares
struct FIRMWARE_FILE {
    FILE * file;
    const char * pathName;
    struct stat fileInfo;
};

//Definicção de métodos
//Métodos Ações
short CheckFirmwareSize(struct stat);
short CheckFirmwareSignature(FILE *);
short CheckFirmwareArchitecture(FILE *);


//Métodos Acessores
struct FIRMWARE_FILE getFirmwareStruct(void);
FILE * getFile(void);
const char* getFileName(void);

#endif /* Loader_h */
