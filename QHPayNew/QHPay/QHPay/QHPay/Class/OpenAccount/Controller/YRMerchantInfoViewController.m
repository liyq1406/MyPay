//
//  YRMerchantInfoViewController.m
//  YunRichMPCR
//
//  Created by YunRich on 15/5/11.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//



#import <AVFoundation/AVFoundation.h>
#import "YRMerchantInfoViewController.h"
#import "YRRequestTool.h"
#import "YRLoginManager.h"
#import "YRDeviceRelative.h"
#import "LandiMPOS.h"
#import "MBProgressHUD+MJ.h"
#import "YRBondDeviceController.h"
#import "YRUserProfileRequest.h"
#import "ZHPickView.h"
#import "QHHomeViewController.h"
#import "QHLoginController.h"

@interface YRMerchantInfoViewController ()<UIScrollViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,ZHPickViewDelegate>
@property (weak, nonatomic) IBOutlet TouchScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation YRMerchantInfoViewController  {
    
    __weak IBOutlet UITextField *_taxRegisterNumTextField;
    __weak IBOutlet UITextField *_runCertificateTextField;
    __weak IBOutlet UITextField *_storeAddressTextField;
    
    __weak IBOutlet UITextField *_showProvienceAreaTextField;
    __weak IBOutlet UIButton *_businessLicenseBtn;
    __weak IBOutlet UIButton *_storeAddressBtn;
    
    __weak IBOutlet UIButton *_nextStepBtn;
    
    NSInteger _selecteBtnTag;
    __weak IBOutlet UIButton *_selectAreaBtn;
    NSArray * _allAreas;
    NSString * _proviceCode;
    NSString * _cityCode;
    YRUserProfileRequest * _profileRequest;
}


- (void)viewDidLayoutSubviews{
    self.mainScrollView.contentSize = CGSizeMake(0, 568);
    self.mainScrollView.bounces = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _nextStepBtn.layer.cornerRadius = 5;
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 24, 24)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"ic_g_return"] forState:UIControlStateNormal];
    
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    if (self.funcationType == FuncationType_OpenAccount) {
        
        UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setFrame:CGRectMake(0, 0, 35, 35)];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        //[rightBtn setBackgroundImage:[UIImage imageNamed:@"ic_g_return"] forState:UIControlStateNormal];
        [rightBtn setTitle:@"跳过" forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(goNextStep:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:@selector(goBack:)];
        [self.navigationItem.leftBarButtonItem setEnabled:NO];
        
    }
    [self judgeStaticDataIsNeedUpdate];
    //[self.view sendSubviewToBack:self.bgView];
   // self.bgView.layer.contents = (id)[UIImage imageNamed:@"qh_rootbg"].CGImage;
}

- (void)goBack:(id)sender {
    
}

