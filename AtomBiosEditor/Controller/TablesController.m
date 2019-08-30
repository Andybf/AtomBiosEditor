//
//  TablesController.m
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 28/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#import "TablesController.h"

@implementation TablesController {
    AtomTable * tableView;
}

struct ATOM_BASE_TABLE atomTable;

-(void)viewDidLoad {
    [super viewDidLoad];
    // Selector Object Configuration
    NSArray * tablesSelectorList = [NSArray arrayWithObjects:@"select..",@"Data Tables",@"Command Tables", nil];
    for (int a=0; a<tablesSelectorList.count; a++) {
        [_selectorTable addItemWithTitle: tablesSelectorList[a]];
    }
    [_selectorTable setEnabled : NO];
    
    //Table Initialization
    tableView = [[AtomTable alloc] initWithFrame: NSMakeRect(0, 0, 424, 357)];
    [tableView initTableStructure];
    NSScrollView * tableContainer = [[NSScrollView alloc] initWithFrame:NSMakeRect(18, 30, 424, 357)];
    // embed the table view in the scroll view, and add the scroll view
    [tableContainer setDocumentView:tableView];
    [tableContainer setHasVerticalScroller:YES];
    //Add the container to window
    [[self view] addSubview:tableContainer];
}

-(void)EnableThisSection : (struct ATOM_BASE_TABLE *)atmtable {
    atomTable = *atmtable;
    [ tableView        setEnabled : YES];
    [_selectorTable    setEnabled : YES];
    [_radioDecimal     setEnabled : YES];
    [_buttonDumpTable  setEnabled : YES];
    [_radioHexadecimal setEnabled : YES];
    [_radioHexadecimal setState   : NSControlStateValueOn];
}

-(void) initTableTabInfo: (short)type : (struct ATOM_BASE_TABLE *)atomTable : (NSControlStateValue)HexOrDecIsEnabled{
    switch (type) {
        case 1: // Data Tables
            NSLog(@"Data tables Selected.");
            [tableView setTableIndex: [[NSMutableArray alloc] initWithCapacity:QUANTITY_DATA_TABLES]];
            [tableView setTableName : [[NSMutableArray alloc] initWithCapacity:QUANTITY_DATA_TABLES]];
            [tableView setOffset    : [[NSMutableArray alloc] initWithCapacity:QUANTITY_DATA_TABLES]];
            [tableView setSize      : [[NSMutableArray alloc] initWithCapacity:QUANTITY_DATA_TABLES]];
            [tableView setFormatRev : [[NSMutableArray alloc] initWithCapacity:QUANTITY_DATA_TABLES]];
            [tableView setContentRev: [[NSMutableArray alloc] initWithCapacity:QUANTITY_DATA_TABLES]];
            for (int a=QUANTITY_COMMAND_TABLES; a<QUANTITY_TOTAL_TABLES; a++) {
                [[tableView tableName]  addObject: [NSString stringWithUTF8String:    atomTable->atomTables[a].name      ]];
                if (HexOrDecIsEnabled) { // Hex on
                    [[tableView tableIndex] addObject: [NSString stringWithUTF8String: atomTable->atomTables[a].id       ]];
                    [[tableView offset] addObject: [NSString stringWithFormat: @"%02X", atomTable->atomTables[a].offset  ]];
                    [[tableView size]   addObject: [NSString stringWithFormat: @"%02X", atomTable->atomTables[a].size    ]];
                } else { // Hex off
                    [[tableView tableIndex] addObject: [NSString stringWithFormat: @"%d",HexToDec(atomTable->atomTables[a].id, 2) ]];
                    [[tableView offset] addObject: [NSString stringWithFormat: @"%i", atomTable->atomTables[a].offset    ]];
                    [[tableView size]   addObject: [NSString stringWithFormat: @"%i", atomTable->atomTables[a].size      ]];
                }
                [[tableView formatRev]  addObject: [NSString stringWithFormat: @"%s", atomTable->atomTables[a].formatRev ]];
                [[tableView contentRev] addObject: [NSString stringWithFormat: @"%s", atomTable->atomTables[a].contentRev]];
            }
            break;
        case 2: // Command Tables
            NSLog(@"Command tables Selected.");
            [tableView setTableIndex: [[NSMutableArray alloc] initWithCapacity:QUANTITY_COMMAND_TABLES]];
            [tableView setTableName : [[NSMutableArray alloc] initWithCapacity:QUANTITY_COMMAND_TABLES]];
            [tableView setOffset    : [[NSMutableArray alloc] initWithCapacity:QUANTITY_COMMAND_TABLES]];
            [tableView setSize      : [[NSMutableArray alloc] initWithCapacity:QUANTITY_COMMAND_TABLES]];
            [tableView setFormatRev : [[NSMutableArray alloc] initWithCapacity:QUANTITY_COMMAND_TABLES]];
            [tableView setContentRev: [[NSMutableArray alloc] initWithCapacity:QUANTITY_COMMAND_TABLES]];
            for (int a=0; a<QUANTITY_COMMAND_TABLES; a++) {
                [[tableView tableName]  addObject: [NSString stringWithUTF8String:    atomTable->atomTables[a].name      ]];
                if (HexOrDecIsEnabled) { // Hex on
                    [[tableView tableIndex] addObject: [NSString stringWithUTF8String: atomTable->atomTables[a].id       ]];
                    [[tableView offset] addObject: [NSString stringWithFormat: @"%02X", atomTable->atomTables[a].offset  ]];
                    [[tableView size]   addObject: [NSString stringWithFormat: @"%02X", atomTable->atomTables[a].size    ]];
                } else { // Hex off
                    [[tableView tableIndex] addObject: [NSString stringWithFormat: @"%d",HexToDec(atomTable->atomTables[a].id, 2) ]];
                    [[tableView offset] addObject: [NSString stringWithFormat: @"%i", atomTable->atomTables[a].offset    ]];
                    [[tableView size]   addObject: [NSString stringWithFormat: @"%i", atomTable->atomTables[a].size      ]];
                }
                [[tableView formatRev]  addObject: [NSString stringWithFormat: @"%s", atomTable->atomTables[a].formatRev ]];
                [[tableView contentRev] addObject: [NSString stringWithFormat: @"%s", atomTable->atomTables[a].contentRev]];
            }
            break;
        default:
            printf("Error: Invalid type of table selected.");
            exit(7);
            break;
    }
    [tableView reloadData];
}

