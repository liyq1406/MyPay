//
//  QHNavigationController.m
//  QHPay
//
//  Created by chenlizhu on 15/7/13.
//  Copyright (c) 2015年 chenlizhu. All rights reserved.
//

#import "QHNavigationController.h"

@interface QHNavigationController ()

@end

@implementation QHNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    //修改全局外观
    UINavigationBar * bar = [UINavigationBar appearance];
    //设置背景
    [bar setBackgroundImage:[UIImage imageNamed:@"qh_navigationBarBg"] forBarMetrics:UIBarMetricsDefault];
    bar.barStyle = UIBarStyleBlackTranslucent;
    //修改文字主题
    [bar setTitleTextAttributes:@{
                                  NSFontAttributeName:[UIFont boldSystemFontOfSize:19.0],
                                  NSForegroundColorAttributeName : [UIColor whiteColor],
                                  }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 设备横屏时可以在子类中重写以下方法
-(BOOL)shouldAutorotate {
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations {
    return  UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
