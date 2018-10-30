//
//  ZYPFluencyMonitor.m
//  ZYPAppMonitor
//
//  Created by ZYP on 2018/3/8.
//  Copyright © 2018年 ZYP. All rights reserved.
//

#import "YPAppFluencyMonitor.h"
#import "YPBacktraceLogger.h"
#import "UIViewController+ZYPMonitor.h"
#import "YPAppFluencyInfo.h"
#import "YP_Extension.h"

static BOOL yp_fluency_is_monitoring = NO ;
static NSTimeInterval yp_fluency_timeout_interval = 0.3;
static dispatch_semaphore_t yp_fluency_semaphore;
static dispatch_queue_t yp_fluency_monitor_queue;

yp_flunecy_handler yp_fluency_result_handler = nil;
BOOL yp_fluency_defaultShow_falg = NO;

@implementation YPAppFluencyMonitor

static inline dispatch_queue_t __fluency_monitor_queue() {
    
    static dispatch_once_t queue_once;
    dispatch_once(&queue_once, ^{
        yp_fluency_monitor_queue = dispatch_queue_create("com.zyp.fluency_monitor_queue", NULL);
    });
    return yp_fluency_monitor_queue;
}

static inline void __fluency_semaphore_init(){
    
    static dispatch_once_t sema_onceToken;
    dispatch_once(&sema_onceToken, ^{
        yp_fluency_semaphore = dispatch_semaphore_create(0);
    });
}

+ (void)start {
    if (yp_fluency_is_monitoring) return;
    
    yp_fluency_is_monitoring = YES;
    __fluency_semaphore_init();
    dispatch_async(__fluency_monitor_queue(), ^{
        while (yp_fluency_is_monitoring) {
            __block BOOL isTimeOut = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                isTimeOut = NO;
                dispatch_semaphore_signal(yp_fluency_semaphore);
            });
            
            [NSThread sleepForTimeInterval:yp_fluency_timeout_interval];
            if (isTimeOut) {
#if DEBUG
                [YPBacktraceLogger YP_logMain];
#endif
                if (yp_fluency_result_handler) {
                    NSString *topViewControllerClassName = NSStringFromClass([[UIViewController YP_findTopViewController] class]);
                    YPAppFluencyInfo *info  = [YPAppFluencyInfo fluencyInfoWithStackInfo:[YPBacktraceLogger YP_backtraceOfMainThread] topViewController:topViewControllerClassName];
                    NSData *shotData = UIApplication.yp_snapshotPNG;
                    yp_fluency_result_handler(info.identifier,info.dictionary.jsonString,shotData);
                }
                
                if (yp_fluency_defaultShow_falg) {
                    NSString *msg = [[@"\n" stringByAppendingString:[YPBacktraceLogger YP_backtraceOfMainThread]] stringByAppendingString:@"\n"];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"卡顿发生"
                                                                                             message:msg preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:nil];
                    [alertController addAction:action];
                    UIViewController *currentVC = [UIViewController YP_findTopViewController];
                    [currentVC presentViewController:alertController animated:YES completion:nil];
                }
            }
            dispatch_semaphore_wait(yp_fluency_semaphore, DISPATCH_TIME_FOREVER);
        }
    });
}


+ (void)startWithCompletedHandler:(yp_flunecy_handler)handler {
    [self startWithResultShowAlert:NO completedHandler:handler];
}

+ (void)startWithResultShowAlert:(BOOL)show completedHandler:(yp_flunecy_handler)handler {
    if (yp_fluency_is_monitoring) return;
    yp_fluency_defaultShow_falg = show;
    yp_fluency_result_handler = handler;
    [self start];
}

+ (void)stop {
    if (!yp_fluency_is_monitoring) return;
    yp_fluency_is_monitoring = NO;
    yp_fluency_result_handler = nil;
    yp_fluency_defaultShow_falg = NO;
}

@end
