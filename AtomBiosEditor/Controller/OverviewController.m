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

-(instancetype)init {
    return self;
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

- (void) initOverviewInfo: (struct FIRMWARE_FILE)FW : (struct ATOM_BASE_TABLE*)atomTable {
    *atomTable = loadMainTable(FW); //carregando o conteúdo do firmware na memória
    [_textFieldArch        setStringValue: [NSString stringWithFormat: @"%s",atomTable->architecture]];
    [_textFieldRomMsg      setStringValue: [NSString stringWithUTF8String: atomTable->romMessage]];
    [_textFieldPartNumber  setStringValue: [NSString stringWithUTF8String: atomTable->partNumber]];
    [_textFieldCompDate    setStringValue: [NSString stringWithUTF8String: atomTable->compTime]];
    [_textFieldBiosVersion setStringValue: [NSString stringWithUTF8String: atomTable->biosVersion]];
    [_textFieldDeviceId       setStringValue: [NSString stringWithUTF8String: (char *)atomTable->deviceId]];
    [_textFieldSubId       setStringValue: [NSString stringWithUTF8String: (char *)atomTable->subsystemId]];
    [_textFieldMTSize setStringValue: [NSString stringWithFormat:  @"%d",atomTable->size]];
    [_textFieldMTOffset setStringValue: [NSString stringWithUTF8String: "4"]];
    short vendor = VerifySubsystemCompanyName(*atomTable,CompanyNames);
    [_textFieldVendorId      setStringValue: [NSString stringWithFormat: @"%s - %s",(char *)atomTable->subsystemVendorId,CompanyNames[vendor][1] ]];

    if (atomTable->uefiSupport != 0) {
        [ _checkUefiSupport setState: NSControlStateValueOn];
        [ _checkUefiSupport setTitle: @"Supported!"];
    } else {
        [ _checkUefiSupport setState: NSControlStateValueOff];
        [ _checkUefiSupport setTitle: @"Unsupported!"];
    }
    if ( VerifyChecksum(FW, *atomTable) != 0) {
        [ _checkChecksum setState: NSControlStateValueOn];
        [ _checkChecksum setTitle: [NSString stringWithFormat: @"Valid! - 0x%02X", atomTable->checksum] ];
    } else {
        [ _checkChecksum setState: NSControlStateValueOff];
        [ _checkChecksum setTitle: [NSString stringWithUTF8String: "Invalid!"] ];
    }
}

- (IBAction)CheckCheksum:(id)sender {
    NSControlStateValue checkChecksumState = [_checkChecksum state];
    if (checkChecksumState != NSControlStateValueOn) {
        [ _checkChecksum setState: NSControlStateValueOn];
    } else {
        [ _checkChecksum setState: NSControlStateValueOff];
    }
}

- (IBAction)CheckUefiChangedState:(id)sender {
    NSControlStateValue checkUefiState = [ _checkUefiSupport state];
    if (checkUefiState != NSControlStateValueOn) {
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
