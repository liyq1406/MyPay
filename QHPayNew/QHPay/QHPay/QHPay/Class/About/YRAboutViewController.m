//
//  YRAboutViewController.m
//  YunRichMPCR
//
//  Created by YunRich on 15/5/27.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//

#import "YRAboutViewController.h"
#import "YRUserProfileRequest.h"
#import "MBProgressHUD+MJ.h"

@interface YRAboutViewController ()<UIAlertViewDelegate>

@end

@implementation YRAboutViewController {
    
    __weak IBOutlet UIView *baseView;
    __weak IBOutlet UIButton *_checkVersionBtn;
    __weak IBOutlet UILabel *_currentVersionLabel;
    
    __weak IBOutlet UIButton *goBackBtn;
    __weak IBOutlet UILabel *companyNameLabel;
    __weak IBOutlet UILabel *companyPhoneNumLabel;
    NSString * _currentVersion;
    NSString * _downloadLink;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.title = @"关于";
    _checkVersionBtn.layer.cornerRadius = 5;
    NSDictionary * versionInfo = [[NSBundle mainBundle] infoDictionary];
   _currentVersion = versionInfo[@"CFBundleShortVersionString"];
    _currentVersionLabel.text = _currentVersion;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithIcon:nil highlightedIcon:nil target:self action:@selector(goBack) barButtonItemType:BarButtonItemTypePopToView];
    //隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES];
    
    baseView.layer.contents = (id)[UIImage imageNamed:@"qh_rootbg"].CGImage;
    
    NSString *companyStr = [[NSUserDefaults standardUserDefaults] objectForKey:COMPANYNAME];
    if ([companyStr isEqualToString:@"QHPay"]) {
        companyNameLabel.text = @"深圳前海钱海支付技术有限公司";
        companyPhoneNumLabel.text = @"400-078-5777";
    } else if ([companyStr isEqualToString:@"YDPay"]) {
        companyNameLabel.text = @"深圳业源达科技有限公司";
        companyPhoneNumLabel.text = @"400-827-3973";
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)goBack {
    
    if (self.aboutViewStyle == ShowAboutViewStyle_Pop) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }else if (self.aboutViewStyle == ShowAboutViewStyle_Present) {
        
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}
- (IBAction)goBack:(id)sender {
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)checkNewVersion:(id)sender {
    
    YRUserProfileRequest * userProfileRequest = [[YRUserProfileRequest alloc] init];
    NSDictionary * parameters = nil;
    NSString *companyName = [[NSUserDefaults standardUserDefaults] objectForKey:COMPANYNAME];
    if ([companyName isEqualToString:@"YDPay"]) {
        parameters = @{@"CLIENTTYPE":@"YDPAYQ",@"ORGVERSION":_currentVersion,@"SOFTTYPE":@"IOS"};
    }
    else if ([companyName isEqualToString:@"QHPay"]) {
        parameters = @{@"ORGVERSION":_currentVersion,@"SOFTTYPE":@"IOS"};
    }
    
    [MBProgressHUD showMessage:@"检查版本中..."];
    
    [userProfileRequest judgeAppVersionIsNeedUpdate:parameters successBlock:^(id responseObject) {
        
        [MBProgressHUD hideHUD];
        
        if ([responseObject[YR_OUTPUT_KEY_STATES_RESP_CODE] isEqualToString:YR_STATIC_SUCCESS_STATES_CODE]) {
            
            [self handleAppUpdate:responseObject];
        }else {
            
            [YRFunctionTools showAlertViewTitle:nil message:[NSString stringWithFormat:@"[%@]%@",responseObject[YR_OUTPUT_KEY_STATES_RESP_DESC],responseObject[YR_OUTPUT_KEY_STATES_RESP_CODE]] cancelButton:TIPS_CONFIRM];
        }
        
    } failureBlock:^(NSString *errInfo) {
        
        [MBProgressHUD hideHUD];
        [YRFunctionTools showAlertViewTitle:nil message:TIPS_MESSAGES cancelButton:TIPS_CONFIRM];
    }];
}

- (void)handleAppUpdate:(NSDictionary *)responseObject {
    
    
    _downloadLink = responseObject[@"DOWNURL"];
    
    if ([_currentVersion compare:responseObject[@"NEWVERSION"]] == NSOrderedAscending) {
        
        NSString * flag = responseObject[@"FROCEUPFLAG"];
        
        NSString * newVersion = [NSString stringWithFormat:@"当前有新版本%@可用", responseObject[@"NEWVERSION"]];
        
        if ([flag isEqualToString:@"Y"]) {
            
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:newVersion delegate:self cancelButtonTitle:@"立即更新" otherButtonTitles:nil, nil];
            alertView.tag = 887;
            [alertView show];
        }else if ([flag isEqualToString:@"N"] && ![responseObject[@"NEWVERSION"] isEqualToString:_currentVersion]) {
            
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:newVersion delegate:self cancelButtonTitle:@"下次再说" otherButtonTitles:@"立即更新", nil];
            alertView.tag = 888;
            [alertView show];
        }
    }else {
        
        [YRFunctionTools showAlertViewTitle:nil message:@"当前版本已为最新" cancelButton:TIPS_CONFIRM];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString * httpStr = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@",_downloadLink];
    //NSString * httpStr = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=https://dn-infosys.qbox.me/YunRich_App.plist%@",@""];
    NSURL * url = [NSURL URLWithString:httpStr];
    switch (alertView.tag) {
        case 887:
        {
            if (buttonIndex == 0) {
                
                [[UIApplication sharedApplication] openURL:url];
            }
        }
            break;
        case 888:
        {
            if (buttonIndex == 1) {

                [[UIApplication sharedApplication] openURL:url];
            }
        }
            break;
        default:
            break;
    }
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
