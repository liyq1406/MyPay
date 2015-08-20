//
//  YRBondDeviceController.m
//  YunRichMPCR
//
//  Created by YunRich on 15/5/16.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//

#import "YRBondDeviceController.h"
#import "YRTransactionTool.h"
#import "YRMainKey.h"
#import "YRDeviceRelative.h"
#import "YRRequestDeviceTool.h"
#import "YRLoginManager.h"
#import "YRWorkKey.h"
#import "YRICPublicKey.h"
#import "YRICParameter.h"
#import "YRBondCell.h"
#import "AppDelegate.h"
#import "YRRequestTool.h"
#import "QHHomeViewController.h"
#import "QHLoginController.h"

@interface YRBondDeviceController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate> {
    BOOL _install9006Complete;
    BOOL _install9007Complete;
    BOOL _install9008complete;
    BOOL _install9009complete;
    BOOL _install9015complete;
    BOOL _install9016complete;
}

@property (weak, nonatomic) IBOutlet UITableView *bondDeviceTV;
@property (nonatomic, assign) NSInteger index;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (nonatomic, assign) NSInteger completeIndex;
@property (nonatomic, assign) NSInteger failedIndex;
@end

@implementation YRBondDeviceController
static NSString * Identifier = @"Cell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"安装组件";
    if(self.loadingType == LoadingKeyType_Initization) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectZero]];
    }
    [self reciveDeviceRelativeAndSerialNO];
    
    [self buildUI];
    
    self.bondDeviceTV.layer.contents = (id)[UIImage imageNamed:@"qh_rootbg"].CGImage;
    self.bondDeviceTV.userInteractionEnabled = NO;
}

