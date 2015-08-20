//
//  YREncashmentController.m
//  YunRichMPCR
//
//  Created by YunRich on 15/5/13.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//

#import "YREncashmentViewController.h"
#import "YRDrawCashRequest.h"
#import "MBProgressHUD+MJ.h"
#import "YRDrawCashDetailView.h"
#import "YRMD5Encryption.h"
#import "YRSelectDrawCashWayViewController.h"
#import "YRRequestTool.h"
#import "YRPersonMessage.h"
#import "TouchTableView.h"

@interface YREncashmentViewController ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,YRSelectDrawCashWayDelegate>
{
    UITextField * passwordTextField;
    BOOL isPassword;
}

@end

@implementation YREncashmentViewController {
    
    __weak IBOutlet TouchTableView *_tableView;
    __weak IBOutlet UIButton *_confirmBtn;
    __weak IBOutlet UIView *_switchView;
    __weak IBOutlet UIButton *_getCashBtn;
    __weak IBOutlet UIButton *_recordInfoBtn;
    
    __weak IBOutlet UIImageView *_imageViewBG;

    YRDrawCashRequest * _drawCashRequest;
    YRDrawCashDetailView * _drawCashDetailView;
    NSDictionary * _allResults;
    UITextField * _textField;
    NSString * _cashWay;

    YRPersonMessage * _personMessage;
    NSString * _minCash;
    NSString * _fees;
    NSString * _tmpValue;
    BOOL _isHaveAuth; // 是否具有T0权限
    BOOL _isExcuted; // 首次加载 查询T0权限
    BOOL _isNeedExcuted;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubView];
    self.title = @"取现";
    [MBProgressHUD showMessage:@"正在加载数据..."];
    [self loadUserMessage];
    _isHaveAuth = NO;
    _isExcuted = NO;
    
    _tableView.layer.contents = (id)[UIImage imageNamed:@"qh_rootbg"].CGImage;
}

- (void)loadSubView {
    
    _textField = [[UITextField alloc] init];
    [_textField setTranslatesAutoresizingMaskIntoConstraints:NO];
    _textField.delegate = self;
    _textField.keyboardType = UIKeyboardTypeDecimalPad;
    _textField.font = [UIFont systemFontOfSize:16];
    
    if (_recordInfoBtn.selected) {
        [_imageViewBG setImage:[UIImage imageNamed:@"tab_bg_left_blue"]];
    }
    else {
        [_imageViewBG setImage:[UIImage imageNamed:@"tab_bg_right_blue"]];
    }
    _confirmBtn.layer.cornerRadius = 5;
    [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    if (_isHaveAuth == YES) {
        _cashWay = @"T0";
    } else {
        _cashWay = @"T1";
    }
    
    _drawCashRequest = [[YRDrawCashRequest alloc] init];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithIcon:nil highlightedIcon:nil target:self action:@selector(goBack) barButtonItemType:BarButtonItemTypePopToView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidDisappear:) name:UIKeyboardDidHideNotification object:nil];
}



