//
//  YRQuickConllectionController.m
//  YunRichMPCR
//
//  Created by YunRich on 15/3/26.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//  

#import "YRQuickConllectionController.h"
#import "YRSignController.h"
#import "LandiMPOS.h"
#import "YRRequestDeviceTool.h"
#import "YRTransactionRequest.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "AppDelegate.h"
#import "MBProgressHUD+MJ.h"
#import "YRAutoConnectDevice.h"
#import "MBProgressHUD+MJ.h"
#import "YRMainViewController.h"
#import "YRRequestTool.h"
#import "YRDeviceRelative.h"
#import "YRBondDeviceController.h"
#import "QHSelectVersionViewController.h"
#import "YRSettingTableViewController.h"
#define LBS_TAG 1001
#define COLLECTION_TAG 1002
#define PASSWORRD_TAG    1003

@interface YRQuickConllectionController ()<CLLocationManagerDelegate,UIAlertViewDelegate,YRRequestDeviceDelegate,CBCentralManagerDelegate>
{
    NSString *_top,*_bottom;//数字顶部，底部
    NSString *_bottom1,*_bottom2;//底部1位，底部2位
    BOOL _thedot;
    BOOL _thedotls;
    YRRequestDeviceTool * _requestDeviceTool;
}

@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UIView *moneyView;
@property (weak, nonatomic) IBOutlet UIButton *one;
@property (weak, nonatomic) IBOutlet UIButton *two;
@property (weak, nonatomic) IBOutlet UIButton *three;
@property (weak, nonatomic) IBOutlet UIButton *four;
@property (weak, nonatomic) IBOutlet UIButton *five;
@property (weak, nonatomic) IBOutlet UIButton *six;
@property (weak, nonatomic) IBOutlet UIButton *seven;
@property (weak, nonatomic) IBOutlet UIButton *eight;
@property (weak, nonatomic) IBOutlet UIButton *nine;
@property (weak, nonatomic) IBOutlet UIButton *point;
@property (weak, nonatomic) IBOutlet UIButton *zero;
@property (weak, nonatomic) IBOutlet UIButton *doubleZero;

@property (strong, nonatomic) CBCentralManager * centralManager;
@property (weak, nonatomic) IBOutlet UIButton *dueBtn;

@end

@implementation YRQuickConllectionController {
    
    CLLocationManager * _locationManager;
    NSString * _latitudeStr;
    NSString * _longitudeStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    [self clear:nil];
    
    [self buildUI];
    [self initLocationService];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [_locationManager stopUpdatingLocation];
}


- (void)initLocationService {
    
    if ([CLLocationManager locationServicesEnabled]) {
        
        if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
            
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.delegate = self;
            if ([[[UIDevice currentDevice]systemVersion] floatValue] >= 8.0) {
                [_locationManager requestWhenInUseAuthorization];
            }
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            _locationManager.distanceFilter = kCLDistanceFilterNone;
            [_locationManager startUpdatingLocation];
        }else {
            if ([[[UIDevice currentDevice]systemVersion] floatValue] <= 8.0) {
                CLAuthorizationStatus stats = [CLLocationManager authorizationStatus];
                if (kCLAuthorizationStatusDenied == stats || kCLAuthorizationStatusRestricted == stats) {
                    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"位置服务已关闭，无法进行交易" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
                    alertView.tag = LBS_TAG;
                    [alertView show];
                }
            }
            else{
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"位置服务已关闭，无法进行交易" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
            alertView.tag = LBS_TAG;
            [alertView show];
            }
        }
    }else {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"位置服务已关闭，无法进行交易" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
       
        
        if ([[[UIDevice currentDevice]systemVersion] floatValue] >= 8.0) {
           
        }
        else{
            alertView = [[UIAlertView alloc]initWithTitle:nil message:@"位置服务已关闭，无法进行交易" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        }
        alertView.tag = LBS_TAG;
       [alertView show];
    }
}