- (void)goBack:(UIBarButtonItem *)btn {
    
    if (self.loadingType == LoadingKeyType_Checkins) {
        NSArray *viewcontrollers = self.navigationController.viewControllers;
        for (QHPayBaseViewController *vc in viewcontrollers) {
            if ([vc isMemberOfClass:[QHHomeViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
                break;
            }
        }
    }else if (self.loadingType == LoadingKeyType_Pay) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (self.loadingType == LoadingKeyType_Initization) {
        QHHomeViewController *homeVC = [[QHHomeViewController alloc] initWithNibName:@"QHHomeViewController" bundle:nil];
        [self.navigationController pushViewController:homeVC animated:YES];
        QHLoginController *qLogin = [[QHLoginController alloc] initWithNibName:@"QHLoginController" bundle:nil];
        self.navigationController.viewControllers = [NSArray arrayWithObjects:qLogin,homeVC,nil];
    }
}

- (void)buildUI{
//    [self.bondDeviceTV setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithIcon:nil highlightedIcon:nil target:self action:@selector(goBack:) barButtonItemType:BarButtonItemTypePopToView];
    
    [self.bondDeviceTV registerNib:[YRBondCell nib] forCellReuseIdentifier:Identifier];
    
    [self.confirmBtn.layer setCornerRadius:5.0];
}

- (void)reciveDeviceRelativeAndSerialNO{
    if(self.loadingType == LoadingKeyType_Initization){
        [self sendOut9006];
    }else if (self.loadingType == LoadingKeyType_Checkins || self.loadingType == LoadingKeyType_Pay){
        YRDeviceRelative * deviceRelative = [YRDeviceRelative shareDeviceRelative];
        NSString *paraDeviceId = deviceRelative.posDeviceId.length > 0 ? deviceRelative.posDeviceId : @"";
        NSString *paraPosId = deviceRelative.posId.length > 0 ? deviceRelative.posId : @"";
        [YRRequestTool getPosSequenceWithPOSDEVID:paraDeviceId POSID:paraPosId success:^(id responseObject) {//判断设备是否已经存入以下这4个值，deviceRelative.posDeviceId是从设备中取的
            if (deviceRelative.posDeviceId == nil || [deviceRelative.posDeviceId isEqualToString:@""] || deviceRelative.posId == nil || [deviceRelative.posId isEqualToString:@""]) {
                NSString *fillCode = responseObject[@"FILLCODE"];
                NSString *posDevId = responseObject[@"POSDEVID"];
                NSString *posId    = responseObject[@"POSID"];
                NSString *merName  = responseObject[@"MERNAME"];
                if (fillCode && fillCode.length > 0 && posDevId && posDevId.length > 0 && posId && posId.length > 0 && merName && merName.length > 0) {
                    NSDictionary * parameter = @{
                                                 YR_DEVICE_RELATIVE_FILLCODE : fillCode,
                                                 YR_DEVICE_RELATIVE_POSDEVICE: posDevId,
                                                 YR_DEVICE_RELATIVE_POSID : posId,
                                                 YR_DEVICE_RELATIVE_MERNAME : merName
                                                 };
                    [deviceRelative saveSNMessage:parameter
                                     successBlock:^(BOOL isSuccessed) {
                                         deviceRelative.fillCode = fillCode;
                                         deviceRelative.posDeviceId = posDevId;
                                         deviceRelative.posId = posId;
                                         deviceRelative.merName = merName;
                                         [self judgeSecretKeysInstall:responseObject];
                                     } failureBlock:^(NSString *errorInfo) {
                                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"设备无法写入参数" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                                         [alert show];
                                     }];
                }
                else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"参数不全,请重新灌装！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                    [alert show];
                }
            }
            else {
                [self judgeSecretKeysInstall:responseObject];
            }
        } failure:^(NSString *errInfo){
            self.bondDeviceTV.userInteractionEnabled = YES;
            [YRFunctionTools setAlertViewWithTitle:@"网络请求错误" buttonTitle:TIPS_CONFIRM];
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 24;
    }else
        return 12;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 12;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    
    YRBondCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if (cell == nil) {
        cell = [[YRBondCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:Identifier];
    }
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"主密钥下装";
            if (self.posSequenceType == PosSequenceType9007 || self.posSequenceType == PosSequenceType9008 || self.posSequenceType == PosSequenceType9009) {
                cell.displayLabel.textColor = kColor(44, 141, 220);
                cell.displayLabel.text = @"完成";
            }
            if (self.index == 11) {
                cell.displayLabel.text = @"进行中";
                cell.displayLabel.textColor = kColor(44, 141, 220);
            }
            if (self.completeIndex == 12){
                cell.displayLabel.text = @"完成";
            }
            if (self.failedIndex == 13) {
                cell.displayLabel.text = @"失败";
            }
        }else if (indexPath.row == 1){
            cell.titleLabel.text = @"主密钥下装确认";
            if (self.posSequenceType == PosSequenceType9008 || self.posSequenceType == PosSequenceType9009) {
                cell.displayLabel.textColor = kColor(44, 141, 220);
                cell.displayLabel.text = @"完成";
            }
            if (self.index == 21) {
                cell.displayLabel.text = @"进行中";
                cell.displayLabel.textColor = kColor(44, 141, 220);
            }
            if (self.completeIndex == 22){
                cell.displayLabel.text = @"完成";
            }
            if (self.failedIndex == 23) {
                cell.displayLabel.text = @"失败";
            }
        }else if (indexPath.row == 2){
            cell.titleLabel.text = @"终端绑定";
            if (self.posSequenceType == PosSequenceType9009) {
                cell.displayLabel.textColor = kColor(44, 141, 220);
                cell.displayLabel.text = @"完成";
            }
            if (self.index == 31) {
                cell.displayLabel.text = @"进行中";
                cell.displayLabel.textColor = kColor(44, 141, 220);
            }
            if (self.completeIndex == 32){
                cell.displayLabel.text = @"完成";
            }
            if (self.failedIndex == 33) {
                cell.displayLabel.text = @"失败";
            }
        }
    }else {
        
        if (indexPath.row == 0){
            cell.titleLabel.text = @"工作密钥下装";
            if (self.index == 41) {
                cell.displayLabel.text = @"进行中";
                cell.displayLabel.textColor = kColor(44, 141, 220);
            }
            if (self.completeIndex == 42){
                cell.displayLabel.text = @"完成";
            }
            if (self.failedIndex == 43) {
                cell.displayLabel.text = @"失败";
            }
        }else if (indexPath.row == 1){
            cell.titleLabel.text = @"公钥下载";
            if (self.index == 51) {
                cell.displayLabel.text = @"进行中";
                cell.displayLabel.textColor = kColor(44, 141, 220);
            }
            if (self.completeIndex == 52){
                cell.displayLabel.text = @"完成";
            }
            if (self.failedIndex == 53) {
                cell.displayLabel.text = @"失败";
            }
        }else{
            cell.titleLabel.text = @"参数下载";
            if (self.index == 61) {
                cell.displayLabel.text = @"进行中";
                cell.displayLabel.textColor = kColor(44, 141, 220);
            }
            if (self.completeIndex == 62){
                cell.displayLabel.text = @"完成";
            }
            if (self.failedIndex == 63) {
                cell.displayLabel.text = @"失败";
            }
        }
    }
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [self sendOut9006];
                break;
            case 1:
                [self sendOut9007];
                break;
            case 2:
                [self sendOut9008];
                break;
                
            default:
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:
                [self sendOut9009];
                break;
            case 1:
                [self sendOut9015];
                break;
            case 2:
                [self sendOut9016];
                break;
                
            default:
                break;
        }

    }
}

