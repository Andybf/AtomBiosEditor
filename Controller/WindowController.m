//
//  NSWindowController+WindowController.m
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 18/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#import "WindowController.h"

@implementation WindowController

- (void) windowDidLoad {
    [super windowDidLoad];
    [[self window] setTitle:@"AtomBiosEditor"];
    printf("Info: Main window has loaded\n");
}

- (int) changeTitle : (NSString*)newTitle {
    [[self window] setTitle:newTitle];
    
    return 0;
}

@end


