//
//  UIApplication+YP_Extension.h
//  YPAppMonitorDemo
//
//  Created by ZYP on 2018/7/18.
//  Copyright © 2018年 ZYP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (YP_Extension)

+ (NSURL *)yp_documentsURL ;
+ (NSString *)yp_documentsPath ;

+ (NSURL *)yp_cachesURL ;
+ (NSString *)yp_cachesPath ;

+ (NSURL *)yp_libraryURL ;
+ (NSString *)yp_libraryPath ;

+ (NSURL *)yp_applicationSupportURL ;
+(NSString *)yp_applicationSupportPath ;

+ (NSString *)budnleVersionString ;
+ (NSString *)bundleBuildVersionString ;

// 包含statusBar的全屏截图
+ (NSData *)yp_snapshotPNG ;

// 重定向日志文件
+ (void)redirectTerminalLog ;
+ (NSData *)currentTerminalLogData ;

@end
