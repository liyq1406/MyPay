//
//  YRPersonalCenterController.m
//  YunRichMPCR
//
//  Created by YunRich on 15/3/26.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//  个人中心

#import "YRPersonalCenterController.h"
#import "YRRequestTool.h"
#import "YRPersonMessage.h"
#import "YRPersonalCenterCell.h"
#import "YRPersonalCenterBtnCell.h"
#import "YRLoginManager.h"
#import "QHLoginController.h"
#import "YRRestPWController.h"


@interface YRPersonalCenterController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    YRPersonMessage * _personMessage;
}

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UITableView *userMessageTV;
@end

@implementation YRPersonalCenterController
static NSString * normalIdentifier = @"NormalCell";
static NSString * btnIdentifier = @"BtnCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildUI];
    
    //下载用户信息
    [self loadUserMessage];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (IBAction)backBTN:(id)sender {
    
    if (self.showStyle == ShowStyle_Pop) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }else if (self.showStyle == ShowStyle_Present) {
        
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (void)loadUserMessage{
    [YRRequestTool queryPersonMessageSuccess:^(id responseObject) {
        _personMessage = responseObject[YR_OUTPUT_KEY_DATA];
        
        [self.userMessageTV reloadData];
    } failure:^(NSString *errInfo) {
        
        [YRFunctionTools showAlertViewTitle:nil message:TIPS_MESSAGES cancelButton:TIPS_CONFIRM];
    }];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    NSString * userName = [YRLoginManager shareLoginManager].username;
    self.userNameLabel.text = userName ? userName:@"";
    self.phoneNameLabel.text = [YRLoginManager shareLoginManager].busrID;//_personMessage.USRMP;
    [self.view bringSubviewToFront:self.backBtn];
}

- (void)buildUI {
    self.title = @"个人中心";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithIcon:nil highlightedIcon:nil target:self action:@selector(back) barButtonItemType:BarButtonItemTypePopToView];
    
    [self.userMessageTV registerNib:[YRPersonalCenterCell nib] forCellReuseIdentifier:normalIdentifier];
    [self.userMessageTV registerNib:[YRPersonalCenterBtnCell nib] forCellReuseIdentifier:btnIdentifier];
    self.userMessageTV.layer.contents = (id)[UIImage imageNamed:@"qh_rootbg"].CGImage;
}

- (void)back{
  

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 2;
    }
    else if (section == 2) {
        return 3;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    YRPersonalCenterCell * normalCell = [tableView dequeueReusableCellWithIdentifier:normalIdentifier];
    
    YRPersonalCenterBtnCell * btnCell = [tableView dequeueReusableCellWithIdentifier:btnIdentifier];
    

    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
          
            case 0:
                normalCell.contentLabel.text = _personMessage.CERTID;
                normalCell.titleLabel.text = @"身份证号:";
                break;
            case 1:
                normalCell.contentLabel.text = _personMessage.IDCHKSTAT;
                normalCell.contentLabel.textColor = [UIColor blueColor];
                normalCell.titleLabel.text = @"证件状态:";
                break;
                
            default:
                break;
        }
        return normalCell;
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
                normalCell.contentLabel.text = _personMessage.CARDNO;
                normalCell.titleLabel.text = @"结算卡号:";
                break;
//            case 2:
//                normalCell.contentLabel.text = _personMessage.REALFLAG;
//                normalCell.titleLabel.text = @"实名认证:";
//                break;
            case 1:
                normalCell.contentLabel.text = _personMessage.ACCTAVL;
                normalCell.contentLabel.textColor = [UIColor blueColor];
                normalCell.titleLabel.text = @"账户余额:";
                break;
            default:
                break;
        }
        return normalCell;
    }else{
        switch (indexPath.row) {
            case 0:
                btnCell.titleLabel.text = @"更改登录密码";
                break;
            case 1:
                btnCell.titleLabel.text = @"更改交易密码";
                break;
            case 2:
                btnCell.titleLabel.text = @"注销登录";
                break;
                
            default:
                break;
        }
        return btnCell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YRRestPWController * resetPWVC = [YRRestPWController new];
    
    if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {

            resetPWVC.changePasswordType = ChangePasswordType_Login;
            [self.navigationController pushViewController:resetPWVC animated:YES];
        }else if (indexPath.row == 1){

            resetPWVC.changePasswordType = ChangePasswordType_Transaction;
            [self.navigationController pushViewController:resetPWVC animated:YES];
        }else if (indexPath.row == 2){

            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"是否退出登录" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认",nil];
            [alert show];

        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 1) {
        [YRFunctionTools logoutWithViewController:self];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        
        return 1;
    }else
        return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 1;
    }else
        return 10;
//   return  section?10:1;
    
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 || indexPath.section == 1) {
        return NO;
    }
    return YES;
}

@end
