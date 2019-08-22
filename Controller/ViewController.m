//
//  ViewController.m
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 18/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#import "ViewController.h"
#import "FileLoader.h"
#import "TableOverviewController.h"

extern FileLoader * loader;
extern TableOverviewController * tbloverview;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    // Update the view, if already loaded.
}


- (IBAction)btnOpenFileTriggered: (id)sender {
    loader = [[FileLoader alloc] init];
    NSString * msg = [loader InitLoader];
    [self initOverviewInfo: msg];
    if (![loader CheckFirmwareSize]) {
        exit(1);
    } else if (loader ch)
    
}
- (void) initOverviewInfo: (NSString*)txt {
    printf("/nInfo: Method InitOverviewInfo Triggered!");
    if ([loader getFile] != NULL) {
        [_labelFilePath setStringValue:txt];
        [_labelRomMsg setStringValue:@"rom"];
    } else {
        NSLog(@"Error: file is null!");
    }
    
}


@end
