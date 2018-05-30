//
//  ZYPAppCrashInfo.h
//  ZYPAppMonitor
//
//  Created by ZYP on 2018/3/16.
//  Copyright © 2018年 ZYP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYPAppCrashInfo : NSObject

@property (nonatomic, readonly) NSString * name;
@property (nonatomic, readonly) NSString * reason;
@property (nonatomic, readonly) NSString * stackInfo;
@property (nonatomic, readonly) NSString * crashTime;
@property (nonatomic, readonly) NSString * topViewController;
@property (nonatomic, readonly) NSString * applicationVersion;

+ (instancetype)crashInfoWithName: (NSString *)name
                           reason: (NSString *)reason
                        stackInfo: (NSString *)stackInfo
                        crashTime: (NSDate *)crashTime
                topViewController: (NSString *)topViewController
                  applicationInfo: (NSString *)applicationInfo;

@end
