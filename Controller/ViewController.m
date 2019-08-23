//
//  ViewController.m
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 18/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#import "ViewController.h"
#import "TableOverviewController.h"
#import "../Core/TableLoader.h"
#import "../Core/FileLoader.h"

extern TableOverviewController * tbloverview;
extern int HexToDec(char[], int);

@implementation ViewController {
    struct ATOM_BASE_TABLE atomTable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    // Update the view, if already loaded.
}


- (IBAction)btnOpenFileTriggered: (id)sender {
    //Criando objeto NSOpenPanel
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    //Configuração
    openPanel.allowsMultipleSelection = false;
    openPanel.canChooseDirectories = false;
    openPanel.canChooseFiles = true;
    
    //Instanciando o painel
    if ([openPanel runModal] == NSModalResponseOK) {
        struct FIRMWARE_FILE FW;
        FW.pathName = [openPanel.URL.path UTF8String];
        //carregando o arquivo para dentro da memoria
        if (! (FW.file = fopen(FW.pathName ,"r")) ) {
            [self DisplayAlert : @"File not found!" : @"Please check if the file exists in the path."];
        } else {
            //Carregando informações sobre o arquivo
            stat(FW.pathName ,&FW.fileInfo);
            printf("Info: File loadded: %s\n",FW.pathName);
            
            if (! CheckFirmwareSize(FW.fileInfo) ) {
                exit(1);
            }
            if (! CheckFirmwareSignature(FW.file) ) {
                [self DisplayAlert : @"Invalid Firmware Signature!" : @"The firmware signature indicates that the file file is corrupted or another kind of binary data."];
                exit(2);
            }
            if (! CheckFirmwareArchitecture(FW.file)) {
                [self DisplayAlert : @"Architecture not supported!" : @"This firmware architecture is not support by this program."];
                exit(3);
            }
        }
        [self initOverviewInfo : FW];
    }
}

- (void) DisplayAlert : (NSString *) title : (NSString *) info  {
    //Craindo um alerta
    NSAlert * alert = [NSAlert new];
    //Configuração
    alert.messageText = title;
    alert.informativeText = info;
    alert.alertStyle = NSAlertStyleCritical;
    //Instanciando
    [alert runModal];
}

- (void) initOverviewInfo: (struct FIRMWARE_FILE)FW {
    printf("Info: Method InitOverviewInfo Triggered!\n");
    
    //carregando o conteúdo do firmware na memória
    struct ATOM_BASE_TABLE atomTable;
    atomTable = loadMainTable(FW);
     
    [_labelFilePath setStringValue: [NSString stringWithUTF8String: FW.pathName]];
    
    [_labelRomMsg      setStringValue: [NSString stringWithUTF8String: atomTable.romMessage]];
    [_labelPartNumber  setStringValue: [NSString stringWithUTF8String: atomTable.partNumber]];
    [_labelCompDate    setStringValue: [NSString stringWithUTF8String: atomTable.compTime]];
    [_labelBiosVersion setStringValue: [NSString stringWithUTF8String: atomTable.biosVersion]];
    [_labelDevId       setStringValue: [NSString stringWithUTF8String: (char *)atomTable.deviceId]];
    [_labelSubId       setStringValue: [NSString stringWithUTF8String: (char *)atomTable.subsystemId]];
    [_labelVendId      setStringValue: [NSString stringWithUTF8String: (char *)atomTable.subsystemVendorId]];
    
}
/*
char * InitLoader() {
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
*/
@end
