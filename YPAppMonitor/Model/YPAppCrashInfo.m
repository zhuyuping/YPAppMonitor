//
//  ZYPAppCrashInfo.m
//  ZYPAppMonitor
//
//  Created by ZYP on 2018/3/16.
//  Copyright © 2018年 ZYP. All rights reserved.
//

#import "YPAppCrashInfo.h"
#import "YPAppFluencyInfo.h"
#import <UIKit/UIKit.h>
#import "UIDevice+YP_Extension.h"
#import "UIApplication+YP_Extension.h"
#import "YPAppInfoHelper.h"

@interface YPAppCrashInfo()

@property (nonatomic, copy) NSString * deviceInfo;          // iOS 11.4 ，iPhone 7
@property (nonatomic, copy) NSString * screenRatio;         // 750x1334
@property (nonatomic, copy) NSString * screenPPI;           // 326 PPI
@property (nonatomic, copy) NSString * memoryInfo;          // 可用：164.86MB，已用：1416.19MB
@property (nonatomic, copy) NSString * telecomperators;     // 中国移动 (LTE)
@property (nonatomic, copy) NSString * WIFI;                // N/A
@property (nonatomic, copy) NSString * electricity;         // 67%，Unplugged
@property (nonatomic, copy) NSString * appVersion;          // 3.1.1 (build 2)
@property (nonatomic, copy) NSString * sdkVersion;          // 3.1.1
@property (nonatomic, copy) NSString * screenShotImageUrl;  // 截图URL

@property (nonatomic, copy) NSString * identifier;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * reason;
@property (nonatomic, copy) NSString * stackInfo;
@property (nonatomic, copy) NSString * time;
@property (nonatomic, copy) NSString * topViewController;

@end

@implementation YPAppCrashInfo

+ (instancetype)crashInfoWithName:(NSString *)name
                           reason:(NSString *)reason
                        stackInfo:(NSString *)stackInfo
                topViewController:(NSString *)topViewController {
    YPAppCrashInfo *info = [YPAppCrashInfo new];
    info.name = name ?: @"";
    info.reason = reason ?: @"";
    info.stackInfo = stackInfo ?: @"";
    info.topViewController = topViewController ?: @"";
    
    info.time = YPAppInfoHelper.timeString;
    info.identifier = YPAppInfoHelper.identifierString;
    info.deviceInfo = YPAppInfoHelper.deviceInfoString;
    info.screenRatio = YPAppInfoHelper.screenRatioString;
    info.screenPPI = YPAppInfoHelper.screenPPIString;
    info.memoryInfo = YPAppInfoHelper.memoryInfoString;
    info.telecomperators = YPAppInfoHelper.telecomperatorsString;
    info.WIFI = YPAppInfoHelper.wifiString;
    info.electricity = YPAppInfoHelper.electricityString;
    info.appVersion = YPAppInfoHelper.appVersionString;
    info.sdkVersion = YPAppInfoHelper.sdkVersionString;
    info.screenShotImageUrl = @"";
    return info;
}

- (NSDictionary *)dictionary {
    return @{
             @"identifier" : _identifier,
             @"name" : _name,
             @"reason" : _reason,
             @"stackInfo" : _stackInfo,
             @"time" : _time,
             @"topViewController" : _topViewController,
             @"deviceInfo":_deviceInfo,
             @"screenRatio":_screenRatio,
             @"screenPPI":_screenPPI,
             @"memoryInfo":_memoryInfo,
             @"telecomperators":_telecomperators,
             @"WIFI":_WIFI,
             @"electricity":_electricity,
             @"appVersion":_appVersion,
             @"sdkVersion":_sdkVersion,
             @"screenShotImageUrl":_screenShotImageUrl
             };
}

@end
