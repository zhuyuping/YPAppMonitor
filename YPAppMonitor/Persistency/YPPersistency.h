//
//  YPPersistency.h
//  YPAppMonitorDemo
//
//  Created by ZYP on 2018/6/14.
//  Copyright © 2018年 ZYP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YPReport.h"

@interface YPPersistency : NSObject

@property(nonatomic, assign) int queueMaxLength; // default 200

+ (instancetype)sharedInstance ;
- (void)addToQueue:(YPReport *)report ;
- (NSArray <YPReport *>*)someReportsWithType:(YPReportType)type ;
- (void)removeReports:(NSArray <YPReport *>*)reports ;
- (void)saveToFileWithType:(YPReportType)type ;

@end
