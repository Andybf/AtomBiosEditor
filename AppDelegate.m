//
//  AppDelegate.m
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 18/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#import "AppDelegate.h"
#import "Core/FileLoader.h"
#import "WindowController.h"


@interface AppDelegate ()

@end

extern FileLoader * l;

@implementation AppDelegate

- (IBAction)openMenuItemClicked:(id)sender {
    l = [[FileLoader alloc] init];
    [l InitLoader];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
