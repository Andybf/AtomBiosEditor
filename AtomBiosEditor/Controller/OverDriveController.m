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
    [_textFieldMaxTdp  setStringValue: [NSString stringWithFormat: @"%d", powerPlay->maxTdp]];
    [_textFieldMinTdp  setStringValue: [NSString stringWithFormat: @"%d", powerPlay->minTdp]];
    [_textFieldTdp     setStringValue: [NSString stringWithFormat: @"%d", (powerPlay->minTdp+powerPlay->maxTdp)/2 ]];
    [_textFieldTemp1   setStringValue: [NSString stringWithFormat: @"%d", powerPlay->tempTarget[0]]];
    [_textFieldTemp2   setStringValue: [NSString stringWithFormat: @"%d", powerPlay->tempTarget[1]]];
    [_textFieldTemp3   setStringValue: [NSString stringWithFormat: @"%d", powerPlay->tempTarget[2]]];
    [_textFieldTmpHyst setStringValue: [NSString stringWithFormat: @"%d", powerPlay->hysteresis]];
    [_textFieldMaxTemp setStringValue: [NSString stringWithFormat: @"%d", powerPlay->maxTemp]];
    [_textFieldFan1    setStringValue: [NSString stringWithFormat: @"%d", powerPlay->fanSpeed[0]]];
    [_textFieldFan2    setStringValue: [NSString stringWithFormat: @"%d", powerPlay->fanSpeed[1]]];
    [_textFieldFan3    setStringValue: [NSString stringWithFormat: @"%d", powerPlay->fanSpeed[2]]];
    [_textFieldMaxFan  setStringValue: [NSString stringWithFormat: @"%d", powerPlay->maxFanSpeed]];
    
    [_textFieldMaxGpu  setEnabled: YES];
    [_textFieldMaxMem  setEnabled: YES];
    [_textFieldMaxTdp  setEnabled: YES];
    [_textFieldMinTdp  setEnabled: YES];
    [_textFieldTdp     setEnabled: YES];
    [_textFieldTemp1   setEnabled: YES];
    [_textFieldTemp2   setEnabled: YES];
    [_textFieldTemp3   setEnabled: YES];
    [_textFieldTmpHyst setEnabled: YES];
    [_textFieldMaxTemp setEnabled: YES];
    [_textFieldFan1    setEnabled: YES];
    [_textFieldFan2    setEnabled: YES];
    [_textFieldFan3    setEnabled: YES];
    [_textFieldMaxFan  setEnabled: YES];
    
    [_textFieldMaxGpu  setTypeIdentifier:1];
    [_textFieldMaxMem  setTypeIdentifier:2];
    [_textFieldMaxTdp  setTypeIdentifier:3];
    [_textFieldMinTdp  setTypeIdentifier:4];
    [_textFieldTdp     setTypeIdentifier:5];
    [_textFieldTemp1   setTypeIdentifier:6];
    [_textFieldTemp2   setTypeIdentifier:7];
    [_textFieldTemp3   setTypeIdentifier:8];
    [_textFieldTmpHyst setTypeIdentifier:9];
    [_textFieldMaxTemp setTypeIdentifier:10];
    [_textFieldFan1    setTypeIdentifier:11];
    [_textFieldFan2    setTypeIdentifier:12];
    [_textFieldFan3    setTypeIdentifier:13];
    [_textFieldMaxFan  setTypeIdentifier:14];
    
    [_textFieldMaxGpu   setPowerPlay: powerPlay];
    [_textFieldMaxMem   setPowerPlay: powerPlay];
    [_textFieldMaxTdp   setPowerPlay: powerPlay];
    [_textFieldMinTdp   setPowerPlay: powerPlay];
    [_textFieldTdp      setPowerPlay: powerPlay];
    [_textFieldTemp1    setPowerPlay: powerPlay];
    [_textFieldTemp2    setPowerPlay: powerPlay];
    [_textFieldTemp3    setPowerPlay: powerPlay];
    [_textFieldTmpHyst  setPowerPlay: powerPlay];
    [_textFieldMaxTemp  setPowerPlay: powerPlay];
    [_textFieldFan1     setPowerPlay: powerPlay];
    [_textFieldFan2     setPowerPlay: powerPlay];
    [_textFieldFan3     setPowerPlay: powerPlay];
    [_textFieldMaxFan   setPowerPlay: powerPlay];
    
}

@end

@implementation CustomPowerPlayTextField

- (void)textDidChange:(NSNotification *)notification {
    [super textDidChange:notification];
    printf(" TextDidChangeEditing | value: %s | ClassName: %s | typeId: %d \n",[[self stringValue] UTF8String],[[self className] UTF8String],[self TypeIdentifier]);
    switch ([self TypeIdentifier]) {
        case 1:
            self.powerPlay->maxGpuClock = [[self stringValue] intValue];
            break;
        case 2:
            self.powerPlay->maxMemClock = [[self stringValue] intValue];
            break;
        case 3:
            self.powerPlay->maxTdp = [[self stringValue] intValue];
            break;
        case 4:
            self.powerPlay->minTdp = [[self stringValue] intValue];
            break;
        case 5:
            
            break;
        case 6:
            self.powerPlay->tempTarget[0] = [[self stringValue] intValue];
            break;
        case 7:
            self.powerPlay->tempTarget[1] = [[self stringValue] intValue];
            break;
        case 8:
            self.powerPlay->tempTarget[2] = [[self stringValue] intValue];
            break;
        case 9:
            self.powerPlay->hysteresis = [[self stringValue] intValue];
            break;
        case 10:
            self.powerPlay->maxTemp = [[self stringValue] intValue];
            break;
        case 11:
            if ([[self stringValue] intValue] <= 100 && [[self stringValue] intValue] >= 0) {
                self.powerPlay->fanSpeed[0] = [[self stringValue] intValue];
            } else {
                self.stringValue = @"100";
            }
            break;
        case 12:
            if ([[self stringValue] intValue] <= 100 && [[self stringValue] intValue] >= 0) {
                self.powerPlay->fanSpeed[1] = [[self stringValue] intValue];
            } else {
                self.stringValue = @"100";
            }
            break;
        case 13:
            if ([[self stringValue] intValue] <= 100 && [[self stringValue] intValue] >= 0) {
                self.powerPlay->fanSpeed[2] = [[self stringValue] intValue];
            } else {
                self.stringValue = @"100";
            }
            break;
        case 14:
            if ([[self stringValue] intValue] <= 100 && [[self stringValue] intValue] >= 0) {
                self.powerPlay->maxFanSpeed = [[self stringValue] intValue];
            } else {
                self.stringValue = @"100";
            }
            break;
        default:
            exit(10);
            break;
    }
}

@end
