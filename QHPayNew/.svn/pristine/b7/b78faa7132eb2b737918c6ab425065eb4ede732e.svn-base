//
//  YRLoginController.m
//  YunRichMPCR
//
//  Created by YunRich on 15/3/24.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//

#import "QHLoginController.h"

#import "YRForgetViewController.h"
#import "LandiMPOS.h"
#import "YRSearchMPOSController.h"
#import "YRLoginManager.h"
#import "YRRequestTool.h"
#import "YROpenAccountViewController.h"
#import "MBProgressHUD+MJ.h"
#import "YRVerifyRegexTool.h"
#import "AppDelegate.h"
#import "YRMerchantInfoViewController.h"
#import "YRMerchantInfoViewController.h"
#import "UIScrollView+UITouch.h"
#import "QHAgreementViewController.h"

#import "QHHomeViewController.h"

#import "QHSelectVersionViewController.h"
#import "TouchScrollView.h"


@interface QHLoginController ()<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *rememberUserNameBtn;
@property (weak, nonatomic) IBOutlet TouchScrollView *scrollView;


@end

@implementation QHLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildUI];
    
    //判断是否记住用户名并读取
    [self loadUserName];
}

- (void)buildUI{
    [self.registBtn.layer setCornerRadius:5.0];
    [self.loginBtn.layer setCornerRadius:5.0];
    self.rememberUserNameBtn.selected = YES;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_REMEMBER_USER_NAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.rememberUserNameBtn setBackgroundImage:[UIImage imageNamed:@"qh_login_n"] forState:UIControlStateNormal];
    [self.rememberUserNameBtn setBackgroundImage:[UIImage imageNamed:@"qh_login_y"] forState:UIControlStateSelected];
    self.loginBtn.layer.borderColor = [UIColor colorWithRed:173.0/255 green:179.0/255 blue:184.0/255 alpha:1].CGColor;
    self.view.layer.contents = (id)[UIImage imageNamed:@"qh_rootbg"].CGImage;
    
#ifndef RELEASE
    UILabel *envLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 60, 11)];
    envLab.textColor = [UIColor brownColor];
    envLab.font = [UIFont systemFontOfSize:11.0f];
    envLab.text = @"测试环境";
    [self.view addSubview:envLab];
#endif
}



#pragma mark 读取记住的用户名
- (void)loadUserName{
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    BOOL isRememberUserName = [ud boolForKey:IS_REMEMBER_USER_NAME];
    if (isRememberUserName == YES) {
        [self.rememberUserNameBtn setSelected:YES];
        NSString * userName = [ud objectForKey:ALREADY_REMEMBER_USER_NAME];
        self.userNameTF.text = userName;
    }
    else {
        [self.rememberUserNameBtn setSelected:NO];
        self.userNameTF.text = @"";
    }
}

