//
//  FirmwareInfo.h
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 22/09/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#ifndef FirmwareInfo_h
#define FirmwareInfo_h

#include <stdio.h>

#include "CoreFunctions.h"

struct FIRMWARE_INFO {
    
    ushort defaultEngineClock;         // 0x08
    ushort defaultMemoryClock;         // 0x0C
    
    ushort defaultDispEngineClkFreq;   // 0x28
    ushort bootUpVDDCVoltage;          // 0x2E
    
    ushort LcdMinPixelClockPLL_Output; // 0x30
    ushort LcdMaxPixelClockPLL_Output; // 0x32
    
    ushort maxPixelClock;              // 0x48
    ushort minPixelClockPLLInput;      // 0x4A
    ushort maxPixelClockPLLInput;      // 0x4C
    
    ushort coreReferenceClock;         // 0x52
    ushort memoryReferenceClock;       // 0x54
    
};

#endif /* FirmwareInfo_h */
