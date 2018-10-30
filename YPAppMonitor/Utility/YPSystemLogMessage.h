//
//  YPSystemLogMessage.h
//  YPAppMonitorDemo
//
//  Created by ZYP on 2018/8/16.
//  Copyright © 2018年 ZYP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YPSystemLogMessage : NSObject

@property(nonatomic, assign) NSTimeInterval timeInterval;    
@property(nonatomic, strong) NSString *date;
@property(nonatomic, strong) NSString *sender;
@property(nonatomic, strong) NSString *messageText;
@property(nonatomic, assign) NSInteger messageID ;

+ (void)saveToURL:(NSURL *)url ;

@end
