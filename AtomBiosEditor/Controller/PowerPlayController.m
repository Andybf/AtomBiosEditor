//
//  PowerPlayController.m
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 30/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#import "PowerPlayController.h"

@implementation PowerPlayController {
    
    NSScrollView * tableContainer[3];
    struct POWERPLAY_DATA powerPlay;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    short dimensions[3][4] = {
        {7,311,440,106},
        {7,172,440,106},
        {7,33 ,440,106}
    };
    for (int c=0; c<3; c++) {
         tableContainer[c] = [[NSScrollView alloc] initWithFrame:NSMakeRect(dimensions[c][0],dimensions[c][1],dimensions[c][2],dimensions[c][3])];
         stTable[c] = [[StatesTable alloc] initWithFrame: NSMakeRect(0,0,dimensions[c][2],dimensions[c][3])];
        if (! (c==0) ) {
            [stTable[c] initTableStructure: 0];
        } else {
            [stTable[c] initTableStructure: 1];
        }
        [tableContainer[c] setDocumentView: stTable[c]];
        [tableContainer[c] setHasVerticalScroller:YES];
        [[self view] addSubview:tableContainer[c]];
    }
}

-(void) initTableInfo : (struct ATOM_BASE_TABLE *)atomTable : (FILE *)firmware {
    [_radioDecimal     setEnabled : YES];
    [_radioHexadecimal setEnabled : YES];
    
    powerPlay = ShowPowerPlayData(firmware, atomTable->atomTables[QUANTITY_COMMAND_TABLES+0x0F]);
    
    [stTable[0] setIndex     : [[NSMutableArray alloc] initWithCapacity: powerPlay.numberOfStates]];
    [stTable[0] setValue     : [[NSMutableArray alloc] initWithCapacity: powerPlay.numberOfStates]];
    [stTable[0] setOffset    : [[NSMutableArray alloc] initWithCapacity: powerPlay.numberOfStates]];
    [stTable[0] setSize      : [[NSMutableArray alloc] initWithCapacity: powerPlay.numberOfStates]];
    for (int a=0; a<powerPlay.numberOfStates; a++) {
        [[stTable[0] index]  addObject: [NSString stringWithFormat: @"%d",a+1]];
        [[stTable[0] value]  addObject: [NSString stringWithFormat: @"%d",powerPlay.gpuClock[a]]];
        [[stTable[0] offset] addObject: [NSString stringWithFormat: @"%d",powerPlay.memClock[a]]];
        [[stTable[0] size]   addObject: [NSString stringWithFormat: @"%d",powerPlay.voltage[a]]];
    }
    [stTable[0] reloadData];
    [stTable[0] setEnabled: YES];
    
    [stTable[1] setIndex     : [[NSMutableArray alloc] initWithCapacity: powerPlay.numberOfGpuStates]];
    [stTable[1] setValue     : [[NSMutableArray alloc] initWithCapacity: powerPlay.numberOfGpuStates]];
    [stTable[1] setOffset    : [[NSMutableArray alloc] initWithCapacity: powerPlay.numberOfGpuStates]];
    [stTable[1] setSize      : [[NSMutableArray alloc] initWithCapacity: powerPlay.numberOfGpuStates]];
    for (int a=0; a<powerPlay.numberOfGpuStates; a++) {
        [[stTable[1] index]  addObject: [NSString stringWithFormat: @"%d",a+1]];
        [[stTable[1] value]  addObject: [NSString stringWithFormat: @"%d",powerPlay.gpuFreqState[a] ]];
        [[stTable[1] offset] addObject: [NSString stringWithFormat: @"%d",powerPlay.gpuFreqOffset + atomTable->atomTables[QUANTITY_COMMAND_TABLES+0x0F].offset + a * 3 ]];
        [[stTable[1] size]   addObject: [NSString stringWithFormat: @"0x3"]];
    }
    [stTable[1] reloadData];
    [stTable[1] setEnabled: YES];
    
    [stTable[2] setIndex     : [[NSMutableArray alloc] initWithCapacity: powerPlay.numberOfMemStates]];
    [stTable[2] setValue     : [[NSMutableArray alloc] initWithCapacity: powerPlay.numberOfMemStates]];
    [stTable[2] setOffset    : [[NSMutableArray alloc] initWithCapacity: powerPlay.numberOfMemStates]];
    [stTable[2] setSize      : [[NSMutableArray alloc] initWithCapacity: powerPlay.numberOfMemStates]];
    for (int a=0; a<powerPlay.numberOfMemStates; a++) {
        [[stTable[2] index]  addObject: [NSString stringWithFormat: @"%d",a+1]];
        [[stTable[2] value]  addObject: [NSString stringWithFormat: @"%d",powerPlay.memFreqState[a] ]];
        [[stTable[2] offset] addObject: [NSString stringWithFormat: @"%d",powerPlay.memFreqOffset + atomTable->atomTables[QUANTITY_COMMAND_TABLES+0x0F].offset + a * 3 ]];
        [[stTable[2] size]   addObject: [NSString stringWithFormat: @"0x3"]];
    }
    [stTable[2] reloadData];
    [stTable[2] setEnabled: YES];
}

