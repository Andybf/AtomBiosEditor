//
//  ViewController.m
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 28/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#import "OverviewController.h"

@implementation OverviewController {
        OverviewTable * tableView;
        struct ATOM_BIOS * atombios;
    }

    - (void)viewDidLoad {
        [super viewDidLoad];
    }

    - (void) initOverviewInfo: (struct ATOM_BIOS *)atomBios {
        atombios = atomBios;
        [_radioDecimal setState : NSControlStateValueOn];
        //Table Initialization
        tableView = [[OverviewTable alloc] initWithFrame: NSMakeRect(0, 0, 440, 380)];
        [tableView initTableStructure];
        NSScrollView * tableContainer = [[NSScrollView alloc] initWithFrame:NSMakeRect(2, 2, 440, 405)];
        // embed the table view in the scroll view, and then, add the scroll view to the box
        [tableContainer setDocumentView:tableView];
        [tableContainer setHasVerticalScroller: YES];
        [tableContainer setAutohidesScrollers:  YES];
        [tableView reloadData : atomBios : false];
        //Add the container to window
        [_OverviewBox addSubview:tableContainer];
    }

    - (IBAction)RadioHexChanged:(id)sender {
        if (_radioHexadecimal.state) {
            [_radioDecimal setState:NSControlStateValueOff];
            [tableView reloadData : atombios : true];
        }
    }

    - (IBAction)RadioDecChanged:(id)sender {
        if (_radioDecimal.state) {
            [_radioHexadecimal setState:NSControlStateValueOff];
            [tableView reloadData : atombios : false];
        }
    }
@end

