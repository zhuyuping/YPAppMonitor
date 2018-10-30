//
//  YPSystemLogMessage.m
//  YPAppMonitorDemo
//
//  Created by ZYP on 2018/8/16.
//  Copyright © 2018年 ZYP. All rights reserved.
//

#import "YPSystemLogMessage.h"
#import <asl.h>

@implementation YPSystemLogMessage

+ (void)saveToURL:(NSURL *)url {
    NSAssert(url, @"url not nil");
    NSArray <YPSystemLogMessage *>* msg = [YPSystemLogMessage allLogMessagesForCurrentProcess];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:url.path]){
        [@"YPSystemLogMessage\n" writeToFile:url.path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:url.path];
    int idx = 0;
    for (YPSystemLogMessage *obj in msg) {
        @autoreleasepool {
            [fileHandle seekToEndOfFile];
            NSString *st = [NSString stringWithFormat:@"- %@ %@ %@\n",obj.date,obj.sender,obj.messageText];
            NSData *stringData  = [st dataUsingEncoding:NSUTF8StringEncoding];
            [fileHandle writeData:stringData];
            idx++;
        }
    }
    [fileHandle closeFile];
}

// 从日志的对象aslmsg中获取我们需要的数据
+ (instancetype)logMessageFromASLMessage:(aslmsg)aslMessage {
    YPSystemLogMessage *logMessage = [[YPSystemLogMessage alloc] init];
    const char *timestamp = asl_get(aslMessage, ASL_KEY_TIME);
    if (timestamp) {
        NSTimeInterval timeInterval = [@(timestamp) integerValue];
        const char *nanoseconds = asl_get(aslMessage, ASL_KEY_TIME_NSEC);
        if (nanoseconds) {
            timeInterval += [@(nanoseconds) doubleValue] / NSEC_PER_SEC;
        }
        logMessage.timeInterval = timeInterval;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"yyyy-HH-dd HH:mm:ss"];
        logMessage.date = [dateformatter stringFromDate:date];
    }
    const char *sender = asl_get(aslMessage, ASL_KEY_SENDER);
    if (sender) {
        logMessage.sender = @(sender);
    }
    const char *messageText = asl_get(aslMessage, ASL_KEY_MSG);
    if (messageText) {
        logMessage.messageText = @(messageText);//NSLog写入的文本内容
    }
    const char *messageID = asl_get(aslMessage, ASL_KEY_MSG_ID);
    if (messageID) {
        logMessage.messageID = [@(messageID) longLongValue];
    }
    return logMessage;
}

+ (NSMutableArray<YPSystemLogMessage *> *)allLogMessagesForCurrentProcess {
    asl_object_t query = asl_new(ASL_TYPE_QUERY);
    NSString *pidString = [NSString stringWithFormat:@"%d", [[NSProcessInfo processInfo] processIdentifier]];
    asl_set_query(query, ASL_KEY_PID, [pidString UTF8String], ASL_QUERY_OP_EQUAL);
    
    aslresponse response = asl_search(NULL, query);
    aslmsg aslMessage = NULL;
    
    NSMutableArray *logMessages = [NSMutableArray array];
    while ((aslMessage = asl_next(response))) {
        [logMessages addObject:[YPSystemLogMessage logMessageFromASLMessage:aslMessage]];
    }
    asl_release(response);
    
    return logMessages;
}
@end
