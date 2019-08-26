//
//  ABELibrary.h
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 22/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#ifndef ABELibrary_h
#define ABELibrary_h

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//quantidades
#define QUANTITY_COMMAND_TABLES 81
#define QUANTITY_DATA_TABLES    34
#define QUANTITY_TOTAL_TABLES   QUANTITY_DATA_TABLES + QUANTITY_COMMAND_TABLES
#define QUANTITY_64KB           65536
#define QUANTITY_128KB          131072
#define QUANTITY_256KB          263168

//Códigos ASCII
#define ASCII_DEC_CODE_0        48
#define ASCII_DEC_CODE_9        57
#define ASCII_DEC_CODE_A        65

//Informações Estáticas
#define STATIC_ROM_MAGIC_NUMBER    "AA55"
#define STATIC_ROM_ARCH_TERASCALE2 "E97E"
#define STATIC_ROM_ARCH_CGN1       "E980"
#define STATIC_ROM_ARCH_CGN3       "E977"
#define STATIC_ROM_ARCH_CGN4       "E974"
#define STATIC_ROM_MESSAGE_BEGIN   "000D0A"
#define STATIC_ROM_SIGNATURE       "373631323935353230"  //761295520
#define STATIC_ROM_TYPE            "41544F4D"            //ATOM

//Formatações
#define FORMAT_HEX                 "%02X"

// Core Functions
char   *                  GetFileData       (FILE * , int , int , short );
int                       HexToDec          (char [], int );

#endif /* ABELibrary_h */
