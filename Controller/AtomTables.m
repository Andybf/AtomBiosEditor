//
//  NSObject+TableOverviewController.m
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 22/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#import "AtomTables.h"

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
        CGFloat widths[] = {35,132.5,50.0,50.0,62.5,62.5};
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
         self.cell.allowsEditingTextAttributes = NO;
        [self reloadData];
    }
    printf("Log: Table was initialized.\n");
    return self;
}

//Override Methods
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    printf("Info: function numberOfRowsInTableView triggered.\n");
    printf("Info: tableIndex Count: %lu\n",self.tableIndex.count);
    return tableIndex.count;
}

- (id)tableView: (NSTableView*)tableView objectValueForTableColumn: (NSTableColumn*)tableColumn row:(NSInteger)row {
    
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
