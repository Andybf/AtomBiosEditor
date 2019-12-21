//
//  AplicationMenuController.m
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 08/09/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#import "AplicationMenuController.h"


@implementation AplicationMenuController {
        struct ATOM_BIOS atomBios;
        struct POWERPLAY_DATA powerPlay;
        struct FIRMWARE_INFO firmwareInfo;
        MasterViewController * masterVC;
        WindowView * windowView;
        WindowView * launchScreen;
        NSArray * fileName;
    }

    - (IBAction)menuItemOpenTriggered:(id)sender {
        [self OpenNewFile];
    }

    - (IBAction)MenuItemCloseTriggered:(id)sender {
        [windowView close];
    }

    - (IBAction)menuItemSaveTriggered:(id)sender {
        NSSavePanel * saveFile = [NSSavePanel savePanel];
        [saveFile setNameFieldStringValue: [NSString stringWithFormat: @"%@-Modified.rom", fileName[fileName.count-1] ]];
        [saveFile beginSheetModalForWindow: windowView completionHandler:^(NSInteger returnCode) {
            if (returnCode == 1) { // if the save button was triggered
                FILE * newFirmwareFile = fopen([saveFile.URL.path UTF8String],"wb");
                SaveAtomBiosData(&(self->atomBios), newFirmwareFile);
                SaveFirmwareInfo(newFirmwareFile, self->atomBios.dataAndCmmdTables[QUANTITY_COMMAND_TABLES+0x04], self->firmwareInfo);
                SavePowerPlayData(newFirmwareFile, self->atomBios.dataAndCmmdTables[QUANTITY_COMMAND_TABLES+0x0F], self->powerPlay);
                fclose(newFirmwareFile);
                FILE * savedFirmwareFile = fopen([saveFile.URL.path UTF8String],"r+b"); // Reading and writing on existing binary file
                SaveChecksum(savedFirmwareFile, [saveFile.URL.path UTF8String]);
                fclose(savedFirmwareFile);
            }
        }];
    }


    - (IBAction)buttonOpenTriggered:(id)sender {
        [self OpenNewFile];
    }

    - (IBAction)buttonExitTriggered:(id)sender {
        exit(0);
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

    - (void) OpenNewFile {
        
        
        NSOpenPanel* openPanel = [NSOpenPanel openPanel]; //Criando objeto NSOpenPanel
        //Config
        openPanel.allowsMultipleSelection = false;
        openPanel.canChooseDirectories    = false;
        openPanel.canChooseFiles          = true;
        if ([openPanel runModal] == NSModalResponseOK) {
            
            self->atomBios.firmware.filePath = (char*)[openPanel.URL.path UTF8String];
            
            if ( (self->atomBios.firmware.file = fopen(self->atomBios.firmware.filePath ,"r")) ) { //carregando o arquivo para dentro da memoria
                
                self->atomBios.firmware.genType = VerifyFirmwareArchitecture(self->atomBios.firmware.file);
                stat(self->atomBios.firmware.filePath ,&self->atomBios.firmware.fileInfo); //Carregando informações sobre o arquivo
                
                if (! VerifyFirmwareSize(self->atomBios.firmware.fileInfo) ) {
                    [self DisplayAlert: @"Invalid File Size!" : @"The size of the file selected is invalid, the file size must be between 64KB and 256KB."];
                    fclose(self->atomBios.firmware.file);
                } else if (! VerifyFirmwareSignature(self->atomBios.firmware.file) ) {
                    [self DisplayAlert : @"Invalid Firmware Signature!" : @"The firmware signature is invalid."];
                    fclose(self->atomBios.firmware.file);
                } else if ( self->atomBios.firmware.genType == 0) {
                    [self DisplayAlert : @"Unsupported Firmware Generation!" : @"This firmware generation is not supported by this program."];
                    fclose(self->atomBios.firmware.file);
                } else {
                    NSUInteger windowStyleMask = NSWindowStyleMaskTitled|NSWindowStyleMaskClosable|NSWindowStyleMaskMiniaturizable;
                    windowView = [[WindowView alloc] initWithContentRect:NSMakeRect(650, 310, 620, 460) styleMask: windowStyleMask backing: NSBackingStoreBuffered defer: NO];
                    [windowView setIsVisible: YES];
                    masterVC = [[MasterViewController alloc] initWithNibName:@"MasterView" bundle: NULL];
                    [[windowView contentView] addSubview: masterVC.view];
                    fileName = [[NSString stringWithUTF8String: self->atomBios.firmware.filePath] componentsSeparatedByString: @"/"];
                    self->atomBios.firmware.fileName = (char*)[fileName[fileName.count-1] UTF8String];
                    [self->windowView setTitle: [NSString stringWithFormat: @"AtomBiosEditor - %@", fileName[fileName.count-1]]];
                    [self->masterVC loadInfo: &(self->atomBios) : &(powerPlay) : &(firmwareInfo)];
                    [_menuItemSave setHidden: NO];
                    [_menuItemClose setHidden: NO];
                    [_launchScreenWindow close];
                }
            }
        }
    }
@end

@implementation WindowView

- (void)close {
    [self setReleasedWhenClosed: NO];
    
    [super close];
}

@end
