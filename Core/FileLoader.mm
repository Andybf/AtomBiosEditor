//
//  Loader.m
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 18/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#import "FileLoader.h"
#import "Library/ABELibrary.h"
#import "../Controller/WindowController.h"


@implementation FileLoader {
    struct FIRMWARE_FILE FW;
}

- (NSString *)InitLoader {
    //Criando objeto NSOpenPanel
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    //Configuração
    openPanel.allowsMultipleSelection = false;
    openPanel.canChooseDirectories = false;
    openPanel.canChooseFiles = true;
    
    //Instanciando o painel
    if ([openPanel runModal] == NSModalResponseOK) {
        self->FW.pathName = openPanel.URL.path;
        if (!(self->FW.file = fopen((const char*)[self->FW.pathName UTF8String],"r"))) { //carregando o arquivo para dentro da memoria
            DisplayAlert(@"File not found!",@"Please check if the file exists in the path.");
        } else {
            //Carregando informações sobre o arquivo
            stat([FW.pathName UTF8String],&FW.fileInfo);
            printf("Info: File loadded!\n");
        }
    }
    return FW.pathName;
}

- (BOOL)CheckFirmwareSize {
    //Verificando tamanho do arquivo
    if (FW.fileInfo.st_size < QUANTITY_64KB || FW.fileInfo.st_size > QUANTITY_256KB) {
        DisplayAlert(@"Invalid File Size!",@"The firmware file size is invalid, only files betweeen 64KB and 256KB are supported.");
        return NO;
    } else {
        printf("Info: Size:  %lli bytes\n",FW.fileInfo.st_size);
        return YES;
    }
}

- (BOOL)CheckFirmwareSignature {
    //Verificando validade do firmware
    if (strcmp(STATIC_ROM_MAGIC_NUMBER, GetFileData(FW.file, 0x0, 0x2, 0)) != 0) {
        DisplayAlert(@"Invalid Firmware Signature!",@"The firmware signature indicates that the file file is corrupted or another kind of binary data.");
        return NO;
    } else {
        return YES;
    };
}

- (BOOL)CheckFirmwareArchitecture {
    printf("Info: Architecture:  ");
    if (strcmp(STATIC_ROM_ARCH_TERASCALE2,GetFileData(FW.file, 0x2, 2, 0)) == 0 ) {
        printf("TeraScale 2\n       Warning:  Architecture is not supported!\n");
        return YES;
    } else if (strcmp(STATIC_ROM_ARCH_CGN1,GetFileData(FW.file, 0x2, 2, 0)) == 0 ) {
        printf("CGN 1.0 - 2.0\n");
        return YES;
    } else if (strcmp(STATIC_ROM_ARCH_CGN3,GetFileData(FW.file, 0x2, 2, 0)) == 0 ) {
        printf("CGN 3.0\n");
        return YES;
    } else if (strcmp(STATIC_ROM_ARCH_CGN4,GetFileData(FW.file, 0x2, 2, 0)) == 0 ) {
        printf("CGN 4.0\n       Warning:  Architecture is not supported!\n");
        return YES;
    } else {
        printf("\n");
        DisplayAlert(@"Architecture not supported!",@"This firmware architecture is not support by this program.");
        return NO;
    }
    return NO;
}


//Metodos Acessores
- (FILE *)getFile {
    return FW.file;
}

- (NSString*)getFileName {
    return FW.pathName;
}

@end


int DisplayAlert(NSString * title, NSString * info) {
    //Craindo um alerta
    NSAlert * alert = [NSAlert new];
    //Configuração
    alert.messageText = title;
    alert.informativeText = info;
    alert.alertStyle = NSAlertStyleCritical;
    //Instanciando
    [alert runModal];
    return 0;
}

