//
//  NSWindowController+WindowController.h
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 18/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface WindowController : NSWindowController

@property IBOutlet NSWindow * varWindow;

- (int) changeTitle : (NSString*)newTitle;


@end

NS_ASSUME_NONNULL_END
