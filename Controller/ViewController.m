//
//  ViewController.m
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 18/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#import "ViewController.h"
#import "../Core/TableLoader.h"


extern int HexToDec(char[], int);

@implementation ViewController {
    struct FIRMWARE_FILE FW;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [[AtomTables alloc] initWithFrame: NSMakeRect(0, 0, 420, 356) : self];
    NSScrollView * tableContainer = [[NSScrollView alloc] initWithFrame:NSMakeRect(17, 34, 420, 356)];
    // embed the table view in the scroll view, and add the scroll view
    [tableContainer setDocumentView:_tableView];
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
    NSOpenPanel* openPanel = [NSOpenPanel openPanel]; //Criando objeto NSOpenPanel
    //Configuração
    openPanel.allowsMultipleSelection = false;
    openPanel.canChooseDirectories    = false;
    openPanel.canChooseFiles          = true;
    [openPanel beginSheetModalForWindow: self.view.window completionHandler:^(NSModalResponse result) {
        self->FW.pathName = [openPanel.URL.path UTF8String];
        if ( (self->FW.file = fopen(self->FW.pathName ,"r")) ) { //carregando o arquivo para dentro da memoria
            stat(self->FW.pathName ,&self->FW.fileInfo); //Carregando informações sobre o arquivo
            if (! CheckFirmwareSize(self->FW.fileInfo) ) {
                [self DisplayAlert: @"Invalid File Size!" : @"The size of the file selected is invalid, the file size must be between 64KB and 256KB."];
                exit(1);
            } if (! CheckFirmwareSignature(self->FW.file) ) {
                [self DisplayAlert : @"Invalid Firmware Signature!" : @"The firmware signature indicates that the file is a AMD Atom BIOS."];
                exit(2);
            } if (! CheckFirmwareArchitecture(self->FW.file)) {
                [self DisplayAlert : @"Architecture not supported!" : @"This firmware architecture is not support by this program."];
                exit(3);
            }
        }
        [self->_labelFilePath setStringValue: [NSString stringWithUTF8String: self->FW.pathName]];
        OverviewController * oc = [[OverviewController alloc] init];
        //OverviewInfo * overviewInfo = [[OverviewInfo alloc] init];
        //[overviewInfo initOverviewInfo: self->FW : &(self->_atomTable) : self];
        [self->_labelRomMsg setStringValue: [NSString stringWithUTF8String: "teste"]];
        [[self tableSelector]    setEnabled: YES];
        [[self radioDecimal]     setEnabled: YES];
        [[self btnDumpTable]     setEnabled: YES];
        [[self radioHexadecimal] setEnabled: YES];
        [[self radioHexadecimal] setState: NSControlStateValueOn];
    }];
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


- (IBAction)DumpButtonTriggered:(id)sender {
    printf("Info: Clicked Row: %ld\n",(long)self->_tableView.selectedRow);
    NSSavePanel * saveFile = [NSSavePanel savePanel];
    long selectedRow;
    
    if (self->_tableView.selectedRow > -1) {
        if ([self->_tableSelector.title isEqualToString: @"Command Tables"]) {
            selectedRow = _tableView.selectedRow;
        } else {
            selectedRow = _tableView.selectedRow+QUANTITY_COMMAND_TABLES;
        }
        [saveFile setNameFieldStringValue: [NSString stringWithFormat: @"%s.bin",_atomTable.atomTables[selectedRow].name]];
        [saveFile beginSheetModalForWindow: self.view.window completionHandler:^(NSInteger returnCode) {
            if (returnCode == 1) { // if the save button was triggered
                printf("path %s\n",[saveFile.URL.path UTF8String]);
                ExtractTable(self->FW.file, self->_atomTable.atomTables[selectedRow], [saveFile.URL.path UTF8String]);
            }
        }];
    } else {
        [self DisplayAlert: @"No table was selected" :@"Please, select the table that you want to extract."];
    }
}
- (IBAction)RadioHexChanged:(id)sender {
    if (_radioHexadecimal.state == 1 ) {
        [_radioDecimal setState:NSControlStateValueOff];
        [_tableView initTableTabInfo: self.tableSelector.indexOfSelectedItem : &(_atomTable) : _radioHexadecimal];
    }
}
- (IBAction)RadioDecChanged:(id)sender {
    if (_radioDecimal.state == 1 ) {
        [_radioHexadecimal setState:NSControlStateValueOff];
        [_tableView initTableTabInfo: self.tableSelector.indexOfSelectedItem: &(_atomTable) : _radioHexadecimal];
    }
}

@end
