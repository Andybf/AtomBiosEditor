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
    struct FIRMWARE_FILE FW;
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
    NSUInteger windowStyleMask = NSWindowStyleMaskTitled|NSWindowStyleMaskClosable|NSWindowStyleMaskMiniaturizable;
    windowView = [[NSWindow alloc] initWithContentRect:NSMakeRect(100, 200, 480, 500) styleMask: windowStyleMask backing: NSBackingStoreBuffered defer: NO];
    masterVC = [[MasterViewController alloc] initWithNibName:@"MasterView" bundle: NULL];
    [windowView setTitle: @"AtomBiosEditor"];
    [[windowView contentView] addSubview: masterVC.view];
    [windowView setIsVisible: YES];
}

- (IBAction)menuItemOpenTriggered:(id)sender {
        NSOpenPanel* openPanel = [NSOpenPanel openPanel]; //Criando objeto NSOpenPanel
        //Configuração
        openPanel.allowsMultipleSelection = false;
        openPanel.canChooseDirectories    = false;
        openPanel.canChooseFiles          = true;
        [openPanel beginSheetModalForWindow: windowView completionHandler:^(NSModalResponse result) {
            self->FW.pathName = [openPanel.URL.path UTF8String];
            if ( (self->FW.file = fopen(self->FW.pathName ,"r")) ) { //carregando o arquivo para dentro da memoria
                self->FW.archType = CheckFirmwareArchitecture(self->FW.file);
                stat(self->FW.pathName ,&self->FW.fileInfo); //Carregando informações sobre o arquivo
                if (! CheckFirmwareSize(self->FW.fileInfo) ) {
                    [self DisplayAlert: @"Invalid File Size!" : @"The size of the file selected is invalid, the file size must be between 64KB and 256KB."];
                    fclose(self->FW.file);
                } else if (! CheckFirmwareSignature(self->FW.file) ) {
                    [self DisplayAlert : @"Invalid Firmware Signature!" : @"The firmware signature is invalid."];
                    fclose(self->FW.file);
                } else if ( self->FW.archType == 0) {
                    [self DisplayAlert : @"Architecture not supported!" : @"This firmware architecture is not support by this program."];
                    fclose(self->FW.file);
                } else {
                    NSArray * fileName = [[NSString stringWithUTF8String: self->FW.pathName] componentsSeparatedByString: @"/"];
                    [self->windowView setTitle: [NSString stringWithFormat: @"AtomBiosEditor - %@", fileName[fileName.count-1]]];
                    [self->masterVC loadInfo : self->FW];
                }
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
