//
//  YPMonitorReport.m
//  YPAppMonitorDemo
//
//  Created by ZYP on 2018/6/14.
//  Copyright © 2018年 ZYP. All rights reserved.
//

#import "YPMonitorReporter.h"
#import "YPDispatchQueuePool.h"
#import "YPPersistency.h"
#import "YPReporterNetworkOperation.h"
#import "YPReport.h"

const int  __updateSessionPeriod = 8;
const char *__queue_name = "com.YPAppMonitor.DataOperationQueue";

@interface YPMonitorReporter(){
    NSTimer* timer;
    BOOL isSuspended;
    NSURL *reportUrl;
}

@end

@implementation YPMonitorReporter

dispatch_queue_t __MonitorReporterOperationQueue;

+ (instancetype)sharedInstance {
    static YPMonitorReporter* s_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{s_sharedInstance = self.new;});
    return s_sharedInstance;
}

- (instancetype)init {
    if (self == [super init]) {
        __MonitorReporterOperationQueue = dispatch_queue_create(__queue_name, DISPATCH_QUEUE_SERIAL);
        [YPPersistency sharedInstance];
    }
    return self;
}

- (void)configReportUrl:(NSURL *)url {
    reportUrl = url.copy;
    _YP_reporterNetworkOperation_setBaseUrl(reportUrl.absoluteString);
}

- (void)addReport:(YPReport *)report {
    dispatch_async(__MonitorReporterOperationQueue, ^{
        [[YPPersistency sharedInstance] addToQueue:report];
    });
}

- (void)resume {
    if (!reportUrl) { NSLog(@"please config reportServerUrl"); return; }
    if (timer) return;
    timer = [NSTimer scheduledTimerWithTimeInterval:__updateSessionPeriod
                                             target:self
                                           selector:@selector(onTimer:)
                                           userInfo:nil
                                            repeats:YES];
    [NSRunLoop.mainRunLoop addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)suspend {
    isSuspended = YES;
    [[YPPersistency sharedInstance] saveToFileWithType:YPReportTypeFluency];
    [[YPPersistency sharedInstance] saveToFileWithType:YPReportTypeCrash];
}

- (void)onTimer:(NSTimer *)timer {
    if (isSuspended) return;
    [self uploadTask];
}

- (void)uploadTask {
    NSArray *someFluencyReports = [[YPPersistency sharedInstance] someReportsWithType:YPReportTypeFluency];
    NSArray *someCrashReports = [[YPPersistency sharedInstance] someReportsWithType:YPReportTypeCrash];
    if (someFluencyReports.count > 0) { [self sendWithReports:someFluencyReports]; }
    if (someCrashReports.count > 0) { [self sendWithReports:someCrashReports]; }
}

- (void)sendWithReports:(NSArray <YPReport *>*)reports {
    NSArray *stringArray = [self stringArrayFromReportArray:reports];
    YPReport *report = reports[0];
    if (report.type == YPReportTypeFluency) {
        [YPReporterNetworkOperation postFluencyReports:stringArray completedHandler:^(NSString *result, NSError *error) {
            if (!error) {
                [[YPPersistency sharedInstance] removeReports:reports];
            }
            else {
                [[YPPersistency sharedInstance] saveToFileWithType:report.type];
            }
        }];
    }
    if (report.type == YPReportTypeCrash) {
        [YPReporterNetworkOperation postCrashReports:stringArray completedHandler:^(NSString *result, NSError *error) {
            if (!error) {
                [[YPPersistency sharedInstance] removeReports:reports];
            }
            else {
                [[YPPersistency sharedInstance] saveToFileWithType:report.type];
            }
        }];
    }
}

- (NSArray <NSString *>*)stringArrayFromReportArray:(NSArray <YPReport *>*)reportArray {
    NSMutableArray *stringArray = [NSMutableArray array];
    for (YPReport *re in reportArray) {
        [stringArray addObject:re.dictionary];
    }
    return stringArray.copy;
}

@end