- (void)buildUI{
    UIImage * highImage = [self imageWithColor:kColor(254, 120, 10)];
    [self.one setBackgroundImage:highImage forState:UIControlStateHighlighted];
    [self.one setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.two setBackgroundImage:highImage forState:UIControlStateHighlighted];
    [self.two setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.three setBackgroundImage:highImage forState:UIControlStateHighlighted];
    [self.three setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.four setBackgroundImage:highImage forState:UIControlStateHighlighted];
    [self.four setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.five setBackgroundImage:highImage forState:UIControlStateHighlighted];
    [self.five setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.six setBackgroundImage:highImage forState:UIControlStateHighlighted];
    [self.six setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.seven setBackgroundImage:highImage forState:UIControlStateHighlighted];
    [self.seven setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.eight setBackgroundImage:highImage forState:UIControlStateHighlighted];
    [self.eight setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.nine setBackgroundImage:highImage forState:UIControlStateHighlighted];
    [self.nine setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.point setBackgroundImage:highImage forState:UIControlStateHighlighted];
    [self.point setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.zero setBackgroundImage:highImage forState:UIControlStateHighlighted];
    [self.zero setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.doubleZero setBackgroundImage:highImage forState:UIControlStateHighlighted];
    [self.doubleZero setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
}

- (void)backHome{
    //[self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clear:(UIButton *)sender {
    self.display.text = @"0";
    _top = @"0";
    _bottom = @"00";
    _bottom1=nil;
    _bottom2=nil;
    _thedot=NO;
    [self setButtonEnableYes];
    
}

- (IBAction)numBtn:(UIButton *)sender {
 
    switch (sender.tag) {
        case 1:
            [self num:@"1"];
            break;
        case 2:
            [self num:@"2"];
            break;
        case 3:
            [self num:@"3"];
            break;
        case 4:
            [self num:@"4"];
            break;
        case 5:
            [self num:@"5"];
            break;
        case 6:
            [self num:@"6"];
            break;
        case 7:
            [self num:@"7"];
            break;
        case 8:
            [self num:@"8"];
            break;
        case 9:
            [self num:@"9"];
            break;
        case 10:
            if (![self.display.text isEqualToString:@"0"]) {
               [self num:@"0"];
            }
            break;
        case 11:
            if ([self.display.text isEqualToString:@"0"]) {
                [self numBtn:nil];
            }else{
                [self num:@"0"];
                [self num:@"0"];
            }
            break;
        case 12:
            if (!_thedot) {
                self.display.text = [NSString stringWithFormat:@"%@.",self.display.text];
                _thedot=YES;
            }
            break;
    }
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)num:(NSString *)num{
    if (!_thedot) {//没有小数点
        if ([self.display.text isEqualToString:@"0"]){//且仅有一位是0
            self.display.text=[NSString stringWithFormat:@"%@",num];
        }else{//非一位
            if ([self.display.text length]<6) {
                
                self.display.text=[NSString stringWithFormat:@"%@%@",self.display.text,num];
            }else{

            }
        }
        //        self.display.text=[self AddComma:self.display.text];
        _top = self.display.text;
        //        [self Converter];
    }else{//有小数点
        if (_bottom1==nil) {//首位为空
            _bottom1 = num;
            self.display.text=[NSString stringWithFormat:@"%@%@",self.display.text,num];
            
        }else{//首位非空
            _bottom2 = num;

            self.display.text=[NSString stringWithFormat:@"%@.%@%@",_top,_bottom1,num];
            [self setButtonEnableNo];
        }
    }
}

- (IBAction)back:(UIButton *)sender {
    
    NSUInteger numl=[self.display.text length];//取得长度

    if (numl==1) {//仅有一位，执行清零
        [self clear:nil];
    }else{//非一位
        
        if (_thedot) {//有小数点
            if(_bottom2!=nil){//小数点后2位不为空
                _bottom2=nil;
                [self setButtonEnableYes];
            }else if (_bottom1!=nil){//小数点后1位不为空
                _bottom1=nil;
            }else if ([self.display.text hasSuffix:@"."]) {//底部是小数点
                _thedot=NO;
            }
            self.display.text=[self.display.text substringWithRange:NSMakeRange(0, numl-1)];
        }else{
            self.display.text=[self.display.text substringWithRange:NSMakeRange(0, numl-1)];
            _top = self.display.text;
        }
    }
}

#pragma mark 开始刷卡
- (IBAction)confirmConllection:(UIButton *)sender {
    NSString * channel = [SFHFKeychainManager loadValueForKey:YR_DEVICE_CHANNEL];
    if ([channel isEqualToString:YR_DEVICE_CHANNEL_VALUE_AUDIOJACK]) {//音频
        [MBProgressHUD showMessage:@"处理中..."];
        [self beginDeal];
    }
    else {//蓝牙
        [MBProgressHUD showMessage:@"交易中..."];
        self.centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation * location = locations.firstObject;
    _latitudeStr = [NSString stringWithFormat:@"%.6f", location.coordinate.latitude];
    _longitudeStr = [NSString stringWithFormat:@"%.6f",location.coordinate.longitude];

}

#pragma mark alertView delegate方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == LBS_TAG) {
        
        if (buttonIndex == 1) {
            
            if ([[[UIDevice currentDevice]systemVersion] floatValue] >= 8.0) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    else if (alertView.tag == PASSWORRD_TAG) {
        if (buttonIndex == 1) {
            NSString *passWordStr = [alertView textFieldAtIndex:0].text;
            if ([passWordStr rangeOfString:@" "].location != NSNotFound) {
                [[[UIAlertView alloc] initWithTitle:@"密码不正确" message:@"请重新输入" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了",nil] show];
                return;
            }
            if (_requestDeviceTool) {
                [_requestDeviceTool passDealPWD:passWordStr];
            }
        }
    }
    else if (alertView.tag == COLLECTION_TAG) {//未连接设备
        if (buttonIndex == 1) {//手动连接
        
//            YRSearchMPOSController * searchVC = [[YRSearchMPOSController alloc] init];
//            searchVC.searchMPOSEnterType = SearchMPOSEnterTypeSetting;
//            [self.navigationController pushViewController:searchVC animated:YES];
            QHSelectVersionViewController *selectVersionVC = [[QHSelectVersionViewController alloc] init];
            selectVersionVC.selecType = setType;
            [self.navigationController pushViewController:selectVersionVC animated:YES];
        }else{//自动连接
            [[[YRAutoConnectDevice alloc] init] autoConnectDeviceWithUIViewController:self SearchMPOSEnterType:SearchMPOSEnterTypeDeal success:^{
                [self confirmConllection:self.dueBtn];
                [MBProgressHUD hideHUD];
            } failure:^(NSString *errInfo) {

                [MBProgressHUD hideHUD];

                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"连接设备失败!!!" message:@"请确保设备或手机蓝牙已打开" delegate:self cancelButtonTitle:nil otherButtonTitles:@"重试",@"前往手动搜索", nil];
                alertView.tag = COLLECTION_TAG;
                [alertView show];

            }];
        }
    }
    
}

#pragma mark - 蓝牙代理
-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
    if (central.state == CBCentralManagerStatePoweredOn) {
        [self beginDeal];
    }else{
        [MBProgressHUD hideHUD];
    }
}

- (NSString *)getDeviceVersion{
    NSString *str1 = [[NSUserDefaults standardUserDefaults] valueForKey:ALREADY_REMEMBER_USER_NAME];
    NSString *str = [NSString stringWithFormat:@"%@%@",str1,str1];
    NSString *fileName = [SFHFKeychainManager loadValueForKey:str];
    NSString *channel = [SFHFKeychainManager loadValueForKey:YR_DEVICE_CHANNEL];
    NSString *str2;
    if ([channel isEqualToString:YR_DEVICE_CHANNEL_VALUE_AUDIOJACK]) {
        str2 = M15_UNS_USERSOFTVERSION;
    }
    else{
        if ([fileName hasPrefix:@"M35"]) {
            str2 = M35_UNS_USERSOFTVERSION;
        }
        else{
            str2 = M36_UNS_USERSOFTVERSION;
        }
    }
    return str2;
}

#pragma 进入交易流程
- (void)dealing {
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
        
    } failure:^(NSString *errInfo) {
        [MBProgressHUD hideHUD];
        [YRFunctionTools setAlertViewWithTitle:@"网络错误，请联网后再试" buttonTitle:TIPS_CONFIRM];
    }];
}


