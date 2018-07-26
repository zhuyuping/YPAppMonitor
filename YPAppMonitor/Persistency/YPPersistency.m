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

NSString* const kYPMonitorFluencyReportsPersistencyKey = @"kYPMonitorFluencyReportsPersistencyKey";
NSString* const kYPMonitorCrashReportsPersistencyKey = @"kYPMonitorCrashReportsPersistencyKey";

@interface YPPersistency()

@property(nonatomic, strong) NSMutableArray *fluencyQueue;
@property(nonatomic, strong) NSMutableArray *crashQueue;

@end

const NSString * __kFluencyDataKey = @"yp_monitor_persistency_fluencyData_key";
const NSString * __kCrashDataKey = @"yp_monitor_persistency_crashData_key";

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
        NSData *fluencySaveData = [NSData dataWithContentsOfURL:[self storageFileURLWithType:YPReportTypeFluency]];
        NSData *crashSaveData = [NSData dataWithContentsOfURL:[self storageFileURLWithType:YPReportTypeCrash]];
        if (fluencySaveData) {
            NSDictionary* readDict = [NSKeyedUnarchiver unarchiveObjectWithData:fluencySaveData];
            self.fluencyQueue = [readDict[kYPMonitorFluencyReportsPersistencyKey] mutableCopy];
        }
        if (crashSaveData) {
            NSDictionary* readDict = [NSKeyedUnarchiver unarchiveObjectWithData:crashSaveData];
            self.crashQueue = [readDict[kYPMonitorCrashReportsPersistencyKey] mutableCopy];
        }
    }
    return self;
}

- (void)addToQueue:(YPReport *)report {
    @synchronized (self){
        NSMutableArray *queue = (report.type == YPReportTypeFluency) ? self.fluencyQueue : self.crashQueue;
        if (queue.count > _queueMaxLength) {
            [queue removeObjectsInRange:(NSRange){0,1}];
        }
        [queue addObject:report];
        if (report.type == YPReportTypeCrash) {
            [self saveToFileSyncWithType:YPReportTypeCrash];
        }
    }
}

- (NSArray <YPReport *>*)someReportsWithType:(YPReportType)type {
    @synchronized (self){
        NSMutableArray *queue = (type == YPReportTypeFluency) ? self.fluencyQueue : self.crashQueue;
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

- (void)removeReports:(NSArray <YPReport *>*)reports {
    if (!reports || reports.count == 0) { return; }
    YPReport *report = reports[0];
    @synchronized (self){
        NSMutableArray *queue = (report.type == YPReportTypeFluency) ? self.fluencyQueue : self.crashQueue;
        [queue removeObjectsInArray:reports];
    }
}

- (void)saveToFileWithType:(YPReportType)type {
    dispatch_async(YPDispatchQueueGetForDefaultQOS(), ^{
        [self saveToFileSyncWithType:type];
    });
}

- (void)saveToFileSyncWithType:(YPReportType)type {
    if (type == YPReportTypeFluency) {
        NSData* fluencySaveData;
        @synchronized (self){
            fluencySaveData = [NSKeyedArchiver archivedDataWithRootObject:@{kYPMonitorFluencyReportsPersistencyKey:self.fluencyQueue}];
        }
        [fluencySaveData writeToFile:[self storageFileURLWithType:YPReportTypeFluency].path atomically:YES];
    }
    
    if (type == YPReportTypeCrash) {
        NSData* crashSaveData;
        @synchronized (self){
            crashSaveData = [NSKeyedArchiver archivedDataWithRootObject:@{kYPMonitorCrashReportsPersistencyKey:self.crashQueue}];
        }
        [crashSaveData writeToFile:[self storageFileURLWithType:YPReportTypeCrash].path atomically:YES];
    }
    
}

- (NSURL *)storageFileURLWithType:(YPReportType)type{
    NSString * const kFluencyPersistencyFileName = @"YPMonitorFluency.dat";
    NSString * const kCrashPersistencyFileName = @"YPMonitorCrash.dat";
    
    static NSURL *fluencyUrl = nil;
    static NSURL *crashUrl = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      fluencyUrl = [[NSFileManager.defaultManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
                      crashUrl = [[NSFileManager.defaultManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
                      NSError *error = nil;
                      
                      if (![NSFileManager.defaultManager fileExistsAtPath:fluencyUrl.absoluteString])
                      {
                          [NSFileManager.defaultManager createDirectoryAtURL:fluencyUrl withIntermediateDirectories:YES attributes:nil error:&error];
                          if(error){ NSLog(@"Application Support directory can not be created: \n%@", error); }
                      }
                      if (![NSFileManager.defaultManager fileExistsAtPath:crashUrl.absoluteString])
                      {
                          [NSFileManager.defaultManager createDirectoryAtURL:crashUrl withIntermediateDirectories:YES attributes:nil error:&error];
                          if(error){ NSLog(@"Application Support directory can not be created: \n%@", error); }
                      }
                      
                      fluencyUrl = [fluencyUrl URLByAppendingPathComponent:kFluencyPersistencyFileName];
                      crashUrl = [crashUrl URLByAppendingPathComponent:kCrashPersistencyFileName];
                  });
    
    return (type == YPReportTypeFluency) ? fluencyUrl : crashUrl;
}

#pragma mark - get && set

- (NSMutableArray *)fluencyQueue {
    if (!_fluencyQueue) {
        _fluencyQueue = @[].mutableCopy;
    }
    return _fluencyQueue;
}

- (NSMutableArray *)crashQueue {
    if (!_crashQueue) {
        _crashQueue = @[].mutableCopy;
    }
    return _crashQueue;
}

@end
