//
//  YPReporterNetworkOperation.m
//  YPAppMonitorDemo
//
//  Created by ZYP on 2018/6/14.
//  Copyright © 2018年 ZYP. All rights reserved.
//

#import "YPReporterNetworkOperation.h"
#import "NSDictionary+YP_Extension.h"


NSString * const __YP_Reporter_path_fluency = @"fluencies";
NSString * const __YP_Reporter_path_crash = @"crashs";
NSString * const __YP_Reporter_path_shot = @"shot";

NSString *__YP_reporterNetworkOperation_baseUrl;
inline void _YP_reporterNetworkOperation_setBaseUrl(NSString *url){
    __YP_reporterNetworkOperation_baseUrl = url.copy;
}

static inline NSString *_YP_reporterNetworkOperation_getBaseUrl(){
    return __YP_reporterNetworkOperation_baseUrl;
}

@implementation YPReporterNetworkOperation

+ (void)postFluencyReports:(NSArray <NSString *>*)reports completedHandler:(YPHttpClientRequestResultBlock)handle {
    NSDictionary *dict = @{@"data" : reports};
    [YPHttpClient POSTWithBaseUrl:_YP_reporterNetworkOperation_getBaseUrl() path:__YP_Reporter_path_fluency parameters:dict completedHandler:handle];
}

+ (void)postCrashReports:(NSArray <NSString *>*)reports completedHandler:(YPHttpClientRequestResultBlock)handle {
    NSDictionary *dict = @{@"data" : reports};
    [YPHttpClient POSTWithBaseUrl:_YP_reporterNetworkOperation_getBaseUrl()
                             path:__YP_Reporter_path_crash
                       parameters:dict
                 completedHandler:handle];
}

+ (void)uploadImagePngWithNames:(NSArray <NSString *>*)fileNames
                       fileUrls:(NSArray <NSURL *>*)fileUrls
               completedHandler:(YPHttpClientRequestResultBlock)handle {
    NSMutableArray *array = @[].mutableCopy;
    [fileNames enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:@"image/png"];
    }];
    NSArray <NSString *>* contentTypes = array.copy;
    [YPHttpClient POSTFilesWithBaseUrl:_YP_reporterNetworkOperation_getBaseUrl()
                                  path:__YP_Reporter_path_shot
                             fileNames:fileNames
                              fileUrls:fileUrls
                                  name:@"image"
                          contentTypes:contentTypes
                      completedHandler:handle];
}

+ (void)uploadTerminalLogFileWithNames:(NSArray <NSString *>*)fileNames
                       fileUrls:(NSArray <NSURL *>*)fileUrls
               completedHandler:(YPHttpClientRequestResultBlock)handle {
    NSMutableArray *array = @[].mutableCopy;
    [fileNames enumerateObjectsUsingBlock:^(NSString * _Nonnull obj,
                                            NSUInteger idx,
                                            BOOL * _Nonnull stop) {
        [array addObject:@"text/plain"];
    }];
    NSArray <NSString *>* contentTypes = array.copy;
    [YPHttpClient POSTFilesWithBaseUrl:_YP_reporterNetworkOperation_getBaseUrl()
                                  path:__YP_Reporter_path_shot
                             fileNames:fileNames
                              fileUrls:fileUrls
                                  name:@"log"
                          contentTypes:contentTypes
                      completedHandler:handle];
}

@end
