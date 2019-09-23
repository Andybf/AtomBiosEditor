//
//  FirmwareInfo.h
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 22/09/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

#import "../Model/FirmwareInfo.h"

@interface FirmwareInfoController : NSViewController {
    
    }

//Properties Declaration
@property (weak) IBOutlet NSTextField *textFieldDefEngClk;
@property (weak) IBOutlet NSTextField *textFieldDefMemClk;
@property (weak) IBOutlet NSTextField *textFieldDefDispEngClk;
@property (weak) IBOutlet NSTextField *textFieldCoreRefClk;
@property (weak) IBOutlet NSTextField *textFieldMemRefClk;

@property (weak) IBOutlet NSTextField *textFieldPixelClk;
@property (weak) IBOutlet NSTextField *textFieldMinPixelClkPll;
@property (weak) IBOutlet NSTextField *textFieldMaxPixelClkPll;
@property (weak) IBOutlet NSTextField *textFieldLcdMinPixelClk;
@property (weak) IBOutlet NSTextField *textFieldLcdMaxPixelClk;

@property (weak) IBOutlet NSTextField *textFieldBootVddcVolt;


// Functions Declaration
- (void)InitFirmwareInfo: (struct FIRMWARE_INFO *) firmwareInfo;;

@end
