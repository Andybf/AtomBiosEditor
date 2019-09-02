//
//  ViewController.h
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 28/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "../Model/TableLoader.h"

@interface OverviewController : NSViewController

    @property (weak) IBOutlet NSTextField *textFieldArch;
    @property (weak) IBOutlet NSTextField *textFieldRomMsg;
    @property (weak) IBOutlet NSTextField *textFieldPartNumber;
    @property (weak) IBOutlet NSTextField *textFieldCompDate;
    @property (weak) IBOutlet NSTextField *textFieldBiosVersion;
    @property (weak) IBOutlet NSTextField *textFieldDeviceId;
    @property (weak) IBOutlet NSTextField *textFieldSubId;
    @property (weak) IBOutlet NSTextField *textFieldVendorId;
    @property (weak) IBOutlet NSButton *checkChecksum;
    @property (weak) IBOutlet NSButton *checkUefiSupport;
    @property (weak) IBOutlet NSTextField *textFieldMTSize;
    @property (weak) IBOutlet NSTextField *textFieldMTOffset;

    - (void) initOverviewInfo: (struct FIRMWARE_FILE)FW : (struct ATOM_BASE_TABLE*)atomTable;

@end

