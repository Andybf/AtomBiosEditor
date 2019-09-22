//
//  ViewController.m
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 28/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#import "MasterViewController.h"


@implementation MasterViewController {
    
    }

    - (void)viewDidLoad {
        
        [super viewDidLoad];
        _varOverviewController     = [[OverviewController     alloc] initWithNibName: @"Overview"     bundle: NULL];
        _varTablesController       = [[TablesController       alloc] initWithNibName: @"Tables"       bundle: NULL];
        _varPowerPlayController    = [[PowerPlayController    alloc] initWithNibName: @"PowerPlay"    bundle: NULL];
        _varOverDriveController    = [[OverDriveController    alloc] initWithNibName: @"OverDrive"    bundle: NULL];
        _varFirmwareInfoController = [[FirmwareInfoController alloc] initWithNibName: @"FirmwareInfo" bundle: NULL];
    }

    - (void)loadInfo : (struct ATOM_BIOS *)atomBios {
        
        NSScrollView * sideBarContainer = [[NSScrollView alloc] initWithFrame:NSMakeRect(0, 0, 160, 500)];
        [sideBarContainer setDrawsBackground:NO];
        SideBar * sideBar = [[SideBar alloc] initWithFrame: NSMakeRect(0, 0, 160, 500)];
        [sideBarContainer setDocumentView: sideBar];
        [sideBar setBackgroundColor: [NSColor colorWithRed:0 green:0 blue:0 alpha:0]];
        [sideBar ConstructSideBar: self : atomBios];
        
        NSVisualEffectView * effectView = [[NSVisualEffectView alloc] initWithFrame: NSMakeRect(0, 0, 160, 500)];
        
        [effectView addSubview: sideBarContainer];
        [[self view] addSubview: effectView];
        [_varOverviewController initOverviewInfo: atomBios];
        [[self contentView] addSubview: self->_varOverviewController.view];
        
    }
@end

@implementation SideBar {
        MasterViewController * mvc;
        struct ATOM_BIOS * at;
        struct POWERPLAY_DATA powerPlay;
    }

    - (void)ConstructSideBar: (MasterViewController *)masterVC : (struct ATOM_BIOS *) atomBios {
        mvc = masterVC;
        at = atomBios;
        NSTableColumn * column = [[NSTableColumn alloc] initWithIdentifier: @"menu"];
        [column setWidth: 160];
        [column setTitle: @"Main Menu"];
        [self addTableColumn:column];
        [self setTableTitles: [[NSMutableArray alloc] initWithCapacity: 5]];
        NSArray * menuTitles = [NSArray arrayWithObjects:@"Overview Info",@"Tables Info",@"Firmware Info",@"Power Play",@"OverDrive", nil];
        for (int a=0; a<5; a++) {
            [_tableTitles addObject: menuTitles[a]];
        }
        [self setRowHeight: 22.0];
        [self setAllowsColumnReordering: NO];
        //[self setHeaderView: NULL];
        [self setDelegate: self];
        [self setDataSource: self];
        [self setEnabled: YES];
        [self reloadData];
        [self tableViewSelectionDidChange: [NSNotification notificationWithName: @"teste" object: NULL]];
    }

    - (void)tableViewSelectionDidChange:(NSNotification *)notification {
        switch ([self selectedRow]) {
            case 0:
                [[mvc contentView] replaceSubview: mvc.contentView.subviews[0] with: [[mvc varOverviewController] view]];
                break;
            case 1:
                [[mvc contentView] replaceSubview: mvc.contentView.subviews[0] with: [[mvc varTablesController] view]];
                [[mvc varTablesController] InitTableTabInfo: at->dataAndCmmdTables : at->firmware.fileName];
                break;
            case 2:
                [[mvc contentView] replaceSubview: mvc.contentView.subviews[0] with: [[mvc varFirmwareInfoController] view]];
                [[mvc varFirmwareInfoController] InitFirmwareInfo];
                break;
            case 3:
                [[mvc contentView] replaceSubview: mvc.contentView.subviews[0] with: [[mvc varPowerPlayController] view]];
                powerPlay = LoadPowerPlayData(at->firmware.file, at->dataAndCmmdTables[QUANTITY_COMMAND_TABLES+0x0F]);
                [[mvc varPowerPlayController] InitPowerPlayInfo : at->dataAndCmmdTables : &(powerPlay) : 0];
                break;
            case 4:
                [[mvc contentView] replaceSubview: mvc.contentView.subviews[0] with: [[mvc varOverDriveController] view]];
                [[mvc varOverDriveController] initOverDriveInfo : &(powerPlay)];
                break;
            default:
                break;
        }
    }

    - (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
        return _tableTitles.count;
    }

    - (id)tableView: (NSTableView*)tableView objectValueForTableColumn: (NSTableColumn*)tableColumn row:(NSInteger)row {
        //Column configurations
        [tableColumn setEditable: NO];
        [[tableColumn dataCell] setFont: [NSFont systemFontOfSize: 13.0] ];
        
        return [self.tableTitles objectAtIndex:row];
    }

@end
