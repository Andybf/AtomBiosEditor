//
//  CoreFunctions.h
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 22/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#ifndef CoreFunctions_h
#define CoreFunctions_h

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

//Quantities
#define QUANTITY_COMMAND_TABLES 81
#define QUANTITY_DATA_TABLES    34
#define QUANTITY_TOTAL_TABLES   QUANTITY_DATA_TABLES + QUANTITY_COMMAND_TABLES

#define QUANTITY_64KB           65536
#define QUANTITY_128KB          131072
#define QUANTITY_256KB          263168

//ASCII codes
#define ASCII_DEC_CODE_0        48
#define ASCII_DEC_CODE_9        57
#define ASCII_DEC_CODE_A        65

//formatting
#define FORMAT_HEX                 "%02X"

// data type definitions
// an integer value between 0 and 65.535 (2 bytes of size)
typedef unsigned short ushort;
// an integer value between 0 and 255 (1 byte of size)
typedef unsigned char byte;

// Core Functions
unsigned char * BigToLittleEndian     (unsigned int num);
char          * GetContentData        (char * data, int initialOffset, ushort size);
char          * GetFileData           (FILE * file, int offset, int size, short endianness);
void            SetFileData           (FILE * fileOutput, unsigned char * data, ushort offset, ushort size);
ushort          GetNumBytesBeforeZero (FILE * file, ushort initialPos);
int             HexToDec              (char [], int );
unsigned char * DecToHex              (unsigned int result);
int             count                 (int num);

#endif
