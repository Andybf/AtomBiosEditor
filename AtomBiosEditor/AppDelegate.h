//
//  AppDelegate.h
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 28/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Model/AtomBios.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet NSMenuItem *menuItemOpen;
@property (weak) IBOutlet NSMenuItem *menuItemNewWindow;
@property (weak) IBOutlet NSMenuItem *menuItemSave;

@end

