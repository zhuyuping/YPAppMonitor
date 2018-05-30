//
//  UIViewController+ZYPMonitor.m
//  ZYPAppMonitor
//
//  Created by ZYP on 2018/3/16.
//  Copyright © 2018年 ZYP. All rights reserved.
//

#import "UIViewController+ZYPMonitor.h"

@implementation UIViewController (ZYPMonitor)

UIViewController * _findViewController(UIViewController * viewController) {
    if (viewController.presentedViewController != nil) {
        return _findViewController(viewController.presentedViewController);
    } else if ([viewController isKindOfClass: [UINavigationController class]]) {
        return _findViewController(((UINavigationController *)viewController).topViewController);
    } else if ([viewController isKindOfClass: [UITabBarController class]]) {
        UITabBarController * tabBarController = (UITabBarController *)viewController;
        return _findViewController(tabBarController.viewControllers[tabBarController.selectedIndex]);
    }
    return viewController;
}

+ (UIViewController *)YP_findTopViewController {
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    if (window.windowLevel != UIWindowLevelNormal) {
        for (UIWindow * win in [[UIApplication sharedApplication] windows]) {
            if (win.windowLevel == UIWindowLevelNormal) {
                window = win;
                break;
            }
        }
    }
    UIView * frontView = [[window subviews] lastObject];
    UIViewController * viewController;
    if ([frontView.nextResponder isKindOfClass: [UIViewController class]]) {
        viewController = (UIViewController *)frontView.nextResponder;
    } else {
        viewController = window.rootViewController;
    }
    return _findViewController(viewController);
}

@end