- (IBAction)RadioHexChanged:(id)sender {
    if (_radioHexadecimal.state == 1 ) {
        [_radioDecimal setState:NSControlStateValueOff];
        NSLog(@"%ld", (long)[_radioDecimal state]);
        //[self initTableInfo : atomTable : ];
    }
}
- (IBAction)RadioDecChanged:(id)sender {
    if (_radioDecimal.state == 1 ) {
        [_radioHexadecimal setState:NSControlStateValueOff];
        NSLog(@"%ld", (long)[_radioDecimal state]);
        //[self initTableInfo : atomTable : ];
    }
}

@end

@implementation StatesTable {
    NSString * columnIdentifiers[4];
}

-(void)initTableStructure : (short)type{
    
    CGFloat widths[] = {60.0,130.0,130.0,100.0};
    NSString * titles[] = {@"Index",@"Value",@"Offset",@"Size"};
    NSString * tempColumnIdentifiers[] = {@"index",@"value",@"offset",@"size"};
    for (int a=0; a<4; a++) {
        columnIdentifiers[a] = tempColumnIdentifiers[a];
    }
    if (type == 1) {
        titles[1] = @"GPU Clock (MHz)";
        titles[2] = @"Mem Clock (MHz)";
        titles[3] = @"Voltage (mV)";
        columnIdentifiers[1] = @"gpu";
        columnIdentifiers[2] = @"mem";
        columnIdentifiers[2] = @"voltage";
    }
    NSTableColumn * columns[4];
    
    for (int a=0; a<4; a++) {
        columns[a] = [[NSTableColumn alloc] initWithIdentifier: columnIdentifiers[a]];
        [columns[a] setWidth:widths[a]];
        [columns[a] setTitle:titles[a]];
        [self       addTableColumn:columns[a]];
    }
    // [self setDelegate:self];
    [self setDataSource: self];
    [self setAllowsColumnResizing: NO];
    [self setAllowsColumnReordering: NO];
    [self setEnabled: NO];
    [self reloadData];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return _index.count;
}

- (id)tableView: (NSTableView*)tableView objectValueForTableColumn: (NSTableColumn*)tableColumn row:(NSInteger)row {
    //Column configurations
    [tableColumn setEditable:NO];
    [[tableColumn dataCell] setFont: [NSFont systemFontOfSize: 12.0] ];
    if        ([[tableColumn identifier] isEqualToString: columnIdentifiers[0]]) {
        return [self.index  objectAtIndex:row];
    }else if ([[tableColumn identifier] isEqualToString: columnIdentifiers[1]]) {
        return [self.value  objectAtIndex:row];
    } else if ([[tableColumn identifier] isEqualToString: columnIdentifiers[2]]) {
        return [self.offset objectAtIndex:row];
    } else if ([[tableColumn identifier] isEqualToString: columnIdentifiers[3]]) {
        return [self.size   objectAtIndex:row];
    } else {
        exit(4);
    }
}

@end