#pragma 开始交易
- (void)beginDeal {
    LandiMPOS * manager = [LandiMPOS getInstance];
    BOOL isConnect = [manager isConnectToDevice];
    if (isConnect) {//已连接设备
        [[LandiMPOS getInstance] getDeviceInfo:^(LDC_DeviceInfo *deviceInfo) {
           if (deviceInfo.userSoftVer.doubleValue < [self getDeviceVersion].doubleValue) {
                [MBProgressHUD hideHUD];
                [YRFunctionTools showAlertViewTitle:@"请先升级固件" message:@"进入设置界面，点击“固件更新”,升级完固件即可使用！" cancelButton:TIPS_CONFIRM];
                YRSettingTableViewController *setVC = [[YRSettingTableViewController alloc]init];
                [self.navigationController pushViewController:setVC animated:YES];
            }
            else{
                if ([deviceInfo.deviceType isEqualToString:@"M15"]) {
                    [MBProgressHUD hideHUD];
                    [[[YRAutoConnectDevice alloc] init] autoConnectDeviceWithUIViewController:self SearchMPOSEnterType:SearchMPOSEnterTypeDeal success:^{
                        [self dealing];
                    } failure:^(NSString *errInfo) {
                        [MBProgressHUD hideHUD];
                        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"连接设备失败!!!" message:@"请确保设备或手机蓝牙已打开" delegate:self cancelButtonTitle:nil otherButtonTitles:@"重试",@"前往手动搜索", nil];
                        alertView.tag = COLLECTION_TAG;
                        [alertView show];
                    }];
                }
                else{
                    [self dealing];
                }
            }
           
        } failedBlock:^(NSString *errCode, NSString *errInfo) {
            [YRFunctionTools setAlertViewWithTitle:@"获取设备信息失败，请重新操作" buttonTitle:TIPS_CONFIRM];
        }];
    }else{//未连接设备
        [MBProgressHUD hideHUD];
        [[[YRAutoConnectDevice alloc] init] autoConnectDeviceWithUIViewController:self SearchMPOSEnterType:SearchMPOSEnterTypeDeal success:^{
            NSString * channel = [SFHFKeychainManager loadValueForKey:YR_DEVICE_CHANNEL];
            if ([channel isEqualToString:YR_DEVICE_CHANNEL_VALUE_AUDIOJACK]) {
                [self dealing];
            }
            else {
                [self beginDeal];
            }
            
        } failure:^(NSString *errInfo) {
            [MBProgressHUD hideHUD];
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"连接设备失败!!!" message:@"请确保设备或手机蓝牙已打开" delegate:self cancelButtonTitle:nil otherButtonTitles:@"重试",@"前往手动搜索", nil];
            alertView.tag = COLLECTION_TAG;
            [alertView show];
        }];
    }
}

