//
//  ViewController.m
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 28/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#import "ViewController.h"
#import "../Model/TableLoader.h"

#import "OverviewController.h"
#import "TablesController.h"
#import "PowerPlayController.h"
#import "OverDriveController.h"

@implementation ViewController {
    struct FIRMWARE_FILE FW;
    
    OverviewController * oc;
    TablesController * tc;
    PowerPlayController * ppc;
    OverDriveController * ovdc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    oc = [[OverviewController alloc] initWithNibName:@"Overview" bundle:NULL];
    [[self containerOverview]  addSubview: self->oc.view];
    
    tc = [[TablesController alloc] initWithNibName: @"Tables" bundle: NULL];
    [[self containerTables]    addSubview: self->tc.view];
    
    ppc = [[PowerPlayController alloc] initWithNibName: @"PowerPlay" bundle: NULL];
    [[self containerPowerPlay] addSubview: self->ppc.view];
    
    ovdc = [[OverDriveController alloc] initWithNibName: @"OverDrive" bundle: NULL];
    [[self containerOverDrive] addSubview: self->ovdc.view];
}


- (IBAction)buttonOpenFileTriggered:(id)sender {
    NSOpenPanel* openPanel = [NSOpenPanel openPanel]; //Criando objeto NSOpenPanel
    //Configuração
    openPanel.allowsMultipleSelection = false;
    openPanel.canChooseDirectories    = false;
    openPanel.canChooseFiles          = true;
    [openPanel beginSheetModalForWindow: self.view.window completionHandler:^(NSModalResponse result) {
        self->FW.pathName = [openPanel.URL.path UTF8String];
        if ( (self->FW.file = fopen(self->FW.pathName ,"r")) ) { //carregando o arquivo para dentro da memoria
            stat(self->FW.pathName ,&self->FW.fileInfo); //Carregando informações sobre o arquivo
            if (! CheckFirmwareSize(self->FW.fileInfo) ) {
                [self DisplayAlert: @"Invalid File Size!" : @"The size of the file selected is invalid, the file size must be between 64KB and 256KB."];
                exit(1);
            } if (! CheckFirmwareSignature(self->FW.file) ) {
                [self DisplayAlert : @"Invalid Firmware Signature!" : @"The firmware signature indicates that the file is a AMD Atom BIOS."];
                exit(2);
            } if (! CheckFirmwareArchitecture(self->FW.file)) {
                [self DisplayAlert : @"Architecture not supported!" : @"This firmware architecture is not support by this program."];
                exit(3);
            }
        }
        [self->_textFieldFilePath setStringValue: [NSString stringWithUTF8String: self->FW.pathName]];
        [self->oc initOverviewInfo: self->FW : &(self->_atomTable) ];
        [self->tc EnableThisSection : &(self->_atomTable) : &(self->FW)];
        [self->ppc initTableInfo: &(self->_atomTable) : self->FW.file];
    }];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    // Update the view, if already loaded.
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

@end
