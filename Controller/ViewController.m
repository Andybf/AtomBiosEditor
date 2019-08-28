//
//  ViewController.m
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 18/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#import "ViewController.h"
#import "../Core/TableLoader.h"
#import "AtomTables.h"


extern int HexToDec(char[], int);

@implementation ViewController {
    struct ATOM_BASE_TABLE atomTable;
    AtomTables * tableView;
    struct FIRMWARE_FILE FW;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    tableView = [[AtomTables alloc] initWithFrame: NSMakeRect(0, 0, 420, 356)];
    NSScrollView * tableContainer = [[NSScrollView alloc] initWithFrame:NSMakeRect(17, 34, 420, 356)];
    // embed the table view in the scroll view, and add the scroll view
    [tableContainer setDocumentView:tableView];
    [tableContainer setHasVerticalScroller:YES];
    //Add the container to window
    [self.tableTabView addSubview:tableContainer];
    
    // Table Tab selector configuration
    NSArray * tables = [NSArray arrayWithObjects:@"select..",@"Data Tables",@"Command Tables", nil];
    for (int a=0; a<tables.count; a++) {
        [[self tableSelector] addItemWithTitle: tables[a]];
    }
    [[self tableSelector] setEnabled : NO];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    // Update the view, if already loaded.
}

- (IBAction)btnOpenFileTriggered: (id)sender {
    //Criando objeto NSOpenPanel
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    //Configuração
    openPanel.allowsMultipleSelection = false;
    openPanel.canChooseDirectories = false;
    openPanel.canChooseFiles = true;
    
    //Instanciando o painel
    if ([openPanel runModal] == NSModalResponseOK) {
        FW.pathName = [openPanel.URL.path UTF8String];
        //carregando o arquivo para dentro da memoria
        if (! (FW.file = fopen(FW.pathName ,"r")) ) {
            [self DisplayAlert : @"File not found!" : @"Please check if the file exists in the path."];
        } else {
            stat(FW.pathName ,&FW.fileInfo); //Carregando informações sobre o arquivo
            if (! CheckFirmwareSize(FW.fileInfo) ) {
                [self DisplayAlert: @"Invalid File Size!" : @"The size of the file selected is invalid, the file must be between 64KB and 256KB."];
                exit(1);
            }
            if (! CheckFirmwareSignature(FW.file) ) {
                [self DisplayAlert : @"Invalid Firmware Signature!" : @"The firmware signature indicates that the file file is corrupted or another kind of binary data."];
                exit(2);
            }
            if (! CheckFirmwareArchitecture(FW.file)) {
                [self DisplayAlert : @"Architecture not supported!" : @"This firmware architecture is not support by this program."];
                exit(3);
            }
        }
        [_labelFilePath setStringValue: [NSString stringWithUTF8String: FW.pathName]];
        
        OverviewInfo * overviewInfo = [[OverviewInfo alloc] init];
        [overviewInfo initOverviewInfo: FW : &(atomTable) : self];
        
        [[self tableSelector]    setEnabled: YES];
        [[self radioHexadecimal] setEnabled: YES];
        [[self radioDecimal]     setEnabled: YES];
        [[self btnDumpTable]     setEnabled: YES];
        [[self radioHexadecimal] setState: NSControlStateValueOn];
        
    }
}

- (IBAction)tableSelectorChanged:(id)sender {
    if ( [self.tableSelector.selectedItem.title isEqual: @"select.."] ) {
        self.tableSelector.title = @"Select..";
    } else if ( [self.tableSelector.selectedItem.title isEqual: @"Data Tables"] ) {
        self.tableSelector.title = @"Data Tables";
        [tableView initTableTabInfo: 1 : &(atomTable) : _radioHexadecimal];
    } else if ( [self.tableSelector.selectedItem.title isEqual: @"Command Tables"] ) {
        self.tableSelector.title = @"Command Tables";
        [tableView initTableTabInfo: 2 : &(atomTable) : _radioHexadecimal];
    } else {
        NSLog(@"Error: Invalid selected item.");
        exit(5);
    }
}
- (IBAction)DumpButtonTriggered:(id)sender {
    printf("Info: Clicked Row: %ld\n",(long)self->tableView.selectedRow);
    NSSavePanel * saveFile = [NSSavePanel savePanel];
    long selectedRow;
    
    if (self->tableView.selectedRow > -1) {
        if ([self->_tableSelector.title isEqualToString: @"Command Tables"]) {
            selectedRow = tableView.selectedRow;
        } else {
            selectedRow = tableView.selectedRow+QUANTITY_COMMAND_TABLES;
        }
        [saveFile setNameFieldStringValue: [NSString stringWithFormat: @"%s.bin",atomTable.atomTables[selectedRow].name]];
        [saveFile beginSheetModalForWindow: self.view.window completionHandler:^(NSInteger returnCode) {
            if (returnCode == 1) { // if the save button was triggered
                printf("path %s\n",[saveFile.URL.path UTF8String]);
                    ExtractTable(self->FW.file, self->atomTable.atomTables[selectedRow], [saveFile.URL.path UTF8String]);
            }
        }];
    } else {
        [self DisplayAlert: @"No table was selected" :@"Please seleted the table that you want to extract"];
    }
    
}

- (void) DisplayAlert : (NSString *) title : (NSString *) info  {
    //Craindo um alerta
    NSAlert * alert = [NSAlert new];
    //Configuração
    alert.messageText = title;
    alert.informativeText = info;
    alert.alertStyle = NSAlertStyleCritical;
    //Instanciando
    [alert runModal];
}

- (IBAction)RadioHexChanged:(id)sender {
    if (_radioHexadecimal.state == 1 ) {
        [_radioDecimal setState:NSControlStateValueOff];
        [tableView initTableTabInfo: self.tableSelector.indexOfSelectedItem : &(atomTable) : _radioHexadecimal];
    }
}
- (IBAction)RadioDecChanged:(id)sender {
    if (_radioDecimal.state == 1 ) {
        [_radioHexadecimal setState:NSControlStateValueOff];
        [tableView initTableTabInfo: self.tableSelector.indexOfSelectedItem: &(atomTable) : _radioHexadecimal];
    }
}


@end