- (IBAction)tableSelectorChanged:(id)sender {
    // Não é possível passar endereços (&) de @property diretamente, para resolver isso, criamos uma variavel temporária:
    struct ATOM_BASE_TABLE tempAtomTable = atomTable;
    if ( [ [[ _selectorTable selectedItem] title] isEqual: @"select.."] ) {
        [ _selectorTable setTitle: @"select.."];
    } else if ( [ [[ _selectorTable selectedItem] title] isEqual: @"Data Tables"] ) {
        [ _selectorTable setTitle: @"Data Tables"];
        [self initTableTabInfo: 1 : &tempAtomTable : _radioHexadecimal.state];
    } else if ( [ [[ _selectorTable selectedItem] title] isEqual: @"Command Tables"] ) {
        [ _selectorTable setTitle: @"Command Tables"];
        [self initTableTabInfo: 2 : &tempAtomTable : _radioHexadecimal.state];
    } else {
        exit(5);
    }
}

- (IBAction)RadioHexChanged:(id)sender {
    if (_radioHexadecimal.state == 1 ) {
        [_radioDecimal setState:NSControlStateValueOff];
        NSLog(@"%ld", (long)[_radioDecimal state]);
        [self initTableTabInfo: self.selectorTable.indexOfSelectedItem : &(atomTable) : _radioHexadecimal.state];
    }
}
- (IBAction)RadioDecChanged:(id)sender {
    if (_radioDecimal.state == 1 ) {
        [_radioHexadecimal setState:NSControlStateValueOff];
        NSLog(@"%ld", (long)[_radioDecimal state]);
        [self initTableTabInfo: self.selectorTable.indexOfSelectedItem: &(atomTable) : _radioHexadecimal.state];
    }
}

@end

@implementation AtomTable {
    NSString * columnIdentifiers[6];
}

-(void)initTableStructure {
    NSString * tempColumnIdentifiers[] = {@"tableIndex",@"tableName",@"offset",@"size",@"formatRev",@"contentRev"};
    for (int a=0; a<6; a++) {
        columnIdentifiers[a] = tempColumnIdentifiers[a];
    }
    NSTableColumn * columns[6];
    CGFloat widths[] = {35,155.0,50.0,50.0,50.0,50.0};
    NSString * titles[] = {@"Index",@"Table Name",@"Offset",@"Size",@"Fmt Rev.",@"Cnt Rev."};
    for (int a=0; a<6; a++) {
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
    printf("Info: function numberOfRowsInTableView triggered.\n");
    printf("Info: tableIndex Count: %lu\n",self.tableIndex.count);
    return _tableIndex.count;
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
