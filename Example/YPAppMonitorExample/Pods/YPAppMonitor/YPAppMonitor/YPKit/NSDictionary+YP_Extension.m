//
//  NSDictionary+YP_Extension.m
//  YPAppMonitorDemo
//
//  Created by ZYP on 2018/6/14.
//  Copyright © 2018年 ZYP. All rights reserved.
//

#import "NSDictionary+YP_Extension.h"

@implementation NSDictionary (YP_Extension)

- (NSString *)jsonString {
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&parseError];
    if (parseError) {
        NSLog(@"NSDictionary+YP_Extension error :%@",parseError);
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