#pragma mark - 判断密钥灌装
- (void)judgeSecretKeysInstall:(NSDictionary *)responseObject {
    //判断密钥灌装情况
    NSString * posSequence = responseObject[@"PR"];
    
    if ([posSequence isEqualToString:@"9006"]) {
        [self sendOut9006];
        self.posSequenceType = PosSequenceType9006;
    }else if ([posSequence isEqualToString:@"9007"]){
        _install9006Complete = YES;
        [self sendOut9007];
        self.posSequenceType = PosSequenceType9007;
    }else if ([posSequence isEqualToString:@"9008"]){
        _install9006Complete = YES;
        _install9007Complete = YES;
        [self sendOut9008];
        self.posSequenceType = PosSequenceType9008;
    }else if ([posSequence isEqualToString:@"9009"]){
        _install9006Complete = YES;
        _install9007Complete = YES;
        _install9008complete = YES;
        [self sendOut9009];
        self.posSequenceType = PosSequenceType9009;
    }
}

- (void)sendOut9006{
    self.index = 11;
    [self.bondDeviceTV reloadData];
    [YRTransactionTool requestFor9006success:^(id responseObject) {
        YRMainKey * mainKey = responseObject[YR_OUTPUT_KEY_DATA];
        
        if ([mainKey.RESP isEqualToString:YR_STATIC_SUCCESS_STATES_CODE]) {
            //拼接主密钥
            NSString * MKEY = [YRRequestDeviceTool appendKey:mainKey.MAINKEY KVC:mainKey.KVC];

            //导入主密钥
            [YRRequestDeviceTool loadKey:MKEY keyType:KEYTYPE_MKEY success:^{
                self.completeIndex = 12;
                [self.bondDeviceTV reloadData];
                _install9006Complete = YES;
                [self sendOut9007];
            } failure:^(NSString *errInfo) {
                self.failedIndex = 13;
                [self.bondDeviceTV reloadData];
                self.bondDeviceTV.userInteractionEnabled = YES;
                if(self.loadingType == LoadingKeyType_Initization) {//新用户注册补全信息后灌装密钥需要代理
                    [[[UIAlertView alloc] initWithTitle:@"密钥导入失败" message:nil delegate:self cancelButtonTitle:TIPS_CONFIRM otherButtonTitles: nil] show];
                }
                else {
                    [YRFunctionTools showAlertViewTitle:nil message:errInfo cancelButton:TIPS_CONFIRM];
                }
            }];
        }else{
            self.failedIndex = 13;
            [self.bondDeviceTV reloadData];
            self.bondDeviceTV.userInteractionEnabled = YES;
            if(self.loadingType == LoadingKeyType_Initization) {
                [[[UIAlertView alloc] initWithTitle:@"密钥灌装请求失败" message:nil delegate:self cancelButtonTitle:TIPS_CONFIRM otherButtonTitles: nil] show];
            }
            else {
                [YRFunctionTools showAlertViewTitle:@"密钥灌装请求失败" message:@"请点击相应面板进行重试或拨打客服电话" cancelButton:nil];
            }
        }
        
    } failure:^(NSString * errInfo) {
        self.failedIndex = 13;
        [self.bondDeviceTV reloadData];
        self.bondDeviceTV.userInteractionEnabled = YES;
        [YRFunctionTools showAlertViewTitle:@"密钥灌装请求失败" message:@"请点击相应面板进行重试或拨打客服电话" cancelButton:nil];
        
    }];
}

