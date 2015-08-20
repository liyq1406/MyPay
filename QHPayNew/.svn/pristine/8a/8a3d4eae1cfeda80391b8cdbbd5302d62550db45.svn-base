//
//  YRSearchMPOSController.m
//  YunRichMPCR
//
//  Created by YunRich on 15/4/15.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//

#import "YRSearchMPOSController.h"
#import "LandiMPOS.h"
#import "YRRegisterViewController.h"
#import "YRLoginManager.h"
#import "MBProgressHUD+MJ.h"
#import "YROpenAccountViewController.h"
#import "YRMainViewController.h"
#import "YRDeviceRelative.h"
#import "YRRequestDeviceTool.h"
#import "YRLoginManager.h"
#import "YRBondDeviceController.h"
#import "YRMerchantInfoViewController.h"
#import "QHHomeViewController.h"

@interface YRSearchMPOSController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray * _devices;
    LDC_DEVICEBASEINFO * _deviceInfo;
}
@property (nonatomic, strong) YRLoginManager * loginManager;
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation YRSearchMPOSController
@synthesize loginManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildUI];
    [self searchDevice];
}

- (void)buildUI{
    NSMutableArray * images = [NSMutableArray array];
    for (int i = 1; i < 12; i++) {
        [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"search_0%d",i]]];
    }
    [self.imageView setAnimationImages:images];
    self.imageView.animationDuration = 1;
    self.imageView.animationRepeatCount = 0;
    [self.imageView startAnimating];
    self.tableView.layer.contents = (id)[UIImage imageNamed:@"qh_rootbg"].CGImage;
    self.title = @"连接设备";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithIcon:nil highlightedIcon:nil target:self action:@selector(back) barButtonItemType:BarButtonItemTypePopToView];
    _devices = [NSMutableArray array];
    loginManager = [YRLoginManager shareLoginManager];
}

- (void)searchDevice {
    __block NSMutableArray * weakDevices = _devices;
    if (_deviceVersion == Landi_M15 || _deviceVersion == Landi_M35 || _deviceVersion == Landi_M36) {//联迪
        [[LandiMPOS getInstance] startSearchDev:10 searchOneDeviceBlcok:^(LDC_DEVICEBASEINFO *deviceInfo) {
            
            NSString *deviceInfoName = deviceInfo.deviceName;
            
            if (self.deviceVersion == Landi_M35) {
                if ([deviceInfoName hasPrefix:@"M35"]) {
                    [weakDevices addObject:deviceInfo];
                }
            } else if (self.deviceVersion == Landi_M15) {
                if ([deviceInfoName hasPrefix:@"AUDIO"]) {
                    [[LandiMPOS getInstance] openDevice:deviceInfo.deviceIndentifier channel:deviceInfo.deviceChannel mode:COMMUNICATIONMODE_MASTER successBlock:^{
                        [[LandiMPOS getInstance] getDeviceInfo:^(LDC_DeviceInfo *deviceInfo1) {
                            LDC_DEVICEBASEINFO *baseInfo = [[LDC_DEVICEBASEINFO alloc] init];
                            baseInfo.deviceChannel = deviceInfo.deviceChannel;
                            baseInfo.deviceIndentifier = deviceInfo1.productSN;
                            baseInfo.deviceName = [NSString stringWithFormat:@"%@-%@",deviceInfo1.deviceType,deviceInfo1.productSN];
                            [weakDevices addObject:baseInfo];
                            [self updateTableView];
                        } failedBlock:^(NSString *errCode, NSString *errInfo) {
                            [weakDevices addObject:deviceInfo];
                        }];
                    } failedBlock:^(NSString *errCode, NSString *errInfo) {
                        [weakDevices addObject:deviceInfo];
                    }];
                }
            }
            else if (self.deviceVersion == Landi_M36) {
                if ([deviceInfoName hasPrefix:@"M36"]) {
                    [weakDevices addObject:deviceInfo];
                }
            }
            [self performSelectorOnMainThread:@selector(updateTableView) withObject:self waitUntilDone:NO];
            
        } completeBlock:^(NSMutableArray *deviceArray) {
            [self performSelectorOnMainThread:@selector(updateTableView) withObject:self waitUntilDone:NO];
        }];
    }
    else if (_deviceVersion == XDL_ME11) {//新大陆
        [[NLSwiperController sharedInstance] startSearchDev:10 searchOneDeviceBlcok:^(LDC_DEVICEBASEINFO *deviceInfo) {
            NSLog(@"%d",deviceInfo.deviceChannel);
            NSLog(@"%@",deviceInfo.deviceName);
            NSLog(@"%@",deviceInfo.deviceIndentifier);
        } completeBlock:^(NSMutableArray *deviceArray) {
            ;
        }];
    }
}

