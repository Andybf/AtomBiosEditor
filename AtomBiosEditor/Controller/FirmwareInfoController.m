//
//  FirmwareInfoController.m
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 22/09/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#import "FirmwareInfoController.h"

@implementation FirmwareInfoController {
    
    }
    - (void)InitFirmwareInfo :(struct FIRMWARE_INFO *) firmwareInfo {
        
        [_textFieldDefEngClk      setStringValue: [NSString stringWithFormat: @"%d", firmwareInfo->defaultEngineClock]];
        [_textFieldDefMemClk      setStringValue: [NSString stringWithFormat: @"%d", firmwareInfo->defaultMemoryClock]];
        [_textFieldDefDispEngClk  setStringValue: [NSString stringWithFormat: @"%d", firmwareInfo->deftDispEngineClk]];
        [_textFieldCoreRefClk     setStringValue: [NSString stringWithFormat: @"%d", firmwareInfo->coreReferenceClock]];
        [_textFieldMemRefClk      setStringValue: [NSString stringWithFormat: @"%d", firmwareInfo->memoryReferenceClock]];
        [_textFieldPixelClk       setStringValue: [NSString stringWithFormat: @"%d", firmwareInfo->maxPixelClock]];
        [_textFieldMinPixelClkPll setStringValue: [NSString stringWithFormat: @"%d", firmwareInfo->minPixelClockPLLInput]];
        [_textFieldMaxPixelClkPll setStringValue: [NSString stringWithFormat: @"%d", firmwareInfo->maxPixelClockPLLInput]];
        [_textFieldLcdMinPixelClk setStringValue: [NSString stringWithFormat: @"%d", firmwareInfo->LcdMinPixelClock]];
        [_textFieldLcdMaxPixelClk setStringValue: [NSString stringWithFormat: @"%d", firmwareInfo->LcdMaxPixelClock]];
        [_textFieldBootVddcVolt   setStringValue: [NSString stringWithFormat: @"%d", firmwareInfo->bootUpVDDCVoltage]];
        
        [_textFieldDefEngClk      setEnabled: YES];
        [_textFieldDefMemClk      setEnabled: YES];
        [_textFieldDefDispEngClk  setEnabled: YES];
        [_textFieldCoreRefClk     setEnabled: YES];
        [_textFieldMemRefClk      setEnabled: YES];
        [_textFieldPixelClk       setEnabled: YES];
        [_textFieldMinPixelClkPll setEnabled: YES];
        [_textFieldMaxPixelClkPll setEnabled: YES];
        [_textFieldLcdMinPixelClk setEnabled: YES];
        [_textFieldLcdMaxPixelClk setEnabled: YES];
        [_textFieldBootVddcVolt   setEnabled: YES];
    }

@end
