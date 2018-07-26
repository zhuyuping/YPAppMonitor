//
//  YPHttpClient.m
//  YPAppMonitorDemo
//
//  Created by ZYP on 2018/6/14.
//  Copyright © 2018年 ZYP. All rights reserved.
//

#import "YPHttpClient.h"
#import "NSDictionary+YP_Extension.h"

@interface YPHttpClient()

@end

@implementation YPHttpClient

+ (void)POSTWithBaseUrl:(NSString *)baseUrl
                   path:(NSString *)path
             parameters:(NSDictionary *)parameters
       completedHandler:(YPHttpClientRequestResultBlock)handle {
    [self sendRequestWithMethod:kHttpMethod_POST
                        baseUrl:baseUrl
                           path:path
                     parameters:parameters
               completedHandler:handle];
}

+ (void)GetWithBaseUrl:(NSString *)baseUrl
                  path:(NSString *)path
            parameters:(NSDictionary *)parameters
      completedHandler:(YPHttpClientRequestResultBlock)handle {
    [self sendRequestWithMethod:kHttpMethod_GET
                        baseUrl:baseUrl
                           path:path
                     parameters:parameters
               completedHandler:handle];
}

+ (void)sendRequestWithMethod:(YPHttpMethod)method
                      baseUrl:(NSString *)baseUrl
                         path:(NSString *)path
                   parameters:(NSDictionary *)parameters
             completedHandler:(YPHttpClientRequestResultBlock)handle {
    
    NSMutableURLRequest *request = [self requestWithMethod:method baseUrl:baseUrl path:path parameters:parameters];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        handle(resultString,error);
        [self logError:error];
        [self logRespone:response];
    }];
    [self logRequest:request];
    [task resume];
}

+ (NSMutableURLRequest *)requestWithMethod:(YPHttpMethod)method
                                   baseUrl:(NSString *)baseUrl
                                      path:(NSString *)path
                                parameters:(NSDictionary *)parameters {
    NSMutableURLRequest *request;
    if (method == kHttpMethod_POST) {
        NSURL *url = [NSURL URLWithString:[baseUrl stringByAppendingString:path]];
        request = [NSMutableURLRequest requestWithURL:url];
        request.HTTPMethod = method;
        request.HTTPBody = [parameters.jsonString dataUsingEncoding:NSUTF8StringEncoding];
        request.timeoutInterval = 6.0;
    }
    if (method == kHttpMethod_GET) {
        NSMutableString *urlString = [NSMutableString stringWithString:baseUrl];
        [urlString appendString:path];
        [urlString appendString:@"?"];
        [urlString appendString:parameters.jsonString];
        NSURL *url = [NSURL URLWithString:urlString];
        request = [NSMutableURLRequest requestWithURL:url];
        request.HTTPMethod = method;
        request.timeoutInterval = 6.0;
    }
    
    return request;
}

+ (void)logRequest:(NSMutableURLRequest *)request {
#if DEBUG
    if (!request) return;
    
    NSDictionary *headerDic = request.allHTTPHeaderFields;
    NSMutableString *logString = @"".mutableCopy;
    
    NSString *method = request.HTTPMethod;
    NSString *host = request.URL.host ? request.URL.host : @"";
    NSNumber *port = request.URL.port ? request.URL.port : @80;
    NSString *httpBodyString = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
    [logString appendString:[NSString stringWithFormat:@" %@ %@ HTTP1.1\n🚀",method,request.URL.path]];
    [logString appendString:[NSString stringWithFormat:@"Host:%@:%@\n🚀",host,port]];
    
    for (NSString *key in headerDic) {
        [logString appendString:[NSString stringWithFormat:@"%@:%@\n",key,headerDic[key]]];
    }
    if (httpBodyString) {
        [logString appendString:[NSString stringWithFormat:@"\n%@",httpBodyString]];
    }
    [logString replaceOccurrencesOfString:@"\n"
                               withString:@"\n🚀"
                                  options:NSCaseInsensitiveSearch
                                    range:NSMakeRange(0, logString.length)];
    NSString *outputString = [NSString stringWithFormat:@"\nRequest: \n🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀\n[%@]\n🚀(%@)\n🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀\n",request.URL.absoluteString,logString];
    NSLog(@"%@", outputString);
#endif
}

+ (void)logRespone:(NSURLResponse *)respone {
#if DEBUG
    if (!respone) return;
    
    NSHTTPURLResponse *httpRespone = (NSHTTPURLResponse *)respone;
    NSInteger statusCode = httpRespone.statusCode;
    NSString *status = [NSHTTPURLResponse localizedStringForStatusCode:statusCode];
    NSMutableString *logString = @"".mutableCopy;
    
    [logString appendString:[NSString stringWithFormat:@"✋ HTTP/1.1 \(%ld) \(%@)\n",(long)statusCode,status]];
    for (NSString *key in httpRespone.allHeaderFields) {
        [logString appendString:[NSString stringWithFormat:@"%@:%@\n",key,httpRespone.allHeaderFields[key]]];
    }
    
    [logString replaceOccurrencesOfString:@"\n"
                               withString:@"\n✋"
                                  options:NSCaseInsensitiveSearch
                                    range:NSMakeRange(0, logString.length)];
    NSString *outputString = [NSString stringWithFormat:@"\nResponse: \n✋✋✋✋✋✋✋✋✋✋\n[\(%@)]:\n\(%@)\n✋✋✋✋✋✋✋✋✋✋\n",respone.URL.absoluteString,logString];
    NSLog(@"%@", outputString);
#endif
}

+ (void)logError:(NSError *)error {
#if DEBUG
    if (!error) return;
    
    NSString *description;
    if (error.code > -1022 && error.code < -1000) {
        description = @"网络错误";
    } else if (error.code > 400 && error.code < 499) {
        description = @"客户端错误";
    } else if (error.code > 500 && error.code < 599) {
        description = @"服务端错误";
    } else {
        description = @"未知错误";
    }
    NSLog(@"\n❌❌❌❌❌❌❌❌❌❌\n❌[ %@ %ld %@] \n❌❌❌❌❌❌❌❌❌❌ \n",description,(long)error.code,error.description);
#endif
}

@end
