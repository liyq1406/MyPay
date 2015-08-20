//
//  QHSurveyViewController.m
//  YunRichMPCR
//
//  Created by liqunfei on 15/6/23.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//

#import "QHSurveyViewController.h"
#import "MBProgressHUD+MJ.h"

#define kScreenSize [UIScreen mainScreen].bounds.size
@interface QHSurveyViewController ()

@end

@implementation QHSurveyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *surveyWV = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height)];
    NSURL *url = [NSURL URLWithString:@"http://www.wenjuan.com/s/AbY3eq/"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [surveyWV loadRequest:request];
    [self.view addSubview:surveyWV];
    
    surveyWV.delegate = (id<UIWebViewDelegate>)self;
    surveyWV.scrollView.bounces = NO;
    
    self.title = @"问卷调查";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithIcon:nil highlightedIcon:nil target:self action:@selector(surveyBack) barButtonItemType:BarButtonItemTypePopToView];
}

- (void)surveyBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [MBProgressHUD showMessage:@"正在加载中..."];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideHUD];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:(NSString *)error delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