- (void)updateTableView {
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return section == 0 ? _devices.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    UILabel * deviceNameL = [[UILabel alloc] init];
    [deviceNameL setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    deviceNameL.textColor = [UIColor colorWithRed:43.0/255 green:139.0/255 blue:217.0/255 alpha:1];
    deviceNameL.font = [UIFont systemFontOfSize:16]; 
    if (indexPath.section == 0) {
        
        _deviceInfo = [_devices objectAtIndex:indexPath.row];
        [cell.contentView addSubview:deviceNameL];
        //[cell.contentView addSubview:deviceIdL];
        deviceNameL.text = _deviceInfo.deviceName;
        //deviceIdL.text = _deviceInfo.deviceIndentifier;
    }
    
    NSLayoutConstraint * leading_DeviceNameL_C = [NSLayoutConstraint constraintWithItem:deviceNameL attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:20];
    NSLayoutConstraint * center_DeviceNameL_C = [NSLayoutConstraint constraintWithItem:deviceNameL attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [cell addConstraint:leading_DeviceNameL_C];
    [cell addConstraint:center_DeviceNameL_C];
  
    return cell;
}

#pragma mark 选择设备
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [MBProgressHUD showMessage:@"开始连接设备"];
    
    _deviceInfo = [_devices objectAtIndex:indexPath.row];
    //开始连接设备
    [[LandiMPOS getInstance] openDevice:_deviceInfo.deviceIndentifier channel:_deviceInfo.deviceChannel mode:COMMUNICATIONMODE_MASTER successBlock:^{
        [YRLoginManager shareLoginManager].deviceName = _deviceInfo.deviceName;
        [YRLoginManager shareLoginManager].deviceId = _deviceInfo.deviceIndentifier;
        [YRLoginManager shareLoginManager].channel = _deviceInfo.deviceChannel;
//        [MBProgressHUD hideHUD];
        if (self.searchMPOSEnterType != SearchMPOSEnterTypeRegister) {
            if (loginManager.busrID.length > 0) {
                [SFHFKeychainManager saveValue:_deviceInfo.deviceIndentifier forKey:loginManager.busrID];
                [SFHFKeychainManager saveValue:_deviceInfo.deviceName forKey:[NSString stringWithFormat:@"%@%@",loginManager.busrID,loginManager.busrID]];
            }

            if (_deviceInfo.deviceChannel == CHANNEL_BLUETOOTH) {//存蓝牙设备信息
                [SFHFKeychainManager saveValue:YR_DEVICE_CHANNEL_VALUE_BLUETOOTH forKey:YR_DEVICE_CHANNEL];
            }else{//存音频设备信息
                [SFHFKeychainManager saveValue:YR_DEVICE_CHANNEL_VALUE_AUDIOJACK forKey:YR_DEVICE_CHANNEL];
            }
        }
        [self getDeviceInfo];
    } failedBlock:^(NSString *errCode, NSString *errInfo) {
        
        [MBProgressHUD hideHUD];
        [YRFunctionTools setAlertViewWithTitle:errInfo buttonTitle:@"确认"];
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 2;
}


- (void)getDeviceInfo{
    [[LandiMPOS getInstance] getDeviceInfo:^(LDC_DeviceInfo *deviceInfo) {
        
        [[[YRRequestDeviceTool alloc] init] hanlePOSFlowNumber:nil operationType:HandleFlowNumberType_Get successBlock:^(NSString *serialNO) {
            
            //读取SN，流水号等信息并存到单例中
            loginManager.supportPrinter = deviceInfo.terminalConfig.isSuportPrinter;
            loginManager.unsVersion = deviceInfo.userSoftVer;
            loginManager.productSN = deviceInfo.productSN;
            loginManager.deviceType = deviceInfo.deviceType;
            loginManager.PSEQ = serialNO;
            
            //读取customParam信息并存到单例中
            [[YRDeviceRelative shareDeviceRelative] getSNMessageSuccessBlock:^(NSDictionary *dict) {
                
                //gyj

                NSString *posId = [[YRDeviceRelative shareDeviceRelative] posId];
                loginManager.EhomeOrd = [NSString stringWithFormat:@"%@%@%@",loginManager.EhomeDate,posId,loginManager.EhomeLsh];
                
                [MBProgressHUD hideHUD];
                if (self.searchMPOSEnterType == SearchMPOSEnterTypeLogin) {//由登入界面进入
                    YROpenAccountViewController * openAccountVC = [[YROpenAccountViewController alloc] init];
                    [self.navigationController pushViewController:openAccountVC animated:YES];
                }else if(self.searchMPOSEnterType == SearchMPOSEnterTypeRegister){//由注册界面进入
                    YRRegisterViewController * registerVC = [[YRRegisterViewController alloc] initWithNibName:@"YRRegisterViewController" bundle:nil];
                    [self.navigationController pushViewController:registerVC animated:YES];
                
                }else if (self.searchMPOSEnterType == SearchMPOSEnterTypeDeal){//由快速刷卡界面进入
                    YRMainViewController * dealMainVC = [[YRMainViewController alloc] initWithNibName:@"YRMainViewController" bundle:nil];
                    [self.navigationController pushViewController:dealMainVC animated:YES];
                
                }else if (self.searchMPOSEnterType == SearchMPOSEnterTypeSetting) {
                    NSArray *viewcontrollers = self.navigationController.viewControllers;
                    QHPayBaseViewController *destinationVC = viewcontrollers[viewcontrollers.count-3];
                    
                    [self.navigationController popToViewController:destinationVC animated:YES];
                }else if (self.searchMPOSEnterType == SearchMPOSEnterTypeSettingForLoadingMainKey) {
                    
                    YRBondDeviceController * bondDeviceC = [YRBondDeviceController new];
                    bondDeviceC.loadingType = LoadingKeyType_Checkins;
                    [self.navigationController pushViewController:bondDeviceC animated:YES];
                }else if (self.searchMPOSEnterType == SearchMPOSEnterTypePromote) {
                    
                    YRMerchantInfoViewController * merchantVC = [YRMerchantInfoViewController new];
                    merchantVC.funcationType = FuncationType_ApplyPromote;
                    [self.navigationController pushViewController:merchantVC animated:YES];
                }else if (self.searchMPOSEnterType == SearchMPOSEnterTypeChangeNumber) {
                    QHHomeViewController *QHHomeVC = [[QHHomeViewController alloc] init];
                    [self.navigationController pushViewController:QHHomeVC animated:YES];
                    [MBProgressHUD hideHUD];
                }
                
                [MBProgressHUD hideHUD];
            } failureBlock:^(NSString *errInfo) {
                
            }];
        } failureBlock:^(NSString *errorInfo) {
            
        }];
    } failedBlock:^(NSString *errCode, NSString *errInfo) {
        
    }];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[LandiMPOS getInstance] stopSearchDev];
}

@end
