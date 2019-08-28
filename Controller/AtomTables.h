//
//  NSObject+TableOverviewController.h
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 22/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

#import "../Core/CoreFunctions.h"
#import "../Core/TableLoader.h"

NS_ASSUME_NONNULL_BEGIN

@interface AtomTables : NSTableView <NSTableViewDataSource> {
   
}

@property (weak) IBOutlet NSView *tableTabView;

@property (nonatomic, strong) NSMutableArray * tableIndex;
@property (nonatomic, strong) NSMutableArray * tableName;
@property (nonatomic, strong) NSMutableArray * offset;
@property (nonatomic, strong) NSMutableArray * size;
@property (nonatomic, strong) NSMutableArray * formatRev;
@property (nonatomic, strong) NSMutableArray * contentRev;

- (id)initWithFrame: (NSRect)frameRect : (NSViewController *)vc;
- (void) initTableTabInfo: (short)type : (struct ATOM_BASE_TABLE *)atomTable : (NSButton*)radioHexadecimal;

@end

NS_ASSUME_NONNULL_END
