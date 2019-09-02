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
}

- (void) initOverDriveInfo :  (struct POWERPLAY_DATA *)powerPlay {
    [_textFieldMaxGpu  setStringValue: [NSString stringWithFormat: @"%d", powerPlay->maxGpuClock]];
    [_textFieldMaxMem  setStringValue: [NSString stringWithFormat: @"%d", powerPlay->maxMemClock]];
    [_textFieldMaxGpu  setEnabled: YES];
    [_textFieldMaxMem  setEnabled: YES];
    
    [_textFieldMaxTdp  setStringValue: [NSString stringWithFormat: @"%d", powerPlay->maxTdp]];
    [_textFieldMinTdp  setStringValue: [NSString stringWithFormat: @"%d", powerPlay->minTdp]];
    [_textFieldTdp     setStringValue: [NSString stringWithFormat: @"%d", (powerPlay->minTdp+powerPlay->maxTdp)/2 ]];
    [_textFieldMaxTdp  setEnabled: YES];
    [_textFieldMinTdp  setEnabled: YES];
    [_textFieldTdp     setEnabled: YES];
    
    [_textFieldTmpHyst setStringValue: [NSString stringWithFormat: @"%d", powerPlay->hysteresis]];
    [_textFieldTemp1   setStringValue: [NSString stringWithFormat: @"%d", powerPlay->tempTarget[0]]];
    [_textFieldTemp2   setStringValue: [NSString stringWithFormat: @"%d", powerPlay->tempTarget[1]]];
    [_textFieldTemp3   setStringValue: [NSString stringWithFormat: @"%d", powerPlay->tempTarget[2]]];
    [_textFieldTmpHyst setEnabled: YES];
    [_textFieldTemp1   setEnabled: YES];
    [_textFieldTemp2   setEnabled: YES];
    [_textFieldTemp3   setEnabled: YES];
    
    [_textFieldFan1    setStringValue: [NSString stringWithFormat: @"%d", powerPlay->fanSpeed[0]]];
    [_textFieldFan2    setStringValue: [NSString stringWithFormat: @"%d", powerPlay->fanSpeed[1]]];
    [_textFieldFan3    setStringValue: [NSString stringWithFormat: @"%d", powerPlay->fanSpeed[2]]];
    [_textFieldFan1    setEnabled: YES];
    [_textFieldFan2    setEnabled: YES];
    [_textFieldFan3    setEnabled: YES];
}

@end
