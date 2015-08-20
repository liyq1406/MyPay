//
//  YRRestPWController.m
//  YunRichMPCR
//
//  Created by YunRich on 15/3/25.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//

#import "YRRestPWController.h"
#import "QHLoginController.h"
#import "YRRequestTool.h"
#import "MBProgressHUD+MJ.h"
#import "YRVerifyRegexTool.h"

@interface YRRestPWController ()<UITextFieldDelegate>

@end

@implementation YRRestPWController {
    
    __weak IBOutlet UITextField *_oldPSTextField;
    __weak IBOutlet UITextField *_newPSTextField;
    __weak IBOutlet UITextField *_confirmPSTextField;
    __weak IBOutlet UIButton *_confirmBtn;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _confirmBtn.layer.cornerRadius = 5;
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 24, 24)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"ic_g_return"] forState:UIControlStateNormal];
    
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    self.view.layer.contents = (id)[UIImage imageNamed:@"qh_rootbg"].CGImage;
}

- (void)goBack {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (self.changePasswordType == ChangePasswordType_Login) {
        
        self.title = @"修改登录密码";
    }else if (self.changePasswordType == ChangePasswordType_Transaction)  {
        
        self.title = @"修改交易密码";
    }
}


- (IBAction)changePasswordAction:(UIButton *)sender {
    
    NSString * newPS = _newPSTextField.text;
    NSString * confirmPS = _confirmPSTextField.text;
    NSString * oldPS = _oldPSTextField.text;
    
    if (newPS.length >= 6 && confirmPS.length >= 6 && oldPS.length >= 6) {
        
        if ([YRVerifyRegexTool validtaeUserName:newPS] &&
            [YRVerifyRegexTool validtaeUserName:confirmPS] &&
            [YRVerifyRegexTool validtaeUserName:oldPS]) {
            
            if (0 == 1) {
                
                [YRFunctionTools showAlertViewTitle:nil message:@"新密码不能与旧密码一样" cancelButton:TIPS_CONFIRM];
            }else {
                
                if ([newPS isEqualToString:confirmPS]) {
                    
                    if (self.changePasswordType == ChangePasswordType_Login) { // 修改登陆密码
                        
                        [MBProgressHUD showMessage:@"正在发送请求..."];
                        [YRRequestTool resetPasswordWithOldPassword:_oldPSTextField.text newPassword:_newPSTextField.text passwordType:ChangePasswordType_Login success:^(id responseObject) {
                            
                            [MBProgressHUD hideHUD];
                            NSString * message = nil;
                            
                            if ([responseObject[YR_OUTPUT_KEY_STATES_RESP_CODE] isEqualToString:YR_STATIC_SUCCESS_STATES_CODE]) {
                               if([oldPS isEqualToString:newPS]) {
                                    [YRFunctionTools showAlertViewTitle:nil message:@"新密码不能与旧密码一样"  cancelButton:TIPS_CONFIRM];
                                }
                               else{
                                if (![responseObject[YR_OUTPUT_KEY_STATES_RESP_DESC] isEqualToString:@""]) {
                                    
                                    message = [NSString stringWithFormat:@"[%@]%@",responseObject[YR_OUTPUT_KEY_STATES_RESP_DESC],responseObject[YR_OUTPUT_KEY_STATES_RESP_CODE]];
                                }else {
                                    message = @"密码修改成功";
                                }
                                [YRFunctionTools showAlertViewTitle:nil message:message cancelButton:TIPS_CONFIRM];
                                
                                [YRFunctionTools logoutWithViewController:self];
                               }
                            }else {
                                [YRFunctionTools showAlertViewTitle:nil message:[NSString stringWithFormat:@"[%@]%@",responseObject[YR_OUTPUT_KEY_STATES_RESP_DESC],responseObject[YR_OUTPUT_KEY_STATES_RESP_CODE]] cancelButton:TIPS_CONFIRM];
                            }
                        
                            
                        } failure:^(NSString *errInfo) {
                            
                            [MBProgressHUD hideHUD];
                            [YRFunctionTools showAlertViewTitle:nil message:TIPS_MESSAGES cancelButton:TIPS_CONFIRM];
                        }];
                    }else if (self.changePasswordType == ChangePasswordType_Transaction)  {  // 修改交易密码
                        [MBProgressHUD showMessage:@"正在发送请求..."];
                        [YRRequestTool resetPasswordWithOldPassword:_oldPSTextField.text newPassword:_newPSTextField.text passwordType:ChangePasswordType_Transaction success:^(id responseObject) {
                            
                            [MBProgressHUD hideHUD];
                            NSString * message = nil;
                            
                            if ([responseObject[YR_OUTPUT_KEY_STATES_RESP_CODE] isEqualToString:YR_STATIC_SUCCESS_STATES_CODE]) {
                                if(0 == 1) {
                                    
                                }
                                else{
                                if (![responseObject[YR_OUTPUT_KEY_STATES_RESP_DESC] isEqualToString:@""]) {
                                    
                                    message = [NSString stringWithFormat:@"[%@]%@",responseObject[YR_OUTPUT_KEY_STATES_RESP_DESC],responseObject[YR_OUTPUT_KEY_STATES_RESP_CODE]];
                                }else {
                                    message = @"密码修改成功";
                                }
                                [self.navigationController popViewControllerAnimated:YES];
                                }
                            }else {
                                
                                message = [NSString stringWithFormat:@"[%@]%@",responseObject[YR_OUTPUT_KEY_STATES_RESP_DESC],responseObject[YR_OUTPUT_KEY_STATES_RESP_CODE]];
                            }
                            [YRFunctionTools showAlertViewTitle:nil message:message cancelButton:TIPS_CONFIRM];
                            
                        } failure:^(NSString *errInfo) {
                            
                            [MBProgressHUD hideHUD];
                            [YRFunctionTools showAlertViewTitle:nil message:TIPS_MESSAGES cancelButton:TIPS_CONFIRM];
                        }];
                    }
                }else{
                    
                    [YRFunctionTools showAlertViewTitle:nil message:@"确认密码不一致" cancelButton:TIPS_CONFIRM];
                }
            }
            
        }else {
            
            [YRFunctionTools showAlertViewTitle:nil message:@"密码不支持特殊字符，只能由数字和字母组成，并区分大小写！" cancelButton:TIPS_CONFIRM];
        }
        
    }else{
        
        [YRFunctionTools showAlertViewTitle:nil message:@"密码的有效长度需大于或等于六位" cancelButton:TIPS_CONFIRM];
    }
}

//限制输入长度

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.location >= 12)
    {
        [YRFunctionTools showAlertViewTitle:nil message:@"密码的有效长度需小于或等于12位" cancelButton:TIPS_CONFIRM];
        return  NO;
    }
    else
    {
        return YES;
    }
}

- (IBAction)setKeyboardDisappear:(id)sender {
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [_oldPSTextField resignFirstResponder];
    [_newPSTextField resignFirstResponder];
    [_confirmPSTextField resignFirstResponder];
}

@end
