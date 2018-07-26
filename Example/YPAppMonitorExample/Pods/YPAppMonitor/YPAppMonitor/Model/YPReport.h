//
//  YPReport.h
//  YPAppMonitorDemo
//
//  Created by ZYP on 2018/6/15.
//  Copyright © 2018年 ZYP. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : int {
    YPReportTypeFluency,
    YPReportTypeCrash,
} YPReportType;

@interface YPReport :NSObject

@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *identifier;
@property(nonatomic, assign) YPReportType type;

+ (instancetype)reportForFluencyWithContent:(NSString *)content ;
+ (instancetype)reportForCrashWithContent:(NSString *)content ;
+ (instancetype)reportWithContent:(NSString *)content
                       identifier:(NSString *)identifier
                             type:(YPReportType)type ;
- (instancetype)initWithContent:(NSString *)content
                     identifier:(NSString *)identifier
                           type:(YPReportType)type ;
+ (NSString *)createIdentifier ;
- (NSDictionary *)dictionary ;

@end
