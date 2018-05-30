//
//  YPBacktraceLogger.h
//  
//
//  Created by zyp on 2017/3/23.
//  Copyright © 2017年 zyp. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  @brief  线程堆栈上下文输出
 */
@interface YPBacktraceLogger : NSObject

+ (NSString *)YP_backtraceOfAllThread;
+ (NSString *)YP_backtraceOfMainThread;
+ (NSString *)YP_backtraceOfCurrentThread;
+ (NSString *)YP_backtraceOfNSThread:(NSThread *)thread;

+ (void)YP_logMain;
+ (void)YP_logCurrent;
+ (void)YP_logAllThread;

+ (NSString *)backtraceLogFilePath;
+ (void)recordLoggerWithFileName: (NSString *)fileName;

@end
