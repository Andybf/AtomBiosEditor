//
//  AplicationMenuController.h
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 08/09/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

#import "../Model/AtomBios.h"
#import "MasterViewController.h"

@interface AplicationMenuController : NSMenu <NSMenuDelegate>

    @property (weak) IBOutlet NSMenuItem *menuItemOpen;
    @property (weak) IBOutlet NSMenuItem *menuItemNewWindow;
    @property (weak) IBOutlet NSMenuItem *menuItemClose;
    @property (weak) IBOutlet NSMenuItem *menuItemSave;

    @property (weak) IBOutlet NSMenuItem *menuTools;
    @property (weak) IBOutlet NSMenuItem *menuItemExtractExeBinaries;
    @property (weak) IBOutlet NSMenuItem *menuItemExtractUefi;

    @property (weak) IBOutlet NSWindow *launchScreenWindow;
    @property (weak) IBOutlet NSButton *launchButtonOpen;
    @property (weak) IBOutlet NSButton *launchButtonAbout;
    @property (weak) IBOutlet NSButton *launchButtonExit;

    - (void) DisplayAlert : (NSString *) title : (NSString *) info : (BOOL) type;

@end

@interface WindowView : NSWindow

    @property (nonatomic, strong) NSMenuItem * menuTools;
    @property (nonatomic) struct ATOM_BIOS * atomBios;

@end
