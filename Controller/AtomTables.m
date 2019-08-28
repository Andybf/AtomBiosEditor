//
//  NSObject+TableOverviewController.m
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 22/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#import "AtomTables.h"

NSArray * labelTexts;

@implementation AtomTables {
    
}

NSString * columnIdentifiers[1];

//Getters and Setters generator
@synthesize contentRev;
@synthesize formatRev;
@synthesize offset;
@synthesize size;
@synthesize tableIndex;
@synthesize tableName;

//Constructor Method
- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        NSString * tempColumnIdentifiers[] = {@"tableIndex",@"tableName",@"offset",@"size",@"formatRev",@"contentRev"};
        for (int a=0; a<6; a++) {
            columnIdentifiers[a] = tempColumnIdentifiers[a];
        }
        // create columns for our table
        NSTableColumn * columns[6];
        CGFloat widths[] = {35,155.0,50.0,50.0,50.0,50.0};
        NSString * titles[] = {@"Index",@"Table Name",@"Offset",@"Size",@"Fmt Rev.",@"Cnt Rev."};
        for (int a=0; a<6; a++) {
            columns[a] = [[NSTableColumn alloc] initWithIdentifier: columnIdentifiers[a]];
            [columns[a] setWidth:widths[a]];
            [columns[a] setTitle:titles[a]];
            [self       addTableColumn:columns[a]];
        }
        //[self setDelegate:self];
        [self setDataSource: self];
        [self setAllowsColumnResizing: NO];
        [self setAllowsColumnReordering: NO];
        [self reloadData];
    }
    printf("Log: Table was initialized.\n");
    return self;
}

-(void) initTableTabInfo: (short)type : (struct ATOM_BASE_TABLE *)atomTable : (NSButton*)radioHexadecimal{
    switch (type) {
        case 1: // Data Tables
            self.tableIndex  = [[NSMutableArray alloc] initWithCapacity:QUANTITY_DATA_TABLES];
            self.tableName   = [[NSMutableArray alloc] initWithCapacity:QUANTITY_DATA_TABLES];
            self.offset      = [[NSMutableArray alloc] initWithCapacity:QUANTITY_DATA_TABLES];
            self.size        = [[NSMutableArray alloc] initWithCapacity:QUANTITY_DATA_TABLES];
            self.formatRev   = [[NSMutableArray alloc] initWithCapacity:QUANTITY_DATA_TABLES];
            self.contentRev  = [[NSMutableArray alloc] initWithCapacity:QUANTITY_DATA_TABLES];
            for (int a=QUANTITY_COMMAND_TABLES; a<QUANTITY_TOTAL_TABLES; a++) {
                [[self tableName]  addObject: [NSString stringWithUTF8String:    atomTable->atomTables[a].name      ]];
                if (radioHexadecimal.state == 1) { // Hex on
                    [[self tableIndex] addObject: [NSString stringWithUTF8String: atomTable->atomTables[a].id       ]];
                    [[self offset] addObject: [NSString stringWithFormat: @"%02X", atomTable->atomTables[a].offset  ]];
                    [[self size]   addObject: [NSString stringWithFormat: @"%02X", atomTable->atomTables[a].size    ]];
                } else { // Hex off
                    [[self tableIndex] addObject: [NSString stringWithFormat: @"%d",HexToDec(atomTable->atomTables[a].id, 2) ]];
                    [[self offset] addObject: [NSString stringWithFormat: @"%i", atomTable->atomTables[a].offset    ]];
                    [[self size]   addObject: [NSString stringWithFormat: @"%i", atomTable->atomTables[a].size      ]];
                }
                [[self formatRev]  addObject: [NSString stringWithFormat: @"%s", atomTable->atomTables[a].formatRev ]];
                [[self contentRev] addObject: [NSString stringWithFormat: @"%s", atomTable->atomTables[a].contentRev]];
            }
            break;
        case 2: // Command Tables
            self.tableIndex  = [[NSMutableArray alloc] initWithCapacity:QUANTITY_COMMAND_TABLES];
            self.tableName   = [[NSMutableArray alloc] initWithCapacity:QUANTITY_COMMAND_TABLES];
            self.offset      = [[NSMutableArray alloc] initWithCapacity:QUANTITY_COMMAND_TABLES];
            self.size        = [[NSMutableArray alloc] initWithCapacity:QUANTITY_COMMAND_TABLES];
            self.formatRev   = [[NSMutableArray alloc] initWithCapacity:QUANTITY_COMMAND_TABLES];
            self.contentRev  = [[NSMutableArray alloc] initWithCapacity:QUANTITY_COMMAND_TABLES];
            for (int a=0; a<QUANTITY_COMMAND_TABLES; a++) {
                [[self tableName]  addObject: [NSString stringWithUTF8String:    atomTable->atomTables[a].name      ]];
                if (radioHexadecimal.state == 1) { // Hex on
                    [[self tableIndex] addObject: [NSString stringWithUTF8String: atomTable->atomTables[a].id       ]];
                    [[self offset] addObject: [NSString stringWithFormat: @"%02X", atomTable->atomTables[a].offset  ]];
                    [[self size]   addObject: [NSString stringWithFormat: @"%02X", atomTable->atomTables[a].size    ]];
                } else { // Hex off
                    [[self tableIndex] addObject: [NSString stringWithFormat: @"%d",HexToDec(atomTable->atomTables[a].id, 2) ]];
                    [[self offset] addObject: [NSString stringWithFormat: @"%i", atomTable->atomTables[a].offset    ]];
                    [[self size]   addObject: [NSString stringWithFormat: @"%i", atomTable->atomTables[a].size      ]];
                }
                [[self formatRev]  addObject: [NSString stringWithFormat: @"%s", atomTable->atomTables[a].formatRev ]];
                [[self contentRev] addObject: [NSString stringWithFormat: @"%s", atomTable->atomTables[a].contentRev]];
            }
            break;
        default:
            printf("Error: Invalid type of table selected.");
            exit(7);
            break;
    }
    [self reloadData];
}

//Override Methods
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    printf("Info: function numberOfRowsInTableView triggered.\n");
    printf("Info: tableIndex Count: %lu\n",self.tableIndex.count);
    return tableIndex.count;
}

- (id)tableView: (NSTableView*)tableView objectValueForTableColumn: (NSTableColumn*)tableColumn row:(NSInteger)row {
    //Column configurations
    [tableColumn setEditable:NO];
    [[tableColumn dataCell] setFont: [NSFont systemFontOfSize: 12.0] ];
    
    if        ([[tableColumn identifier] isEqualToString: columnIdentifiers[0]]) {
        return [self.tableIndex objectAtIndex:row];
    } else if ([[tableColumn identifier] isEqualToString: columnIdentifiers[1]]) {
        return [self.tableName  objectAtIndex:row];
    } else if ([[tableColumn identifier] isEqualToString: columnIdentifiers[2]]) {
        return [self.offset     objectAtIndex:row];
    } else if ([[tableColumn identifier] isEqualToString: columnIdentifiers[3]]) {
        return [self.size       objectAtIndex:row];
    } else if ([[tableColumn identifier] isEqualToString: columnIdentifiers[4]]) {
        return [self.formatRev  objectAtIndex:row];
    } else if ([[tableColumn identifier] isEqualToString: columnIdentifiers[5]]) {
        return [self.contentRev objectAtIndex:row];
    } else {
        NSLog( @"%@", [tableColumn identifier] );
        exit(4);
    }
}

@end
