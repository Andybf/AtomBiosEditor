//
//  ABELibrary.m
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 22/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#include "ABELibrary.h"

char * CompanyNames[11][2] = {
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
char * GetFileData(FILE * firmware, int posInicial, int quantBytes, short endianness) {
    char * formated_output = (char *) malloc(quantBytes * sizeof(char*));
    if (endianness == 0) { // Little Endian
        //posiciona o ponteiro do arquivo no final
        fseek(firmware, posInicial+(quantBytes-1), SEEK_SET);
        for (int c=0; c<quantBytes*2; c+=2){
            sprintf((char*)&formated_output[c], FORMAT_HEX, fgetc(firmware));
            fseek(firmware, ftell(firmware)-2, SEEK_SET);
        }
    } else if (endianness == 1) { // Big Endian
        //posiciona o ponteiro do arquivo no começo
        fseek(firmware, posInicial, SEEK_SET);
        for (int c=0; c<quantBytes; c++){
            sprintf((char*)&formated_output[c], "%c", fgetc(firmware));
        }
    } else {
        exit(1);
    }
    return formated_output;
}


