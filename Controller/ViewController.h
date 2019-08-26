//
//  ViewController.h
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 18/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "../Core/FileLoader.h"

//          Nome da Classe  Herda de:
@interface ViewController : NSViewController {
}
@property (weak) IBOutlet NSView *tableTabView;

//Elementos da StoryBoard
@property (weak) IBOutlet NSButton *btnOpenFile;

// Overview Tab
@property (weak) IBOutlet NSTextField *labelFilePath;

@property (weak) IBOutlet NSTextField *labelArch;

@property (weak) IBOutlet NSTextField *labelMainTableSize;
@property (weak) IBOutlet NSTextField *labelMainTableOffset;

@property (weak) IBOutlet NSTextField *labelRomMsg;
@property (weak) IBOutlet NSTextField *labelPartNumber;
@property (weak) IBOutlet NSTextField *labelCompDate;
@property (weak) IBOutlet NSTextField *labelBiosVersion;
@property (weak) IBOutlet NSTextField *labelDevId;
@property (weak) IBOutlet NSTextField *labelSubId;
@property (weak) IBOutlet NSTextField *labelVendId;
@property (weak) IBOutlet NSButton *checkChecksumStatus;
@property (weak) IBOutlet NSButton *checkUefiSupport;

//Tables Tab
@property (weak) IBOutlet NSPopUpButton *tableSelector;


- (void) DisplayAlert : (NSString *) title : (NSString *) info;
- (void) initOverviewInfo: (struct FIRMWARE_FILE)FW;
- (void) initTableTabInfo: (short)type;


@end

