//
//  YROpenAccountController.m
//  YunRichMPCR
//
//  Created by YunRich on 15/3/25.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "YROpenAccountViewController.h"
#import "YRMerchantInfoViewController.h"
#import "YRVerifyRegexTool.h"
#import "ZHPickView.h"
#import "YRUserProfileRequest.h"
#import "MBProgressHUD+MJ.h"
#import "YRRequestTool.h"
#import "YRDeviceRelative.h"
#import "YRLoginManager.h"
#import "TouchScrollView.h"


@interface YROpenAccountViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZHPickViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *downBGView;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageviews;

@end

@implementation YROpenAccountViewController {
    ZHPickView * pickerView ;
    __weak IBOutlet TouchScrollView *_scrollView;
    
    __weak IBOutlet UITextField *_usernameTextField;
    __weak IBOutlet UITextField *_idCardNumTextField;
    __weak IBOutlet UITextField *_merchantNameTextField;
    __weak IBOutlet UITextField *_payAccountTextField;
    
    __weak IBOutlet UIView *_idCardFrontView;
    __weak IBOutlet UIView *_idCardBackView;
    __weak IBOutlet UIView *_personalPhotoView;
    __weak IBOutlet UIView *_bankCardPhotoView;
    
    __weak IBOutlet UIButton *_idCardFrontBtn;
    __weak IBOutlet UIButton *_idCardBackBtn;
    __weak IBOutlet UIButton *_personalPhotoBtn;
    __weak IBOutlet UIButton *_bankCardPhotoBtn;
    __weak IBOutlet UIButton *_nextStepBtn;
    __weak IBOutlet UIButton *_selectCityBtn;
    NSInteger _selecteBtnTag;
    YRUserProfileRequest * _profileRequest;
    NSArray * _allAreas;
    NSString * _proviceCode;
    NSString * _cityCode;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _nextStepBtn.layer.cornerRadius = 5;
    [_selectCityBtn setTitleColor:[UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1] forState:UIControlStateNormal];
    [self.navigationItem setHidesBackButton:YES];
    [self judgeStaticDataIsNeedUpdate];
    
}

- (void)goBackToSuperView {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"商户开通";
}

- (void)viewDidLayoutSubviews{
    for (UIImageView *imageview in self.imageviews) {
        [self.view sendSubviewToBack:imageview];
    }
    self.downBGView.layer.contents = (id)[UIImage imageNamed:@"qh_rootbg"].CGImage;
}

- (void)setTitleLabelCornerRadius:(UILabel *)label {
    
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 3;
}


- (IBAction)checkIDCardNumber:(UITextField *)sender {
    
    if(![YRVerifyRegexTool verifyIDCardNumber:sender.text]) {
        
        [YRFunctionTools showAlertViewTitle:nil
                                    message:@"身份证输入有误，请重新输入！"
                               cancelButton:TIPS_CONFIRM];
    }
}

