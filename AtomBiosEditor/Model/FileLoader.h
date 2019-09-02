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

#include "CoreFunctions.h"


// Estruturas da dados auxiliares
struct FIRMWARE_FILE {
    FILE * file;
    char * pathName;
    struct stat fileInfo;
    ushort archType;
};

//Definicção de funcoes
short CheckFirmwareSize(struct stat);
short CheckFirmwareSignature(FILE *);
short CheckFirmwareArchitecture(FILE *);

#endif /* Loader_h */
