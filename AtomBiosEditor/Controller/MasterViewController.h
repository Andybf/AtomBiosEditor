//
//  ViewController.h
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 28/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "../Model/TableLoader.h"

@interface MasterViewController : NSViewController

@property (weak) IBOutlet NSView *containerOverview;
@property (weak) IBOutlet NSView *containerTables;
@property (weak) IBOutlet NSView *containerPowerPlay;
@property (weak) IBOutlet NSView *containerOverDrive;

@property struct ATOM_BASE_TABLE atomTable;

- (void)loadInfo : (struct FIRMWARE_FILE) FW;;

@end