- (IBAction)takePhotoes:(UIButton *)sender {
    
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
        //pickerC.allowsEditing = YES;
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
            
        case 1: // 身份证照片
        {
            [_idCardFrontBtn setBackgroundImage:image forState:UIControlStateNormal];
        }
            break;
        case 2: // 身份证背面
        {
            [_idCardBackBtn setBackgroundImage:image forState:UIControlStateNormal];
        }
            break;
        case 3: // 个人照片
        {
            [_personalPhotoBtn setBackgroundImage:image forState:UIControlStateNormal];
        }
            break;
        case 4: // 银行卡照片
        {
            [_bankCardPhotoBtn setBackgroundImage:image forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 收起键盘
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [_usernameTextField resignFirstResponder];
    [_idCardNumTextField resignFirstResponder];
    [_merchantNameTextField resignFirstResponder];
    [_payAccountTextField resignFirstResponder];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [_usernameTextField resignFirstResponder];
    [_idCardNumTextField resignFirstResponder];
    [_merchantNameTextField resignFirstResponder];
    [_payAccountTextField resignFirstResponder];
}

- (BOOL)checkTextIsNotEmpty:(NSString *)text {
    
    if ([text isEqualToString:@""] || [text isKindOfClass:[NSNull class]]) {
        return NO;
    }
    return YES;
}

- (NSString *)clearSpace:(NSString *)text {
    
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    return text;
}

- (IBAction)nextStep:(id)sender {
    if (_idCardFrontBtn.currentBackgroundImage &&
        _idCardBackBtn.currentBackgroundImage &&
        _personalPhotoBtn.currentBackgroundImage &&
        _bankCardPhotoBtn.currentBackgroundImage) {
        for (UIImageView *imageview in self.imageviews) {
            [imageview removeFromSuperview];
        }
    }
    
    NSString * username = _usernameTextField.text;
    NSString * merchantName = _merchantNameTextField.text;
    NSString * payAccount = _payAccountTextField.text;
    username = [self clearSpace:username];
    merchantName = [self clearSpace:merchantName];
    payAccount = [self clearSpace:payAccount];
    NSString *a;
    NSString *b;
    a = _cityCode;
    b = _proviceCode;
    NSString * posNum = [YRLoginManager shareLoginManager].productSN;
    if ([self checkTextIsNotEmpty:username] &&
        [self checkTextIsNotEmpty:merchantName] &&
        [self checkTextIsNotEmpty:payAccount] && _proviceCode && _cityCode && posNum) {
        if (_idCardFrontBtn.currentBackgroundImage &&
            _idCardBackBtn.currentBackgroundImage &&
            _personalPhotoBtn.currentBackgroundImage &&
            _bankCardPhotoBtn.currentBackgroundImage) {
            self.view.userInteractionEnabled = NO;
            [YRLoginManager shareLoginManager].storeName = _merchantNameTextField.text;
            
            [YRLoginManager shareLoginManager].username = _usernameTextField.text;
            [MBProgressHUD showMessage:@"请求发送中..."];
            [YRRequestTool finishOpenAccountWithFactory:[YRLoginManager shareLoginManager].factoryName
                                              machineNo:posNum
                                                mername:_merchantNameTextField.text
                                                 certID:_idCardNumTextField.text
                                       certPicProsImage:_idCardFrontBtn.currentBackgroundImage
                                       certPicConsImage:_idCardBackBtn.currentBackgroundImage
                                          perPhotoImage:_personalPhotoBtn.currentBackgroundImage
                                               cardName:_usernameTextField.text
                                                cardNum:_payAccountTextField.text
                                             taxRegCode:nil
                                       taxRegPhotoImage:nil
                                            busiRegCode:nil
                                           busiRegPhoto:nil
                                              instuCode:nil
                                        instuPhotoImage:nil
                                                 provId:_proviceCode
                                                 areaId:_cityCode
                                               busiAddr:nil successBlock:^(id responseObject)
            {
                [MBProgressHUD hideHUD];
                self.view.userInteractionEnabled = YES;
                if (responseObject && [responseObject[YR_OUTPUT_KEY_STATES_RESP_CODE] isEqualToString:YR_STATIC_SUCCESS_STATES_CODE]) {
                    
                    NSDictionary * parameter = @{
                                                 YR_DEVICE_RELATIVE_FILLCODE : responseObject[@"FILLCODE"],
                                                 YR_DEVICE_RELATIVE_POSDEVICE: responseObject[@"POSDEVID"],
                                                 YR_DEVICE_RELATIVE_POSID : responseObject[@"POSID"],
                                                 YR_DEVICE_RELATIVE_MERNAME : responseObject[@"MERNAME"]
                                                 };
                    [[YRDeviceRelative shareDeviceRelative] saveSNMessage:parameter successBlock:^(BOOL isSuccessed) {
                        //
                        [[YRDeviceRelative shareDeviceRelative] getSNMessageSuccessBlock:^(NSDictionary *dict)
                         {
                             // 保存 店铺名 到本地
                             NSString * fillCode = [[YRDeviceRelative shareDeviceRelative] fillCode];
                             NSString * merchantKey = [NSString stringWithFormat:@"%@%@",[[YRLoginManager shareLoginManager] username],fillCode];
                             [[NSUserDefaults standardUserDefaults] setObject:_merchantNameTextField.text forKey:merchantKey];
                             [[NSUserDefaults standardUserDefaults] synchronize];
                             YRMerchantInfoViewController * merchantInfo = [YRMerchantInfoViewController new];
                             merchantInfo.funcationType = FuncationType_OpenAccount;
                             [self.navigationController pushViewController:merchantInfo animated:YES];
                             [[[UIAlertView alloc] initWithTitle:@"开通成功" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定" ,nil] show];
                             
                         } failureBlock:^(NSString *errorInfo) {
                             //
                             [YRFunctionTools showAlertViewTitle:@"数据获取失败" message:errorInfo cancelButton:TIPS_CONFIRM];
                         }];
                        
                    } failureBlock:^(NSString *errorInfo) {
                        [YRFunctionTools showAlertViewTitle:@"数据存储失败" message:errorInfo cancelButton:TIPS_CONFIRM];
                    }];
                }else {
                    
                    [YRFunctionTools showAlertViewTitle:nil message:[NSString stringWithFormat:@"[%@]%@",responseObject[YR_OUTPUT_KEY_STATES_RESP_DESC],responseObject[YR_OUTPUT_KEY_STATES_RESP_CODE]]cancelButton:TIPS_CONFIRM];
                }
                
            } failureBlock:^(NSString *errInfo) {
                self.view.userInteractionEnabled = YES;
                [MBProgressHUD hideHUD];
                [YRFunctionTools showAlertViewTitle:nil message:TIPS_MESSAGES cancelButton:TIPS_CONFIRM];
            }];
            
        }else {
            
            [[[UIAlertView alloc] initWithTitle:nil
                                        message:@"图片不能为空，请继续拍摄相关照片！"
                                       delegate:self
                              cancelButtonTitle:TIPS_CONFIRM
                              otherButtonTitles:nil, nil] show];
        }
    }else {
        
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"内容不能为空或含有特殊字符"
                                   delegate:self
                          cancelButtonTitle:TIPS_CONFIRM
                          otherButtonTitles:nil, nil] show];
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
            //[self areaJsonDataConvertIntoPlistFormat:responseObject[@"PROVAREALIST"]];
        }
        
    } failureBlock:^(NSString *errInfo) {
        
        [MBProgressHUD hideHUD];
        [YRFunctionTools showAlertViewTitle:nil message:TIPS_MESSAGES cancelButton:TIPS_CONFIRM];
    }];
}
#pragma mark -- 把数据转换成plist文件
- (void)areaJsonDataConvertIntoPlistFormat:(NSArray *)areaList {
    
    // 拿到所有的省市
    NSMutableDictionary * provencesDict = [NSMutableDictionary new];
    
    for (NSDictionary * area in areaList) {
        
        [provencesDict setObject:area[@"PROVNAME"] forKey:area[@"PROVID"]];
    }
    
    NSArray * allProvences = [provencesDict allKeys];
    
    NSMutableDictionary * allCities = [NSMutableDictionary new];
    
    for (NSString * key in allProvences) {
        
        NSMutableArray * cites = [NSMutableArray new];
        for (NSDictionary * area in areaList) {
            
            if ([key isEqualToString:area[@"PROVID"]]) {
                
                [cites addObject:area[@"AREANAME"]];
            }
        }
        [allCities setObject:cites forKey:provencesDict[key]];
    }
}

