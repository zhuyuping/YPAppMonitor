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

+ (void)POSTFilesWithBaseUrl:(NSString *)baseUrl
                        path:(NSString *)path
                   fileNames:(NSArray <NSString *>*)fileNames
                    fileUrls:(NSArray <NSURL *>*)fileUrls
                        name:(NSString *)name
                contentTypes:(NSArray <NSString *>*)contentTypes
            completedHandler:(YPHttpClientRequestResultBlock)handle {
    [self sendFilesRequestWithMethod:kHttpMethod_POST
                             baseUrl:baseUrl
                                path:path
                           fileNames:fileNames
                            fileUrls:fileUrls
                                name:name
                        contentTypes:contentTypes
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

+ (void)sendFilesRequestWithMethod:(YPHttpMethod)method
                           baseUrl:(NSString *)baseUrl
                              path:(NSString *)path
                         fileNames:(NSArray <NSString *>*)fileNames
                          fileUrls:(NSArray <NSURL *>*)fileUrls
                              name:(NSString *)name
                      contentTypes:(NSArray <NSString *>*)contentTypes
                  completedHandler:(YPHttpClientRequestResultBlock)handle {
    
    NSMutableURLRequest *request = [self fileRequestWithMethod:method
                                                       baseUrl:baseUrl
                                                          path:path
                                                     fileNames:fileNames
                                                      fileUrls:fileUrls
                                                          name:@""
                                                  contentTypes:contentTypes];
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

+ (NSMutableURLRequest *)fileRequestWithMethod:(YPHttpMethod)method
                                       baseUrl:(NSString *)baseUrl
                                          path:(NSString *)path
                                     fileNames:(NSArray <NSString *>*)fileNames
                                      fileUrls:(NSArray <NSURL *>*)fileUrls
                                          name:(NSString *)name
                                  contentTypes:(NSArray <NSString *>*)contentTypes {
    NSMutableURLRequest *request;
    NSURL *url = [NSURL URLWithString:[baseUrl stringByAppendingString:path]];
    request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = method;
    request.timeoutInterval = 6.0;
    
    static NSString *boundary = @"xdxd2313132331221232Request";
    
    //拼接请求体数据(0-6步)
    NSMutableData *requestMutableData = [NSMutableData data];
    
    for (int i = 0; i < fileNames.count; i++) {
        /*--------------------------------------------------------------------------*/
        //1.\r\n--Boundary+72D4CD655314C423\r\n   // 分割符，以“--”开头，后面的字随便写，只要不写中文即可
        NSMutableString *myString = [NSMutableString stringWithFormat:@"\r\n--%@\r\n",boundary];
        
        //2. Content-Disposition: form-data; name="image"; filename="001.png"\r\n
        // 这里注明服务器接收图片的参数（类似于接收用户名的userName）及服务器上保存图片的文件名
        NSString *fileName = fileNames[i];
        [myString appendString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",name,fileName]];
        
        //3. Content-Type:image/png \r\n  // 图片类型为png
        NSString *contentString = [NSString stringWithFormat:@"Content-Type:%@\r\n",contentTypes[i]];
        [myString appendString:contentString];
        
        //4. Content-Transfer-Encoding: binary\r\n\r\n  // 编码方式
        [myString appendString:@"Content-Transfer-Encoding: binary\r\n\r\n"];
        
        //转换成为二进制数据
        [requestMutableData appendData:[myString dataUsingEncoding:NSUTF8StringEncoding]];
        
        //5.文件数据部分
        //转换成为二进制数据
        NSURL *fileUrl = fileUrls[i];
        NSData *filedata = [NSData dataWithContentsOfFile:fileUrl.path];
        [requestMutableData appendData:filedata];
//        [requestMutableData appendData:[@"这是内容" dataUsingEncoding:NSUTF8StringEncoding]];

    }
    //6. \r\n--Boundary+72D4CD655314C423--\r\n  // 分隔符后面以"--"结尾，表明结束
    [requestMutableData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //设置请求体
    request.HTTPBody = requestMutableData;
    NSLog(@"以下:\n %@",[[NSString alloc] initWithData:requestMutableData encoding:NSUTF8StringEncoding]);
    //设置请求头
    NSString *headStr = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request setValue:headStr forHTTPHeaderField:@"Content-Type"];
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
