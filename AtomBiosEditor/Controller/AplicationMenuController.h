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

@end