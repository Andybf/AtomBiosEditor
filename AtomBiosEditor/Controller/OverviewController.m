//
//  ViewController.m
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 28/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#import "OverviewController.h"

@implementation OverviewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

const char * CompanyNames[11][2] = {
    {"1002","AMD/ATI"},
    {"106B","Apple"},
    {"1043","Asus"},
    {"1849","ASRock"},
    {"1028","Dell"},
    {"1458","Gigabyte"},
    {"1787","HIS"},
    {"1462","MSI"},
    {"148C","PowerColor"},
    {"174B","Sapphire"},
    {"1682","XFX"},
};

- (void) initOverviewInfo: (struct ATOM_BIOS *)atomBios {
    atomBios->mainTable = loadMainTable(atomBios);
    loadOffsetsTable(     atomBios);
    loadCmmdAndDataTables(atomBios);
    [_textFieldArch        setStringValue: [NSString stringWithFormat:     @"%s",atomBios->mainTable.architecture]];
    [_textFieldRomMsg      setStringValue: [NSString stringWithUTF8String: atomBios->mainTable.romMessage]];
    [_textFieldPartNumber  setStringValue: [NSString stringWithUTF8String: atomBios->mainTable.partNumber]];
    [_textFieldCompDate    setStringValue: [NSString stringWithUTF8String: atomBios->mainTable.compTime]];
    [_textFieldBiosVersion setStringValue: [NSString stringWithUTF8String: atomBios->mainTable.biosVersion]];
    [_textFieldDeviceId    setStringValue: [NSString stringWithUTF8String: (char *)atomBios->mainTable.deviceId]];
    [_textFieldSubId       setStringValue: [NSString stringWithUTF8String: (char *)atomBios->mainTable.subsystemId]];
    [_textFieldMTSize      setStringValue: [NSString stringWithFormat:     @"%d",atomBios->mainTable.size]];
    [_textFieldMTOffset    setStringValue: [NSString stringWithUTF8String: "0x4"]];
    short vendor = VerifySubSysCompany(atomBios->mainTable,CompanyNames);
    [_textFieldVendorId    setStringValue: [NSString stringWithFormat: @"%s - %s",(char *)atomBios->mainTable.subsystemVendorId,CompanyNames[vendor][1] ]];

    [ _checkUefiSupport setState: NSControlStateValueOff];
    [ _checkUefiSupport setTitle: @"Unsupported!"];
    if (atomBios->mainTable.uefiSupport != 0) {
        [ _checkUefiSupport setState: NSControlStateValueOn];
        [ _checkUefiSupport setTitle: @"Supported!"];
    }
    
    [ _checkChecksum setState: NSControlStateValueOff];
    [ _checkChecksum setTitle: [NSString stringWithUTF8String: "Invalid!"] ];
    if ( VerifyChecksum(atomBios) != 0) {
        [ _checkChecksum setState: NSControlStateValueOn];
        [ _checkChecksum setTitle: [NSString stringWithFormat: @"Valid! - 0x%02X", atomBios->mainTable.checksum] ];
    }
}

- (IBAction)CheckCheksum:(id)sender {
    if (! [_checkChecksum state]) {
        [ _checkChecksum setState: NSControlStateValueOn];
    } else {
        [ _checkChecksum setState: NSControlStateValueOff];
    }
}

- (IBAction)CheckUefiChangedState:(id)sender {
    if (! [ _checkUefiSupport state]) {
        [ _checkUefiSupport setState: NSControlStateValueOn];
    } else {
        [ _checkUefiSupport setState: NSControlStateValueOff];
    }
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    // Update the view, if already loaded.
}

@end
