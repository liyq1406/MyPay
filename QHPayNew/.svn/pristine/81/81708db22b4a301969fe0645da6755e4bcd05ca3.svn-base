//
//  QHPayBaseViewController.m
//  QHPay
//
//  Created by chenlizhu on 15/7/13.
//  Copyright (c) 2015年 chenlizhu. All rights reserved.
//

#import "QHPayBaseViewController.h"

@interface QHPayBaseViewController ()

@property (strong, nonatomic) NSTimer * timer;

@end

@implementation QHPayBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)showAlertViewTitle:(NSString *)title message:(NSString *)content cancelButton:(NSString *)btnTitle
{
    UIAlertView * alertView = nil;
    if (btnTitle) {
        alertView = [[UIAlertView alloc] initWithTitle:title
                                               message:content
                                              delegate:self
                                     cancelButtonTitle:btnTitle
                                     otherButtonTitles:nil, nil];
        
    }else {
        alertView = [[UIAlertView alloc] initWithTitle:title
                                               message:content
                                              delegate:self
                                     cancelButtonTitle:nil
                                     otherButtonTitles:nil, nil];
        
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:self
                                                    selector:@selector(hiddenAlertView:)
                                                    userInfo:[NSDictionary dictionaryWithObject:alertView forKey:@"alertView"]
                                                     repeats:NO];
    }
    [alertView setNeedsLayout];
    [alertView show];
}

- (void)hiddenAlertView:(NSTimer *)timer
{
    UIAlertView * alertView = [timer.userInfo objectForKey:@"alertView"];
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark - 友盟统计

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"UIView"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"UIView"];
}

#pragma mark - 设备横屏设置
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