- (IBAction)selectCity:(UIButton *)sender {
    
    CGRect frame = self.view.bounds;
    frame.origin.y = 80;
    [_scrollView setContentOffset:CGPointMake(0, 80) animated:YES];
    
    [_usernameTextField resignFirstResponder];
    [_idCardNumTextField resignFirstResponder];
    [_merchantNameTextField resignFirstResponder];
    [_payAccountTextField resignFirstResponder];
    
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    path = [path stringByAppendingPathComponent:@"area.plist"];
    BOOL isDirectory;
    if(![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory]) {
        
        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    }
    pickerView = [[ZHPickView alloc] initPickviewWithPlistName:@"city" isHaveNavControler:NO];
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
    [_selectCityBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_selectCityBtn setTitle:title forState:UIControlStateNormal];
    [self searchCityCodeWithProviceName:provice cityName:city];
}
// 判断店铺名的长度
- (IBAction)judgeStoreNameLength:(UITextField *)sender {
    
    if (sender.text.length > 20) {
       sender.text = [sender.text substringToIndex:20];
       
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if (_profileRequest) {
        
        [_profileRequest cancel];
    }
}
#pragma mark 判断textField输入框字数是否超限
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (_idCardNumTextField == textField) {
        if (toBeString.length > 18) {
            [YRFunctionTools showAlertViewTitle:nil message:@"输入信息过长" cancelButton:TIPS_CONFIRM];
            return NO;
        }
    }
    return YES;
}

@end
