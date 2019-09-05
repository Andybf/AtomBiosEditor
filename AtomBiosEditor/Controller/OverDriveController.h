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

@interface OverDriveController : NSViewController

    @property (weak) IBOutlet NSTextField *textFieldMaxGpu;
    @property (weak) IBOutlet NSTextField *textFieldMaxMem;

    @property (weak) IBOutlet NSTextField *textFieldMaxTdp;
    @property (weak) IBOutlet NSTextField *textFieldTdp;
    @property (weak) IBOutlet NSTextField *textFieldMinTdp;

    @property (weak) IBOutlet NSTextField *textFieldTmpHyst;
    @property (weak) IBOutlet NSTextField *textFieldTemp1;
    @property (weak) IBOutlet NSTextField *textFieldTemp2;
    @property (weak) IBOutlet NSTextField *textFieldTemp3;
    @property (weak) IBOutlet NSTextField *textFieldMaxTemp;

    @property (weak) IBOutlet NSTextField *textFieldFan1;
    @property (weak) IBOutlet NSTextField *textFieldFan2;
    @property (weak) IBOutlet NSTextField *textFieldFan3;
    @property (weak) IBOutlet NSTextField *textFieldMaxFan;

    @property (weak) IBOutlet NSButton *radioHexadecimal;
    @property (weak) IBOutlet NSButton *radioDecimal;

    - (void) initOverDriveInfo : (struct POWERPLAY_DATA*)powerPlay;
    
@end
