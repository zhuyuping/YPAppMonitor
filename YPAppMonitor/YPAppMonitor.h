//
//  YPAppMonitor.h
//  YPAppMonitor
//
//  Created by ZYP on 2018/5/30.
//  Copyright © 2018年 ZYP. All rights reserved.
//

#import <UIKit/UIKit.h>

#if __has_include(<YPAppMonitor/YPAppMonitor.h>)

FOUNDATION_EXPORT double YPAppMonitorVersionNumber;
FOUNDATION_EXPORT const unsigned char YPAppMonitorVersionString[];

YPAppMonitorVersionNumber = 3;
YPAppMonitorVersionString = @"0.0.4"; // sync change tag !!!

#import <YPAppMonitor/YPAppFluencyMonitor.h>

#endif


@interface YPAppMonitorConfiguration : NSObject

@property(nonatomic, assign) BOOL useFluencymonitoring;                         // default is Yes
@property(nonatomic, assign) BOOL showAlertWhenNotFluency;                      // default is NO
@property(nonatomic, assign) BOOL useCrashMonitoring;                           // default is Yes
@property(nonatomic, strong) NSURL *reportServerBaseUrl;                        // default is nil

@end

@interface YPAppMonitor : NSObject

@property (nonatomic, strong)YPAppMonitorConfiguration *config;

+ (void)startWithConfiguration:(YPAppMonitorConfiguration *)config ;

@end
