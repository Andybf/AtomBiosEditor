//
//  PowerPlayController.m
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 30/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#import "OverDriveController.h"

@implementation OverDriveController

-(void)viewDidLoad {
    [super viewDidLoad];
    [_textFieldMaxGpu  setStringValue: @"null"];
    [_textFieldMaxMem  setStringValue: @"null"];
    
    [_textFieldMaxTdp  setStringValue: @"null"];
    [_textFieldTdp     setStringValue: @"null"];
    [_textFieldMinTdp  setStringValue: @"null"];
    
    [_textFieldTmpHyst setStringValue: @"null"];
    [_textFieldTemp1   setStringValue: @"null"];
    [_textFieldTemp2   setStringValue: @"null"];
    [_textFieldTemp3   setStringValue: @"null"];
    
    [_textFieldFan1    setStringValue: @"null"];
    [_textFieldFan2    setStringValue: @"null"];
    [_textFieldFan3    setStringValue: @"null"];
}

@end
