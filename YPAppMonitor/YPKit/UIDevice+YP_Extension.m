//
//  UIDevice+YP_Extension.m
//  YPAppMonitorDemo
//
//  Created by ZYP on 2018/7/18.
//  Copyright © 2018年 ZYP. All rights reserved.
//

#import "UIDevice+YP_Extension.h"
#import <dlfcn.h>
#import <limits.h>
#import <string.h>
#import <pthread.h>
#import <sys/types.h>
#import <mach/mach.h>
#import <mach-o/nlist.h>
#import <mach-o/dyld.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

#ifndef NBYTE_PER_MB
#define NBYTE_PER_MB (1024 * 1024)
#endif

@implementation UIDevice (YP_Extension)

+ (double)currentCpuUsage {
    double usageRatio = 0;
    thread_info_data_t thinfo;
    thread_act_array_t threads;
    thread_basic_info_t basic_info_t;
    mach_msg_type_number_t count = 0;
    mach_msg_type_number_t thread_info_count = THREAD_INFO_MAX;
    
    if (task_threads(mach_task_self(), &threads, &count) == KERN_SUCCESS) {
        for (int idx = 0; idx < count; idx++) {
            if (thread_info(threads[idx], THREAD_BASIC_INFO, (thread_info_t)thinfo, &thread_info_count) == KERN_SUCCESS) {
                basic_info_t = (thread_basic_info_t)thinfo;
                if (!(basic_info_t->flags & TH_FLAGS_IDLE)) {
                    usageRatio += basic_info_t->cpu_usage / (double)TH_USAGE_SCALE;
                }
            }
        }
        assert(vm_deallocate(mach_task_self(), (vm_address_t)threads, count * sizeof(thread_t)) == KERN_SUCCESS);
    }
    return usageRatio * 100.;
}

+ (YPApplicationMemoryUsage)currentMemoryUsage {
    
    struct mach_task_basic_info info;
    mach_msg_type_number_t count = sizeof(info) / sizeof(integer_t);
    if (task_info(mach_task_self(), MACH_TASK_BASIC_INFO, (task_info_t)&info, &count) == KERN_SUCCESS) {
        return (YPApplicationMemoryUsage){
            .usage = info.resident_size >> 20,
            .total = [NSProcessInfo processInfo].physicalMemory >> 20,
            .ratio = info.virtual_size / [NSProcessInfo processInfo].physicalMemory,
        };
    }
    return (YPApplicationMemoryUsage){ 0 };
}

+ (NSString *)wifi_ssid {
    NSString *wifiName = @"Not Found";
    
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray != nil) {
        CFDictionaryRef myDict =CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        if (myDict != nil) {
            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
            wifiName = [dict valueForKey:@"SSID"];
            
        }
    }
    return wifiName;
}

+ (NSString *)mobileName {
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    NSString *mobile;
    if (!carrier.isoCountryCode) {
        mobile = @"无运营商";
    }
    else{
        mobile = [carrier carrierName];
    }
    return mobile;
}

@end
