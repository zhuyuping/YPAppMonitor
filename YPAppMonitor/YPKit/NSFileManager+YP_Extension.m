//
//  NSFileManager+YP_Extension.m
//  YPAppMonitorDemo
//
//  Created by ZYP on 2018/8/15.
//  Copyright © 2018年 ZYP. All rights reserved.
//

#import "NSFileManager+YP_Extension.h"
#import "YP_Extension.h"

@implementation NSFileManager (YP_Extension)

+ (BOOL)checkAndCreateDirIfNotExistWithName:(NSString *)newDirName
                           InSandBoxDirType:(NSFileManagerSanBoxDirType)dirType {
    NSAssert(newDirName, @"newDirName must not nil");
    NSAssert(newDirName.length > 1, @"newDirName length must > 1");
    NSAssert(dirType < 3, @"dirType must < 3(NSFileManagerSanBoxDirType_Cached)");
    NSString *path ;
    switch (dirType) {
        case NSFileManagerSanBoxDirType_Document:
            path = [UIApplication yp_documentsPath];
            break;
        case NSFileManagerSanBoxDirType_Library:
            path = [UIApplication yp_libraryPath];
            break;
        default:
            path = [UIApplication yp_cachesPath];
            break;
    }
    
    NSArray *pathHierarchy = [newDirName componentsSeparatedByString:@"/"];
    BOOL IntermediateDirectories = pathHierarchy.count > 1;
    
    [path stringByAppendingPathComponent:newDirName];
    NSError *error = nil;
    if (![NSFileManager.defaultManager fileExistsAtPath:path]) {
        [NSFileManager.defaultManager createDirectoryAtPath:path
                                withIntermediateDirectories:IntermediateDirectories
                                                 attributes:nil
                                                      error:&error];
        
        if(error){ NSLog(@"directory can not be created: \n%@", error); return NO; }
    }
    return YES;
}

+ (BOOL)checkAndCreateDirIfNotExistWithPath:(NSString *)path {
    NSError *error = nil;
    if (![NSFileManager.defaultManager fileExistsAtPath:path]) {
        [NSFileManager.defaultManager createDirectoryAtPath:path
                                withIntermediateDirectories:YES
                                                 attributes:nil
                                                      error:&error];
        
        if(error){ NSLog(@"directory can not be created: \n%@", error); return NO; }
    }
    return YES;
}

@end
