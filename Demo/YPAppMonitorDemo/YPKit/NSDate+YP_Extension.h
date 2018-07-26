//
//  NSDate+YP_Extension.h
//  YPAppMonitorDemo
//
//  Created by ZYP on 2018/6/14.
//  Copyright © 2018年 ZYP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (YP_Extension)

// from 1970
+ (NSString *)currentTimeStamp ;
+ (NSString *)currentTimeStampMS ;
// yyyy-HH-dd HH:mm:ss
+ (NSString *)currentTimeString;
@end
