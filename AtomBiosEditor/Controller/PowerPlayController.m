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
        {18,311,425,106},
        {18,172,425,106},
        {18,33,425,106}
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
    NSLog(@"PowerPlay tables initializing.");
    [stTable[0] setEnabled: YES];
    powerPlay = ShowPowerPlayData(firmware, atomTable->atomTables[QUANTITY_COMMAND_TABLES+0x0F]);
    
    [stTable[0] setIndex     : [[NSMutableArray alloc] initWithCapacity: powerPlay.numberOfStates]];
    [stTable[0] setValue     : [[NSMutableArray alloc] initWithCapacity: powerPlay.numberOfStates]];
    [stTable[0] setOffset    : [[NSMutableArray alloc] initWithCapacity: powerPlay.numberOfStates]];
    [stTable[0] setSize      : [[NSMutableArray alloc] initWithCapacity: powerPlay.numberOfStates]];
    
    for (int a=0; a<powerPlay.numberOfStates; a++) {
        [[stTable[0] index] addObject: [NSString stringWithFormat: @"%d",a+1]];
        [[stTable[0] value] addObject: [NSString stringWithFormat: @"%s",powerPlay.gpuClock[a]]];
        [[stTable[0] offset] addObject: [NSString stringWithFormat: @"%s",powerPlay.memClock[a]]];
        [[stTable[0] size] addObject: [NSString stringWithFormat: @"%s",powerPlay.voltage[a]]];
    }
    

    [stTable[0] reloadData];
}

@end

@implementation StatesTable {
    NSString * columnIdentifiers[4];
}

-(void)initTableStructure : (short)type{
    
    CGFloat widths[] = {60.0,120.0,120.0,100.0};
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
    printf("Info: PowerPlay function numberOfRowsInTableView triggered.\n");
    printf("Info: PowerPlay index Count: %lu\n",self.index.count);
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
        NSLog( @"%@", [tableColumn identifier] );
        exit(4);
    }
}

@end
