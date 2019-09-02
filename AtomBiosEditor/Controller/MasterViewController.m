//
//  ViewController.m
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 28/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#import "MasterViewController.h"

#import "OverviewController.h"
#import "TablesController.h"
#import "PowerPlayController.h"
#import "OverDriveController.h"

@implementation MasterViewController {
    
    OverviewController * oc;
    TablesController * tc;
    PowerPlayController * ppc;
    OverDriveController * ovdc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    oc = [[OverviewController alloc] initWithNibName:@"Overview" bundle:NULL];
    [[self containerOverview]  addSubview: self->oc.view];
    
    tc = [[TablesController alloc] initWithNibName: @"Tables" bundle: NULL];
    [[self containerTables]    addSubview: self->tc.view];
    
    ppc = [[PowerPlayController alloc] initWithNibName: @"PowerPlay" bundle: NULL];
    [[self containerPowerPlay] addSubview: self->ppc.view];
    
    ovdc = [[OverDriveController alloc] initWithNibName: @"OverDrive" bundle: NULL];
    [[self containerOverDrive] addSubview: self->ovdc.view];
}

- (void)loadInfo : (struct FIRMWARE_FILE) FW {
    [self->oc initOverviewInfo: FW : &(self->_atomTable) ];
    [self->tc EnableThisSection : &(self->_atomTable) : &(FW)];
    
    struct POWERPLAY_DATA powerPlay = ShowPowerPlayData(FW.file, self->_atomTable.atomTables[QUANTITY_COMMAND_TABLES+0x0F]);
    
    [self->ppc initTableInfo: &(self->_atomTable) : &(powerPlay) : 1];
    [self->ovdc initOverDriveInfo : &(powerPlay)];
}

@end
