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
    
    OverviewController * varOverviewController;
    TablesController * varTablesController;
    PowerPlayController * varPowerPlayController;
    OverDriveController * varOverDriveController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    varOverviewController = [[OverviewController alloc] initWithNibName:@"Overview" bundle:NULL];
    [[self containerOverview]  addSubview: self->varOverviewController.view];
    
    varTablesController = [[TablesController alloc] initWithNibName: @"Tables" bundle: NULL];
    [[self containerTables]    addSubview: self->varTablesController.view];
    
    varPowerPlayController = [[PowerPlayController alloc] initWithNibName: @"PowerPlay" bundle: NULL];
    [[self containerPowerPlay] addSubview: self->varPowerPlayController.view];
    
    varOverDriveController = [[OverDriveController alloc] initWithNibName: @"OverDrive" bundle: NULL];
    [[self containerOverDrive] addSubview: self->varOverDriveController.view];
}

- (void)loadInfo : (struct FIRMWARE_FILE *) FW {
    
    [self->varOverviewController initOverviewInfo: *FW : &(self->_atomTable) ];
    [self->varTablesController EnableThisSection : &(self->_atomTable) : FW->fileName];
    
    struct POWERPLAY_DATA powerPlay = ShowPowerPlayData(FW->file, self->_atomTable.atomTables[QUANTITY_COMMAND_TABLES+0x0F]);
    
    [self->varPowerPlayController  InitPowerPlayInfo : &(self->_atomTable) : &(powerPlay) : 1];
    [self->varOverDriveController initOverDriveInfo : &(powerPlay)];
}

@end
