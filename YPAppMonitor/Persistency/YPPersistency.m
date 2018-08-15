//
//  YPPersistency.m
//  YPAppMonitorDemo
//
//  Created by ZYP on 2018/6/14.
//  Copyright © 2018年 ZYP. All rights reserved.
//

#import "YPPersistency.h"
#import "YPDispatchQueuePool.h"
#import "YPReport.h"
#import "YP_Extension.h"

NSString * const kYPMonitorFluencyReportsPersistencyKey = @"kYPMonitorFluencyReportsPersistencyKey";
NSString * const kYPMonitorCrashReportsPersistencyKey = @"kYPMonitorCrashReportsPersistencyKey";
NSString * const kYPMonitorScreenShotPersistencyKey = @"kYPMonitorScreenShotPersistencyKey";
NSString * const kYPMonitorTerminalLogPersistencyKey = @"kYPMonitorTerminalLogPersistencyKey";

NSString * const kShotDirectoryName = @"YPMonitorScreenShot";
NSString * const kTerminalLogDirectoryName = @"YPMonitorTerminalLog";

NSString * const kFluencyPersistencyFileName = @"YPMonitorFluency.dat";
NSString * const kCrashPersistencyFileName = @"YPMonitorCrash.dat";
NSString * const kShotPersistencyFileName = @"YPMonitorShot.dat";
NSString * const kTerminalLogPersistencyFileName = @"YPMonitorTerminalLog.dat";

NSURL * __fluencySaveDataUrl() {
    static NSURL *url = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        url = UIApplication.yp_applicationSupportURL;
        [url URLByAppendingPathComponent:kFluencyPersistencyFileName];
    });
    return url;
}
NSURL * __CrashSaveDataUrl() {
    static NSURL *url = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        url = UIApplication.yp_applicationSupportURL;
        [url URLByAppendingPathComponent:kCrashPersistencyFileName];
    });
    return url;
}
NSURL * __shotIndexDataUrl() {
    static NSURL *url = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        url = UIApplication.yp_applicationSupportURL;
        [url URLByAppendingPathComponent:kShotPersistencyFileName];
    });
    return url;
}
NSURL * __terminalLogIndexDataUrl() {
    static NSURL *url = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        url = UIApplication.yp_applicationSupportURL;
        [url URLByAppendingPathComponent:kTerminalLogPersistencyFileName];
    });
    return url;
}
NSURL * __shotDirectoryUrl() {
    static NSURL *url = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        url = [UIApplication.yp_applicationSupportURL URLByAppendingPathComponent:kShotDirectoryName];
        [NSFileManager checkAndCreateDirIfNotExistWithPath:url.path];
    });
    return url;
}
NSURL * __TerminalLogDirectoryUrl() {
    static NSURL *url = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        url = [UIApplication.yp_applicationSupportURL URLByAppendingPathComponent:kTerminalLogDirectoryName];
        [NSFileManager checkAndCreateDirIfNotExistWithPath:url.path];
    });
    return url;
}

@interface YPPersistency()

@property(nonatomic, strong) NSMutableArray *fluencyQueue;
@property(nonatomic, strong) NSMutableArray *crashQueue;
@property(nonatomic, strong) NSMutableArray *screenShotIndexQueue;
@property(nonatomic, strong) NSMutableArray *terminalLogIndexQueue;

@end

@implementation YPPersistency

+ (instancetype)sharedInstance {
    static YPPersistency* s_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{s_sharedInstance = self.new;});
    return s_sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        _queueMaxLength = 200;
        
        _fluencyQueue = @[].mutableCopy;
        _crashQueue = @[].mutableCopy;
        _screenShotIndexQueue = @[].mutableCopy;
        _terminalLogIndexQueue = @[].mutableCopy;
        
        NSData *fluencySaveData = [NSData dataWithContentsOfURL:__fluencySaveDataUrl()];
        NSData *crashSaveData = [NSData dataWithContentsOfURL:__CrashSaveDataUrl()];
        NSData *screenShotData = [NSData dataWithContentsOfURL:__shotIndexDataUrl()];
        NSData *terminalLogData = [NSData dataWithContentsOfURL:__terminalLogIndexDataUrl()];
        
        if (fluencySaveData) {
            NSDictionary* readDict = [NSKeyedUnarchiver unarchiveObjectWithData:fluencySaveData];
            self.fluencyQueue = [readDict[kYPMonitorFluencyReportsPersistencyKey] mutableCopy];
        }
        if (crashSaveData) {
            NSDictionary* readDict = [NSKeyedUnarchiver unarchiveObjectWithData:crashSaveData];
            self.crashQueue = [readDict[kYPMonitorCrashReportsPersistencyKey] mutableCopy];
        }
        if (screenShotData) {
            NSDictionary* readDict = [NSKeyedUnarchiver unarchiveObjectWithData:screenShotData];
            self.screenShotIndexQueue = [readDict[kYPMonitorScreenShotPersistencyKey] mutableCopy];
        }
        if (terminalLogData) {
            NSDictionary* readDict = [NSKeyedUnarchiver unarchiveObjectWithData:terminalLogData];
            self.terminalLogIndexQueue = [readDict[kYPMonitorTerminalLogPersistencyKey] mutableCopy];
        }
    }
    return self;
}