- (void)sendOut9007{
    self.index = 21;
    [self.bondDeviceTV reloadData];
    [YRTransactionTool requestFor9007success:^(id responseObject) {

        NSString * resp = responseObject[YR_OUTPUT_KEY_STATES_RESP_CODE];
        if ([resp isEqualToString:YR_STATIC_SUCCESS_STATES_CODE]) {
            self.completeIndex = 22;
            [self.bondDeviceTV reloadData];
            _install9007Complete = YES;
            [self sendOut9008];
        }else{
            self.failedIndex = 23;
            [self.bondDeviceTV reloadData];
            self.bondDeviceTV.userInteractionEnabled = YES;
            if(self.loadingType == LoadingKeyType_Initization) {
                [[[UIAlertView alloc] initWithTitle:@"密钥灌装成功通知失败" message:nil delegate:self cancelButtonTitle:TIPS_CONFIRM otherButtonTitles: nil] show];
            }
            else {
                [YRFunctionTools showAlertViewTitle:@"密钥灌装成功通知失败" message:@"请点击相应面板进行重试或拨打客服电话" cancelButton:nil];
            }
        }
        
    } failure:^(NSString * errInfo) {
        self.failedIndex = 23;
        [self.bondDeviceTV reloadData];
        self.bondDeviceTV.userInteractionEnabled = YES;
        if(self.loadingType == LoadingKeyType_Initization) {
            [[[UIAlertView alloc] initWithTitle:@"密钥灌装成功通知失败" message:nil delegate:self cancelButtonTitle:TIPS_CONFIRM otherButtonTitles: nil] show];
        }
        else {
            [YRFunctionTools showAlertViewTitle:@"密钥灌装成功通知失败" message:@"请点击相应面板进行重试或拨打客服电话" cancelButton:nil];
        }
    }];
}

- (void)sendOut9008{
    self.index = 31;
    [self.bondDeviceTV reloadData];
    [YRTransactionTool requestFor9008success:^(id responseObject) {

        NSString * resp = responseObject[YR_OUTPUT_KEY_STATES_RESP_CODE];
        if ([resp isEqualToString:YR_STATIC_SUCCESS_STATES_CODE]) {
            self.completeIndex = 32;
            [self.bondDeviceTV reloadData];
            _install9008complete = YES;
            [self sendOut9009];
        }else{
            self.failedIndex = 33;
            [self.bondDeviceTV reloadData];
            self.bondDeviceTV.userInteractionEnabled = YES;
            if(self.loadingType == LoadingKeyType_Initization) {
                [[[UIAlertView alloc] initWithTitle:@"终端绑定失败" message:nil delegate:self cancelButtonTitle:TIPS_CONFIRM otherButtonTitles: nil] show];
            }
            else {
                [YRFunctionTools showAlertViewTitle:@"终端绑定失败" message:@"请点击相应面板进行重试或拨打客服电话" cancelButton:nil];
            }
        }
        
    } failure:^(NSString * errInfo) {
        self.failedIndex = 33;
        [self.bondDeviceTV reloadData];
        self.bondDeviceTV.userInteractionEnabled = YES;
        if(self.loadingType == LoadingKeyType_Initization) {
            [[[UIAlertView alloc] initWithTitle:@"终端绑定失败" message:nil delegate:self cancelButtonTitle:TIPS_CONFIRM otherButtonTitles: nil] show];
        }
        else {
            [YRFunctionTools showAlertViewTitle:@"终端绑定失败" message:@"请点击相应面板进行重试或拨打客服电话" cancelButton:nil];
        }
    }];
}

