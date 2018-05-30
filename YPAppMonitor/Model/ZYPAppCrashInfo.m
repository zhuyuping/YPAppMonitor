//
//  ZYPAppCrashInfo.m
//  ZYPAppMonitor
//
//  Created by ZYP on 2018/3/16.
//  Copyright © 2018年 ZYP. All rights reserved.
//

#import "ZYPAppCrashInfo.h"

@interface ZYPAppCrashInfo()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *reason;
@property (nonatomic, copy) NSString *stackInfo;
@property (nonatomic, copy) NSString *crashTime;
@property (nonatomic, copy) NSString *topViewController;
@property (nonatomic, copy) NSString *applicationVersion;

@end

@implementation ZYPAppCrashInfo

NSString * __convert_time(NSDate * date) {
    static NSDateFormatter * lxd_date_formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lxd_date_formatter = [NSDateFormatter new];
        lxd_date_formatter.dateFormat = @"yyyy-HH-dd HH:mm:ss";
    });
    return [lxd_date_formatter stringFromDate: date];
}

+ (instancetype)crashInfoWithName: (NSString *)name
                           reason: (NSString *)reason
                        stackInfo: (NSString *)stackInfo
                        crashTime: (NSDate *)crashTime
                topViewController: (NSString *)topViewController
                  applicationInfo: (NSString *)applicationInfo {
    ZYPAppCrashInfo *info = [ZYPAppCrashInfo new];
    info.name = name ?: @"";
    info.reason = reason ?: @"";
    info.stackInfo = stackInfo ?: @"";
    info.crashTime = __convert_time(crashTime);
    info.topViewController = topViewController ?: @"";
    info.applicationVersion = applicationInfo ?: @"";
    return info;
}

- (NSString *)description {
    return [NSString stringWithFormat: @"Error: %@\nReson: %@\n%@\nTop viewcontroller: %@\nCrash time: %@\n\nCall Stack: \n%@", _name, _reason, _applicationVersion, _topViewController, _crashTime, _stackInfo];
}

@end
