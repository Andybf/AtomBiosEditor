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
#import "../Core/Library/TableLoader.h"

extern FileLoader * file;
extern TableOverviewController * tbloverview;

@implementation ViewController {
    struct ATOM_BASE_TABLE atomTable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    // Update the view, if already loaded.
}


- (IBAction)btnOpenFileTriggered: (id)sender {
    file = [[FileLoader alloc] init];
    NSString * msg = [file InitLoader];
    
    if (![file CheckFirmwareSize]) {
        exit(1);
    } else if (![file CheckFirmwareSignature]) {
        exit(2);
    } else if (![file CheckFirmwareArchitecture]) {
        exit(3);
    }
    
    //carregando o conteúdo do firmware na memória
    
    TableLoader * tblLoader = [[TableLoader alloc] init];
    
    [tblLoader loadMainTable:[file getFirmwareStruct]];
    
    [self initOverviewInfo: msg :  [tblLoader getAtomBaseTableStruct]];
    
}
- (void) initOverviewInfo: (NSString*)filePath : (struct ATOM_BASE_TABLE)atomTable {
    printf("Info: Method InitOverviewInfo Triggered!\n");
    if ([file getFile] != NULL) {
        [_labelFilePath setStringValue:filePath];
        [_labelRomMsg setStringValue:@"rom"];
    } else {
        NSLog(@"Error: file is null!");
    }
    
}


@end