- (void)sendOut9009{
    self.index = 41;
    [self.bondDeviceTV reloadData];
    [YRTransactionTool requestFor9009success:^(id responseObject) {
        YRWorkKey * workKey = responseObject[YR_OUTPUT_KEY_DATA];
        if ([workKey.RESP isEqualToString:YR_STATIC_SUCCESS_STATES_CODE]) {
            //拼接pin密钥
            NSString * pinKey = [YRRequestDeviceTool appendKey:workKey.PINKEY KVC:workKey.PINKVC];
            //拼接pack密钥
            NSString * packKey = [YRRequestDeviceTool appendKey:workKey.PACKKEY KVC:workKey.PACKKVC];
            //拼接mac密钥
            NSString * macKey = [YRRequestDeviceTool appendKey:workKey.MACKEY KVC:workKey.MACKVC];
            
            //导入pin密钥
            [YRRequestDeviceTool loadKey:pinKey keyType:KEYTYPE_PIN success:^{
                //导入pack密钥
                [YRRequestDeviceTool loadKey:packKey keyType:KEYTYPE_TRACK success:^{
                    //导入mac密钥
                    [YRRequestDeviceTool loadKey:macKey keyType:KEYTYPE_MAC success:^{
                        NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
                        [ud setBool:YES forKey:IS_COMPLETE_9009];
                        self.completeIndex = 42;
                        [self.bondDeviceTV reloadData];
                        _install9009complete = YES;
                        [self sendOut9015];
                    } failure:^(NSString *errInfo) {
                        self.failedIndex = 43;
                        [self.bondDeviceTV reloadData];
                        self.bondDeviceTV.userInteractionEnabled = YES;
                        if(self.loadingType == LoadingKeyType_Initization) {
                            [[[UIAlertView alloc] initWithTitle:@"签到失败" message:nil delegate:self cancelButtonTitle:TIPS_CONFIRM otherButtonTitles: nil] show];
                        }
                        else {
                            [YRFunctionTools showAlertViewTitle:@"签到失败" message:@"请点击相应面板进行重试或拨打客服电话" cancelButton:nil];
                        }
                    }];
                } failure:^(NSString *errInfo) {
                    self.failedIndex = 43;
                    [self.bondDeviceTV reloadData];
                    self.bondDeviceTV.userInteractionEnabled = YES;
                    if(self.loadingType == LoadingKeyType_Initization) {
                        [[[UIAlertView alloc] initWithTitle:@"签到失败" message:nil delegate:self cancelButtonTitle:TIPS_CONFIRM otherButtonTitles: nil] show];
                    }
                    else {
                        [YRFunctionTools showAlertViewTitle:@"签到失败" message:@"请点击相应面板进行重试或拨打客服电话" cancelButton:nil];
                    }
                }];
            } failure:^(NSString *errInfo) {
                self.failedIndex = 43;
                [self.bondDeviceTV reloadData];
                self.bondDeviceTV.userInteractionEnabled = YES;
                if(self.loadingType == LoadingKeyType_Initization) {
                    [[[UIAlertView alloc] initWithTitle:@"签到失败" message:nil delegate:self cancelButtonTitle:TIPS_CONFIRM otherButtonTitles: nil] show];
                }
                else {
                    [YRFunctionTools showAlertViewTitle:@"签到失败" message:@"请点击相应面板进行重试或拨打客服电话" cancelButton:nil];
                }
            }];
            
        }else{
            self.failedIndex = 43;
            [self.bondDeviceTV reloadData];
            self.bondDeviceTV.userInteractionEnabled = YES;
            if(self.loadingType == LoadingKeyType_Initization) {
                [[[UIAlertView alloc] initWithTitle:@"签到失败" message:nil delegate:self cancelButtonTitle:TIPS_CONFIRM otherButtonTitles: nil] show];
            }
            else {
                [YRFunctionTools showAlertViewTitle:@"签到失败" message:@"请点击相应面板进行重试或拨打客服电话" cancelButton:nil];
            }
        }
       
    } failure:^(NSString * errInfo) {
        self.failedIndex = 43;
        [self.bondDeviceTV reloadData];
        self.bondDeviceTV.userInteractionEnabled = YES;
        if(self.loadingType == LoadingKeyType_Initization) {
            [[[UIAlertView alloc] initWithTitle:@"签到失败" message:nil delegate:self cancelButtonTitle:TIPS_CONFIRM otherButtonTitles: nil] show];
        }
        else {
            [YRFunctionTools showAlertViewTitle:@"签到失败" message:@"请点击相应面板进行重试或拨打客服电话" cancelButton:nil];
        }

    }];
}

