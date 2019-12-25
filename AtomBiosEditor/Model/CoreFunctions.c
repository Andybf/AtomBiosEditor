//
//  CoreFunctions.m
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 22/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#include "CoreFunctions.h"

unsigned char * BigToLittleEndian(unsigned int num) {
    short size = 0;
    // checking the size in bytes that the number occupies
    if (num < 256) {
        size = 0x1;
    } else if (num < 65536) {
        size = 0x2;
    } else if (num < 16777215) {
        size = 0x3;
    } else {
        size = 0x4;
    }
    // filling the array in the little endian way
    unsigned char * data = malloc(sizeof(char*) * size);
    if (size == 0x1) {
        data[0] = (num & 0x0000ff)>>0;
    } else if (size == 0x2) {
        data[0] = (num & 0x0000ff)>>0;
        data[1] = (num & 0x00ff00)>>8;
    } else if (size == 0x3) {
        data[0] = (num & 0x0000ff)>>0;
        data[1] = (num & 0x00ff00)>>8;
        data[2] = (num & 0xff0000)>>16;
    } else if (size == 0x4) {
        data[0] = (num & 0x000000ff)>>0;
        data[1] = (num & 0x0000ff00)>>8;
        data[2] = (num & 0x00ff0000)>>16;
        data[3] = (num & 0xff000000)>>24;
    }
    return data;
}

unsigned char* DecToHex(unsigned int result) {
    static unsigned char hex[9];
    unsigned int resto[8];
    for (int p=7; p>=0; p--) {
        resto[p] = (int) result % 16;
        result   = (int) result / 16;
    }
    for (int c=7; c>=0; c--) {
        if (resto[c] < 10) {
            hex[c] = resto[c] + 48;
        } else {
            hex[c] = (resto[c]-10) + 65;
        }
    }
    return hex;
}

// Transforma um vetor de caracteres[4] com hexadecimais em um numero decimal
int HexToDec(char input[8],int quantHex) {
    int c, d, asciiCode;
    unsigned int output = 0;
    d = 8-quantHex;
    for (c=0; c<8; c++) {
        asciiCode = input[c] > ASCII_DEC_CODE_9 ? 55 : ASCII_DEC_CODE_0;
        switch (d) {
            case 0:
                output += (input[c]-asciiCode) * 16 * 16 * 16 * 16 *16 *16 *16;
                break;
            case 1:
                output += (input[c]-asciiCode) * 16 * 16 * 16 * 16 *16 *16;
                break;
            case 2:
                output += (input[c]-asciiCode) * 16 * 16 * 16 * 16 *16;
                break;
            case 3:
                output += (input[c]-asciiCode) * 16 * 16 * 16 * 16;
                break;
            case 4:
                output += (input[c]-asciiCode) * 16 * 16 * 16;
                break;
            case 5:
                output += (input[c]-asciiCode) * 16 * 16;
                break;
            case 6:
                output += (input[c]-asciiCode) * 16;
                break;
            case 7:
                output += (input[c]-asciiCode) * 1;
                break;
        }
        d++;
    }
    return output;
}

// Works like a substring function, returns un hex array in string format
char * GetContentData(char * data, ushort initialOffset, ushort size) {
    char * value = (char*)calloc( sizeof(char*), size*2 );
    int step = size-1;
    for (int position=0; position<size*2; position+=2) {
        sprintf((char*)&value[position], "%02X", data[initialOffset+step] & 0xFF);
        step -= 1;
    }
    return value;
}

// Extract a specific size of bytes form the file with the given offset
char * GetFileData(FILE * file, int offset, int size, short endianness) {
    char * formated_output = (char *) malloc(size * sizeof(char*));
    if (endianness == 0) { // Little Endian
        fseek(file, offset+(size-1), SEEK_SET);
        for (int c=0; c<size*2; c+=2){
            sprintf((char*)&formated_output[c], FORMAT_HEX, fgetc(file));
            fseek(file, ftell(file)-2, SEEK_SET);
        }
    } else if (endianness == 1) { // Big Endian
        fseek(file, offset, SEEK_SET);
        for (int c=0; c<size; c++){
            sprintf((char*)&formated_output[c], "%c", fgetc(file));
        }
    } else {
        exit(1);
    }
    return formated_output;
}

void SetFileData(FILE * file, unsigned char * data, ushort offset, ushort size) {
    fseek(file, offset, SEEK_SET);
    fwrite(data, sizeof(char), size, file);
}

ushort GetNumBytesBeforeZero(FILE * file, ushort initialPos) {
    ushort bytes = 0;
    fseek(file, initialPos, SEEK_SET);
    while (fgetc(file) != '\0') {
        bytes++;
    }
    return bytes;
}

//count the number of digits in a int variable
int count(int num){
    int contagem = 0;
    while(num != 0){
        contagem++;
        num /= 10;
    }
    return contagem;
}
