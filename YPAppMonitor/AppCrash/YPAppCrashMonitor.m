//
//  YPAppCrashMonitor.m
//  ZYPAppMonitor
//
//  Created by ZYP on 2018/3/16.
//  Copyright © 2018年 ZYP. All rights reserved.
//

#import "YPAppCrashMonitor.h"
#import "ZYPAppCrashInfo.h"
#import "YPBacktraceLogger.h"
#import "UIViewController+ZYPMonitor.h"
#import "YPCrashLogger.h"

@implementation YPAppCrashMonitor

+ (void)startMonitor {
    NSSetUncaughtExceptionHandler(__exception_caught);
    signal(SIGILL, __YP_signal_handler);
    signal(SIGFPE, __YP_signal_handler);
    signal(SIGBUS, __YP_signal_handler);
    signal(SIGPIPE, __YP_signal_handler);
    signal(SIGSEGV, __YP_signal_handler);
    signal(SIGABRT, __YP_signal_handler);
}

+ (void)_killApp {
    NSSetUncaughtExceptionHandler(NULL);
    signal(SIGILL, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGABRT, SIG_DFL);
    kill(getpid(), SIGKILL);
}

static void __exception_caught(NSException *exception) {
    
    NSString *deviceModel = [UIDevice currentDevice].model;
    NSString *OS_Info = [NSString stringWithFormat:@"%@%@",[UIDevice currentDevice].systemName,[UIDevice currentDevice].systemVersion];
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *applicationVersion = infoDict[@"CFBundleShortVersionString"];
    NSString *applicationInfo = [NSString stringWithFormat:@"device:%@\n OS_Version:%@\n OS_System:%@",deviceModel,applicationVersion,OS_Info];
    NSString *stackInfo = [YPBacktraceLogger YP_backtraceOfCurrentThread];
    NSString *topViewControllerClassName = NSStringFromClass([[UIViewController YP_findTopViewController] class]);
    
    ZYPAppCrashInfo *info = [ZYPAppCrashInfo crashInfoWithName:exception.name
                                                        reason:exception.reason
                                                     stackInfo:stackInfo
                                                     crashTime:[NSDate date]
                                             topViewController:topViewControllerClassName
                                               applicationInfo:applicationInfo];
    
    YPCrashLogger * crashLogger = [YPCrashLogger crashLoggerWithName: exception.name
                                                                reason: exception.reason
                                                             stackInfo: [YPBacktraceLogger YP_backtraceOfCurrentThread]
                                                             crashTime: [NSDate date]
                                                     topViewController: topViewControllerClassName
                                                    applicationVersion: applicationInfo];
    [[YPCrashLoggerServer sharedServer] insertLogger: crashLogger];
}

static void __YP_signal_handler(int signal) {
    __exception_caught([NSException exceptionWithName: __signal_name(signal) reason: __signal_reason(signal) userInfo: nil]);
    [YPAppCrashMonitor _killApp];
}

CF_INLINE NSString * __signal_name(int signal) {
    switch (signal) {
            /// 非法指令
        case SIGILL:
            return @"SIGILL";
            /// 计算错误
        case SIGFPE:
            return @"SIGFPE";
            /// 总线错误
        case SIGBUS:
            return @"SIGBUS";
            /// 无进程接手数据
        case SIGPIPE:
            return @"SIGPIPE";
            /// 无效地址
        case SIGSEGV:
            return @"SIGSEGV";
            /// abort信号
        case SIGABRT:
            return @"SIGABRT";
        default:
            return @"Unknown";
    }
}

CF_INLINE NSString * __signal_reason(int signal) {
    switch (signal) {
            /// 非法指令
        case SIGILL:
            return @"Invalid Command";
            /// 计算错误
        case SIGFPE:
            return @"Math Type Error";
            /// 总线错误
        case SIGBUS:
            return @"Bus Error";
            /// 无进程接手数据
        case SIGPIPE:
            return @"No Data Receiver";
            /// 无效地址
        case SIGSEGV:
            return @"Invalid Address";
            /// abort信号
        case SIGABRT:
            return @"Abort Signal";
        default:
            return @"Unknown";
    }
}


@end