- (void)goBack {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadUserMessage{
    
    [YRRequestTool queryPersonMessageSuccess:^(id responseObject) {
        //[MBProgressHUD hideHUD];
        _personMessage = responseObject[YR_OUTPUT_KEY_DATA];
        
        NSString * minCash = _personMessage.ACCTAVL ? _personMessage.ACCTAVL : @"";
        _minCash = [NSString stringWithFormat:@"本次取现的限额为 %@ 元",minCash];
        [_tableView reloadData];

        if (!_isExcuted) {
            
            [self queryAuthorityForDrawCash:nil];
            _isExcuted = YES;
        }
        
    } failure:^(NSString *errInfo) {
        [MBProgressHUD hideHUD];
        [YRFunctionTools showAlertViewTitle:nil message:TIPS_MESSAGES cancelButton:TIPS_CONFIRM];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    _isNeedExcuted = NO;
    
    if (_cashWay) {
        
        if ([_cashWay isEqualToString:@"T1"] && _personMessage.ACCTAVL) {
            
            NSString * minCash = _personMessage.ACCTAVL ? _personMessage.ACCTAVL : @"";
            _minCash = [NSString stringWithFormat:@"本次取现的限额为 %@ 元",minCash];
            [_tableView reloadData];
        }else if ([_cashWay isEqualToString:@"T0"]) {
            
            if (_allResults) {
                
                NSString * minCash = _allResults[@"MINAMT"] ? _allResults[@"MINAMT"] : @"00";
                _minCash = [NSString stringWithFormat:@"本次取现的限额为 %@ 元",minCash];
                [_tableView reloadData];

            }else {
                
                //[self queryAuthorityForDrawCash:@"正在查询取现权限..."];
            }
        }
    }
    
    [self checkCashWaySetConfirmBtn];
}

#pragma mark -- 切换取现和明细
- (IBAction)switchReceivePaymentAndTransactionInfo:(UIButton *)sender {
    
    switch (sender.tag) {
        case 111:
        {
            self.title = @"取现";
            [_imageViewBG setImage:[UIImage imageNamed:@"tab_bg_right_blue"]];
            [_getCashBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_recordInfoBtn setTitleColor:[UIColor colorWithRed:43.0/255 green:139.0/255 blue:217.0/255 alpha:1] forState:UIControlStateNormal];
            _recordInfoBtn.selected = NO;
            if (_drawCashDetailView) {
                
                [_drawCashDetailView cancelRequest];
                [_drawCashDetailView setHidden:YES];
            }
        }
            break;
        case 112:
        {
            _recordInfoBtn.selected = YES;
            [self displayDrawCashDetailView];
        }
            break;
        default:
            break;
    }
}

- (void)displayDrawCashDetailView {
    
    self.title = @"明细";
    [_imageViewBG setImage:[UIImage imageNamed:@"tab_bg_left_blue"]];
    [_recordInfoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_getCashBtn setTitleColor:[UIColor colorWithRed:43.0/255 green:139.0/255 blue:217.0/255 alpha:1] forState:UIControlStateNormal];
    
    if (!_drawCashDetailView) {
        _drawCashDetailView = [[[NSBundle mainBundle] loadNibNamed:@"YRDrawCashDetailView" owner:self options:nil] objectAtIndex:0];
        [_drawCashDetailView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.view addSubview:_drawCashDetailView];
        
        NSLayoutConstraint * top_Cons = [NSLayoutConstraint constraintWithItem:_drawCashDetailView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_switchView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        NSLayoutConstraint * bottom_Cons = [NSLayoutConstraint constraintWithItem:_drawCashDetailView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        NSLayoutConstraint * leading_Cons = [NSLayoutConstraint constraintWithItem:_drawCashDetailView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
        NSLayoutConstraint * trailing_Cons = [NSLayoutConstraint constraintWithItem:_drawCashDetailView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
        
        [self.view addConstraint:top_Cons];
        [self.view addConstraint:bottom_Cons];
        [self.view addConstraint:leading_Cons];
        [self.view addConstraint:trailing_Cons];
//        CGRect detailRect = self.view.frame;
//        detailRect.size.height = detailRect.size.height-55;
//        [_drawCashDetailView setFrame:detailRect];
        
    }
    [_drawCashDetailView startSendRequest];
    [_drawCashDetailView setHidden:NO];
    if (_drawCashDetailView.dateBtn.selected) {
        
        _drawCashDetailView.dateBtn.selected = NO;
        [_drawCashDetailView.selectDateView setHidden:YES];
    }
}

#pragma mark -- 查询提现权限
- (void)queryAuthorityForDrawCash:(NSString *)message {
    
    if (message) {
        
        [MBProgressHUD showMessage:message];
    }
    
    NSDictionary * parameters = @{@"CASHTYPE" : @"T0"};
    
    [_drawCashRequest queryAuthorityForDrawCash:parameters successBlock:^(id responseObject) {
        
        [MBProgressHUD hideHUD];
        if ([responseObject[YR_OUTPUT_KEY_STATES_RESP_CODE] isEqualToString:YR_STATIC_SUCCESS_STATES_CODE]) {
            
            if ([responseObject[@"AUTHFLAG"] isEqualToString:@"I"]) {
                
                // 正在审核
                //[YRFunctionTools showAlertViewTitle:@"即时取现暂无法使用" message:responseObject[YR_OUTPUT_KEY_STATES_RESP_DESC] cancelButton:TIPS_CONFIRM];
                _isHaveAuth = NO;
                _cashWay = @"T1";
            }else if ([responseObject[@"AUTHFLAG"] isEqualToString:@"F"]) {
                
                if (message) {
                    
                    // 可以申请
                    [self applyDrawCash:nil];
                }else {
                    _isHaveAuth = NO;
                }
            }else if ([responseObject[@"AUTHFLAG"] isEqualToString:@"S"]) {
                
                // 可以取现
                _isHaveAuth = YES;
                [self loadSubView];
                    
                [self updateViewValue:responseObject];
            }
        }else {
            [YRFunctionTools showAlertViewTitle:@"友情提示" message:[NSString stringWithFormat:@"[%@]%@",responseObject[YR_OUTPUT_KEY_STATES_RESP_DESC],responseObject[YR_OUTPUT_KEY_STATES_RESP_CODE]] cancelButton:TIPS_CONFIRM];
            //解析失败
        }
        
    } failureBlock:^(NSString *errInfo) {
        
        [MBProgressHUD hideHUD];
        [YRFunctionTools setAlertViewWithTitle:TIPS_MESSAGES buttonTitle:TIPS_CONFIRM];
    }];
}

- (void)updateViewValue:(NSDictionary *)responseObject {
    
    if ([_cashWay isEqualToString:@"T0"]) {
        
        NSString * minCash = responseObject[@"MINAMT"] ? responseObject[@"MINAMT"] : @"00";
        _minCash = [NSString stringWithFormat:@"本次取现的限额为 %@ 元",minCash];
    }
    
    _allResults = responseObject;
    [_tableView reloadData];
}

#pragma mark -- 申请提现
- (void)applyDrawCash:(NSString *)message {
    
    if (message) {
        
        [MBProgressHUD showMessage:message];
    }
    
    NSDictionary * parameters = @{@"CASHTYPE" : @"T0"};
    [_drawCashRequest applyDrawCash:parameters successBlock:^(id responseObject) {
        
        [MBProgressHUD hideHUD];
        
        if ([responseObject[YR_OUTPUT_KEY_STATES_RESP_CODE] isEqualToString:YR_STATIC_SUCCESS_STATES_CODE]) {
            
            if ([responseObject[@"STAT"] isEqualToString:@"I"]) {
                
                // 申请已提交 系统正在审核中
                _cashWay = @"T1";
                if (message) {
                    
                    [YRFunctionTools showAlertViewTitle:@"即时取现暂无法使用"
                                                message:@"申请已提交,系统审核中"
                                           cancelButton:TIPS_CONFIRM];
                }
                
            }else if ([responseObject[@"STAT"] isEqualToString:@"F"]) {
                _cashWay = @"T1";
                // 提现申请被系统拒绝，详情请联系客服人员
                _isHaveAuth = NO;
                if (message) {
                    
                    [YRFunctionTools showAlertViewTitle:nil
                                                message:[NSString stringWithFormat:@"[%@]%@",responseObject[YR_OUTPUT_KEY_STATES_RESP_DESC],responseObject[YR_OUTPUT_KEY_STATES_RESP_CODE]]
                                           cancelButton:TIPS_CONFIRM];
                }
                
            }else if ([responseObject[@"STAT"] isEqualToString:@"S"]) {
                
                // 审核通过 可以提现
                _isHaveAuth = YES;
            }
        }else {
            //数据返回错误
            [YRFunctionTools showAlertViewTitle:nil
                                        message:[NSString stringWithFormat:@"[%@]%@",responseObject[YR_OUTPUT_KEY_STATES_RESP_DESC],responseObject[YR_OUTPUT_KEY_STATES_RESP_CODE]]
                                   cancelButton:TIPS_CONFIRM];
        }
    } failureBlock:^(NSString *errInfo) {
        //
        [MBProgressHUD hideHUD];
        [YRFunctionTools setAlertViewWithTitle:TIPS_MESSAGES buttonTitle:TIPS_CONFIRM];
    }];
}

#pragma mark -- 提现
- (void)drawCashWithPassword:(NSString *)password {
    
    NSString * encryptionedPD = [YRMD5Encryption encryptionMD5WithPassword:password passwordType:PasswordTypeTrans];
    NSString * cashNum = [NSString stringWithFormat:@"%.2f", [_textField.text doubleValue]];
    [MBProgressHUD showMessage:@"提现中..."];
    if ([_cashWay isEqualToString:@"T11"]) {
        
        _cashWay = @"T1";
    }
    NSDictionary * parameters = @{@"AMT" : cashNum, @"CASHTYPE" : _cashWay,@"TRANSPWD" : encryptionedPD};
    
    [_drawCashRequest drawCash:parameters successBlock:^(id responseObject) {
        
        [MBProgressHUD hideHUD];
        
        if (responseObject && [responseObject[YR_OUTPUT_KEY_STATES_RESP_CODE] isEqualToString:YR_STATIC_SUCCESS_STATES_CODE]) {
    
            _textField.text = @"";
            if ([responseObject[YR_OUTPUT_KEY_STATES_RESP_DESC] isEqualToString:@""]) {
                
                [YRFunctionTools setAlertViewWithTitle:@"取现成功" buttonTitle:@"确认"];
                
                if ([_cashWay isEqualToString:@"T0"]) {
                    [self loadUserMessage];
                    [self queryAuthorityForDrawCash:nil];
                }else if ([_cashWay isEqualToString:@"T1"]){
                    
                    [self loadUserMessage];
                   
                }
                
                //[_tableView reloadData];
                _recordInfoBtn.selected = YES   ;
                [self displayDrawCashDetailView];
            }else{
                [YRFunctionTools setAlertViewWithTitle:[NSString stringWithFormat:@"[%@]%@",responseObject[YR_OUTPUT_KEY_STATES_RESP_DESC],responseObject[YR_OUTPUT_KEY_STATES_RESP_CODE]] buttonTitle:TIPS_CONFIRM];
            }
        }else {
            
            [YRFunctionTools showAlertViewTitle:nil message:[NSString stringWithFormat:@"[%@]%@",responseObject[YR_OUTPUT_KEY_STATES_RESP_DESC],responseObject[YR_OUTPUT_KEY_STATES_RESP_CODE]] cancelButton:TIPS_CONFIRM];
        }
    } failureBlock:^(NSString *errInfo) {
        
        [MBProgressHUD hideHUD];
        [YRFunctionTools setAlertViewWithTitle:TIPS_MESSAGES buttonTitle:TIPS_CONFIRM];
    }];
}


- (IBAction)confirmDrawCash:(UIButton *)sender {
    
    if ([_cashWay isEqualToString:@"T0"]) {
        
        if ([_textField.text floatValue] >= [_allResults[@"MINAMT"] floatValue] &&
            [_textField.text floatValue] <= [_allResults[@"MAXAMT"] floatValue]) {
            
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"请输入交易密码" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
            UITextField * textField = [alertView textFieldAtIndex:0];
            textField.placeholder = @"请输入交易密码";
            [alertView show];
        }else {
            
            NSString * messageInfo = [NSString stringWithFormat:@"请输入合法的取现金额\n最小金额:%@元,最大金额:%@元",_allResults[@"MINAMT"],_allResults[@"MAXAMT"]];
            
            [YRFunctionTools showAlertViewTitle:nil message:messageInfo cancelButton:TIPS_CONFIRM];
        }
        
    }else if ([_cashWay isEqualToString:@"T1"]) {
        
        if ([_textField.text floatValue] > [_personMessage.ACCTAVL floatValue])  {
            
            [YRFunctionTools showAlertViewTitle:nil message:@"输入金额不能大于可取金额" cancelButton:TIPS_CONFIRM];
        }else {
            
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"请输入交易密码" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
            passwordTextField = [alertView textFieldAtIndex:0];
            passwordTextField.placeholder = @"请输入交易密码";
            [alertView show];
        }
    }
}

#pragma delegate method alertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        UITextField * textField = [alertView textFieldAtIndex:0];
        
        if (textField.text.length > 0) {
            isPassword = YES;
            [self drawCashWithPassword:textField.text];
        }else {
            
            [YRFunctionTools showAlertViewTitle:nil message:@"密码长度输入有误" cancelButton:nil];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 4;
    }else if (section == 1) {
        
        return 2;
    }else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * Identifier = @"reusedCell";
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel * content = [[UILabel alloc] init];
    [content setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSLayoutConstraint * constraint_H = [NSLayoutConstraint constraintWithItem:content attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:105];
    
    NSLayoutConstraint * constraint_V = [NSLayoutConstraint constraintWithItem:content attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell.textLabel attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    
    UIButton * _drawAll = nil;
    
    NSLayoutConstraint * Tconstraint_H = [NSLayoutConstraint constraintWithItem:_textField attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:105];
    
    NSLayoutConstraint * Tconstraint_TrailingTF = nil;
    NSLayoutConstraint * V_DrawAllBtn = nil;
    NSLayoutConstraint * trailingBtn = nil;
    
    NSLayoutConstraint * Tconstraint_Height = [NSLayoutConstraint constraintWithItem:_textField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
    NSLayoutConstraint * Tconstraint_V = [NSLayoutConstraint constraintWithItem:_textField attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell.textLabel attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            [cell.contentView addSubview:content];
            [cell addConstraint:constraint_H];
            [cell addConstraint:constraint_V];
            cell.textLabel.text = @"可取金额: ";
            content.textColor = [UIColor grayColor];
            content.text = _personMessage.ACCTAVL ? _personMessage.ACCTAVL : @"";
//            if ([_cashWay isEqualToString:@"T0"] && (_personMessage.ACCTAVL.intValue > 50000)) {
//               content.text = @"500000";
//            }
            
            cell.detailTextLabel.text = @"查询";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.row == 1) {
            
            [cell.contentView addSubview:content];
            [cell addConstraint:constraint_H];
            [cell addConstraint:constraint_V];
            content.textColor = [UIColor colorWithRed:43.0/255 green:139.0/255 blue:217.0/255 alpha:1];
            
            if ([_cashWay isEqualToString:@"T0"]) {
                
                content.text = @"即时取现";
            }else if ([_cashWay isEqualToString:@"T1"]) {
                
                content.text = @"普通取现";
            }else {
                
                //content.text = @"全部提取";
            }
            cell.textLabel.text = @"取现方式: ";
            cell.detailTextLabel.text = @"请选择";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.row == 2) {
            
            cell.textLabel.text = @"取现账户";
            NSString * bankNum = [_personMessage.CARDNO substringFromIndex:_personMessage.CARDNO.length-4];
            NSString * bankName = _personMessage.BANKNAME ? _personMessage.BANKNAME : @"";
            
            if (bankName && bankNum) {
                
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@(尾号%@)",bankName,bankNum];
            }
        }else {
            
            [cell.contentView addSubview:content];
            [cell addConstraint:constraint_H];
            [cell addConstraint:constraint_V];
            cell.textLabel.text = @"到账时间: ";
            content.textColor = [UIColor colorWithRed:43.0/255 green:139.0/255 blue:217.0/255 alpha:1];
            if ([_cashWay isEqualToString:@"T0"]) {
                
                content.text = @"2小时";
            }else if ([_cashWay isEqualToString:@"T1"]) {
                
                content.text = @"下一个工作日";
            }
        }
        
    }else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            [cell.contentView addSubview:_textField];
            [_textField addTarget:self action:@selector(checkSpecialCharacter:) forControlEvents:UIControlEventEditingChanged];
            [cell addConstraint:Tconstraint_H];
            [cell addConstraint:Tconstraint_V];
            [cell addConstraint:Tconstraint_Height];
            
            _drawAll = [UIButton buttonWithType:UIButtonTypeCustom];
            [_drawAll setTitle:@"全部取现" forState:UIControlStateNormal];
            [_drawAll setTranslatesAutoresizingMaskIntoConstraints:NO];
            _drawAll.titleLabel.font = [UIFont systemFontOfSize:16];
            [_drawAll addTarget:self action:@selector(switchDrawAllCash) forControlEvents:UIControlEventTouchUpInside];
            [_drawAll setTitleColor:[UIColor colorWithRed:43.0/255 green:139.0/255 blue:217.0/255 alpha:1] forState:UIControlStateNormal];
            [cell.contentView addSubview:_drawAll];
            
            V_DrawAllBtn = [NSLayoutConstraint constraintWithItem:_drawAll attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
            trailingBtn = [NSLayoutConstraint constraintWithItem:_drawAll attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-20];
            Tconstraint_TrailingTF = [NSLayoutConstraint constraintWithItem:_textField attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_drawAll attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
            [cell addConstraint:V_DrawAllBtn];
            [cell addConstraint:trailingBtn];
            [cell addConstraint:Tconstraint_TrailingTF];
            
            cell.textLabel.text = @"取现金额: ";
            _textField.textColor = [UIColor colorWithRed:43.0/255 green:139.0/255 blue:217.0/255 alpha:1];
            _textField.placeholder = @"请输入取现金额";
            
            if ([_cashWay isEqualToString:@"T0"] && [_textField.text doubleValue] > 0 && !_isNeedExcuted) {
                
                [self calculateFeeWithCash:_textField.text];
                
                
            }

            [self checkCashWaySetConfirmBtn];
            
        }else {
            
            [cell.contentView addSubview:content];
            [cell addConstraint:constraint_H];
            [cell addConstraint:constraint_V];
            cell.textLabel.text = @"手续费: ";
            content.textColor = [UIColor grayColor];
            if ([_cashWay isEqualToString:@"T0"]) {
                
                if ([_textField.text intValue] != 0) {
                    
                    content.text = _fees ? _fees : @"";
                }else {
                    
                    content.text = @"0.00";
                }
                
            }else if ([_cashWay isEqualToString:@"T1"]) {
                
                content.text = @"0.00";
            }
        }
    }
    
    return cell;
}

#pragma mark -- 全部取现
- (void)switchDrawAllCash {
    
    if ([_cashWay isEqualToString:@"T0"]) {
//        if ( _personMessage.ACCTAVL.intValue > 50000) {
//            _textField.text = @"500000";
//        }
//        _textField.text = _personMessage.ACCTAVL ? _personMessage.ACCTAVL : @"";
        _textField.text = _allResults[@"AVLAMT"] ? _allResults[@"AVLAMT"] : @"";
        
    }else if ([_cashWay isEqualToString:@"T1"]) {
        
        _textField.text = _personMessage.ACCTAVL ? _personMessage.ACCTAVL : @"";
    }
    
    _isNeedExcuted = NO;
    [_tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 10;
    }else
        return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 0) {
        return 0.1;
    }else {
        return 30;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView * footView = nil;
    if (section == 1) {
        
        footView = [[UIView alloc] init];
        UILabel * titleLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, self.view.bounds.size.width*2/3, 16)];
        titleLable.text = _minCash;
        titleLable.hidden = YES;
        titleLable.font = [UIFont systemFontOfSize:14];
        [titleLable setTextColor:[UIColor colorWithRed:173.0/255 green:179.0/255 blue:184.0/255 alpha:1]];
        [footView addSubview:titleLable];
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(self.view.bounds.size.width*3/4, 3, 60, 20)];
        
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn setTitle:@"额度说明" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(explanDrawCashLimit:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:btn];
        
        if ([_cashWay isEqualToString:@"T0"]) {
            
            [btn setTitleColor:[UIColor colorWithRed:43.0/255 green:139.0/255 blue:217.0/255 alpha:1] forState:UIControlStateNormal];
            [btn setHidden:NO];
        }else if ([_cashWay isEqualToString:@"T1"]) {
            
            [btn setHidden:YES];
        }
    }
    return footView;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_textField resignFirstResponder];
    if (indexPath.section == 0) {
        
        switch (indexPath.row) {
            case 0:
            {
                if ([_cashWay isEqualToString:@"T0"]) {
                    
                    [self queryAuthorityForDrawCash:@"正在查询取现权限..."];
                }else if ([_cashWay isEqualToString:@"T1"]) {
                    
                    [self loadUserMessage];
                }
            }
                break;
            case 1:
            {
                YRSelectDrawCashWayViewController * selectDrawCashVC = [YRSelectDrawCashWayViewController new];
                selectDrawCashVC.delegate = self;
                selectDrawCashVC.drawCash = _cashWay;
                selectDrawCashVC.isGotAuth = _isHaveAuth;
                [self.navigationController pushViewController:selectDrawCashVC animated:YES];
            }
                break;
            default:
                break;
        }
    }
}


#pragma mark -- 约束小数点保留两位小数
- (void)checkSpecialCharacter:(UITextField *)textF {
    
    NSRange range = [textF.text rangeOfString:@"."];
    if (range.length == 1) {
        
        NSString * subString = [textF.text substringFromIndex:range.location];
        if (subString.length >= 3) {
            
            textF.text = [textF.text substringToIndex:range.location+3];
        }
    }else {
        
        if (textF.text.length >= 10) {
            
            textF.text = [textF.text substringToIndex:10];
        }
    }
}

// 额度说明
- (void)explanDrawCashLimit:(id)sender {
    
    NSString * messageInfo = [NSString stringWithFormat:@"本次取现最小金额:%@元\n本次取现最大金额:%@元\n当前允许取现:%@元",_allResults[@"MINAMT"],_allResults[@"MAXAMT"],_allResults[@"AVLAMT"]];
    
    [YRFunctionTools showAlertViewTitle:@"额度说明" message:messageInfo cancelButton:@"关闭"];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y < -3) {
        
        [_textField resignFirstResponder];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [textField becomeFirstResponder];
    [_tableView setContentOffset:CGPointMake(0, 80) animated:YES];
    _textField.font = [UIFont systemFontOfSize:15];
    if (textField == passwordTextField) {
        isPassword = YES;
    }
    {
        isPassword = NO;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSArray *array = [_textField.text componentsSeparatedByString:@"."];
    NSString *laststr = [array lastObject];
    if (![_textField.text isEqualToString:@""] && (array.count == 1)) {
        _textField.text = [NSString stringWithFormat:@"%@.00",_textField.text];
    }
    else if (!(array.count == 1) && laststr.length == 1){
        _textField.text = [NSString stringWithFormat:@"%@0",_textField.text];
    }
    else if((array.count == 2) && [laststr isEqualToString:@""]){
        _textField.text = [NSString stringWithFormat:@"%@00",_textField.text];
    }
}

- (void)selectDrawCashWay:(YRSelectDrawCashWayViewController *)selectVC whichOne:(NSString *)way {
    
    _cashWay = way;
}
#pragma mark -- 键盘消失时 计算手续费
- (void)keyboardDidDisappear:(NSNotification *)notification {
    if (isPassword) {
        
    }
    else{
    if ([_cashWay isEqualToString:@"T0"]) {
        
        if ([_textField.text floatValue] > 0 && ![_textField.text isEqualToString:_tmpValue]) {
            
            [_confirmBtn setEnabled:YES];
            [_confirmBtn setBackgroundColor:[UIColor colorWithRed:0 green:95.0/255 blue:173.0/255 alpha:1]];
            _tmpValue = _textField.text;
            
            [self calculateFeeWithCash:_textField.text];
            
        }else {

            [self checkCashWaySetConfirmBtn];
        }
    }else if ([_cashWay isEqualToString:@"T1"]) {
    
        [self checkCashWaySetConfirmBtn];
    }
    }
//    isPassword = NO;
}



#pragma mark -- 计算手续费
- (void)calculateFeeWithCash:(NSString *)cash {
    
    NSString * cashAMT = [NSString stringWithFormat:@"%.2f",[cash doubleValue]];
    [MBProgressHUD showMessage:@"正在计算手续费..."];
    NSDictionary * parameters = @{@"RAPIDTYPE":@"T0", @"CASHAMT":cashAMT};
    [_drawCashRequest calculateFee:parameters successBlock:^(id responseObject) {
        
        _isNeedExcuted = YES;
        [MBProgressHUD hideHUD];
        if ([responseObject[YR_OUTPUT_KEY_STATES_RESP_CODE] isEqualToString:YR_STATIC_SUCCESS_STATES_CODE]) {
            [MBProgressHUD hideHUD];
            _fees = responseObject[@"FEEAMT"];
            [_tableView reloadData];
        }else {
            
            [YRFunctionTools showAlertViewTitle:nil message:[NSString stringWithFormat:@"[%@]%@",responseObject[YR_OUTPUT_KEY_STATES_RESP_DESC],responseObject[YR_OUTPUT_KEY_STATES_RESP_CODE]] cancelButton:TIPS_CONFIRM];
        }
        
    } failureBlock:^(NSString *errInfo) {
        
        [MBProgressHUD hideHUD];
        [YRFunctionTools showAlertViewTitle:nil message:TIPS_MESSAGES cancelButton:TIPS_CONFIRM];
    }];
}

- (void)checkCashWaySetConfirmBtn {
    
    if ([_textField.text floatValue] > 0) {
        
        [_confirmBtn setEnabled:YES];
        [_confirmBtn setBackgroundColor:[UIColor colorWithRed:0 green:95.0/255 blue:173.0/255 alpha:1]];
    }else {
        
        [_confirmBtn setEnabled:NO];
        [_confirmBtn setBackgroundColor:[UIColor colorWithRed:173.0/255 green:179.0/255 blue:184.0/255 alpha:1]];
    }
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
