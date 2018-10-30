//
//  ZYPAppCrashMonitor.h
//  ZYPAppMonitor
//
//  Created by ZYP on 2018/3/16.
//  Copyright © 2018年 ZYP. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^yp_crash_handler)(NSString *identifier, NSString *crashInfoString, NSData *shotData);

@interface YPAppCrashMonitor : NSObject

+ (void)startWithCompletedHandler:(yp_crash_handler)handler ;

@end
