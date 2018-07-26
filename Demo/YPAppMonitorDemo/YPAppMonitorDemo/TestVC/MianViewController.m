//
//  MianViewController.m
//  ZYPAppMonitor
//
//  Created by ZYP on 2018/3/8.
//  Copyright © 2018年 ZYP. All rights reserved.
//

#import "MianViewController.h"
#import "FluencyTestVC.h"
#import "YPAppFluencyMonitor.h"
#import "YPAppMonitor.h"

@interface MianViewController ()

@property (nonatomic, readwrite, strong) NSArray *dataList;

@end

@implementation MianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ZYPAppMonitor";
    _dataList = @[@"1.流畅性监控",@"2.崩溃日志收集"];
    YPAppMonitorConfiguration *config = [YPAppMonitorConfiguration new];
    config.useCrashMonitoring = YES;
    config.useFluencymonitoring = YES;
    config.reportServerUrl = [NSURL URLWithString:@"http://127.0.0.1:8088/YPAppMonitor/"];
    [YPAppMonitor startWithConfiguration:config];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _dataList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MianViewControllerCell" forIndexPath:indexPath];
    cell.textLabel.text = _dataList[indexPath.row];
    cell.detailTextLabel.text = @"演示";
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 0){
        FluencyTestVC  *vc = [FluencyTestVC new];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.row == 1) {
        [self performSegueWithIdentifier:@"CrashTestVC" sender:nil];
        return;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
