//
//  NSFileManager+YP_Extension.h
//  YPAppMonitorDemo
//
//  Created by ZYP on 2018/8/15.
//  Copyright © 2018年 ZYP. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NSFileManagerSanBoxDirType) {
    NSFileManagerSanBoxDirType_Document = 0,
    NSFileManagerSanBoxDirType_Library,
    NSFileManagerSanBoxDirType_Cached
};

@interface NSFileManager (YP_Extension)

+ (BOOL)checkAndCreateDirIfNotExistWithName:(NSString *)newDirName
                           InSandBoxDirType:(NSFileManagerSanBoxDirType)dirType;
+ (BOOL)checkAndCreateDirIfNotExistWithPath:(NSString *)path ;

@end
