//
//  YRMainViewController.m
//  YunRichMPCR
//
//  Created by YunRich on 15/3/25.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//  暂时不用

#import "YRMainViewController.h"
#import "YRDealDetailController.h"
#import "YRQuickConllectionController.h"
#import "AppDelegate.h"

#define kDealBorder 5
@interface YRMainViewController ()
{
    AppDelegate *appdekegate;
}
@property (weak, nonatomic) IBOutlet UIImageView *background;
@property (weak, nonatomic) IBOutlet UIButton *gatherBtn;
@property (weak, nonatomic) IBOutlet UIButton *dealDetailBtn;


@end

@implementation YRMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addAllChildControllers];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithIcon:nil highlightedIcon:nil target:self action:@selector(back) barButtonItemType:BarButtonItemTypePopToView];
    appdekegate = [UIApplication sharedApplication].delegate;
    if (self.storeType == DepartmentStore) {
        appdekegate.storeTypeString = @"YB";
    }
    else if(self.storeType == WholeSale){
        appdekegate.storeTypeString = @"YBFD";
    }
    else{
        appdekegate.storeTypeString = nil;
    }
   
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.dealType == DealTypeConllection) {
        [self gather:self.gatherBtn];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    if (self.dealType == DealTypepDetail){
        [self detail:self.dealDetailBtn];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    
}

- (void)addAllChildControllers{
    YRQuickConllectionController * quickConllectVC = [[YRQuickConllectionController alloc] init];
    [self addChildViewController:quickConllectVC]; 
    YRDealDetailController * dealDetailVC = [[YRDealDetailController alloc]init];
    [self addChildViewController:dealDetailVC];
    
}

- (IBAction)gather:(UIButton *)sender {
    self.dealType = DealTypeConllection;
    UIViewController * oldVC = self.childViewControllers[1];
    [oldVC.view removeFromSuperview];
    //取出即将显示的控制器
    UIViewController * newVC = self.childViewControllers[0];
    CGFloat Y = kDealBorder * 2 + self.background.frame.size.height;
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height - Y;
    newVC.view.frame = CGRectMake(0, Y, width, height);
    //添加新控制器的View到MainController上面
    [self.view addSubview:newVC.view];
    self.background.image = [UIImage imageNamed:@"tab_bg_right_blue"];
    [self.gatherBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.dealDetailBtn setTitleColor:kColor(43, 139, 217) forState:UIControlStateNormal] ;
    self.title = @"收款";
}

#pragma mark 显示明细
- (IBAction)detail:(UIButton *)sender {
    self.dealType = DealTypepDetail;
    UIViewController * oldVC = self.childViewControllers[0];
    [oldVC.view removeFromSuperview];
    //取出即将显示的控制器
    UIViewController * newVC = self.childViewControllers[1];
    CGFloat Y = kDealBorder * 2 + self.background.frame.size.height;
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height - Y;
    newVC.view.frame = CGRectMake(0, Y, width, height);
    //添加新控制器的View到MainController上面
    [self.view addSubview:newVC.view];
    self.background.image = [UIImage imageNamed:@"tab_bg_left_blue"];
    [self.gatherBtn setTitleColor:kColor(43, 139, 217) forState:UIControlStateNormal];
    [self.dealDetailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
    self.title = @"明细";
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
