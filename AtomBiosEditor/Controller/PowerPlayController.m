//
//  PowerPlayController.m
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 30/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#import "PowerPlayController.h"

@implementation PowerPlayController {
        NSArray * stringFormat;
        NSScrollView * tableContainer[3];
        struct ATOM_DATA_AND_CMMD_TABLES * dcTable;
        struct POWERPLAY_DATA pPlay;
    }

    -(void)viewDidLoad {
        [super viewDidLoad];
        stringFormat = [NSArray arrayWithObjects: @"%d",@"%02X", nil];
        [_radioDecimal setState: NSControlStateValueOn];
        [_radioDecimal     setEnabled : YES];
        [_radioHexadecimal setEnabled : YES];
    }

    -(void) InitPowerPlayInfo : (struct ATOM_DATA_AND_CMMD_TABLES *)dataAndCmmdTables : (struct POWERPLAY_DATA *)powerPlay : (short)HexActived{
        
        for (int c=0; c<3; c++) {
            tableContainer[c] = [[NSScrollView alloc] initWithFrame:NSMakeRect(3,3,439,120)];
            stTable[c] = [[StatesTable alloc] initWithFrame: NSMakeRect(0,0,439,120)];
            if (! (c==0) ) {
                [stTable[c] initTableStructure: 0 : powerPlay];
            } else {
                [stTable[c] initTableStructure: 1 : powerPlay];
            }
            [tableContainer[c] setDocumentView: stTable[c]];
            [tableContainer[c] setHasVerticalScroller:YES];
            [_BoxPowerPlay addSubview:tableContainer[0]];
            [_BoxGpuStates addSubview:tableContainer[1]];
            [_BoxMemStates addSubview:tableContainer[2]];
        }
        
        pPlay = *powerPlay;
        dcTable = dataAndCmmdTables;
        ushort rows[3] = { powerPlay->numberOfStates, powerPlay->numberOfGpuStates, powerPlay->numberOfMemStates};
        
        for (int a=0; a<3; a++) {
            [stTable[a] setIndex     : [[NSMutableArray alloc] initWithCapacity: rows[HexActived] ]];
            [stTable[a] setClock     : [[NSMutableArray alloc] initWithCapacity: rows[HexActived] ]];
            [stTable[a] setOffset    : [[NSMutableArray alloc] initWithCapacity: rows[HexActived] ]];
            [stTable[a] setSize      : [[NSMutableArray alloc] initWithCapacity: rows[HexActived] ]];
        }
        for (int a=0; a<powerPlay->numberOfStates; a++) {
            [[stTable[0] index]  addObject: [NSString stringWithFormat: stringFormat[HexActived],a+1]];
            [[stTable[0] Clock]  addObject: [NSString stringWithFormat: stringFormat[HexActived],powerPlay->gpuClock[a]]];
            [[stTable[0] offset] addObject: [NSString stringWithFormat: stringFormat[HexActived],powerPlay->memClock[a]]];
            [[stTable[0] size]   addObject: [NSString stringWithFormat: stringFormat[HexActived],powerPlay->voltage[a]]];
            [stTable[0] setEnabled: YES];
        }
        
        for (int a=0; a<powerPlay->numberOfGpuStates; a++) {
            [[stTable[1] index]  addObject: [NSString stringWithFormat: stringFormat[HexActived],a+1]];
            [[stTable[1] Clock]  addObject: [NSString stringWithFormat: stringFormat[HexActived],powerPlay->gpuFreqState[a] ]];
            [[stTable[1] offset] addObject: [NSString stringWithFormat: stringFormat[HexActived],powerPlay->gpuFreqOffset + dataAndCmmdTables[QUANTITY_COMMAND_TABLES+0x0F].offset + a * 3 ]];
            [[stTable[1] size]   addObject: [NSString stringWithFormat: stringFormat[HexActived],3]];
            [stTable[1] setEnabled:NO];
        }
        
        for (int a=0; a<powerPlay->numberOfMemStates; a++) {
            [[stTable[2] index]  addObject: [NSString stringWithFormat: stringFormat[HexActived],a+1]];
            [[stTable[2] Clock]  addObject: [NSString stringWithFormat: stringFormat[HexActived],powerPlay->memFreqState[a] ]];
            [[stTable[2] offset] addObject: [NSString stringWithFormat: stringFormat[HexActived],powerPlay->memFreqOffset + dataAndCmmdTables[QUANTITY_COMMAND_TABLES+0x0F].offset + a * 3 ]];
            [[stTable[2] size]   addObject: [NSString stringWithFormat: stringFormat[HexActived],3]];
            [stTable[2] setEnabled:NO];
        }
        for (int a=0; a<3; a++){
            [stTable[a] reloadData];
        }
    }

    - (IBAction)RadioHexChanged:(id)sender {
        if (_radioHexadecimal.state) {
            [_radioDecimal setState:NSControlStateValueOff];
            [self InitPowerPlayInfo : dcTable : &(pPlay) : 1];
        }
    }

    - (IBAction)RadioDecChanged:(id)sender {
        if (_radioDecimal.state) {
            [_radioHexadecimal setState:NSControlStateValueOff];
            [self InitPowerPlayInfo : dcTable : &(pPlay) : 0];
        }
    }
