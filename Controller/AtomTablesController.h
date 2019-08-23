//
//  NSObject+TableOverviewController.h
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 22/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

#import "AtomTablesController.h"
#import "../Core/ABELibrary.h"


NS_ASSUME_NONNULL_BEGIN

@interface AtomTablesController : NSObject <NSTableViewDataSource>

@property (nonatomic, strong) NSMutableArray * tableIndex;
@property (nonatomic, strong) NSMutableArray * tableName;
@property (nonatomic, strong) NSArray * offset;
@property (nonatomic, strong) NSArray * size;
@property (nonatomic, strong) NSArray * formatRev;
@property (nonatomic, strong) NSArray * contentRev;

@end

NS_ASSUME_NONNULL_END
