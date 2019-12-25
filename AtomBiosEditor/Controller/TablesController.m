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
        struct ATOM_DATA_AND_CMMD_TABLES * dataAndCmmdTables;
        struct FIRMWARE_INFO * firmwareInfoData;
        struct POWERPLAY_DATA * powerPlayData;
        NSString * filename;
        NSArray * stringFormat;
        ushort rows, aInitial, aFinal;
    }

    -(void)viewDidLoad {
        [super viewDidLoad]; 
        
        [_radioDecimal setState : NSControlStateValueOn];
        stringFormat = [NSArray arrayWithObjects: @"%d",@"%02X", nil];
        // Selector Object Configuration
        NSArray * tablesSelectorList = [NSArray arrayWithObjects:@"select..",@"Data Tables",@"Command Tables", nil];
        for (int a=0; a<tablesSelectorList.count; a++) {
            [_selectorTable addItemWithTitle: tablesSelectorList[a]];
        }
        [_selectorTable setEnabled : NO];
        //Table Initialization
        tableView = [[AtomTable alloc] initWithFrame: NSMakeRect(0, 0, 440, 385)];
        [tableView initTableStructure : _buttonDumpTable : _buttonReplaceTable];
        NSScrollView * tableContainer = [[NSScrollView alloc] initWithFrame:NSMakeRect(2, 2, 440, 385)];
        // embed the table view in the scroll view, and add the scroll view
        [tableContainer setDocumentView:tableView];
        [tableContainer setHasVerticalScroller:YES];
        //Add the container to window
        [_tableBox addSubview: tableContainer];
    }

    -(void)InitTableTabInfo : (struct ATOM_DATA_AND_CMMD_TABLES *)atmtable : (char *)fileName : (struct FIRMWARE_INFO*) fwd : (struct POWERPLAY_DATA*) ppd {
        firmwareInfoData = fwd;
        powerPlayData = ppd;
        dataAndCmmdTables = atmtable;
        filename = [NSString stringWithUTF8String: fileName];
        [_selectorTable setTitle: @"select.."];
        [self ReloadTableView: 0 : _radioHexadecimal.state];
        [ tableView          setEnabled : YES];
        [_selectorTable      setEnabled : YES];
    }

    -(void) ReloadTableView: (short)tableType : (NSControlStateValue)viewMode {
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
            [[tableView tableName]  addObject: [NSString stringWithUTF8String: dataAndCmmdTables[a].name]];
            [[tableView tableIndex] addObject: [NSString stringWithFormat: stringFormat[viewMode], dataAndCmmdTables[a].index ]];
            if (dataAndCmmdTables[a].offset == 0) {
                [[tableView offset]     addObject: [NSString stringWithFormat: @""]];
                [[tableView size]       addObject: [NSString stringWithFormat: @""]];
                [[tableView formatRev]  addObject: [NSString stringWithFormat: @""]];
                [[tableView contentRev] addObject: [NSString stringWithFormat: @""]];
            } else {
                [[tableView formatRev]  addObject: [NSString stringWithFormat: stringFormat[viewMode], dataAndCmmdTables[a].formatRev ]];
                [[tableView contentRev] addObject: [NSString stringWithFormat: stringFormat[viewMode], dataAndCmmdTables[a].contentRev]];
                [[tableView offset]     addObject: [NSString stringWithFormat: stringFormat[viewMode], dataAndCmmdTables[a].offset]];
                [[tableView size]       addObject: [NSString stringWithFormat: stringFormat[viewMode], dataAndCmmdTables[a].size  ]];
            }
        }
        [tableView reloadData];
    }

    - (IBAction)tableSelectorChanged:(id)sender {
        if ( [ [[ _selectorTable selectedItem] title] isEqual: @"select.."] ) {
            [ _selectorTable setTitle: @"select.."];
        } else if ( [ [[ _selectorTable selectedItem] title] isEqual: @"Data Tables"] ) {
            [ _selectorTable setTitle: @"Data Tables"];
            [self ReloadTableView: 1 : _radioHexadecimal.state];
        } else if ( [ [[ _selectorTable selectedItem] title] isEqual: @"Command Tables"] ) {
            [ _selectorTable setTitle: @"Command Tables"];
            [self ReloadTableView: 2 : _radioHexadecimal.state];
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
            [saveFile setNameFieldStringValue: [NSString stringWithFormat: @"%@-%s.bin",self->filename,dataAndCmmdTables[selectedRow].name]];
            [saveFile beginSheetModalForWindow: self.view.window completionHandler:^(NSInteger returnCode) {
                if (returnCode == 1) { // if the save button was triggered
                    ExtractTable(self->dataAndCmmdTables[selectedRow], [saveFile.URL.path UTF8String]);
                }
            }];
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
                    ReplaceTable( &self->dataAndCmmdTables[selectedRow], selectedRow, [openPanel.URL.path UTF8String]);
                    char size[6];
                    sprintf(&size[0], "%02X", self->dataAndCmmdTables[selectedRow].content[1] & 0xff);
                    sprintf(&size[2], "%02X", self->dataAndCmmdTables[selectedRow].content[0] & 0xff);
                    self->dataAndCmmdTables[selectedRow].size = HexToDec(size, 4);
                    self->dataAndCmmdTables[selectedRow].formatRev = self->dataAndCmmdTables[selectedRow].content[2];
                    self->dataAndCmmdTables[selectedRow].contentRev = self->dataAndCmmdTables[selectedRow].content[3];
                    [self ReloadTableView: [self->_selectorTable indexOfSelectedItem ] : [self->_radioHexadecimal state ] ];
                    //Realoading tables powerplay and firmawareinfo
                    *self->powerPlayData = LoadPowerPlayData(self->dataAndCmmdTables[96]);
                    *self->firmwareInfoData = LoadFirmwareInfo(self->dataAndCmmdTables[85]);
                }
            }];
        }
    }

    - (IBAction)RadioHexChanged:(id)sender {
        if (_radioHexadecimal.state) {
            [_radioDecimal setState:NSControlStateValueOff];
            [self ReloadTableView: self.selectorTable.indexOfSelectedItem : _radioHexadecimal.state];
        }
    }
    - (IBAction)RadioDecChanged:(id)sender {
        if (_radioDecimal.state) {
            [_radioHexadecimal setState:NSControlStateValueOff];
            [self ReloadTableView: self.selectorTable.indexOfSelectedItem : _radioHexadecimal.state];
        }
    }

@end

@implementation AtomTable {
        NSString * columnIdentifiers[6];
        NSButton * buttonDump;
        NSButton * buttonReplace;
    }

    - (void)tableViewSelectionDidChange:(NSNotification *)notification {
        if ([self selectedRow] > 0) {
            [buttonDump setEnabled: YES];
            [buttonReplace setEnabled: YES];
        }
    }

    -(void)initTableStructure : (NSButton*)bDump : (NSButton*)bReplace {
        buttonDump = bDump;
        buttonReplace = bReplace;
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
        [self setDelegate:self];
        [self setDataSource: self];
        [self setAllowsColumnResizing: NO];
        [self setAllowsColumnReordering: NO];
        [self setUsesAlternatingRowBackgroundColors: YES];
        [self setEnabled: NO];
        [self reloadData];
    }

    - (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
        return _tableIndex.count;
    }

    - (id)tableView: (NSTableView*)tableView objectValueForTableColumn: (NSTableColumn*)tableColumn row:(NSInteger)row {
        //Column configurations
        [tableColumn setEditable: NO];
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
