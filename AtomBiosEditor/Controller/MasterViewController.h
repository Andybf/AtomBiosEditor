//
//  ViewController.h
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 28/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "../Model/AtomBios.h"

@interface MasterViewController : NSViewController

@property (weak) IBOutlet NSView *containerOverview;
@property (weak) IBOutlet NSView *containerTables;
@property (weak) IBOutlet NSView *containerPowerPlay;
@property (weak) IBOutlet NSView *containerOverDrive;

- (void)loadInfo : (struct ATOM_BIOS *) atomBios;

@end

