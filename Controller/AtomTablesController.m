//
//  NSObject+TableOverviewController.m
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 22/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#import "AtomTablesController.h"

@implementation AtomTablesController

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    printf("Info: function numberOfRowsInTableView triggered.\n");
    printf("Info: tableIndex Count: %lu\n",self.tableIndex.count);
    return self.tableIndex.count;
    
}

- (id)tableView: (NSTableView*)tableView objectValueForTableColumn: (NSTableColumn*)tableColumn row:(NSInteger)row {
    if ([[tableColumn identifier] isEqualToString:@"tableIndex"]) {
        tableView.dataSource = self;
        return [self.tableIndex objectAtIndex:row];
    } else {
        return [self.tableName objectAtIndex:row];
    }
}

-(void)initTableTab {
    printf("teste inauguração!\n");
    NSMutableArray * indexTable = [[NSMutableArray alloc] initWithCapacity: QUANTITY_COMMAND_TABLES]; // = 81
    for (int a=0; a<QUANTITY_COMMAND_TABLES; a++) {
        indexTable[a] = @"teste";//[NSString stringWithUTF8String: atomTable.atomTables[a].id];
    }
}

@end
