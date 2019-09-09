//
//  AppDelegate.m
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 28/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#import "AppDelegate.h"
#import "Controller/MasterViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate {
    struct ATOM_BIOS atomBios;
    MasterViewController * masterVC;
    NSWindow * windowView;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    NSUInteger windowStyleMask = NSWindowStyleMaskTitled|NSWindowStyleMaskClosable|NSWindowStyleMaskMiniaturizable;
    windowView = [[NSWindow alloc] initWithContentRect:NSMakeRect(100, 200, 480, 500) styleMask: windowStyleMask backing: NSBackingStoreBuffered defer: NO];
    masterVC = [[MasterViewController alloc] initWithNibName:@"MasterView" bundle: NULL];
    [windowView setTitle: @"AtomBiosEditor"];
    [[windowView contentView] addSubview: masterVC.view];
    [windowView setIsVisible: YES];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}



- (IBAction)menuItemNewWindow:(id)sender {
}

- (IBAction)menuItemOpenTriggered:(id)sender {
    NSOpenPanel* openPanel = [NSOpenPanel openPanel]; //Criando objeto NSOpenPanel
    //Configuração
    openPanel.allowsMultipleSelection = false;
    openPanel.canChooseDirectories    = false;
    openPanel.canChooseFiles          = true;
    [openPanel beginSheetModalForWindow: windowView completionHandler:^(NSModalResponse result) {
        self->atomBios.firmware.filePath = (char*)[openPanel.URL.path UTF8String];
        
        if ( (self->atomBios.firmware.file = fopen(self->atomBios.firmware.filePath ,"r")) ) { //carregando o arquivo para dentro da memoria
            self->atomBios.firmware.archType = VerifyFirmwareArchitecture(self->atomBios.firmware.file);
            stat(self->atomBios.firmware.filePath ,&self->atomBios.firmware.fileInfo); //Carregando informações sobre o arquivo
            
            if (! VerifyFirmwareSize(self->atomBios.firmware.fileInfo) ) {
                [self DisplayAlert: @"Invalid File Size!" : @"The size of the file selected is invalid, the file size must be between 64KB and 256KB."];
                fclose(self->atomBios.firmware.file);
            } else if (! VerifyFirmwareSignature(self->atomBios.firmware.file) ) {
                [self DisplayAlert : @"Invalid Firmware Signature!" : @"The firmware signature is invalid."];
                fclose(self->atomBios.firmware.file);
            } else if ( self->atomBios.firmware.archType == 0) {
                [self DisplayAlert : @"Architecture not supported!" : @"This firmware architecture is not support by this program."];
                fclose(self->atomBios.firmware.file);
            } else {
                NSArray * fileName = [[NSString stringWithUTF8String: self->atomBios.firmware.filePath] componentsSeparatedByString: @"/"];
                self->atomBios.firmware.fileName = (char*)[fileName[fileName.count-1] UTF8String];
                [self->windowView setTitle: [NSString stringWithFormat: @"AtomBiosEditor - %@", fileName[fileName.count-1]]];
                
                [self->masterVC loadInfo : &(self->atomBios)];
            }
        }
    }];
}

- (IBAction)menuItemSaveTriggered:(id)sender {
    NSSavePanel * saveFile = [NSSavePanel savePanel];
    [saveFile setNameFieldStringValue: [NSString stringWithFormat: @"%s-Modified.rom",atomBios.firmware.fileName] ];
    [saveFile beginSheetModalForWindow: windowView completionHandler:^(NSInteger returnCode) {
        if (returnCode == 1) { // if the save button was triggered
            NSLog(@"Save was triggerred!");
            
        }
    }];
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
