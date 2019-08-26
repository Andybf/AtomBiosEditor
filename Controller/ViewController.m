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

const char * CompanyNames[11][2] = {
    {"1002","AMD/ATI"},
    {"106B","Apple"},
    {"1043","Asus"},
    {"1849","ASRock"},
    {"1028","Dell"},
    {"1458","Gigabyte"},
    {"1787","HIS"},
    {"1462","MSI"},
    {"148C","PowerColor"},
    {"174B","Sapphire"},
    {"1682","XFX"},
};

@implementation ViewController {
    struct ATOM_BASE_TABLE atomTable;
    AtomTables * tableView;
    struct FIRMWARE_FILE FW;
    NSArray * fileTypes;
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
        [ self initOverviewInfo: FW];
        [[self tableSelector]    setEnabled: YES];
        [[self radioHexadecimal] setEnabled: YES];
        [[self radioDecimal]     setEnabled: YES];
        [[self radioHexadecimal] setState: NSControlStateValueOn];
        [[self btnDumpTable] setEnabled:YES];
    }
}

- (IBAction)tableSelectorChanged:(id)sender {
    if ( [self.tableSelector.selectedItem.title isEqual: @"select.."] ) {
        self.tableSelector.title = @"Select..";
    } else if ( [self.tableSelector.selectedItem.title isEqual: @"Data Tables"] ) {
        self.tableSelector.title = @"Data Tables";
        [self initTableTabInfo:1];
    } else if ( [self.tableSelector.selectedItem.title isEqual: @"Command Tables"] ) {
        self.tableSelector.title = @"Command Tables";
        [self initTableTabInfo:2];
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

- (void) initOverviewInfo: (struct FIRMWARE_FILE)FW {
    //carregando o conteúdo do firmware na memória
    atomTable = loadMainTable(FW);
    [_labelFilePath setStringValue: [NSString stringWithUTF8String: FW.pathName]];
    
    [_labelArch setStringValue: [NSString stringWithFormat: @"%s",FW.architecture]];
    
    [_labelRomMsg      setStringValue: [NSString stringWithUTF8String: atomTable.romMessage]];
    [_labelPartNumber  setStringValue: [NSString stringWithUTF8String: atomTable.partNumber]];
    [_labelCompDate    setStringValue: [NSString stringWithUTF8String: atomTable.compTime]];
    [_labelBiosVersion setStringValue: [NSString stringWithUTF8String: atomTable.biosVersion]];
    [_labelDevId       setStringValue: [NSString stringWithUTF8String: (char *)atomTable.deviceId]];
    [_labelSubId       setStringValue: [NSString stringWithUTF8String: (char *)atomTable.subsystemId]];
    
    [_labelMainTableSize setStringValue: [NSString stringWithFormat:  @"%d",atomTable.size]];
    [_labelMainTableOffset setStringValue: [NSString stringWithUTF8String: "4"]];
    
    short vendor = VerifySubsystemCompanyName(atomTable,CompanyNames);
    char vendorstr[32];
    sprintf(vendorstr, "%s - %s",CompanyNames[vendor][1],(char *)atomTable.subsystemVendorId);
    [_labelVendId      setStringValue: [NSString stringWithUTF8String: vendorstr]];
    
    if (atomTable.uefiSupport != 0) {
        [_checkUefiSupport setState: NSControlStateValueOn];
        [_checkUefiSupport setTitle: @"Supported!"];
    } else {
        [_checkUefiSupport setState: NSControlStateValueOff];
        [_checkUefiSupport setTitle: @"Unsupported!"];
    }
    char chk[16];
    sprintf(chk, "Valid! - 0x%02X", atomTable.checksum);
    if ( VerifyChecksum(FW, atomTable) != 0) {
        [_checkChecksumStatus setState: NSControlStateValueOn];
        [_checkChecksumStatus setTitle: [NSString stringWithUTF8String: chk ] ];
    }
}
- (IBAction)CheckUefiChangedState:(id)sender {
    NSControlStateValue checkUefiState = [[self checkUefiSupport] state];
    if (checkUefiState != NSControlStateValueOn) {
        [[self checkUefiSupport] setState: NSControlStateValueOn];
    } else {
        [[self checkUefiSupport] setState: NSControlStateValueOff];
    }
    
}
- (IBAction)CheckCheksum:(id)sender {
    NSControlStateValue checkChecksumState = [[self checkChecksumStatus] state];
    if (checkChecksumState != NSControlStateValueOn) {
        [[self checkChecksumStatus] setState: NSControlStateValueOn];
    } else {
        [[self checkChecksumStatus] setState: NSControlStateValueOff];
    }
}
- (IBAction)RadioHexChanged:(id)sender {
    if (_radioHexadecimal.state == 1 ) {
        [_radioDecimal setState:NSControlStateValueOff];
        [self initTableTabInfo: self.tableSelector.indexOfSelectedItem];
    }
}
- (IBAction)RadioDecChanged:(id)sender {
    if (_radioDecimal.state == 1 ) {
        [_radioHexadecimal setState:NSControlStateValueOff];
        [self initTableTabInfo: self.tableSelector.indexOfSelectedItem];
    }
}

-(void) initTableTabInfo: (short)type {
    printf("Info: Index of selecteditem: %ld\n",self.tableSelector.indexOfSelectedItem);
    switch (type) {
        case 1: // Data Tables
            tableView.tableIndex  = [[NSMutableArray alloc] initWithCapacity:QUANTITY_DATA_TABLES];
            tableView.tableName   = [[NSMutableArray alloc] initWithCapacity:QUANTITY_DATA_TABLES];
            tableView.offset      = [[NSMutableArray alloc] initWithCapacity:QUANTITY_DATA_TABLES];
            tableView.size        = [[NSMutableArray alloc] initWithCapacity:QUANTITY_DATA_TABLES];
            tableView.formatRev   = [[NSMutableArray alloc] initWithCapacity:QUANTITY_DATA_TABLES];
            tableView.contentRev  = [[NSMutableArray alloc] initWithCapacity:QUANTITY_DATA_TABLES];
            for (int a=QUANTITY_COMMAND_TABLES; a<QUANTITY_TOTAL_TABLES; a++) {
                [[tableView tableName]  addObject: [NSString stringWithUTF8String:    atomTable.atomTables[a].name      ]];
                if (_radioHexadecimal.state == 1) { // Hex on
                    [[tableView tableIndex] addObject: [NSString stringWithUTF8String: atomTable.atomTables[a].id       ]];
                    [[tableView offset] addObject: [NSString stringWithFormat: @"%02X", atomTable.atomTables[a].offset  ]];
                    [[tableView size]   addObject: [NSString stringWithFormat: @"%02X", atomTable.atomTables[a].size    ]];
                } else { // Hex off
                    [[tableView tableIndex] addObject: [NSString stringWithFormat: @"%d",HexToDec(atomTable.atomTables[a].id, 2) ]];
                    [[tableView offset] addObject: [NSString stringWithFormat: @"%i", atomTable.atomTables[a].offset    ]];
                    [[tableView size]   addObject: [NSString stringWithFormat: @"%i", atomTable.atomTables[a].size      ]];
                }
                [[tableView formatRev]  addObject: [NSString stringWithFormat: @"%s", atomTable.atomTables[a].formatRev ]];
                [[tableView contentRev] addObject: [NSString stringWithFormat: @"%s", atomTable.atomTables[a].contentRev]];
            }
            break;
        case 2: // Command Tables
            tableView.tableIndex  = [[NSMutableArray alloc] initWithCapacity:QUANTITY_COMMAND_TABLES];
            tableView.tableName   = [[NSMutableArray alloc] initWithCapacity:QUANTITY_COMMAND_TABLES];
            tableView.offset      = [[NSMutableArray alloc] initWithCapacity:QUANTITY_COMMAND_TABLES];
            tableView.size        = [[NSMutableArray alloc] initWithCapacity:QUANTITY_COMMAND_TABLES];
            tableView.formatRev   = [[NSMutableArray alloc] initWithCapacity:QUANTITY_COMMAND_TABLES];
            tableView.contentRev  = [[NSMutableArray alloc] initWithCapacity:QUANTITY_COMMAND_TABLES];
            for (int a=0; a<QUANTITY_COMMAND_TABLES; a++) {
                [[tableView tableName]  addObject: [NSString stringWithUTF8String:    atomTable.atomTables[a].name      ]];
                if (_radioHexadecimal.state == 1) { // Hex on
                    [[tableView tableIndex] addObject: [NSString stringWithUTF8String: atomTable.atomTables[a].id       ]];
                    [[tableView offset] addObject: [NSString stringWithFormat: @"%02X", atomTable.atomTables[a].offset  ]];
                    [[tableView size]   addObject: [NSString stringWithFormat: @"%02X", atomTable.atomTables[a].size    ]];
                } else { // Hex off
                    [[tableView tableIndex] addObject: [NSString stringWithFormat: @"%d",HexToDec(atomTable.atomTables[a].id, 2) ]];
                    [[tableView offset] addObject: [NSString stringWithFormat: @"%i", atomTable.atomTables[a].offset    ]];
                    [[tableView size]   addObject: [NSString stringWithFormat: @"%i", atomTable.atomTables[a].size      ]];
                }
                [[tableView formatRev]  addObject: [NSString stringWithFormat: @"%s", atomTable.atomTables[a].formatRev ]];
                [[tableView contentRev] addObject: [NSString stringWithFormat: @"%s", atomTable.atomTables[a].contentRev]];
            }
            break;
        default:
            printf("Error: Invalid type of table selected.");
            exit(7);
            break;
    }
    [tableView reloadData];
}

@end
