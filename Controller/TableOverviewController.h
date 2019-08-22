//
//  NSObject+TableOverviewController.h
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 22/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface TableOverviewController : NSObject <NSTableViewDataSource>

@property (nonatomic, strong) NSArray * columnDesc;

@property (nonatomic, strong) NSArray * value;

@end

NS_ASSUME_NONNULL_END
