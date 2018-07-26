//
//  UIDevice+YP_Extension.h
//  YPAppMonitorDemo
//
//  Created by ZYP on 2018/7/18.
//  Copyright © 2018年 ZYP. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct YPApplicationMemoryUsage
{
    double usage;   ///< 已用内存(MB)
    double total;   ///< 总内存(MB)
    double ratio;   ///< 占用比率
} YPApplicationMemoryUsage;

@interface UIDevice (YP_Extension)

+ (double)currentCpuUsage ;
+ (YPApplicationMemoryUsage)currentMemoryUsage ;
+ (NSString *)wifi_ssid ;
+ (NSString *)mobileName ;

@end
