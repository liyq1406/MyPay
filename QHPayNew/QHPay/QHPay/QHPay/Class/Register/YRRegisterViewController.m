//
//  YRRegisterViewController.m
//  Normal_SlideMenu
//
//  Created by YunRich on 15/5/6.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//

#import "YRRegisterViewController.h"
#import "YRRequestTool.h"
#import "YRVerifyRegexTool.h"
#import "UIBarButtonItem+PSM.h"
#import "YRLoginManager.h"
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD+MJ.h"
#import "NSString+PSM.h"

@interface YRRegisterViewController () <UIAlertViewDelegate,UITextFieldDelegate>
{
    NSString * _vertifyCode;
    YRLoginManager * _loginManager;
}
@end

@implementation YRRegisterViewController {

    __weak IBOutlet UITextField *phoneNumTextField;
    __weak IBOutlet UITextField *phoneVertifyCodeTextField;
    __weak IBOutlet UITextField *logInPasswordTextField;
    __weak IBOutlet UITextField *confirmLoginPasswordTextField;
    
    __weak IBOutlet UITextField *_certIdTextField;
    __weak IBOutlet UIView *_certIdView;
    
    __weak IBOutlet UIButton *sendVertifyCodeBtn;
    __weak IBOutlet UIButton *nextBtn;
    NSTimer * _timer;
    CGFloat _heightOfKeyboard;
    int _count;
    BOOL _phoneNumIsCorrect;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self buildUI];
    self.title = @"注册";
    self.view.layer.contents = (id)[UIImage imageNamed:@"qh_rootbg"].CGImage;
}

- (void)viewWillAppear:(BOOL)animated {
    //不能删
}

- (void)buildUI{
    _loginManager = [YRLoginManager shareLoginManager];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithIcon:nil highlightedIcon:nil target:self action:@selector(back) barButtonItemType:BarButtonItemTypePopToView];
    [self setSubViewRoundBorder:sendVertifyCodeBtn];
    [self setSubViewRoundBorder:nextBtn];
}


#pragma 设置圆角
- (void)setSubViewRoundBorder:(UIView *)subView {
    
    subView.layer.masksToBounds = YES;
    subView.layer.borderWidth = 0.5;
    subView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    subView.layer.cornerRadius = 5;
}

#pragma mark 发送短信验证码
- (IBAction)sendPhoneVertifyCode:(id)sender {
    
    if ([YRVerifyRegexTool isMobileNumber:phoneNumTextField.text]) {
        [phoneVertifyCodeTextField becomeFirstResponder];
        NSString * systemType = @"REG";

        UIButton * vertifyBtn = (UIButton *)sender;
        
        [MBProgressHUD showMessage:@"正在发送验证码..."];
        //获取验证码
        [YRRequestTool userSendPhoneNum:phoneNumTextField.text syetemtype:systemType busrId:_certIdTextField.text success:^(id responseObject) {
            
            [MBProgressHUD hideHUD];
            if ([responseObject[YR_OUTPUT_KEY_STATES_RESP_CODE] isEqualToString:YR_STATIC_SUCCESS_STATES_CODE]) {
                
                [YRFunctionTools setAlertViewWithTitle:@"验证码发送成功" buttonTitle:TIPS_CONFIRM];
                NSDictionary * userInfo = @{@"btn" : vertifyBtn};
                _count = 60;
                [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeBtnTitle:) userInfo:userInfo repeats:YES];
    
            }else {
                
                [YRFunctionTools setAlertViewWithTitle:@"验证码发送失败" buttonTitle:TIPS_CONFIRM];
                [vertifyBtn setEnabled:YES];
                vertifyBtn.alpha = 1;
                [vertifyBtn setTitle:@"重发验证码" forState:UIControlStateNormal];
                [_timer invalidate];
            }
        } failure:^(NSString *errInfo) {
            [MBProgressHUD hideHUD];
            [YRFunctionTools setAlertViewWithTitle:TIPS_MESSAGES buttonTitle:TIPS_CONFIRM];
            [vertifyBtn setEnabled:YES];
            vertifyBtn.alpha = 1;
            [vertifyBtn setTitle:@"重发验证码" forState:UIControlStateNormal];
            [_timer invalidate];
        }];
    }else{
        
        [YRFunctionTools setAlertViewWithTitle:@"请输入有效的手机号" buttonTitle:TIPS_CONFIRM];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (phoneVertifyCodeTextField == textField) {
        if (toBeString.length > 6) {
            [YRFunctionTools showAlertViewTitle:nil message:@"输入信息过长" cancelButton:TIPS_CONFIRM];
            return NO;
        }
    }else if (phoneNumTextField == textField){
        if (toBeString.length > 11) {
            [YRFunctionTools showAlertViewTitle:nil message:@"输入信息过长" cancelButton:TIPS_CONFIRM];
            return NO;
        }
    }
    else if (_certIdTextField == textField) {
        if (toBeString.length > 20) {
            [YRFunctionTools showAlertViewTitle:nil message:@"输入信息过长" cancelButton:TIPS_CONFIRM];
            return NO;
        }
        
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHA] invertedSet];
        
        NSString *filter = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL bTest = [string isEqualToString:filter];
        return bTest;
    }
    else {
        if (toBeString.length > 12) {
            [YRFunctionTools setAlertViewWithTitle:@"输入过长" buttonTitle:TIPS_CONFIRM];
            return NO;
        }
        
    }
    return YES;
}

