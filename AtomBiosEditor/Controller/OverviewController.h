//
//  ViewController.h
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 28/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "../Model/AtomBios.h"

@interface OverviewController : NSViewController

    @property (weak) IBOutlet NSBox    *OverviewBox;
    @property (weak) IBOutlet NSButton *radioHexadecimal;
    @property (weak) IBOutlet NSButton *radioDecimal;

    - (void) initOverviewInfo: (struct ATOM_BIOS *)atomBios;

@end

@interface OverviewTable : NSTableView <NSTableViewDataSource,NSTableViewDelegate>

    @property (nonatomic, strong) NSMutableArray * rowDesc;
    @property (nonatomic, strong) NSMutableArray * rowValue;

- (void)reloadData : (struct ATOM_BIOS*)atomBios : (bool)viewMode;
    - (void)initTableStructure;

@end




