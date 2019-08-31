//
//  PowerPalyController.h
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 30/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

#import "../Model/TableLoader.h"
#import "../Model/FileLoader.h"
#import "../Model/Modules/PowerPlay/PowerPlay.h"

@interface StatesTable : NSTableView <NSTableViewDataSource>

    @property (nonatomic, strong) NSMutableArray * index;
    @property (nonatomic, strong) NSMutableArray * value;
    @property (nonatomic, strong) NSMutableArray * offset;
    @property (nonatomic, strong) NSMutableArray * size;

-(void) initTableStructure : (short)type;

@end


@interface PowerPlayController : NSViewController {
    StatesTable * stTable[3];
}

-(void) initTableInfo : (struct ATOM_BASE_TABLE *)atomTable : (FILE *)firmware;

@end