#pragma mark - public
#pragma mark add method

- (void)addReport:(YPReport *)report {
    if (!report) return;
    @synchronized (self){
        NSMutableArray *queue = (report.type == YPReportTypeFluency) ? self.fluencyQueue : self.crashQueue;
        if (queue.count > _queueMaxLength) {
            [queue removeObjectsInRange:(NSRange){0,1}];
        }
        [queue addObject:report];
        if (report.type == YPReportTypeCrash) {
            [self saveToFileSyncWithType:YPPersistencyTypeCrashData];
        }
    }
}

- (void)addShot:(NSData *)data name:(NSString *)name {
    if (!data || !name) return;
    dispatch_async(YPDispatchQueueGetForDefaultQOS(), ^{
        
        NSURL *fileUrl = [__shotDirectoryUrl() URLByAppendingPathComponent:name];
        BOOL succes = [data writeToFile:fileUrl.path atomically:YES];
        if (succes) { [self.screenShotIndexQueue addObject:name];}
    });
}

- (void)addTerminalLog:(NSData *)data name:(NSString *)name {
    if (!data || !name) return;
    dispatch_async(YPDispatchQueueGetForDefaultQOS(), ^{
        NSURL *fileUrl = [__TerminalLogDirectoryUrl() URLByAppendingPathComponent:name];
        [data writeToFile:fileUrl.path atomically:YES];
        [self.screenShotIndexQueue addObject:name];
    });
}

#pragma mark - remove method

- (void)removeReports:(NSArray <YPReport *>*)reports {
    if (!reports || reports.count == 0) return;
    YPReport *report = reports[0];
    YPPersistencyType type = (report.type == YPReportTypeFluency) ? YPPersistencyTypeFluencyData : YPPersistencyTypeCrashData;
    [self remove:type name:nil orReports:reports];
}

- (void)removeShotWithNames:(NSArray<NSString *> *)names {
    [self remove:YPPersistencyTypeScreenShot name:names orReports:nil];
}

- (void)removeTerminalLogWithNames:(NSArray<NSString *> *)names {
    [self remove:YPPersistencyTypeTerminalLog name:names orReports:nil];
}

#pragma mark - read method

- (NSArray <YPReport *>*)someReportsWithType:(YPReportType)type {
    YPPersistencyType newType = (type == YPReportTypeFluency) ? YPPersistencyTypeFluencyData : YPPersistencyTypeCrashData;
    return [self some:newType];
}

- (NSArray<NSString *> *)someShotNames {
    return [self some:YPPersistencyTypeScreenShot];
}

- (NSArray<NSString *> *)someTerminalLogNames {
    return [self some:YPPersistencyTypeTerminalLog];
}

+ (NSURL *)urlForScreenShotWithName:(NSString *)name {
    return [__shotDirectoryUrl() URLByAppendingPathComponent:name];
}

+ (NSURL *)urlTerminalLogWithName:(NSString *)name {
    return [__TerminalLogDirectoryUrl() URLByAppendingPathComponent:name];
}

+ (NSData *)dataScreenShotWithName:(NSString *)name {
    if (!name) return nil;
    NSURL *dataUrl = [__shotDirectoryUrl() URLByAppendingPathComponent:name];
    return [NSData dataWithContentsOfFile:dataUrl.absoluteString];
}

+ (NSData *)dataTerminalLogWithName:(NSString *)name {
    if (!name) return nil;
    NSURL *dataUrl = [__TerminalLogDirectoryUrl() URLByAppendingPathComponent:name];
    return [NSData dataWithContentsOfFile:dataUrl.absoluteString];
}

#pragma mark - save method