@implementation OverviewTable {
        NSString * columnIdentifiers[2];
        NSArray * stringFormat;
        struct ATOM_BIOS * atomBios;
    }

    - (void) DisplayAlert : (NSString *) title : (NSString *) content : (BOOL) type {
        NSAlert * alert = [NSAlert new];
        alert.messageText = title;
        alert.informativeText = content;
        if (type == 0) {
            alert.alertStyle = NSAlertStyleInformational;
        } else {
            alert.alertStyle = NSAlertStyleCritical;
        }
        [alert runModal];
    }

    -(void)initTableStructure {
        stringFormat = [NSArray arrayWithObjects: @"%i",@"%02X", nil];
        NSString * tempColumnIdentifiers[] = {@"description",@"value"};
        for (int a=0; a<2; a++) {
            columnIdentifiers[a] = tempColumnIdentifiers[a];
        }
        NSTableColumn * columns[2];
        CGFloat widths[] = {120.0,300.0};
        NSString * titles[] = {@"Description",@"Value"};
        for (int a=0; a<2; a++) {
            columns[a] = [[NSTableColumn alloc] initWithIdentifier: columnIdentifiers[a]];
            [columns[a] setWidth:widths[a]];
            [columns[a] setTitle:titles[a]];
            [self       addTableColumn:columns[a]];
        }
        [self setDelegate:self];
        [self setDataSource: self];
        [self setUsesAlternatingRowBackgroundColors: YES];
        [self setAllowsColumnResizing: NO];
        [self setAllowsColumnReordering: NO];
        [self setEnabled: YES];
        [self reloadData];
    }

    - (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
        return _rowDesc.count;
    }

    - (id)tableView: (NSTableView*)tableView objectValueForTableColumn: (NSTableColumn*)tableColumn row:(NSInteger)row {
        //Column configurations
        [tableColumn setEditable: NO];
        [[tableColumn dataCell] setFont: [NSFont systemFontOfSize: 12.0] ];
        if        ([[tableColumn identifier] isEqualToString: columnIdentifiers[0]]) {
            [[tableColumn dataCell] setAlignment: NSRightTextAlignment];
            return [self.rowDesc objectAtIndex:row];
        } else if ([[tableColumn identifier] isEqualToString: columnIdentifiers[1]]) {
            [tableColumn setEditable: YES];
            return [self.rowValue  objectAtIndex:row];
        } else {
            exit(4);
        }
    }

    // Update the datacell modified bt the user
    - (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
        switch (row) {
            case 6: // Compilation date
                if ([object length] == 14) {
                    strcpy(atomBios->mainTable.compTime, [object UTF8String]);
                    [_rowValue replaceObjectAtIndex:row withObject: object];
                } else {
                    [self DisplayAlert:@"Invalid Input" : @"The new value has to be the same size of the old value" : 1 ];
                }
                break;
            case 7: // Bios Version
                if ([object length] == 22) {
                    strcpy(atomBios->mainTable.biosVersion, [object UTF8String]);
                    [_rowValue replaceObjectAtIndex:row withObject: object];
                } else {
                    [self DisplayAlert:@"Invalid Input" : @"The new value has to be the same size of the old value" : 1 ];
                }
                break;
            case 8: // Device id
                if ([object length] == 8) {
                    strcpy((char*)atomBios->mainTable.deviceId, [object UTF8String]);
                    [_rowValue replaceObjectAtIndex:row withObject: object];
                } else {
                    [self DisplayAlert:@"Invalid Input" : @"The new value has to be the same size of the old value" : 1 ];
                }
                break;
            case 9: // Subsystem id
                if ([object length] == 4) {
                    strcpy((char*)atomBios->mainTable.subsystemId, [object UTF8String]);
                    [_rowValue replaceObjectAtIndex:row withObject: object];
                } else {
                    [self DisplayAlert:@"Invalid Input" : @"The new value has to be the same size of the old value" : 1 ];
                }
                break;
            case 10: // vendor id
                if ([object length] == 4) {
                    strcpy((char*)atomBios->mainTable.subsystemVendorId, [object UTF8String]);
                    [_rowValue replaceObjectAtIndex:row withObject: object];
                } else {
                    [self DisplayAlert:@"Invalid Input" : @"The new value has to be the same size of the old value" : 1 ];
                }
                break;
            default:
                break;
        }
    }

    - (void)reloadData : (struct ATOM_BIOS*)atBios : (bool)viewMode {
        atomBios = atBios;
        NSString * rowDescLabels[] = {
            @"ROM Message",@"Generation",@"Architecture",
            @"Connection Type",@"Memory Generation",@"Part Number",
            @"Compilation Date",@"BIOS Version", @"Device ID",
            @"Subsystem ID",@"Vendor ID",@"Vendor Name",
            @"Checksum", @"UEFI Support",@"Main Table Size",
            @"Main Table Offset",@"Data Tbl. Addr. Off.",@"Data Tbl. Addr. Size",
            @"Cmd Tbl. Addr. Off.",@"Cmd Tbl. Addr. Size"
        };
        [self setRowDesc:  [[NSMutableArray alloc] initWithCapacity: 20]]; // rows
        [self setRowValue:  [[NSMutableArray alloc] initWithCapacity: 20]]; // rows
        
        for (int a=0; a<20; a++) {
            [[self rowDesc]  addObject: [NSString stringWithFormat: @"%@", rowDescLabels[a]]];
        }
        [[self rowValue] addObject: [NSString stringWithUTF8String: atomBios->mainTable.romMessage]];
        [[self rowValue] addObject: [NSString stringWithUTF8String: atomBios->mainTable.generation]];
        [[self rowValue] addObject: [NSString stringWithUTF8String: atomBios->mainTable.architecture]];
        [[self rowValue] addObject: [NSString stringWithUTF8String: atomBios->mainTable.connectionType]];
        [[self rowValue] addObject: [NSString stringWithUTF8String: atomBios->mainTable.memoryGen]];
        [[self rowValue] addObject: [NSString stringWithUTF8String: atomBios->mainTable.partNumber]];
        [[self rowValue] addObject: [NSString stringWithUTF8String: atomBios->mainTable.compTime]];
        [[self rowValue] addObject: [NSString stringWithUTF8String: atomBios->mainTable.biosVersion]];
        [[self rowValue] addObject: [NSString stringWithUTF8String: (char *)atomBios->mainTable.deviceId]];
        [[self rowValue] addObject: [NSString stringWithUTF8String: (char *)atomBios->mainTable.subsystemId]];
        [[self rowValue] addObject: [NSString stringWithFormat: @"%s",(char *)atomBios->mainTable.subsystemVendorId]];
        [[self rowValue] addObject: [NSString stringWithUTF8String: atomBios->mainTable.vendorName]];
        if ( VerifyChecksum(atomBios) != 0) {
            [[self rowValue] addObject: [NSString stringWithFormat: @"Valid! - 0x%02X", atomBios->mainTable.checksum]];
        } else {
            [[self rowValue] addObject: [NSString stringWithFormat: @"Invalid! - 0x%02X", atomBios->mainTable.checksum]];
        }
        if (atomBios->mainTable.uefiSupport != 0) {
            [[self rowValue] addObject: @"Supported!"];
        } else {
            [[self rowValue] addObject: @"Unsupported!"];
        }
        [[self rowValue] addObject: [NSString stringWithFormat: stringFormat[viewMode], atomBios->mainTable.size]];
        [[self rowValue] addObject: [NSString stringWithFormat: stringFormat[viewMode], 0x04]];
        [[self rowValue] addObject: [NSString stringWithFormat: stringFormat[viewMode], atomBios->offsetsTable[0].offset]];
        [[self rowValue] addObject: [NSString stringWithFormat: stringFormat[viewMode], atomBios->offsetsTable[0].size]];
        [[self rowValue] addObject: [NSString stringWithFormat: stringFormat[viewMode], atomBios->offsetsTable[1].offset]];
        [[self rowValue] addObject: [NSString stringWithFormat: stringFormat[viewMode], atomBios->offsetsTable[1].size]];
        [super reloadData];
    }
@end
