//
//  NSObject+TableOverviewController.m
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 22/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#import "TableOverviewController.h"

@implementation TableOverviewController

- (NSArray*)columnDesc {
    if (!_columnDesc) {
        _columnDesc = @[
                        @"Rom Message",@"Part Number",@"Compilation Date",
                        @"BIOS Version",@"Device ID",@"Subsystem ID",
                        @"Vendor ID",@"Checksum",@"UEFI Support"
        ];
    }
    return _columnDesc;
}

- (NSArray*)value {
    if (!_value) {
        _value = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
    }
    NSLog(@"%@", _value[0]);
    return _value;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.columnDesc.count;
    
}

- (id)tableView: (NSTableView*)tableView objectValueForTableColumn: (NSTableColumn*)tableColumn row:(NSInteger)row {
    if ([[tableColumn identifier] isEqualToString:@"columnDesc"]) {
        tableView.dataSource = self;
        return [self.columnDesc objectAtIndex:row];
    } else {
        return [self.value objectAtIndex:row];
    }
}

@end
