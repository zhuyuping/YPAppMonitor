//
//  YPReport.m
//  YPAppMonitorDemo
//
//  Created by ZYP on 2018/6/15.
//  Copyright © 2018年 ZYP. All rights reserved.
//

#import "YPReport.h"
#import "NSDate+YP_Extension.h"
#import "NSString+YP_Extension.h"

@interface YPReport ()<NSCoding>

@end

@implementation YPReport

+ (instancetype)reportForFluencyWithContent:(NSString *)content {
    
    NSString *identifier = [self createIdentifier];
    return [[YPReport alloc] initWithContent:content
                                  identifier:identifier
                                        type:YPReportTypeFluency];
}

+ (instancetype)reportForCrashWithContent:(NSString *)content {
    
    NSString *identifier = [self createIdentifier];
    return [[YPReport alloc] initWithContent:content
                                  identifier:identifier
                                        type:YPReportTypeCrash];
}

+ (instancetype)reportWithContent:(NSString * )content
                       identifier:(NSString *)identifier
                             type:(YPReportType)type {
    return [[YPReport alloc] initWithContent:content
                                  identifier:identifier
                                        type:type];
}

- (instancetype)initWithContent:(NSString *)content
                     identifier:(NSString *)identifier
                           type:(YPReportType)type {
    if (self = [super init]) {
        _content = content;
        _identifier = identifier;
        _type = type;
    }
    return self;
}

+ (NSString *)createIdentifier {
    NSMutableString *str = @"".mutableCopy;
    [str appendString:[NSDate currentTimeStampMS]];
    [str appendString:@"-"];
    [str appendString:[NSString random32String]];
    return str.copy;
}

- (NSDictionary *)dictionary {
    return @{@"type":@(self.type),
             @"identifier":self.identifier,
             @"content":self.content
             };
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_identifier forKey:@"identifier"];
    [aCoder encodeObject:_content forKey:@"content"];
    [aCoder encodeInt:_type forKey:@"type"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.identifier = [aDecoder decodeObjectForKey:@"identifier"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.type = [aDecoder decodeIntForKey:@"type"];
    }
    return self;
}

@end
