//
//  YPHttpClient.h
//  YPAppMonitorDemo
//
//  Created by ZYP on 2018/6/14.
//  Copyright © 2018年 ZYP. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString* YPHttpMethod;
static const YPHttpMethod kHttpMethod_GET = @"GET";
static const YPHttpMethod kHttpMethod_POST = @"POST";

typedef void(^YPHttpClientRequestResultBlock)(id msg,NSError *error);

@interface YPHttpClient : NSObject

+ (void)POSTWithBaseUrl:(NSString *)baseUrl
                   path:(NSString *)path
             parameters:(NSDictionary *)parameters
       completedHandler:(YPHttpClientRequestResultBlock)handle ;
+ (void)GetWithBaseUrl:(NSString *)baseUrl
                  path:(NSString *)path
            parameters:(NSDictionary *)parameters
      completedHandler:(YPHttpClientRequestResultBlock)handle ;

@end