- (void)viewDidLayoutSubviews {
    self.scrollView.contentSize   = CGSizeMake(0, 550);
    self.scrollView.bounces       = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadUserName];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    _passwordTF.text = @"";
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark 判断textField输入框字数是否超限
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (self.userNameTF == textField) {
        if (toBeString.length > 20) {
            [YRFunctionTools showAlertViewTitle:nil message:@"输入信息过长" cancelButton:TIPS_CONFIRM];
            return NO;
        }
    }
    else if (self.passwordTF == textField) {
        if (toBeString.length > 12) {
            [YRFunctionTools showAlertViewTitle:nil message:@"输入信息过长" cancelButton:TIPS_CONFIRM];
            return NO;
        }
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if ((textField == _passwordTF) && ([UIScreen mainScreen].bounds.size.height < 550)) {
        [UIView animateWithDuration:.3 animations:^{
            self.scrollView.contentOffset = CGPointMake(0, 128);
        } completion:nil];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{

    
    if ((textField == _passwordTF) && ([UIScreen mainScreen].bounds.size.height < 550)) {
        [UIView animateWithDuration:.3 animations:^{
            self.scrollView.contentOffset = CGPointMake(0, 0);
        } completion:nil];
    }
}

#pragma mark 记住用户名
- (IBAction)rememberUserName:(UIButton *)sender {
    sender.selected = !sender.selected;

    [[NSUserDefaults standardUserDefaults] setBool:sender.selected forKey:IS_REMEMBER_USER_NAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)inputTF:(UITextField *)sender {
    if (sender.tag == 101) {
        [self login:self.loginBtn];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    [self.userNameTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
}


#pragma mark 登录
- (IBAction)login:(UIButton *)sender {
    [_passwordTF resignFirstResponder];
    if (self.userNameTF.text.length < 6 && self.userNameTF.text.length > 20) {//6-20位企业号
        [self showAlertViewTitle:nil message:@"请输入正确的企业号" cancelButton:nil];
    }else if (self.passwordTF.text.length < 6){//密码小于6位
  
        [self showAlertViewTitle:nil message:@"密码长度至少六位" cancelButton:nil];
    }else{
        //登录信息正确时进行跳转
        [self loginMessageIsTureWithUserName:self.userNameTF.text password:self.passwordTF.text];
    }
    
}

#pragma mark 登录信息正确时进行跳转
- (void)loginMessageIsTureWithUserName:(NSString *)userAccount password:(NSString *)password{
    
    [MBProgressHUD showMessage:@"登录中..."];
    
    [YRRequestTool loginWithBusrId:userAccount loginPwd:password success:^(NSString *isCompLogin, NSString *sessionID, NSString *loginSucceedOrFailed, NSString *userName, NSString *custID) {
        
        if ([loginSucceedOrFailed isEqualToString:YR_STATIC_SUCCESS_STATES_CODE]) {
            YRLoginManager * manager = [YRLoginManager shareLoginManager];
            manager.busrID = userAccount;
            manager.username = userName;
            manager.custID = custID;
            //保存sessionID
            [manager saveSessionId:sessionID];
            
            if ([isCompLogin isEqualToString:@"N"]) {//没有进行信息补全
                
                if ([[LandiMPOS getInstance] isConnectToDevice]) {//已经与设备连接
                    
                    YROpenAccountViewController * openAccountVC = [[YROpenAccountViewController alloc] init];
                    [self.navigationController pushViewController:openAccountVC animated:YES];
                    [MBProgressHUD hideHUD];
                }else{//未与设备连接
                    QHSelectVersionViewController *selectVC = [[QHSelectVersionViewController alloc] init];
                    selectVC.selecType = loginType;
                    [self.navigationController pushViewController:selectVC animated:YES];
                    [MBProgressHUD hideHUD];
                }
            }else if(![self.userNameTF.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:ALREADY_REMEMBER_USER_NAME]]){//登录的手机号有变化时要重新连接设备
                [[NSUserDefaults standardUserDefaults] setObject:self.userNameTF.text forKey:ALREADY_REMEMBER_USER_NAME];
                [[NSUserDefaults standardUserDefaults] synchronize];
                QHSelectVersionViewController *selectVC = [[QHSelectVersionViewController alloc] init];
                selectVC.selecType = changeNumberType;
                [self.navigationController pushViewController:selectVC animated:YES];
                [MBProgressHUD hideHUD];
                
            }else{
                NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:ALREADY_REMEMBER_USER_NAME]);
                [self toHome];
                
            }
            
        }else if ([loginSucceedOrFailed isEqualToString:YR_STATIC_WRONG_USERNAME_CODE] || [loginSucceedOrFailed isEqualToString:YR_STATIC_WRONG_PASSWORD_CODE]){
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"用户名或密码错误" message:nil delegate:nil cancelButtonTitle:@"请重新输入" otherButtonTitles:nil];
            [alert show];
            [MBProgressHUD hideHUD];
        }else{
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"登录失败！" message:nil delegate:nil cancelButtonTitle:@"请重新输入" otherButtonTitles:nil];
            [alert show];
            [MBProgressHUD hideHUD];
        }
        
    } failure:^(NSString *error) {
        [MBProgressHUD hideHUD];
        [YRFunctionTools showAlertViewTitle:@"请求超时" message:@"请检查网络连接" cancelButton:TIPS_CONFIRM];
    }];
     
}



#pragma mark 记住用户名
- (void)rememberUserName{
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    if (self.rememberUserNameBtn.selected == YES) {
        [ud setObject:self.userNameTF.text forKey:ALREADY_REMEMBER_USER_NAME];
    }
    [ud setBool:self.rememberUserNameBtn.selected forKey:IS_REMEMBER_USER_NAME];
    [ud synchronize];
}

#pragma mark 注册
- (IBAction)registered:(UIButton *)sender {
    QHAgreementViewController *agreeVC = [[QHAgreementViewController alloc] init];
    
    [self.navigationController pushViewController:agreeVC animated:YES];
}

#pragma mark 忘记密码
- (IBAction)fogetPassword:(UIButton *)sender {
    
    YRForgetViewController * forgetPW = [YRForgetViewController new];
    [self.navigationController pushViewController:forgetPW animated:YES];
     
}

#pragma mark 跳转至首页
-(void)toHome{
    //将手机号存储到本地 以便更换账号时判断使用
    [self rememberUserName];
    
    QHHomeViewController *QHHomeVC = [[QHHomeViewController alloc] init];
    [self.navigationController pushViewController:QHHomeVC animated:YES];
    [MBProgressHUD hideHUD];
}



@end
