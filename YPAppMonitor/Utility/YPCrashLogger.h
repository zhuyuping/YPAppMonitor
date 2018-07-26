//
//  YPCrashLogger.h
//
//
//  Created by yp on 2017/4/27.
//  Copyright © 2017年 zyp. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  @brief  崩溃日志
 */
@interface YPCrashLogger : NSObject

@property (nonatomic, readonly) NSString * name;
@property (nonatomic, readonly) NSString * reason;
@property (nonatomic, readonly) NSString * stackInfo;
@property (nonatomic, readonly) NSString * crashTime;
@property (nonatomic, readonly) NSString * topViewController;
@property (nonatomic, readonly) NSString * applicationVersion;

+ (instancetype)crashLoggerWithName: (NSString *)name
                             reason: (NSString *)reason
                          stackInfo: (NSString *)stackInfo
                          crashTime: (NSDate *)crashTime
                  topViewController: (NSString *)topViewController
                 applicationVersion: (NSString *)applicationVersion;

- (NSString *)loggerDescription;

@end


/*!
 *  @brief  日志服务管理
 */
@interface YPCrashLoggerServer : NSObject

+ (instancetype)sharedServer;
- (void)insertLogger: (YPCrashLogger *)logger;
- (void)fetchLastLogger: (void(^)(YPCrashLogger * logger))fetchHandle;
- (void)fetchLoggers: (void(^)(NSArray<YPCrashLogger *> * loggers))fetchHandle;

@end