- (void)changeBtnTitle:(NSTimer *)timer {
    
    NSDictionary * dict = timer.userInfo;
    UIButton * btn = dict[@"btn"];
    
    if (_count != 0) {
        NSString *timeCount = [NSString stringWithFormat:@"%d秒",_count];
        sendVertifyCodeBtn.titleLabel.text = timeCount;
        _count--;
        [btn setEnabled:NO];
        btn.alpha = 0.6;
    }else {
        btn.alpha = 1;
        [btn setEnabled:YES];
        [btn setTitle:@"重发验证码" forState:UIControlStateNormal];
        [timer invalidate];
    }
}

#pragma 点击完成注册并登录
- (IBAction)continueNextStep:(id)sender {
    
    NSString * password = logInPasswordTextField.text;
    if (_certIdTextField.text.length < 6) {
        [YRFunctionTools setAlertViewWithTitle:@"请输入6-20位企业号" buttonTitle:TIPS_CONFIRM];
    }
    else if (![YRVerifyRegexTool isMobileNumber:phoneNumTextField.text]) {
        
        [YRFunctionTools setAlertViewWithTitle:@"请输入有效的手机号" buttonTitle:TIPS_CONFIRM];
    }
    else if (phoneVertifyCodeTextField.text.length < 6){
        [YRFunctionTools setAlertViewWithTitle:@"请输入6位验证码" buttonTitle:TIPS_CONFIRM];
    }
    else {
        
        if (password.length >= 6) {
            
            if ([YRVerifyRegexTool validtaeUserName:password]) {
                
                if (![password isEqualToString:confirmLoginPasswordTextField.text]) {
                    
                    [YRFunctionTools setAlertViewWithTitle:@"密码不一致，请重新输入" buttonTitle:TIPS_CONFIRM];
                }else {
                    
                    NSString * productSN = [[YRLoginManager shareLoginManager] productSN];
                    
                    [MBProgressHUD showMessage:@"注册中..."];
                    [YRRequestTool registerInfoWithUsrmp:phoneNumTextField.text authcode:phoneVertifyCodeTextField.text loginpwd:password transpwd:password busrId:_certIdTextField.text factory:[YRLoginManager shareLoginManager].factoryName machineno:productSN success:^(id responseObject) {
                        
                        [MBProgressHUD hideHUD];
                        
                        NSString * response = responseObject[YR_OUTPUT_KEY_STATES_RESP_CODE];
                        
                        if ([response isEqualToString:YR_STATIC_REGIERPHONE_IS_EXIST_CODE]) {
                            [YRFunctionTools setAlertViewWithTitle:@"注册手机号已经存在" buttonTitle:TIPS_CONFIRM];
                        }else if ([response isEqualToString:YR_STATIC_SUCCESS_STATES_CODE]){
                            //将手机号存到本地
                            [[NSUserDefaults standardUserDefaults] setObject:_certIdTextField.text forKey:ALREADY_REMEMBER_USER_NAME];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"注册成功" message:nil delegate:self cancelButtonTitle:@"点击登录" otherButtonTitles:nil];
                            [alert show];
                        }else{
                            [YRFunctionTools setAlertViewWithTitle:responseObject[@"RESPDESC"] buttonTitle:@"确认"];
                        }
                        
                    } failure:^(NSString *errInfo) {
                        
                        [MBProgressHUD hideHUD];
                        [YRFunctionTools setAlertViewWithTitle:TIPS_MESSAGES buttonTitle:TIPS_CONFIRM];
                    }];
                }
            }else {
                
                [YRFunctionTools setAlertViewWithTitle:@"密码不支持特殊字符，请输入字母与数字组合 区分大小写" buttonTitle:TIPS_CONFIRM];
            }
        }else {
            
            [YRFunctionTools setAlertViewWithTitle:@"密码的有效长度需6位及以上！" buttonTitle:TIPS_CONFIRM];
        }
    }
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{


    if (buttonIndex == 0) {
        NSLog(@"%@",_certIdTextField.text);
        NSString *busrId = [NSString stringReplaceSpacingAndLinefeedWithString:_certIdTextField.text];
        [self loginMessageIsTureWithUserName:busrId password:logInPasswordTextField.text];
        
        [SFHFKeychainManager saveValue:_loginManager.deviceId forKey:busrId];
        [SFHFKeychainManager saveValue:_loginManager.deviceName forKey:[NSString stringWithFormat:@"%@%@",busrId,busrId]];
        NSString *str = [SFHFKeychainManager loadValueForKey:[NSString stringWithFormat:@"%@%@",busrId,busrId]];
        NSLog(@"%@",str);
        
        if (_loginManager.channel == CHANNEL_BLUETOOTH) {//存蓝牙设备信息
            [SFHFKeychainManager saveValue:YR_DEVICE_CHANNEL_VALUE_BLUETOOTH forKey:YR_DEVICE_CHANNEL];
        }else{//存音频设备信息
            [SFHFKeychainManager saveValue:YR_DEVICE_CHANNEL_VALUE_AUDIOJACK forKey:YR_DEVICE_CHANNEL];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [phoneNumTextField resignFirstResponder];
    [phoneVertifyCodeTextField resignFirstResponder];
    [confirmLoginPasswordTextField resignFirstResponder];
    [logInPasswordTextField resignFirstResponder];
    [_certIdTextField resignFirstResponder];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame =CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    } completion:nil];

}

- (IBAction)resignResponder:(id)sender {
    
    [confirmLoginPasswordTextField resignFirstResponder];
    [logInPasswordTextField resignFirstResponder];
    [_certIdTextField resignFirstResponder];
    
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [_timer invalidate];
}

/*
//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    return YES;
}
*/
//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    CGRect frame = textField.superview.frame;
    
    CGRect viewFrame = self.view.frame;
    
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);//键盘高度216
    
    if (offset > 0) {
        [UIView animateWithDuration:0.3 animations:^{
            
            self.view.frame = CGRectMake(0.0f, -offset, viewFrame.size.width, viewFrame.size.height);
        } completion:^(BOOL finished) {
            nil;
        }];
    }
    
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame =CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    } completion:nil];
    return YES;
}

@end
