//
//  UIApplication+YP_Extension.m
//  YPAppMonitorDemo
//
//  Created by ZYP on 2018/7/18.
//  Copyright © 2018年 ZYP. All rights reserved.
//

#import "UIApplication+YP_Extension.h"
#import "YP_Extension.h"
@implementation UIApplication (YP_Extension)

+ (NSURL *)yp_documentsURL {
    return [[[NSFileManager defaultManager]
             URLsForDirectory:NSDocumentDirectory
             inDomains:NSUserDomainMask] lastObject];
}

+ (NSString *)yp_documentsPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSURL *)yp_cachesURL {
    return [[[NSFileManager defaultManager]
             URLsForDirectory:NSCachesDirectory
             inDomains:NSUserDomainMask] lastObject];
}

+ (NSString *)yp_cachesPath {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSURL *)yp_libraryURL {
    return [[[NSFileManager defaultManager]
             URLsForDirectory:NSLibraryDirectory
             inDomains:NSUserDomainMask] lastObject];
}

+ (NSString *)yp_libraryPath {
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSURL *)yp_applicationSupportURL {
    NSURL *url = [[[NSFileManager defaultManager]
                   URLsForDirectory:NSApplicationSupportDirectory
                   inDomains:NSUserDomainMask] lastObject];
    [NSFileManager checkAndCreateDirIfNotExistWithPath:url.path];
    return url;
}

+ (NSString *)yp_applicationSupportPath {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject];
    [NSFileManager checkAndCreateDirIfNotExistWithPath:path];
    return path;
}

+ (NSString *)budnleVersionString {
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
}

+ (NSString *)bundleBuildVersionString {
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
}

NSData * __yp_get_snapshot_png(void) {
    UIImage *image;
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation))
        imageSize = [UIScreen mainScreen].bounds.size;
    else
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        
        switch (orientation) {
            case UIInterfaceOrientationLandscapeLeft:
            {
                CGContextRotateCTM(context, M_PI_2);
                CGContextTranslateCTM(context, 0, -imageSize.width);
            }
                break;
                
            case UIInterfaceOrientationLandscapeRight:
            {
                CGContextRotateCTM(context, -M_PI_2);
                CGContextTranslateCTM(context, -imageSize.height, 0);
            }
                break;
                
            case UIInterfaceOrientationPortraitUpsideDown:
            {
                CGContextRotateCTM(context, M_PI);
                CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
            }
                break;
                
                
            default:
                break;
        }
        
        
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }else{
            [window.layer renderInContext:context];
        }
        
        CGContextRestoreGState(context);
    }
    
    if (orientation == UIInterfaceOrientationPortrait || orientation ==UIInterfaceOrientationPortraitUpsideDown) {
        CGContextSaveGState(context);
        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
        [statusBar drawViewHierarchyInRect:statusBar.bounds afterScreenUpdates:NO];
        CGContextRestoreGState(context);
        
    }
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImagePNGRepresentation(image);
}

// 包含statusBar的全屏截图
+ (NSData *)yp_snapshotPNG {
    if ([NSThread currentThread].isMainThread) {
        NSData * __block data;
        data = __yp_get_snapshot_png();
        return data;
    }
    else {
        NSData * __block data;
        dispatch_sync(dispatch_get_main_queue(), ^{
            data = __yp_get_snapshot_png();
        });
        return data;
    }
}

+ (void)redirectTerminalLog {
    NSString *dirPath = [[self yp_applicationSupportPath] stringByAppendingPathComponent:@"applog"];
    [NSFileManager checkAndCreateDirIfNotExistWithPath:dirPath];
    NSString *filePath = [dirPath stringByAppendingPathComponent:@"app.log"];
    [self redirectTerminalLogWithNewPath:filePath];
}

+ (void)redirectTerminalLogWithNewPath:(NSString *)path {
    NSLog(@"terminal log now is redirect to file , so there are blank in xcode terminal log");
    freopen([path cStringUsingEncoding:NSASCIIStringEncoding],"a+", stdout);
    freopen([path cStringUsingEncoding:NSASCIIStringEncoding],"a+", stderr);
}

+ (NSData *)currentTerminalLogData {
    NSString *path = [[self yp_applicationSupportPath] stringByAppendingPathComponent:@"applog/app.log"];
    return [NSData dataWithContentsOfFile:path];
}

@end
