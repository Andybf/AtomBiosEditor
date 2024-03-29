//
//  PowerPalyController.h
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 30/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

#import "../Model/AtomBios.h"
#import "../Model/PowerPlay.h"

@interface StatesTable : NSTableView <NSTableViewDataSource,NSTableViewDelegate>

    @property (nonatomic, strong) NSMutableArray * index;
    @property (nonatomic, strong) NSMutableArray * Clock;
    @property (nonatomic, strong) NSMutableArray * offset;
    @property (nonatomic, strong) NSMutableArray * size;

    -(void) initTableStructure : (short)type : (struct POWERPLAY_DATA *)pPlay;

@end

@interface PowerPlayController : NSViewController {
        StatesTable * stTable[3];
    }

    @property (weak) IBOutlet NSView *BoxPowerPlay;
    @property (weak) IBOutlet NSBox  *BoxGpuStates;
    @property (weak) IBOutlet NSBox  *BoxMemStates;

    @property (weak) IBOutlet NSButton *radioHexadecimal;
    @property (weak) IBOutlet NSButton *radioDecimal;

    -(void) InitPowerPlayInfo : (struct ATOM_DATA_AND_CMMD_TABLES *)dataAndCmmdTables : (struct POWERPLAY_DATA *)powerPlay : (short)HexActived;

@end

