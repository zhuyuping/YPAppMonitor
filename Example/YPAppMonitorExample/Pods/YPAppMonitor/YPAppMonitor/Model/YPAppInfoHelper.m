//
//  YPAppInfoHelper.m
//  YPAppMonitorDemo
//
//  Created by ZYP on 2018/7/18.
//  Copyright © 2018年 ZYP. All rights reserved.
//

#import "YPAppInfoHelper.h"
#import "YP_Extension.h"
#import <sys/utsname.h>

@implementation YPAppInfoHelper

+ (NSString *)timeString {
    return NSDate.currentTimeString;
}

+ (NSString *)identifierString {
    NSMutableString *str = @"".mutableCopy;
    [str appendString:[NSDate currentTimeStampMS]];
    [str appendString:@"-"];
    [str appendString:[NSString random32String]];
    return str.copy;
}

+ (NSString *)deviceInfoString {
    return [NSString stringWithFormat:@"%@ %@ , %@ %@(%@)",
            [UIDevice currentDevice].systemName,
            [UIDevice currentDevice].systemVersion,
            [UIDevice currentDevice].model,
            [UIDevice currentDevice].localizedModel,
            [UIDevice currentDevice].name];
}

+ (NSString *)screenRatioString {
    int width = (int)[UIScreen mainScreen].bounds.size.width*[UIScreen mainScreen].scale;
    int height = (int)[UIScreen mainScreen].bounds.size.height*[UIScreen mainScreen].scale;
    return [NSString stringWithFormat:@"%dx%d",width,height];
}

+ (NSString *)screenPPIString {
    return [NSString stringWithFormat:@"%d PPI",(int)UIScreen.screenPPI];
}

+ (NSString *)memoryInfoString {
    YPApplicationMemoryUsage memoryUsage = [UIDevice currentMemoryUsage];
    return [NSString stringWithFormat:@"%.2f%% %dMB/%dMB",memoryUsage.ratio,(int)memoryUsage.usage,(int)memoryUsage.total];
}

+ (NSString *)telecomperatorsString {
    return UIDevice.mobileName;
}

+ (NSString *)wifiString {
    return [UIDevice wifi_ssid];
}

+ (NSString *)electricityString {
    float batteryLevel = [UIDevice currentDevice].batteryLevel;
    return [NSString stringWithFormat:@"%f%%",batteryLevel];
}

+ (NSString *)appVersionString {
    return [NSString stringWithFormat:@"%@ (build:%@)",UIApplication.budnleVersionString,UIApplication.bundleBuildVersionString];
}

+ (NSString *)sdkVersionString {
    return @"0.1";
}

@end
