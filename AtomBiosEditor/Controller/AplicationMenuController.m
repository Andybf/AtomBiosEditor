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
                SavePowerPlayData(newFirmwareFile, self->atomBios.dataAndCmmdTables[QUANTITY_COMMAND_TABLES+0x0F], &(self->powerPlay));
                fclose(newFirmwareFile);
                FILE * savedFirmwareFile = fopen([saveFile.URL.path UTF8String],"r+b"); // Reading and writing on existing binary file
                SaveChecksum(savedFirmwareFile, [saveFile.URL.path UTF8String]);
                fclose(savedFirmwareFile);
            }
        }];
    }

    - (IBAction)MenuItemExtractExeBinaries:(id)sender {
        NSSavePanel * saveFile = [NSSavePanel savePanel];
        [saveFile setNameFieldStringValue: [NSString stringWithFormat: @"%@-ExeBinaries.rom", fileName[fileName.count-1] ]];
        [saveFile beginSheetModalForWindow: windowView completionHandler:^(NSInteger returnCode) {
            if (returnCode == 1) { // if the save button was triggered
                FILE * ExeBinariesFile = fopen([saveFile.URL.path UTF8String],"wb");
                SaveExecutableBinaries(ExeBinariesFile,&(self->atomBios));
                fclose(ExeBinariesFile);
            }
        }];
    }

    - (IBAction)MenuItemExtractUefi:(id)sender {
        if (atomBios.mainTable.uefiSupport != 0) {
            NSSavePanel * saveFile = [NSSavePanel savePanel];
            [saveFile setNameFieldStringValue: [NSString stringWithFormat: @"%@-UefiBinaries.rom", fileName[fileName.count-1] ]];
            [saveFile beginSheetModalForWindow: windowView completionHandler:^(NSInteger returnCode) {
                if (returnCode == 1) { // if the save button was triggered
                    FILE * UefiBinariesFile = fopen([saveFile.URL.path UTF8String],"wb");
                    SaveUefiBinaries(UefiBinariesFile,&(self->atomBios));
                    fclose(UefiBinariesFile);
                }
            }];
        } else {
            [self DisplayAlert: @"No UEFI Section Found" : @"Your firmware file doesn't have UEFI GOP Driver." : 1 ];
        }
    }

    - (IBAction)buttonOpenTriggered:(id)sender {
        [self OpenNewFile];
    }

    - (IBAction)buttonExitTriggered:(id)sender {
        exit(0);
    }

    - (void) DisplayAlert : (NSString *) title : (NSString *) content : (BOOL) type {
        NSAlert * alert = [NSAlert new];
        alert.messageText = title;
        alert.informativeText = content;
        if (type == 0) {
            alert.alertStyle = NSAlertStyleInformational;
        } else {
            alert.alertStyle = NSAlertStyleCritical;
        }
        [alert runModal];
    }

    - (void) OpenNewFile {
        
        NSOpenPanel* openPanel = [NSOpenPanel openPanel];
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
                    [self DisplayAlert: @"Invalid File Size!" : @"The size of the file selected is invalid, the file size must be between 64KB and 256KB.\nCheck your rom folder to load a new version of your rom." : 1];
                    // Create a new version of the selected rom with 64KB of size
                    if (self->atomBios.firmware.fileInfo.st_size < QUANTITY_64KB) {
                        fseek(self->atomBios.firmware.file, 0x0, SEEK_SET);
                        FILE * newFile = fopen(strcat(self->atomBios.firmware.filePath,"-new.rom"),"w");
                        char * fileContent = malloc(sizeof(char*) * atomBios.firmware.fileInfo.st_size);
                        for (int c=0; c<atomBios.firmware.fileInfo.st_size; c++){
                            sprintf(&fileContent[c], "%c", fgetc(atomBios.firmware.file));
                        }
                        fwrite(fileContent, sizeof(char), self->atomBios.firmware.fileInfo.st_size, newFile);
                        fseek(newFile, self->atomBios.firmware.fileInfo.st_size, SEEK_SET);
                        long zeroFill = QUANTITY_64KB - self->atomBios.firmware.fileInfo.st_size;
                        for (int i=0; i<zeroFill; i++) {
                            fputc(0, newFile);
                        }
                        fclose(newFile);
                    }
                } else if (! VerifyFirmwareSignature(self->atomBios.firmware.file) ) {
                    [self DisplayAlert : @"Invalid Firmware Signature!" : @"The firmware signature is invalid." : 1];
                    fclose(self->atomBios.firmware.file);
                } else {
                    if ( self->atomBios.firmware.genType != 2) {
                        [self DisplayAlert : @"Unsupported Firmware Generation!" : @"This firmware generation is not supported by this program." : 1];
                    }
                    
                    NSUInteger windowStyleMask = NSWindowStyleMaskTitled|NSWindowStyleMaskClosable|NSWindowStyleMaskMiniaturizable;
                    windowView = [[WindowView alloc] initWithContentRect:NSMakeRect(650, 310, 620, 460) styleMask: windowStyleMask backing: NSBackingStoreBuffered defer: NO];
                    [windowView setIsVisible: YES];
                    masterVC = [[MasterViewController alloc] initWithNibName:@"MasterView" bundle: NULL];
                    [[windowView contentView] addSubview: masterVC.view];
                    fileName = [[NSString stringWithUTF8String: self->atomBios.firmware.filePath] componentsSeparatedByString: @"/"];
                    [self->windowView setTitle: [NSString stringWithFormat: @"AtomBiosEditor - %@", fileName[fileName.count-1]]];
                    [self->masterVC loadInfo: &(self->atomBios) : &(powerPlay) : &(firmwareInfo)];
                    [_menuItemSave setHidden: NO];
                    [_menuItemClose setHidden: NO];
                    [_menuTools setEnabled:YES];
                    [_menuTools setHidden:NO];
                    [_menuItemExtractUefi setEnabled:YES];
                    [_menuItemExtractUefi setHidden:NO];
                    [_menuItemExtractExeBinaries setEnabled:YES];
                    [_menuItemExtractExeBinaries setHidden:NO];
                    [windowView setMenuTools: _menuTools];
                    [windowView setAtomBios: &(self->atomBios)];
                    [_launchScreenWindow close];
                }
            }
        }
    }
@end

@implementation WindowView

    - (void)close {
        [self setReleasedWhenClosed: NO];
        [_menuTools setEnabled:NO];
        _atomBios = NULL;
        [super close];
    }

    - (void)setMenuTools:(NSMenuItem *)menuTools {
        _menuTools = menuTools;
    }

    - (void)setAtomBios:(struct ATOM_BIOS *)at {
        _atomBios = at;
    }
@end
