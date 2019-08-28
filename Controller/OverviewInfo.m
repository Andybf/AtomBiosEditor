//
//  OverviewInfo.m
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 26/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#import "OverviewInfo.h"

@implementation OverviewInfo {
    ViewController * viewc;
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

- (void) initOverviewInfo: (struct FIRMWARE_FILE)FW : (struct ATOM_BASE_TABLE*)atomTable  : (ViewController *)vc{
    viewc = vc;
    *atomTable = loadMainTable(FW); //carregando o conteúdo do firmware na memória
    [[viewc labelArch]        setStringValue: [NSString stringWithFormat: @"%s",FW.architecture]];
    [[viewc labelRomMsg]      setStringValue: [NSString stringWithUTF8String: atomTable->romMessage]];
    [[viewc labelPartNumber]  setStringValue: [NSString stringWithUTF8String: atomTable->partNumber]];
    [[viewc labelCompDate]    setStringValue: [NSString stringWithUTF8String: atomTable->compTime]];
    [[viewc labelBiosVersion] setStringValue: [NSString stringWithUTF8String: atomTable->biosVersion]];
    [[viewc labelDevId]       setStringValue: [NSString stringWithUTF8String: (char *)atomTable->deviceId]];
    [[viewc labelSubId]       setStringValue: [NSString stringWithUTF8String: (char *)atomTable->subsystemId]];
    [[viewc labelMainTableSize] setStringValue: [NSString stringWithFormat:  @"%d",atomTable->size]];
    [[viewc labelMainTableOffset] setStringValue: [NSString stringWithUTF8String: "4"]];
    short vendor = VerifySubsystemCompanyName(*atomTable,CompanyNames);
    [[viewc labelVendId]      setStringValue: [NSString stringWithFormat: @"%s - %s",(char *)atomTable->subsystemVendorId,CompanyNames[vendor][1] ]];
    
    if (atomTable->uefiSupport != 0) {
        [[viewc checkUefiSupport] setState: NSControlStateValueOn];
        [[viewc checkUefiSupport] setTitle: @"Supported!"];
    } else {
        [[viewc checkUefiSupport] setState: NSControlStateValueOff];
        [[viewc checkUefiSupport] setTitle: @"Unsupported!"];
    }
    if ( VerifyChecksum(FW, *atomTable) != 0) {
        [[viewc checkChecksumStatus] setState: NSControlStateValueOn];
        [[viewc checkChecksumStatus] setTitle: [NSString stringWithFormat: @"Valid! - 0x%02X", atomTable->checksum] ];
    } else {
        [[viewc checkChecksumStatus] setState: NSControlStateValueOff];
        [[viewc checkChecksumStatus] setTitle: [NSString stringWithUTF8String: "Invalid!"] ];
    }
}

- (IBAction)CheckCheksum:(id)sender {
    NSControlStateValue checkChecksumState = [[viewc checkChecksumStatus] state];
    if (checkChecksumState != NSControlStateValueOn) {
        [[viewc checkChecksumStatus] setState: NSControlStateValueOn];
    } else {
        [[viewc checkChecksumStatus] setState: NSControlStateValueOff];
    }
}

- (IBAction)CheckUefiChangedState:(id)sender {
    NSControlStateValue checkUefiState = [[viewc checkUefiSupport] state];
    if (checkUefiState != NSControlStateValueOn) {
        [[viewc checkUefiSupport] setState: NSControlStateValueOn];
    } else {
        [[viewc checkUefiSupport] setState: NSControlStateValueOff];
    }
    
}

@end
