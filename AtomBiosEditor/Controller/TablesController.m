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
        struct ATOM_BASE_TABLE * atomTable;
        NSString * filename;
        NSArray * stringFormat;
        ushort rows, aInitial, aFinal;
    }

    -(void)viewDidLoad {
        [super viewDidLoad];
        
        [_radioDecimal       setState   : NSControlStateValueOn];
        stringFormat = [NSArray arrayWithObjects: @"%d",@"%02X", nil];
        // Selector Object Configuration
        NSArray * tablesSelectorList = [NSArray arrayWithObjects:@"select..",@"Data Tables",@"Command Tables", nil];
        for (int a=0; a<tablesSelectorList.count; a++) {
            [_selectorTable addItemWithTitle: tablesSelectorList[a]];
        }
        [_selectorTable setEnabled : NO];
        
        //Table Initialization
        tableView = [[AtomTable alloc] initWithFrame: NSMakeRect(0, 0, 440, 380)];
        [tableView initTableStructure];
        NSScrollView * tableContainer = [[NSScrollView alloc] initWithFrame:NSMakeRect(7, 33, 440, 380)];
        // embed the table view in the scroll view, and add the scroll view
        [tableContainer setDocumentView:tableView];
        [tableContainer setHasVerticalScroller:YES];
        //Add the container to window
        [[self view] addSubview:tableContainer];
    }

    -(void)EnableThisSection : (struct ATOM_BASE_TABLE *)atmtable : (char *)fileName {
        atomTable = atmtable;
        filename = [NSString stringWithUTF8String: fileName];
        [_selectorTable setTitle: @"select.."];
        [self initTableTabInfo: 0 : _radioHexadecimal.state];
        [ tableView          setEnabled : YES];
        [_selectorTable      setEnabled : YES];
        [_buttonDumpTable    setEnabled : YES];
        [_buttonReplaceTable setEnabled : YES];
    }

    -(void) initTableTabInfo: (short)tableType : (NSControlStateValue)viewMode {
        [_radioDecimal     setEnabled : YES];
        [_radioHexadecimal setEnabled : YES];
        switch (tableType) {
            case 0:
                rows     = 0;
                aInitial = 0;
                aFinal   = 0;
                break;
            case 1:
                rows     = QUANTITY_DATA_TABLES;
                aInitial = QUANTITY_COMMAND_TABLES;
                aFinal   = QUANTITY_TOTAL_TABLES;
                break;
            case 2:
                rows     = QUANTITY_COMMAND_TABLES;
                aInitial = 0;
                aFinal   = QUANTITY_COMMAND_TABLES;
                break;
        }
        [tableView setTableIndex: [[NSMutableArray alloc] initWithCapacity: rows]];
        [tableView setTableName : [[NSMutableArray alloc] initWithCapacity: rows]];
        [tableView setOffset    : [[NSMutableArray alloc] initWithCapacity: rows]];
        [tableView setSize      : [[NSMutableArray alloc] initWithCapacity: rows]];
        [tableView setFormatRev : [[NSMutableArray alloc] initWithCapacity: rows]];
        [tableView setContentRev: [[NSMutableArray alloc] initWithCapacity: rows]];
        for (int a=aInitial; a<aFinal; a++) {
            [[tableView tableName]  addObject: [NSString stringWithUTF8String: atomTable->atomTables[a].name]];
            [[tableView tableIndex] addObject: [NSString stringWithFormat: stringFormat[viewMode], atomTable->atomTables[a].id ]];
            if (atomTable->atomTables[a].offset == 0) {
                [[tableView offset]     addObject: [NSString stringWithFormat: @""]];
                [[tableView size]       addObject: [NSString stringWithFormat: @""]];
                [[tableView formatRev]  addObject: [NSString stringWithFormat: @""]];
                [[tableView contentRev] addObject: [NSString stringWithFormat: @""]];
            } else {
                [[tableView formatRev]  addObject: [NSString stringWithFormat: stringFormat[viewMode], atomTable->atomTables[a].formatRev ]];
                [[tableView contentRev] addObject: [NSString stringWithFormat: stringFormat[viewMode], atomTable->atomTables[a].contentRev]];
                [[tableView offset]     addObject: [NSString stringWithFormat: stringFormat[viewMode], atomTable->atomTables[a].offset]];
                [[tableView size]       addObject: [NSString stringWithFormat: stringFormat[viewMode], atomTable->atomTables[a].size  ]];
            }
        }
        [tableView reloadData];
    }

    - (IBAction)tableSelectorChanged:(id)sender {
        if ( [ [[ _selectorTable selectedItem] title] isEqual: @"select.."] ) {
            [ _selectorTable setTitle: @"select.."];
        } else if ( [ [[ _selectorTable selectedItem] title] isEqual: @"Data Tables"] ) {
            [ _selectorTable setTitle: @"Data Tables"];
            [self initTableTabInfo: 1 : _radioHexadecimal.state];
        } else if ( [ [[ _selectorTable selectedItem] title] isEqual: @"Command Tables"] ) {
            [ _selectorTable setTitle: @"Command Tables"];
            [self initTableTabInfo: 2 : _radioHexadecimal.state];
        } else {
            exit(5);
        }
    }

    - (IBAction)DumpButtonTriggered:(id)sender {
        NSSavePanel * saveFile = [NSSavePanel savePanel];
        long selectedRow;
        
        if (self->tableView.selectedRow > -1) {
            if ([self.selectorTable.title isEqualToString: @"Command Tables"]) {
                selectedRow = tableView.selectedRow;
            } else {
                selectedRow = tableView.selectedRow+QUANTITY_COMMAND_TABLES;
            }
            [saveFile setNameFieldStringValue: [NSString stringWithFormat: @"%@-%s.bin",self->filename, atomTable->atomTables[selectedRow].name]];
            [saveFile beginSheetModalForWindow: self.view.window completionHandler:^(NSInteger returnCode) {
                if (returnCode == 1) { // if the save button was triggered
                    ExtractTable(self->atomTable->atomTables[selectedRow], [saveFile.URL.path UTF8String]);
                }
            }];
        } else {
            //[self DisplayAlert: @"No table was selected" :@"Please, select the table that you want to extract."];
        }
    }
    - (IBAction)ButtonReplaceTriggered:(id)sender {
        NSOpenPanel* openPanel = [NSOpenPanel openPanel]; //Criando objeto NSOpenPanel
        //Configuração
        openPanel.allowsMultipleSelection = false;
        openPanel.canChooseDirectories    = false;
        openPanel.canChooseFiles          = true;
        
        long selectedRow;
        if (self->tableView.selectedRow > -1) {
            if ([self.selectorTable.title isEqualToString: @"Command Tables"]) {
                selectedRow = tableView.selectedRow;
            } else {
                selectedRow = tableView.selectedRow + QUANTITY_COMMAND_TABLES;
            }
            [openPanel beginSheetModalForWindow: self.view.window completionHandler:^(NSModalResponse result) {
                if (openPanel.URL.path != NULL) {
                    //ReplaceTable((char*)[self->filename UTF8String], self->atomTable, selectedRow, [openPanel.URL.path UTF8String]);
                    
                    self->atomTable->atomTables[selectedRow].offset = 0;
                    self->atomTable->atomTables[selectedRow].size = 0;
                    self->atomTable->atomTables[selectedRow].formatRev = 0;
                    self->atomTable->atomTables[selectedRow].contentRev = 0;
                }
            }];
        }
    }

    - (IBAction)RadioHexChanged:(id)sender {
        if (_radioHexadecimal.state) {
            [_radioDecimal setState:NSControlStateValueOff];
            [self initTableTabInfo: self.selectorTable.indexOfSelectedItem : _radioHexadecimal.state];
        }
    }
    - (IBAction)RadioDecChanged:(id)sender {
        if (_radioDecimal.state) {
            [_radioHexadecimal setState:NSControlStateValueOff];
            [self initTableTabInfo: self.selectorTable.indexOfSelectedItem : _radioHexadecimal.state];
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
        CGFloat widths[] = {35,175.0,50.0,50.0,50.0,50.0};
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
            exit(4);
        }
    }
@end
