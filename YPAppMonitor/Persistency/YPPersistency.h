//
//  YPPersistency.h
//  YPAppMonitorDemo
//
//  Created by ZYP on 2018/6/14.
//  Copyright © 2018年 ZYP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YPReport.h"

typedef enum : NSUInteger {
    YPPersistencyTypeFluencyData,
    YPPersistencyTypeCrashData,
    YPPersistencyTypeScreenShot,
    YPPersistencyTypeTerminalLog,
} YPPersistencyType;

@interface YPPersistency : NSObject

@property(nonatomic, assign) int queueMaxLength; // default 200

+ (instancetype)sharedInstance ;

// add method
- (void)addReport:(YPReport *)report ;
- (void)addShot:(NSData *)data name:(NSString *)name ;
- (void)addTerminalLogWithName:(NSString *)name ;

// remove method
- (void)removeReports:(NSArray <YPReport *>*)reports ;
- (void)removeShotWithNames:(NSArray <NSString *>*)names ;
- (void)removeTerminalLogWithNames:(NSArray <NSString *>*)names ;

// read method
- (NSArray <YPReport *>*)someReportsWithType:(YPReportType)type ;
- (NSArray <NSString *>*)someShotNames ;
- (NSArray <NSString *>*)someTerminalLogNames ;
+ (NSURL *)urlForScreenShotWithName:(NSString *)name;
+ (NSURL *)urlTerminalLogWithName:(NSString *)name;
+ (NSData *)dataScreenShotWithName:(NSString *)name ;
+ (NSData *)dataTerminalLogWithName:(NSString *)name;

// save method
- (void)saveReportToFileWithType:(YPReportType)type ;
- (void)saveShotToFile ;
- (void)saveTerminalLogToFile ;


@end
