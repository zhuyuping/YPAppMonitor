//
//  NSDate+YP_Extension.m
//  YPAppMonitorDemo
//
//  Created by ZYP on 2018/6/14.
//  Copyright © 2018年 ZYP. All rights reserved.
//

#import "NSDate+YP_Extension.h"

@implementation NSDate (YP_Extension)

+ (NSString *)currentTimeStamp {
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    return [NSString stringWithFormat:@"%f",interval];
}

+ (NSString *)currentTimeStampMS {
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    long long ms = round(interval*1000);
    return [NSString stringWithFormat:@"%lld",ms];
}

// yyyy-HH-dd HH:mm:ss
+ (NSString *)currentTimeString {
    static NSDateFormatter * yp_date_formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        yp_date_formatter = [NSDateFormatter new];
        yp_date_formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    });
    return [yp_date_formatter stringFromDate: [NSDate date]];
}

@end
