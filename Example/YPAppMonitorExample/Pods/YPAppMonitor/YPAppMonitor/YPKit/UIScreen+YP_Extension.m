//
//  UIScreen+YP_Extension.m
//  YPAppMonitorDemo
//
//  Created by ZYP on 2018/7/19.
//  Copyright © 2018年 ZYP. All rights reserved.
//

#import "UIScreen+YP_Extension.h"

@implementation UIScreen (YP_Extension)

/*
 
型号                  屏幕尺寸inch）    逻辑分辨率point）   缩放因子scale factor）    物理分辨率（pixel）   像素密度（pixel）

iPhone3GS               3.5             320*480         @1X                     320*480             163
iPhone4/4s              3.5             320*480         @2X                     640*960             326
iPhone5/5s/SE           4               320*568         @2X                     640*1136            326
iPhone6/6s/7/7s/8/8s    4.7             375*667         @2X                     750*1134            326
iPhone6Plus/6s Plus     5.5             414*736         @3X                     1242*2208           401
iPhoneX                 5.8             375*812         @3X                     2436*1125           458
 
*/
+ (NSInteger)screenPPI {
    CGSize size = UIScreen.mainScreen.bounds.size ;
    NSInteger scale = (int)UIScreen.mainScreen.scale ;
    NSInteger height = (int)size.height;
    switch (height) {
            case 480: return (scale == 1) ? 163 : 326;
            case 568: return 326;
            case 667: return 326;
            case 736: return 401;
            case 812: return 485;
        default:
            return 0;
    }
}

@end