- (void)setButtonEnableNo{
    self.one.enabled = NO;
    self.two.enabled = NO;
    self.three.enabled = NO;
    self.four.enabled = NO;
    self.five.enabled = NO;
    self.six.enabled = NO;
    self.seven.enabled = NO;
    self.eight.enabled = NO;
    self.nine.enabled = NO;
    self.point.enabled = NO;
    self.zero.enabled = NO;
    self.doubleZero.enabled = NO;
}

- (void)setButtonEnableYes{
    self.one.enabled = YES;
    self.two.enabled = YES;
    self.three.enabled = YES;
    self.four.enabled = YES;
    self.five.enabled = YES;
    self.six.enabled = YES;
    self.seven.enabled = YES;
    self.eight.enabled = YES;
    self.nine.enabled = YES;
    self.point.enabled = YES;
    self.zero.enabled = YES;
    self.doubleZero.enabled = YES;
}

#pragma mark - YRRequestDeviceDelegate
- (void)requestDeviceTool:(YRRequestDeviceTool *)requestDeviceTool transMessage:(YRTransactionMessage *)transMessage{

    YRSignController * signVC = [[YRSignController alloc] initWithNibName:@"YRSignController" bundle:nil];
    signVC.transMessage = transMessage;
    signVC.showType = ShowType_Sign;
    [self.navigationController pushViewController:signVC animated:YES];
}

- (void)inputDealPWD {
    //音频设备在客户端输入密码
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入密码" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    alert.tag = PASSWORRD_TAG;
    UITextField *passWordTF = [alert textFieldAtIndex:0];
    passWordTF.keyboardType = UIKeyboardTypeNumberPad;
    passWordTF.placeholder = @"请输入6位数字密码";
    
    [alert show];
}

#pragma mark - 判断密钥灌装
- (void)judgeSecretKeysInstall:(NSDictionary *)responseObject {
    //判断密钥灌装情况
    NSString *deviceKEY = [NSString stringWithFormat:@"%@%@",[YRLoginManager shareLoginManager].busrID,[YRLoginManager shareLoginManager].busrID];
    NSString *deviceName = [SFHFKeychainManager loadValueForKey:deviceKEY];
    BOOL secretKeyInstallCompleted = NO;
    if (deviceName) {
        secretKeyInstallCompleted = [[NSUserDefaults standardUserDefaults] boolForKey:deviceName];
    }
    
    NSString * posSequence = responseObject[@"PR"];
    if ([posSequence isEqualToString:@"9009"] && secretKeyInstallCompleted) {//返回9009
        if (_latitudeStr && _longitudeStr) {
            if ([self.display.text isEqualToString:@"0"] || [self.display.text isEqualToString:@"0.0"] || [self.display.text isEqualToString:@"0.00"]) {
                [YRFunctionTools setAlertViewWithTitle:@"交易金额不能为零" buttonTitle:TIPS_CONFIRM];
                [MBProgressHUD hideHUD];
                return;
            }
            [YRLoginManager shareLoginManager].latitudeStr = _latitudeStr;
            [YRLoginManager shareLoginManager].longitudeStr = _longitudeStr;
            
            _requestDeviceTool = nil;
            _requestDeviceTool = [[YRRequestDeviceTool alloc] init];
            _requestDeviceTool.delegate = self;
            [_requestDeviceTool beginDealWithMoenyNum:self.display.text payType:payTypeQuick];
            YRMainViewController * mainVC = (YRMainViewController *)self.parentViewController;
            mainVC.dealType = DealTypepDetail;
        }else{
            [MBProgressHUD hideHUD];
            [YRFunctionTools showAlertViewTitle:nil message:@"当前位置无法获取，请打开位置服务后尝试此操作" cancelButton:TIPS_CONFIRM];
        }
    }else{//其他情况
        YRBondDeviceController * bondVC = [[YRBondDeviceController alloc] init];
        bondVC.loadingType = LoadingKeyType_Pay;

        [MBProgressHUD hideHUD];
        [self.navigationController pushViewController:bondVC animated:YES];
    }
}

@end

