//
//  TablesController.h
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 28/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

#import "../Model/AtomBios.h"
#import "../Model/CoreFunctions.h"

@interface TablesController : NSViewController

    @property (weak) IBOutlet NSPopUpButton *selectorTable;
    @property (weak) IBOutlet NSButton *buttonDumpTable;
    @property (weak) IBOutlet NSButton *buttonReplaceTable;
    @property (weak) IBOutlet NSButton *radioHexadecimal;
    @property (weak) IBOutlet NSButton *radioDecimal;

    -(void) ReloadTableView: (short)type : (NSControlStateValue)HexOrDecIsEnabled;
    -(void) InitTableTabInfo : (struct ATOM_DATA_AND_CMMD_TABLES *)atmtable : (char *)fileName;

@end


@interface AtomTable : NSTableView <NSTableViewDataSource,NSTableViewDelegate>

    @property (nonatomic, strong) NSMutableArray * tableIndex;
    @property (nonatomic, strong) NSMutableArray * tableName;
    @property (nonatomic, strong) NSMutableArray * offset;
    @property (nonatomic, strong) NSMutableArray * size;
    @property (nonatomic, strong) NSMutableArray * formatRev;
    @property (nonatomic, strong) NSMutableArray * contentRev;

    -(void) initTableStructure : (NSButton*)bDump : (NSButton*)bReplace;

@end