- (void)goBack {
    
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goNextStep:(UIBarButtonItem *)btn {
    QHHomeViewController *qhHomeVC = [[QHHomeViewController alloc] initWithNibName:@"QHHomeViewController" bundle:nil];
    [self.navigationController pushViewController:qhHomeVC animated:YES];
    
    QHLoginController *qLogin = [[QHLoginController alloc] initWithNibName:@"QHLoginController" bundle:nil];
    self.navigationController.viewControllers = [NSArray arrayWithObjects:qLogin,qhHomeVC,nil];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.title = @"补全信息";
}

- (void)setTitleLabelCornerRadius:(UILabel *)label {
    
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 3;
}

- (void)setViewBorderStyle:(UIView *)photoView {
    
    photoView.layer.masksToBounds = YES;
    photoView.layer.borderWidth = 2;
    photoView.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (IBAction)openCarmeraToTakePhotoes:(UIButton *)sender {
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        
        [YRFunctionTools showAlertViewTitle:@"无法打开相机" message:@"请在用户隐私设置中开启相机使用权限" cancelButton:TIPS_CONFIRM];
    }else {
        
        [self openCarmeraTakePhotoes:sender];
    }
}

- (void)openCarmeraTakePhotoes:(UIButton *)sender {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        _selecteBtnTag = sender.tag;
        UIImagePickerController * pickerC = [[UIImagePickerController alloc] init];
        pickerC.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerC.delegate = self;
        [self presentViewController:pickerC animated:YES completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 设置拍照的图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage * image = info[UIImagePickerControllerOriginalImage];
    
    switch (_selecteBtnTag) {
            
        case 1: // 营业执照
        {
            [_businessLicenseBtn setBackgroundImage:image forState:UIControlStateNormal];
        }
            break;
        case 2: // 营业场所
        {
            [_storeAddressBtn setBackgroundImage:image forState:UIControlStateNormal];
        }
            break;
        
        default:
            break;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 收起键盘
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_taxRegisterNumTextField resignFirstResponder];
    [_runCertificateTextField resignFirstResponder];
    [_storeAddressTextField resignFirstResponder];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [_taxRegisterNumTextField resignFirstResponder];
    [_runCertificateTextField resignFirstResponder];
    [_storeAddressTextField resignFirstResponder];
}

- (BOOL)checkTextIsNotEmpty:(NSString *)text {
    
    if ([text isEqualToString:@""] || [text isKindOfClass:[NSNull class]]) {
        return NO;
    }
    return YES;
}


- (IBAction)hidekeyboard:(id)sender {
    
    
}


- (IBAction)confirmAndSendRequest:(id)sender {
    
    if ([self checkTextIsNotEmpty:_taxRegisterNumTextField.text] &&
        [self checkTextIsNotEmpty:_runCertificateTextField.text] &&
        [self checkTextIsNotEmpty:_storeAddressTextField.text] && _proviceCode && _cityCode) {
        
        if (_businessLicenseBtn.currentBackgroundImage && _storeAddressBtn.currentBackgroundImage) {
            
            [MBProgressHUD showMessage:@"请求发送中..."];
            NSString * posId = [[YRDeviceRelative shareDeviceRelative] posId];
            posId = posId ? posId : @"";
            NSDictionary * parameters = @{@"APPLYTYPE":@"MPOS",
                                          @"TAXREGCODE":_taxRegisterNumTextField.text,
                                          @"BUSIREGCODE":_runCertificateTextField.text,
                                          @"BUSIADDR":_storeAddressTextField.text,
                                          @"PROVID":_proviceCode,@"AREAID":_cityCode,
                                          @"POSID":posId};
            
            NSDictionary * imageKes = @{@"BUSIREGPHOTO":_businessLicenseBtn.currentBackgroundImage,@"PLACEPHOTO":_storeAddressBtn.currentBackgroundImage};
            [_profileRequest applyPromoteLimit:parameters imageKeyFiles:imageKes successBlock:^(id responseObject) {
                
                [MBProgressHUD hideHUD];
                if ([responseObject[YR_OUTPUT_KEY_STATES_RESP_CODE] isEqualToString:YR_STATIC_SUCCESS_STATES_CODE]) {
                    
                    if (self.funcationType == FuncationType_ApplyPromote) {
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    }else {
                        
                        YRBondDeviceController * bondDeviceC = [YRBondDeviceController new];
                        bondDeviceC.loadingType = LoadingKeyType_Initization;
                        [self.navigationController pushViewController:bondDeviceC animated:YES];
                    }
                    
                    [[[UIAlertView alloc] initWithTitle:@"提交成功，会在三日之内审核完成" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定" ,nil] show];
                }
            } failureBlock:^(NSString *errInfo) {
                
                [MBProgressHUD hideHUD];
                [YRFunctionTools showAlertViewTitle:nil message:TIPS_MESSAGES cancelButton:TIPS_CONFIRM];
            }];
        }else {
            [YRFunctionTools showAlertViewTitle:nil message:@"图片不能为空" cancelButton:TIPS_CONFIRM];
        }
    }else {
        
        [YRFunctionTools showAlertViewTitle:nil message:@"输入有误，关键数据不能为空" cancelButton:TIPS_CONFIRM];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        
//        YRBondDeviceController * bondDeviceVC = [[YRBondDeviceController alloc] init];
//        bondDeviceVC.loadingType = LoadingKeyType_Initization;
//        [self.navigationController pushViewController:bondDeviceVC animated:YES];
    }
}

#pragma mark -- 判断是非需要更新静态数据
- (void)judgeStaticDataIsNeedUpdate {
    
    if (!_profileRequest) {
        _profileRequest = [[YRUserProfileRequest alloc] init];
    }
    
    [MBProgressHUD showMessage:@"检测数据是否需要更新..."];
    
    NSDictionary * parameters = @{ @"SOFTTYPE" : @"IOS" };
    NSString * areaVersion = [[NSUserDefaults standardUserDefaults] objectForKey:AREA_VERSION];
    [_profileRequest judgeStaticDataIsNeedUpdate:parameters successBlock:^(id responseObject) {
        
        [MBProgressHUD hideHUD];
        if (responseObject && [responseObject[YR_OUTPUT_KEY_STATES_RESP_CODE] isEqualToString:YR_STATIC_SUCCESS_STATES_CODE]) {
            
            if (areaVersion == nil || [responseObject[@"PROVAREAVER"] intValue] > [areaVersion intValue]) {
                
                [self updateStaticCityData:responseObject[@"PROVAREAVER"]];
            }else {
                
                _allAreas = [[NSUserDefaults standardUserDefaults] objectForKey:AREA_KEY];
            }
        }
    } failureBlock:^(NSString *errInfo) {
        //
        [MBProgressHUD hideHUD];
        [YRFunctionTools showAlertViewTitle:nil message:TIPS_MESSAGES cancelButton:TIPS_CONFIRM];
    }];
}

#pragma mark --更新静态省份地区数据
- (void)updateStaticCityData:(NSString *)provAreaVersion {
    
    [[NSUserDefaults standardUserDefaults] setObject:provAreaVersion forKey:AREA_VERSION];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSDictionary * parameters = @{ @"SOFTTYPE" : @"IOS" };
    [MBProgressHUD showMessage:@"正在更新数据..."];
    [_profileRequest updateProviceData:parameters successBlock:^(id responseObject) {
        [MBProgressHUD hideHUD];
        if (responseObject) {
            _allAreas = responseObject[@"PROVAREALIST"];
            [[NSUserDefaults standardUserDefaults] setObject:_allAreas forKey:AREA_KEY];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
    } failureBlock:^(NSString *errInfo) {
        
        [MBProgressHUD hideHUD];
        [YRFunctionTools showAlertViewTitle:nil message:TIPS_MESSAGES cancelButton:TIPS_CONFIRM];
    }];
}

- (IBAction)selectProvienceAndArea:(id)sender {
    
    [_taxRegisterNumTextField resignFirstResponder];
    [_runCertificateTextField resignFirstResponder];
    [_storeAddressTextField resignFirstResponder];
    
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    path = [path stringByAppendingPathComponent:@"area.plist"];
    BOOL isDirectory;
    if(![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory]) {
        
        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    }
    ZHPickView * pickerView = [[ZHPickView alloc] initPickviewWithPlistName:@"city" isHaveNavControler:NO];
    pickerView.delegate = self;
    [pickerView show];
}

#pragma mark --根据省份地区 选择地区代号
- (void)searchCityCodeWithProviceName:(NSString *)provice cityName:(NSString *)city {
    
    for (NSDictionary * dictArea in _allAreas) {
        
        if ([dictArea[@"AREANAME"] isEqualToString:city] && [dictArea[@"PROVNAME"] isEqualToString:provice]) {
            
            _proviceCode = dictArea[@"PROVID"];
            _cityCode = dictArea[@"AREAID"];
        }
    }
}

#pragma mark -- 选择好地区 设置button title
- (void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString {
    NSRange range = [resultString rangeOfString:@"|"];
    NSString * provice = [resultString substringToIndex:range.location];
    NSString * city = [resultString substringFromIndex:range.location+1];
    NSString * title = [NSString stringWithFormat:@"%@  %@",provice,city];
    
    [_showProvienceAreaTextField setText:title];
    
    [self searchCityCodeWithProviceName:provice cityName:city];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if (_profileRequest) {
        
        [_profileRequest cancel];
    }
}

@end
