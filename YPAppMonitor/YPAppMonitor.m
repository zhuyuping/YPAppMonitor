//
//  YPAppMonitor.m
//  YPAppMonitorDemo
//
//  Created by ZYP on 2018/6/14.
//  Copyright © 2018年 ZYP. All rights reserved.
//

#import "YPAppMonitor.h"
#import "YPAppFluencyMonitor.h"
#import "YPAppCrashMonitor.h"
#import "YPMonitorReporter.h"
#import "YPReport.h"

@implementation YPAppMonitorConfiguration

- (instancetype)init {
    if (self = [super init]) {
        _useCrashMonitoring = YES;
        _useFluencymonitoring = YES;
        _showAlertWhenNotFluency = NO;
    }
    return self;
}

@end

@interface YPAppMonitor()

@end

@implementation YPAppMonitor

+ (instancetype)sharedInstance {
    static YPAppMonitor *s_sharedCountly = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{s_sharedCountly = self.new;});
    return s_sharedCountly;
}

- (instancetype)init {
    if (self = [super init]){
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(didEnterBackgroundCallBack:)
                                                   name:UIApplicationDidEnterBackgroundNotification
                                                 object:nil];
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(willEnterForegroundCallBack:)
                                                   name:UIApplicationWillEnterForegroundNotification
                                                 object:nil];
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(willTerminateCallBack:)
                                                   name:UIApplicationWillTerminateNotification
                                                 object:nil];
    }
    return self;
}

+ (void)start {
    YPAppMonitorConfiguration *config = [YPAppMonitorConfiguration new];
    config.useCrashMonitoring = YES;
    config.useCrashMonitoring = YES;
    [self startWithConfiguration:config];
}

+ (void)startWithConfiguration:(YPAppMonitorConfiguration *)config {
    
    [YPAppMonitor sharedInstance].config = config;
    if (config.useFluencymonitoring || config.useCrashMonitoring) {
        [[YPMonitorReporter sharedInstance] configReportUrl:config.reportServerBaseUrl];
        [[YPMonitorReporter sharedInstance] resume];
    }
    if (config.useFluencymonitoring) {
        [YPAppFluencyMonitor startWithCompletedHandler:^(NSString *backtrace) {
            YPReport *report = [YPReport reportForFluencyWithContent:backtrace];
            [[YPMonitorReporter sharedInstance] addReport:report];
        }];
    }
    if (config.useCrashMonitoring) {
        [YPAppCrashMonitor startWithCompletedHandler:^(NSString *crashInfoString) {
            YPReport *report = [YPReport reportForCrashWithContent:crashInfoString];
            [[YPMonitorReporter sharedInstance] addReport:report];
        }];
    }
    
}

- (void)suspend {
    [[YPMonitorReporter sharedInstance] suspend];
}

- (void)resume {
    [[YPMonitorReporter sharedInstance] resume];
}

#pragma mark --- Notification

- (void)didEnterBackgroundCallBack:(NSNotification *)notification {
    NSLog(@"App did enter background.");
    [self suspend];
}

- (void)willEnterForegroundCallBack:(NSNotification *)notification {
    NSLog(@"App will enter foreground.");
    [self resume];
}

- (void)willTerminateCallBack:(NSNotification *)notification {
    NSLog(@"App will terminate.");
    [self suspend];
}

@end
