//
//  Loader.h
//  AtomBiosEditor
//
//  Created by Anderson Bucchianico on 18/08/19.
//  Copyright © 2019 Anderson Bucchianico. All rights reserved.
//

#ifndef Loader_h
#define Loader_h

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <sys/stat.h>

@interface FileLoader : NSObject

// Estruturas da dados auxiliares
struct FIRMWARE_FILE {
    FILE * file;
    NSString *pathName;
    struct stat fileInfo;
};

//Definicção de métodos
- (NSString*)InitLoader;
- (BOOL)CheckFirmwareSize;
- (BOOL)CheckFirmwareSignature;
- (BOOL)CheckFirmwareArchitecture;

- (FILE *)getFile;
- (NSString*)getFileName;
int DisplayAlert(NSString * , NSString * );


@end


#endif /* Loader_h */
