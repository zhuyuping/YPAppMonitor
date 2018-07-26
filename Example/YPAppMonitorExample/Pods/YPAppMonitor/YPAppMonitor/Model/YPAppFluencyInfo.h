//
//  YPAppFluencyInfo.h
//  YPAppMonitorDemo
//
//  Created by ZYP on 2018/7/10.
//  Copyright © 2018年 ZYP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YPAppFluencyInfo : NSObject

@property (nonatomic, readonly) NSString * deviceInfo;          // iOS 11.4 ，iPhone 7
@property (nonatomic, readonly) NSString * screenRatio;         // 750x1334
@property (nonatomic, readonly) NSString * screenPPI;           // 326 PPI
@property (nonatomic, readonly) NSString * memoryInfo;          // 可用：164.86MB，已用：1416.19MB
@property (nonatomic, readonly) NSString * telecomperators;     // 中国移动 (LTE)
@property (nonatomic, readonly) NSString * WIFI;                // N/A
@property (nonatomic, readonly) NSString * electricity;         // 67%，Unplugged
@property (nonatomic, readonly) NSString * appVersion;          // 3.1.1 (build 2)
@property (nonatomic, readonly) NSString * sdkVersion;          // 3.1.1
@property (nonatomic, readonly) NSString * screenShotImageUrl;  // 截图URL

@property (nonatomic, readonly) NSString * identifier;
@property (nonatomic, readonly) NSString * name;
@property (nonatomic, readonly) NSString * stackInfo;
@property (nonatomic, readonly) NSString * time;
@property (nonatomic, readonly) NSString * topViewController;

+ (instancetype)fluencyInfoWithStackInfo: (NSString *)stackInfo
                       topViewController: (NSString *)topViewController;
- (NSDictionary *)dictionary ;

@end
