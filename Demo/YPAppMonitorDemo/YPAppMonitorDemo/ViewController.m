//
//  ViewController.m
//  YPAppMonitorDemo
//
//  Created by ZYP on 2018/5/30.
//  Copyright © 2018年 ZYP. All rights reserved.
//

#import "ViewController.h"
#import "YPAppFluencyMonitor.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [YPAppFluencyMonitor start];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end