@end

@implementation StatesTable {
        NSString * columnIdentifiers[4];
        struct POWERPLAY_DATA * powerPlay;
    }

    -(void)initTableStructure : (short)type : (struct POWERPLAY_DATA *)pPlay {
        powerPlay = pPlay;
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
        [self setDelegate:self];
        [self setDataSource: self];
        [self setAllowsColumnResizing: NO];
        [self setAllowsColumnReordering: NO];
        [self setAllowsMultipleSelection: NO];
        [self setUsesAlternatingRowBackgroundColors: YES];
        [self reloadData];
    }

    - (void)tableViewSelectionDidChange:(NSNotification *)notification {
        //PlaceHolder
    }

    // Update the datacell modified bt the user
    - (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
        NSLog(@"Identifier: %@",[tableColumn identifier]);
        if ([[tableColumn identifier]  isEqual: @"gpu"]) {
            for (int a=0; a<powerPlay->numberOfGpuStates; a++) {
                if (powerPlay->gpuFreqState[a] == powerPlay->gpuClock[row]) {
                    [_Clock replaceObjectAtIndex:row withObject: object];
                    powerPlay->gpuClock[row] = [object intValue];
                    powerPlay->gpuFreqState[a] = powerPlay->gpuClock[row];
                }
            }
            [_Clock replaceObjectAtIndex:row withObject: object];
            powerPlay->gpuClock[row] = [object intValue];
        } else if ([[tableColumn identifier] isEqual: @"voltage"]) {
            for (int a=0; a<powerPlay->numberOfMemStates; a++) {
                printf("%d | %d \n",powerPlay->memFreqState[a],powerPlay->memClock[row]);
                if (powerPlay->memFreqState[a] == powerPlay->memClock[row]) {
                    [_offset replaceObjectAtIndex:row withObject: object];
                    powerPlay->memClock[row] = [object intValue];
                    powerPlay->memFreqState[a] = powerPlay->memClock[row];
                }
            }
            [_offset replaceObjectAtIndex:row withObject: object];
            powerPlay->memClock[row] = [object intValue];
        } else if ([[tableColumn identifier] isEqual: @"size"]) {
            [_size replaceObjectAtIndex:row withObject: object];
            powerPlay->voltage[row] = [object intValue];
        }
    }

    - (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
        return _index.count;
    }

    - (id)tableView: (NSTableView*)tableView objectValueForTableColumn: (NSTableColumn*)tableColumn row:(NSInteger)row {
        //Column configurations
        [tableColumn setEditable: YES];
        [[tableColumn dataCell] setFont: [NSFont systemFontOfSize: 12.0] ];
        if        ([[tableColumn identifier] isEqualToString: columnIdentifiers[0]]) {
            [tableColumn setEditable: NO];
            return [self.index  objectAtIndex:row];
        } else if ([[tableColumn identifier] isEqualToString: columnIdentifiers[1]]) {
            return [self.Clock  objectAtIndex:row];
        } else if ([[tableColumn identifier] isEqualToString: columnIdentifiers[2]]) {
            return [self.offset objectAtIndex:row];
        } else if ([[tableColumn identifier] isEqualToString: columnIdentifiers[3]]) {
            return [self.size   objectAtIndex:row];
        } else {
            exit(4);
        }
    }
@end
