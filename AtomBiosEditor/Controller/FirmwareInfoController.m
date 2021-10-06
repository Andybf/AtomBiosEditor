//
//  FirmwareInfoController.m
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 22/09/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#import "FirmwareInfoController.h"

@implementation FirmwareInfoController
    - (void)InitFirmwareInfo: (struct FIRMWARE_INFO *) firmwareInfo {
        
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
        
        [_textFieldDefEngClk      setTypeIdentifier: 1];
        [_textFieldDefMemClk      setTypeIdentifier: 2];
        [_textFieldDefDispEngClk  setTypeIdentifier: 3];
        [_textFieldCoreRefClk     setTypeIdentifier: 4];
        [_textFieldMemRefClk      setTypeIdentifier: 5];
        [_textFieldPixelClk       setTypeIdentifier: 6];
        [_textFieldMinPixelClkPll setTypeIdentifier: 7];
        [_textFieldMaxPixelClkPll setTypeIdentifier: 8];
        [_textFieldLcdMinPixelClk setTypeIdentifier: 9];
        [_textFieldLcdMaxPixelClk setTypeIdentifier: 10];
        [_textFieldBootVddcVolt   setTypeIdentifier: 11];
        
        [_textFieldDefEngClk      setFirmwareInfo: firmwareInfo];
        [_textFieldDefMemClk      setFirmwareInfo: firmwareInfo];
        [_textFieldDefDispEngClk  setFirmwareInfo: firmwareInfo];
        [_textFieldCoreRefClk     setFirmwareInfo: firmwareInfo];
        [_textFieldMemRefClk      setFirmwareInfo: firmwareInfo];
        [_textFieldPixelClk       setFirmwareInfo: firmwareInfo];
        [_textFieldMinPixelClkPll setFirmwareInfo: firmwareInfo];
        [_textFieldMaxPixelClkPll setFirmwareInfo: firmwareInfo];
        [_textFieldLcdMinPixelClk setFirmwareInfo: firmwareInfo];
        [_textFieldLcdMaxPixelClk setFirmwareInfo: firmwareInfo];
        [_textFieldBootVddcVolt   setFirmwareInfo: firmwareInfo];
    }
@end
        
@implementation CustomTextField

    - (void)textDidChange:(NSNotification *)notification {
        [super textDidChange:notification];
        switch ([self TypeIdentifier]) {
            case 1:
                if ([[self stringValue] intValue] >= 0 && [[self stringValue] intValue] <= 4096) {
                    self.firmwareInfo->defaultEngineClock = [[self stringValue] intValue];
                } else {
                    self.stringValue = [NSString stringWithFormat: @"%d", self.firmwareInfo->defaultEngineClock];
                }
                break;
            case 2:
                if ([[self stringValue] intValue] >= 0 && [[self stringValue] intValue] <= 4096) {
                    self.firmwareInfo->defaultMemoryClock = [[self stringValue] intValue];
                } else {
                    self.stringValue = [NSString stringWithFormat: @"%d", self.firmwareInfo->defaultMemoryClock];
                }
                break;
            case 3:
                if ([[self stringValue] intValue] >= 0 && [[self stringValue] intValue] <= 4096) {
                    self.firmwareInfo->deftDispEngineClk = [[self stringValue] intValue];
                } else {
                    self.stringValue = [NSString stringWithFormat: @"%d", self.firmwareInfo->deftDispEngineClk];
                }
                break;
            case 4:
                if ([[self stringValue] intValue] >= 0 && [[self stringValue] intValue] <= 4096) {
                    self.firmwareInfo->coreReferenceClock = [[self stringValue] intValue];
                } else {
                    self.stringValue = [NSString stringWithFormat: @"%d", self.firmwareInfo->coreReferenceClock];
                }
                break;
            case 5:
                if ([[self stringValue] intValue] >= 0 && [[self stringValue] intValue] <= 4096) {
                    self.firmwareInfo->memoryReferenceClock = [[self stringValue] intValue];
                } else {
                    self.stringValue = [NSString stringWithFormat: @"%d", self.firmwareInfo->memoryReferenceClock];
                }
                break;
            case 6:
                if ([[self stringValue] intValue] >= 0 && [[self stringValue] intValue] <= 4096) {
                    self.firmwareInfo->maxPixelClock = [[self stringValue] intValue];
                } else {
                    self.stringValue = [NSString stringWithFormat: @"%d", self.firmwareInfo->maxPixelClock];
                }
                break;
            case 7:
                if ([[self stringValue] intValue] >= 0 && [[self stringValue] intValue] <= 4096) {
                    self.firmwareInfo->minPixelClockPLLInput = [[self stringValue] intValue];
                } else {
                    self.stringValue = [NSString stringWithFormat: @"%d", self.firmwareInfo->minPixelClockPLLInput];
                }
                break;
            case 8:
                if ([[self stringValue] intValue] >= 0 && [[self stringValue] intValue] <= 4096) {
                    self.firmwareInfo->maxPixelClockPLLInput = [[self stringValue] intValue];
                } else {
                    self.stringValue = [NSString stringWithFormat: @"%d", self.firmwareInfo->maxPixelClockPLLInput];
                }
                break;
            case 9:
                if ([[self stringValue] intValue] >= 0 && [[self stringValue] intValue] <= 4096) {
                    self.firmwareInfo->LcdMinPixelClock = [[self stringValue] intValue];
                } else {
                    self.stringValue = [NSString stringWithFormat: @"%d", self.firmwareInfo->LcdMinPixelClock];
                }
                break;
            case 10:
                if ([[self stringValue] intValue] >= 0 && [[self stringValue] intValue] <= 4096) {
                    self.firmwareInfo->LcdMaxPixelClock = [[self stringValue] intValue];
                } else {
                    self.stringValue = [NSString stringWithFormat: @"%d", self.firmwareInfo->LcdMaxPixelClock];
                }
                break;
            case 11:
                if ([[self stringValue] intValue] >= 0 && [[self stringValue] intValue] <= 2000) {
                    self.firmwareInfo->bootUpVDDCVoltage = [[self stringValue] intValue];
                } else {
                    self.stringValue = [NSString stringWithFormat: @"%d", self.firmwareInfo->bootUpVDDCVoltage];
                }
                break;
            default:
                exit(10);
                break;
        }
    }
@end
