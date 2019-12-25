//
//  ViewController.h
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 28/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "../Model/AtomBios.h"

#import "OverviewController.h"
#import "TablesController.h"
#import "PowerPlayController.h"
#import "OverDriveController.h"
#import "FirmwareInfoController.h"

@interface MasterViewController : NSViewController {
    struct ATOM_BIOS * atomBios;
}
    @property (nonatomic, strong) OverviewController  * varOverviewController;
    @property (nonatomic, strong) TablesController    * varTablesController;
    @property (nonatomic, strong) PowerPlayController * varPowerPlayController;
    @property (nonatomic, strong) OverDriveController * varOverDriveController;
    @property (nonatomic, strong) FirmwareInfoController * varFirmwareInfoController;

    @property (weak) IBOutlet NSView *contentView;
    @property (weak) IBOutlet NSView *warningView;

    - (void)loadInfo : (struct ATOM_BIOS *)atomBios : (struct POWERPLAY_DATA*)powerPlay : (struct FIRMWARE_INFO *)firmwareInfo;

@end

@interface SideBar : NSTableView <NSTableViewDelegate, NSTableViewDataSource> {
    
    }
    @property (nonatomic, strong) NSMutableArray * tableTitles;

    - (void)ConstructSideBar: (MasterViewController *)masterVC : (struct ATOM_BIOS *) atomBios : (struct POWERPLAY_DATA *) pp : (struct FIRMWARE_INFO *) fi;

@end
