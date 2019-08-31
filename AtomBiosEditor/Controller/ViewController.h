//
//  ViewController.h
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 28/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController

@property (weak) IBOutlet NSButton *buttonOpenFile;
@property (weak) IBOutlet NSTextField *textFieldFilePath;

@property (weak) IBOutlet NSView *containerOverview;
@property (weak) IBOutlet NSView *containerTables;
@property (weak) IBOutlet NSView *containerPowerPlay;
@property (weak) IBOutlet NSView *containerOverDrive;

@property struct ATOM_BASE_TABLE atomTable;

@end

