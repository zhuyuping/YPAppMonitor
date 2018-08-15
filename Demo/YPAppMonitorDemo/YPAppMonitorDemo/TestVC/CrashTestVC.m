//
//  CrashTestVC.m
//  ZYPAppMonitor
//
//  Created by ZYP on 2018/3/16.
//  Copyright © 2018年 ZYP. All rights reserved.
//

#import "CrashTestVC.h"

@interface CrashTestVC ()

@property (weak, nonatomic) IBOutlet UIButton *nsexceptionButton;
@property (weak, nonatomic) IBOutlet UIButton *signalExceptionButton;
@property (assign,nonatomic) NSArray *testArray;
@end

@implementation CrashTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _testArray = @[@"1"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark -- Action


- (IBAction)buttonOnclick:(UIButton *)sender {
    if (sender == self.nsexceptionButton) {
        NSArray *arr = @[];
        NSLog(@"%@",arr[1]);
    }
    
    if (sender == self.signalExceptionButton) {
        [_testArray objectAtIndex:0];
    }
}


@end
