//
//  YRAgreementViewController.m
//  QHPay
//
//  Created by liqunfei on 15/7/14.
//  Copyright (c) 2015年 chenlizhu. All rights reserved.
//

#import "QHAgreementViewController.h"
#import "YRSearchMPOSController.h"
#import "YRRegisterViewController.h"
#import "QHSelectVersionViewController.h"

@interface QHAgreementViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *agreementWebView;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreementBtn;

@end

@implementation QHAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildUI];
}

- (void)buildUI {
    self.nextBtn.enabled         = NO;
    self.nextBtn.backgroundColor = [UIColor grayColor];
    
    //加载本地web显示协议
    NSString *path = [[NSBundle mainBundle] pathForResource:@"protocol" ofType:@"htm"];
    NSURL *url     = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.agreementWebView loadRequest:request];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithIcon:nil highlightedIcon:nil target:self action:@selector(agreeBack) barButtonItemType:BarButtonItemTypePopToView];
    
    self.title = @"服务协议";
    
    self.view.layer.contents = (id)[UIImage imageNamed:@"qh_rootbg"].CGImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)nextBtnClick:(UIButton *)sender {
    LandiMPOS *manger = [LandiMPOS getInstance];
    BOOL isConnectToDevice = [manger isConnectToDevice];
    
    if (isConnectToDevice) {
        //跳转到注册界面
        YRRegisterViewController *registerVC = [[YRRegisterViewController alloc] init];
        [self.navigationController pushViewController:registerVC animated:YES];
    }else {
        //跳转到搜索设备界面
//        YRSearchMPOSController *searchMPOS = [[YRSearchMPOSController alloc] init];
//        searchMPOS.searchMPOSEnterType     = SearchMPOSEnterTypeRegister;
//        [self.navigationController pushViewController:searchMPOS animated:YES];
        
//        跳转到选择设备型号界面
        QHSelectVersionViewController *selectVersionVC = [[QHSelectVersionViewController alloc] init];
        selectVersionVC.selecType = registerType;
        [self.navigationController pushViewController:selectVersionVC animated:YES];
    }
}

- (void)agreeBack {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)agreement:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.nextBtn.enabled = sender.selected;
    if (sender.selected == NO) {
        self.nextBtn.backgroundColor = [UIColor grayColor];
    }else {
        self.nextBtn.backgroundColor = kColor(0, 95, 173);
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
