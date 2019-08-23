//
//  ViewController.h
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 18/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//          Nome da Classe  Herda de:
@interface ViewController : NSViewController {
    
}

//Elementos da StoryBoard
@property (weak) IBOutlet NSButton *btnOpenFile;

@property (weak) IBOutlet NSTextField *labelFilePath;

@property (weak) IBOutlet NSTextField *labelRomMsg;
@property (weak) IBOutlet NSTextField *labelPartNumber;
@property (weak) IBOutlet NSTextField *labelCompDate;
@property (weak) IBOutlet NSTextField *labelBiosVersion;
@property (weak) IBOutlet NSTextField *labelDevId;
@property (weak) IBOutlet NSTextField *labelSubId;
@property (weak) IBOutlet NSTextField *labelVendId;
@property (weak) IBOutlet NSTextField *labelChecksum;
@property (weak) IBOutlet NSTextField *labelUefiSupprot;



@end

