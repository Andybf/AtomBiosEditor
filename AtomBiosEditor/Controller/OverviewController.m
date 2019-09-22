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
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) initOverviewInfo: (struct ATOM_BIOS *)atomBios {
    atomBios->mainTable = loadMainTable(atomBios);
    loadOffsetsTable(     atomBios);
    loadCmmdAndDataTables(atomBios);
    
    //Table Initialization
    tableView = [[OverviewTable alloc] initWithFrame: NSMakeRect(0, 0, 440, 380)];
    [tableView initTableStructure];
    NSScrollView * tableContainer = [[NSScrollView alloc] initWithFrame:NSMakeRect(10, 58, 440, 405)];
    // embed the table view in the scroll view, and add the scroll view
    [tableContainer setDocumentView:tableView];
    [tableContainer setHasVerticalScroller: YES];
    [tableContainer setAutohidesScrollers:  YES];
    //Add the container to window
    [[self view] addSubview:tableContainer];
    
    NSString * rowDescLabels[] = {
        @"ROM Message",@"Generation",@"Architecture",
        @"Connection Type",@"Memory Generation",@"Part Number",
        @"Compilation Date",@"BIOS Version", @"Device ID",
        @"Subsystem ID",@"Vendor ID",@"Vendor Name",
        @"Checksum", @"UEFI Support",@"Main Table Size",
        @"Main Table Offset",@"Data Tbl. Addr. Off.",@"Data Tbl. Addr. Size",
        @"Cmd Tbl. Addr. Off.",@"Cmd Tbl. Addr. Size"
    };
    
    [tableView setRowDesc:  [[NSMutableArray alloc] initWithCapacity: 20]]; // rows
    [tableView setRowValue:  [[NSMutableArray alloc] initWithCapacity: 20]]; // rows
    
    for (int a=0; a<20; a++) {
        [[tableView rowDesc]  addObject: [NSString stringWithFormat: @"%@", rowDescLabels[a]]];
    }
    [[tableView rowValue] addObject: [NSString stringWithUTF8String: atomBios->mainTable.romMessage]];
    [[tableView rowValue] addObject: [NSString stringWithUTF8String: atomBios->mainTable.generation]];
    [[tableView rowValue] addObject: [NSString stringWithUTF8String: atomBios->mainTable.architecture]];
    [[tableView rowValue] addObject: [NSString stringWithUTF8String: atomBios->mainTable.connectionType]];
    [[tableView rowValue] addObject: [NSString stringWithUTF8String: atomBios->mainTable.memoryGen]];
    [[tableView rowValue] addObject: [NSString stringWithUTF8String: atomBios->mainTable.partNumber]];
    [[tableView rowValue] addObject: [NSString stringWithUTF8String: atomBios->mainTable.compTime]];
    [[tableView rowValue] addObject: [NSString stringWithUTF8String: atomBios->mainTable.biosVersion]];
    [[tableView rowValue] addObject: [NSString stringWithUTF8String: (char *)atomBios->mainTable.deviceId]];
    [[tableView rowValue] addObject: [NSString stringWithUTF8String: (char *)atomBios->mainTable.subsystemId]];
    [[tableView rowValue] addObject: [NSString stringWithFormat: @"%s",(char *)atomBios->mainTable.subsystemVendorId]];
    [[tableView rowValue] addObject: [NSString stringWithUTF8String: atomBios->mainTable.vendorName]];
    if ( VerifyChecksum(atomBios) != 0) {
        [[tableView rowValue] addObject: [NSString stringWithFormat: @"Valid! - 0x%02X", atomBios->mainTable.checksum] ];
    } else {
        [[tableView rowValue] addObject: [NSString stringWithUTF8String: "Invalid!"] ];
    }
    if (atomBios->mainTable.uefiSupport != 0) {
        [[tableView rowValue] addObject: @"Supported!"];
    } else {
        [[tableView rowValue] addObject: @"Unsupported!"];
    }
    [[tableView rowValue] addObject: [NSString stringWithFormat: @"%i",atomBios->mainTable.size]];
    [[tableView rowValue] addObject: [NSString stringWithFormat: @"0x04"]];
    [[tableView rowValue] addObject: [NSString stringWithFormat: @"%i",atomBios->offsetsTable[0].offset]];
    [[tableView rowValue] addObject: [NSString stringWithFormat: @"%i",atomBios->offsetsTable[0].size]];
    [[tableView rowValue] addObject: [NSString stringWithFormat: @"%i",atomBios->offsetsTable[1].offset]];
    [[tableView rowValue] addObject: [NSString stringWithFormat: @"%i",atomBios->offsetsTable[1].size]];
    
    [tableView reloadData];
}

- (IBAction)CheckCheksum:(id)sender {
    if (! [_checkChecksum state]) {
        [ _checkChecksum setState: NSControlStateValueOn];
    } else {
        [ _checkChecksum setState: NSControlStateValueOff];
    }
}

- (IBAction)CheckUefiChangedState:(id)sender {
    if (! [ _checkUefiSupport state]) {
        [ _checkUefiSupport setState: NSControlStateValueOn];
    } else {
        [ _checkUefiSupport setState: NSControlStateValueOff];
    }
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    // Update the view, if already loaded.
}

@end

@implementation OverviewTable {
    NSString * columnIdentifiers[2];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    if ([self selectedRow] > 0) {
    }
}

-(void)initTableStructure {
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
    [self setUsesAlternatingRowBackgroundColors: YES];
    [self setDataSource: self];
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
@end
