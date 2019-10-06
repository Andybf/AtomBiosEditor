//
//  PowerPalyController.h
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 30/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

#import "../Model/PowerPlay.h"

@interface CustomPowerPlayTextField : NSTextField  {
    
    }
    @property (nonatomic) short TypeIdentifier;
    @property struct POWERPLAY_DATA * powerPlay;

@end

@interface OverDriveController : NSViewController

    @property (weak) IBOutlet CustomPowerPlayTextField *textFieldMaxGpu;
    @property (weak) IBOutlet CustomPowerPlayTextField *textFieldMaxMem;

    @property (weak) IBOutlet CustomPowerPlayTextField *textFieldMaxTdp;
    @property (weak) IBOutlet CustomPowerPlayTextField *textFieldTdp;
    @property (weak) IBOutlet CustomPowerPlayTextField *textFieldMinTdp;

    @property (weak) IBOutlet CustomPowerPlayTextField *textFieldTmpHyst;
    @property (weak) IBOutlet CustomPowerPlayTextField *textFieldTemp1;
    @property (weak) IBOutlet CustomPowerPlayTextField *textFieldTemp2;
    @property (weak) IBOutlet CustomPowerPlayTextField *textFieldTemp3;
    @property (weak) IBOutlet CustomPowerPlayTextField *textFieldMaxTemp;

    @property (weak) IBOutlet CustomPowerPlayTextField *textFieldFan1;
    @property (weak) IBOutlet CustomPowerPlayTextField *textFieldFan2;
    @property (weak) IBOutlet CustomPowerPlayTextField *textFieldFan3;
    @property (weak) IBOutlet CustomPowerPlayTextField *textFieldMaxFan;

    @property (weak) IBOutlet NSButton *radioHexadecimal;
    @property (weak) IBOutlet NSButton *radioDecimal;

    - (void) initOverDriveInfo : (struct POWERPLAY_DATA*)powerPlay;
    
@end
