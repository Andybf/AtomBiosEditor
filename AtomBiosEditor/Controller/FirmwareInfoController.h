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

@interface CustomTextField : NSTextField  {
    
}
    @property (nonatomic) short TypeIdentifier;
    @property struct FIRMWARE_INFO * firmwareInfo;

@end

@interface FirmwareInfoController : NSViewController {
    
    }

    //Properties Declaration
    @property (strong) IBOutlet CustomTextField *textFieldDefEngClk;
    @property (strong) IBOutlet CustomTextField *textFieldDefMemClk;
    @property (strong) IBOutlet CustomTextField *textFieldDefDispEngClk;
    @property (strong) IBOutlet CustomTextField *textFieldCoreRefClk;
    @property (strong) IBOutlet CustomTextField *textFieldMemRefClk;

    @property (weak) IBOutlet CustomTextField *textFieldPixelClk;
    @property (weak) IBOutlet CustomTextField *textFieldMinPixelClkPll;
    @property (weak) IBOutlet CustomTextField *textFieldMaxPixelClkPll;
    @property (weak) IBOutlet CustomTextField *textFieldLcdMinPixelClk;
    @property (weak) IBOutlet CustomTextField *textFieldLcdMaxPixelClk;

    @property (weak) IBOutlet CustomTextField *textFieldBootVddcVolt;

    // Functions Declaration
    - (void)InitFirmwareInfo: (struct FIRMWARE_INFO *) firmwareInfo;

@end
