//
//  CoreFunctions.m
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 22/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#include "CoreFunctions.h"

ushort BtoL16(ushort num) {
    return (num>>8) | (num<<8);
}

unsigned char* decToHex(unsigned int result) {
    
    static unsigned char hex[9];
    unsigned int resto[8];
    
    for (int p=7; p>=0; p--) {
        resto[p] = (int) result % 16; //resto da divisão por 16
        result   = (int) result / 16; //dividido por 16
    }
    for (int c=7; c>=0; c--) {// este for tem que se repetir quatro vezes apenas.
        if (resto[c] < 10) {
            hex[c] = resto[c] + 48;
        } else {
            hex[c] = (resto[c]-10) + 65;
        }
    }
    return hex;
}

// Transforma um vetor de caracteres[4] com hexadecimais em um numero decimal
int HexToDec(char input[6],int quantHex) {
    int c, d, asciiCode, output = 0;
    d = 6-quantHex;
    for (c=0; c<6; c++) {
        asciiCode = input[c] > ASCII_DEC_CODE_9 ? 55 : ASCII_DEC_CODE_0;
        switch (d) {
            case 0:
                output += (input[c]-asciiCode) * 16 * 16 * 16 * 16 *16;
                break;
            case 1:
                output += (input[c]-asciiCode) * 16 * 16 * 16 * 16;
                break;
            case 2:
                output += (input[c]-asciiCode) * 16 * 16 * 16;
                break;
            case 3:
                output += (input[c]-asciiCode) * 16 * 16;
                break;
            case 4:
                output += (input[c]-asciiCode) * 16;
                break;
            case 5:
                output += (input[c]-asciiCode) * 1;
                break;
        }
        d++;
    }
    return output;
}

// Extrai uma quantidade específica de bytes em um arquivo. Suporta Little e Big Endian
char * GetFileData(FILE * file, int posInicial, int quantBytes, short endianness) {
    char * formated_output = (char *) malloc(quantBytes * sizeof(char*));
    if (endianness == 0) { // Little Endian
        fseek(file, posInicial+(quantBytes-1), SEEK_SET);
        for (int c=0; c<quantBytes*2; c+=2){
            sprintf((char*)&formated_output[c], FORMAT_HEX, fgetc(file));
            fseek(file, ftell(file)-2, SEEK_SET);
        }
    } else if (endianness == 1) { // Big Endian
        fseek(file, posInicial, SEEK_SET);
        for (int c=0; c<quantBytes; c++){
            sprintf((char*)&formated_output[c], "%c", fgetc(file));
        }
    } else {
        exit(1);
    }
    return formated_output;
}

void SetFile16bitValue(FILE * fileOutput, ushort data, ushort offset, ushort size) {
    unsigned char * byte = malloc(sizeof(unsigned char *)*size);
    int step = 8-(size*2);
    for (short a=0; a<size; a++) {
        byte[a] = strtol( substr((char*)decToHex(data), step, 2) ,NULL,16) & 0xFF;
        step += 2;
    }
    fseek(fileOutput, offset, SEEK_SET);
    fwrite(byte, sizeof(ushort), 1, fileOutput);
}

void SetFile8bitValue(FILE * fileOutput, char * data, ushort offset, ushort size) {
    fseek(fileOutput, offset, SEEK_SET);
    fwrite(data, sizeof(char), size, fileOutput);
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

char * substr(char *string, int position, int size) {
    char *substring = (char*)malloc(size);
    int a=0, b=0;
    while(string[b]!='\0') {
        if ( b >= position && a < size ) {
            substring[a] = string[b];
            a++;
        }
        b++;
    }
    substring[a] = '\0';
    return substring;
}
