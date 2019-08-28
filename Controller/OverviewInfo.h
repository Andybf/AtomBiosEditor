//
//  OverviewInfo.h
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 26/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

#import "ViewController.h"
#import "../Core/TableLoader.h"

NS_ASSUME_NONNULL_BEGIN

@interface OverviewInfo : NSObject



- (void) initOverviewInfo: (struct FIRMWARE_FILE)FW : (struct ATOM_BASE_TABLE*)atomTable : (NSViewController *)vc;

@end

NS_ASSUME_NONNULL_END
