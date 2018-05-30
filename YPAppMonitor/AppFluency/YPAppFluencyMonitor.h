//
//  ZYPFluencyMonitor.h
//  ZYPAppMonitor
//
//  Created by ZYP on 2018/3/8.
//  Copyright © 2018年 ZYP. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^yp_flunecy_handler)(NSString *);

@interface YPAppFluencyMonitor : NSObject

+ (void)start ;
+ (void)startWithAlertShowResult ;
+ (void)startWithCompletedHandler:(yp_flunecy_handler)handler ;

+ (void)stop ;

@end
