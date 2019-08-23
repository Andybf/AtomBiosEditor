//
//  ViewController.m
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 18/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#import "ViewController.h"
#import "../Core/TableLoader.h"
#import "../Core/FileLoader.h"
#import "AtomTablesController.h"

extern int HexToDec(char[], int);

const char * CompanyNames[11][2] = {
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
                [self DisplayAlert: @"Invalid File Size!" : @"The size of the file selected is invalid, the file must be between 64KB and 256KB."];
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
    
    short vendor = VerifySubsystemCompanyName(atomTable,CompanyNames);
    char vendorstr[32];
    sprintf(vendorstr, "%s - %s",CompanyNames[vendor][1],(char *)atomTable.subsystemVendorId);
    [_labelVendId      setStringValue: [NSString stringWithUTF8String: vendorstr]];
    
    if (atomTable.uefiSupport != 0) {
        [_checkUefiSupport setState: NSControlStateValueOn];
        [_checkUefiSupport setTitle: @"Supported!"];
    } else {
        [_checkUefiSupport setState: NSControlStateValueOff];
        [_checkUefiSupport setTitle: @"Unsupported!"];
    }
    char chk[16];
    sprintf(chk, "Valid! - 0x%02X", atomTable.checksum);
    if ( VerifyChecksum(FW, atomTable) != 0) {
        [_checkChecksumStatus setState: NSControlStateValueOn];
        [_checkChecksumStatus setTitle: [NSString stringWithUTF8String: chk ] ];
    }
}

@end
