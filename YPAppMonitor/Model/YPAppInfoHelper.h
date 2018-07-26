//
//  YPAppInfoHelper.h
//  YPAppMonitorDemo
//
//  Created by ZYP on 2018/7/18.
//  Copyright © 2018年 ZYP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YPAppInfoHelper : NSObject

+ (NSString *)timeString ;
+ (NSString *)identifierString ;
+ (NSString *)deviceInfoString ;
+ (NSString *)screenRatioString ;
+ (NSString *)screenPPIString ;
+ (NSString *)memoryInfoString ;
+ (NSString *)telecomperatorsString ;
+ (NSString *)wifiString ;
+ (NSString *)electricityString ;
+ (NSString *)appVersionString ;
+ (NSString *)sdkVersionString ;

@end
