//
//  UIApplication+YP_Extension.m
//  YPAppMonitorDemo
//
//  Created by ZYP on 2018/7/18.
//  Copyright © 2018年 ZYP. All rights reserved.
//

#import "UIApplication+YP_Extension.h"

@implementation UIApplication (YP_Extension)

+ (NSString *)budnleVersionString {
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
}

+ (NSString *)bundleBuildVersionString {
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
}

@end
