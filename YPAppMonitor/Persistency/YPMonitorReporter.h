//
//  YPMonitorReport.h
//  YPAppMonitorDemo
//
//  Created by ZYP on 2018/6/14.
//  Copyright © 2018年 ZYP. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YPReport;

@interface YPMonitorReporter : NSObject

+ (instancetype)sharedInstance ;
- (void)configReportUrl:(NSURL *)url;
- (void)addReport:(YPReport *)report ;
- (void)resume ;
- (void)suspend ;

@end