- (void)sendOut9015{
    self.index = 51;
    [self.bondDeviceTV reloadData];
    [YRTransactionTool requestFor9015WithINXNum:1 success:^(id responseObject) {

       YRICPublicKey * ICPublicKey = responseObject[YR_OUTPUT_KEY_DATA];
        if ([ICPublicKey.RESP isEqualToString:YR_STATIC_SUCCESS_STATES_CODE]) {
            self.completeIndex = 52;
            [self.bondDeviceTV reloadData];
            _install9015complete = YES;
            [self sendOut9016];
        }else{
            self.failedIndex = 53;
            [self.bondDeviceTV reloadData];
            self.bondDeviceTV.userInteractionEnabled = YES;
            if(self.loadingType == LoadingKeyType_Initization) {
                [[[UIAlertView alloc] initWithTitle:@"公钥下载失败" message:nil delegate:self cancelButtonTitle:TIPS_CONFIRM otherButtonTitles: nil] show];
            }
            else {
                [YRFunctionTools showAlertViewTitle:@"公钥下载失败" message:@"请点击相应面板进行重试或拨打客服电话" cancelButton:nil];
            }
        }
    } failure:^(NSString * errInfo) {
        self.failedIndex = 53;
        [self.bondDeviceTV reloadData];
        self.bondDeviceTV.userInteractionEnabled = YES;
        if(self.loadingType == LoadingKeyType_Initization) {
            [[[UIAlertView alloc] initWithTitle:@"公钥下载失败" message:nil delegate:self cancelButtonTitle:TIPS_CONFIRM otherButtonTitles: nil] show];
        }
        else {
            [YRFunctionTools showAlertViewTitle:@"公钥下载失败" message:@"请点击相应面板进行重试或拨打客服电话" cancelButton:nil];
        }
    }];
}

- (void)sendOut9016{
    self.index = 61;
    [self.bondDeviceTV reloadData];
    [YRTransactionTool requestFor9016WithINXNum:1 success:^(id responseObject) {

        YRICParameter * ICParameter = responseObject[YR_OUTPUT_KEY_DATA];
        if ([ICParameter.RESP isEqualToString:YR_STATIC_SUCCESS_STATES_CODE]) {
            self.completeIndex = 62;
            [self.bondDeviceTV reloadData];
            self.bondDeviceTV.userInteractionEnabled = YES;
            _install9016complete = YES;
            [[[UIAlertView alloc] initWithTitle:@"灌装成功" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"完成", nil] show];
            [self judgeAllSecretKeysInstallCompleted];
        }else{
            self.failedIndex = 63;
            [self.bondDeviceTV reloadData];
            self.bondDeviceTV.userInteractionEnabled = YES;
            if(self.loadingType == LoadingKeyType_Initization) {
                [[[UIAlertView alloc] initWithTitle:@"参数下载失败" message:nil delegate:self cancelButtonTitle:TIPS_CONFIRM otherButtonTitles: nil] show];
            }
            else {
                [YRFunctionTools showAlertViewTitle:@"参数下载失败" message:@"请点击相应面板进行重试或拨打客服电话" cancelButton:nil];
            }
        }
    } failure:^(NSString * errInfo) {
        self.failedIndex = 63;
        [self.bondDeviceTV reloadData];
        self.bondDeviceTV.userInteractionEnabled = YES;
        if(self.loadingType == LoadingKeyType_Initization) {
            [[[UIAlertView alloc] initWithTitle:@"参数下载失败" message:nil delegate:self cancelButtonTitle:TIPS_CONFIRM otherButtonTitles: nil] show];
        }
        else {
            [YRFunctionTools showAlertViewTitle:@"参数下载失败" message:@"请点击相应面板进行重试或拨打客服电话" cancelButton:nil];
        }
    }];
}

- (void)judgeAllSecretKeysInstallCompleted {
    if (_install9006Complete && _install9007Complete && _install9008complete && _install9009complete && _install9015complete && _install9016complete) {
        NSString *deviceName = [SFHFKeychainManager loadValueForKey:[NSString stringWithFormat:@"%@%@",[YRLoginManager shareLoginManager].busrID,[YRLoginManager shareLoginManager].busrID]];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:deviceName];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        if (self.loadingType == LoadingKeyType_Pay || self.loadingType == LoadingKeyType_Checkins) {
            [self.navigationController popViewControllerAnimated:YES];
        }else if (self.loadingType == LoadingKeyType_Initization){
            QHHomeViewController *homeVC = [[QHHomeViewController alloc] initWithNibName:@"QHHomeViewController" bundle:nil];
            [self.navigationController pushViewController:homeVC animated:YES];
            QHLoginController *qLogin = [[QHLoginController alloc] initWithNibName:@"QHLoginController" bundle:nil];
            self.navigationController.viewControllers = [NSArray arrayWithObjects:qLogin,homeVC,nil];
        }

    }
}


@end