- (void)saveReportToFileWithType:(YPReportType)type {
    dispatch_async(YPDispatchQueueGetForDefaultQOS(), ^{
        YPPersistencyType newType = (type == YPReportTypeFluency) ? YPPersistencyTypeFluencyData : YPPersistencyTypeCrashData;
        [self saveToFileSyncWithType:newType];
    });
}

- (void)saveShotToFile {
    dispatch_async(YPDispatchQueueGetForDefaultQOS(), ^{
        [self saveToFileSyncWithType:YPPersistencyTypeScreenShot];
    });
}

- (void)saveTerminalLogToFile {
    dispatch_async(YPDispatchQueueGetForDefaultQOS(), ^{
        [self saveToFileSyncWithType:YPPersistencyTypeTerminalLog];
    });
}

#pragma mark - private

- (void)saveToFileSyncWithType:(YPPersistencyType)type {
    NSDictionary *dic;
    NSURL *url;
    switch (type) {
        case YPPersistencyTypeFluencyData:
            dic = @{kYPMonitorFluencyReportsPersistencyKey:self.fluencyQueue};
            url = __fluencySaveDataUrl();
            break;
        case YPPersistencyTypeCrashData:
            dic = @{kYPMonitorCrashReportsPersistencyKey:self.crashQueue};
            url = __CrashSaveDataUrl();
            break;
        case YPPersistencyTypeScreenShot:
            dic = @{kYPMonitorScreenShotPersistencyKey:self.screenShotIndexQueue};
            url = __shotIndexDataUrl();
            break;
        default:
            dic = @{kYPMonitorTerminalLogPersistencyKey:self.terminalLogIndexQueue};
            url = __terminalLogIndexDataUrl();
            break;
    }
    NSData* data;
    @synchronized (self){
        data = [NSKeyedArchiver archivedDataWithRootObject:dic];
        [data writeToFile:url.path atomically:YES];
    }
}

- (void)remove:(YPPersistencyType)type
          name:(NSArray <NSString *>*)names
     orReports:(NSArray <YPReport*>*)reports {
    
    NSMutableArray *queue;
    NSArray *removeItems;
    switch (type) {
        case YPPersistencyTypeFluencyData:
            NSAssert(reports, @"reports must be not nil");
            queue =  self.fluencyQueue;
            removeItems = reports;
            break;
        case YPPersistencyTypeCrashData:
            NSAssert(reports, @"reports must be not nil");
            queue =  self.crashQueue;
            removeItems = reports;
            break;
        case YPPersistencyTypeScreenShot:
            NSAssert(names, @"names must be not nil");
            queue =  self.screenShotIndexQueue;
            removeItems = names;
            [self removeDataWithType:type names:removeItems];
            break;
        default:
            NSAssert(names, @"names must be not nil");
            queue =  self.terminalLogIndexQueue;
            removeItems = names;
            [self removeDataWithType:type names:removeItems];
            break;
    }
}

- (void)removeDataWithType:(YPPersistencyType)type names:(NSArray <NSString *>*)names {
    for (NSString *name in names) {
        dispatch_async(YPDispatchQueueGetForDefaultQOS(), ^{
            NSURL *fileUrl = (type == YPPersistencyTypeScreenShot) ? [YPPersistency urlForScreenShotWithName:name] : [YPPersistency urlTerminalLogWithName:name];
            NSError *error = nil;
            [NSFileManager.defaultManager removeItemAtURL:fileUrl error:&error];
            if(error){ NSLog(@"ScreenShot file can not be remove: \n%@", error); }
        });
    }
}

- (NSArray *)some:(YPPersistencyType)type {
    @synchronized (self){
        NSMutableArray *queue ;
        switch (type) {
            case YPPersistencyTypeFluencyData:
                queue = self.fluencyQueue;
                break;
            case YPPersistencyTypeCrashData:
                queue = self.crashQueue;
                break;
            case YPPersistencyTypeScreenShot:
                queue = self.screenShotIndexQueue;
                break;
            default:
                queue = self.terminalLogIndexQueue;
                break;
        }
        
        if (queue.count <= 10) {
            return queue.copy;
        }
        else if (queue.count >10 && queue.count < 30) {
            NSMutableArray *someReports = [NSMutableArray arrayWithArray:[queue subarrayWithRange:(NSRange){0,10}]];
            return someReports.copy;
        }
        else {
            NSMutableArray *someReports = [NSMutableArray arrayWithArray:[queue subarrayWithRange:(NSRange){0,30}]];
            return someReports.copy;
        }
    }
}

@end
