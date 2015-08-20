//
//  YRSettingTableViewController.m
//  YunRichMPCR
//
//  Created by YunRich on 15/5/21.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//

#import "YRSettingTableViewController.h"
#import "LandiMPOS.h"
#import "MBProgressHUD+MJ.h"
#import "YRBondDeviceController.h"
#import "YRSearchMPOSController.h"
#import "YRAutoConnectDevice.h"
#import "YRLoginManager.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "QHSelectVersionViewController.h"

@interface YRSettingTableViewController ()<UITableViewDataSource,UITableViewDelegate,CBCentralManagerDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) CBCentralManager * centralManager;
@end

@implementation YRSettingTableViewController {
    
    UILabel * _middleTitle;
    NSString * _deviceName;
    NSString * _deviceId;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithIcon:nil highlightedIcon:nil target:self action:@selector(goBack) barButtonItemType:BarButtonItemTypePopToView];
    YRLoginManager * logManager = [YRLoginManager shareLoginManager];
    _deviceId = [SFHFKeychainManager loadValueForKey:logManager.busrID];
    _deviceName = [SFHFKeychainManager loadValueForKey:[NSString stringWithFormat:@"%@%@",logManager.busrID,logManager.busrID]];
    self.view.layer.contents = (id)[UIImage imageNamed:@"qh_rootbg"].CGImage;

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if ([YRLoginManager shareLoginManager].deviceName.length != 0 ) {
            _deviceId = [YRLoginManager shareLoginManager].deviceId;
            _deviceName = [YRLoginManager shareLoginManager].deviceName;
        
    }
   [self.tableView reloadData];
}


- (void)goBack {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * reuseIdentifier = @"reuseCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];

    _middleTitle = [[UILabel alloc] init];
    [_middleTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    UISwitch * switchBtn = [[UISwitch alloc] init];
    [switchBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [switchBtn addTarget:self action:@selector(changeStatues:) forControlEvents:UIControlEventValueChanged];
    NSLayoutConstraint * _VConstraints = [NSLayoutConstraint constraintWithItem:switchBtn
                                                                      attribute:NSLayoutAttributeCenterY
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:cell.contentView
                                                                      attribute:NSLayoutAttributeCenterY
                                                                     multiplier:1 constant:0];
    
    NSLayoutConstraint * _TrailingConstraints = [NSLayoutConstraint constraintWithItem:switchBtn
                                                                             attribute:NSLayoutAttributeTrailing
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:cell.contentView
                                                                             attribute:NSLayoutAttributeTrailing
                                                                            multiplier:1 constant:-20];
    
    NSLayoutConstraint * _HorConstraints = [NSLayoutConstraint constraintWithItem:_middleTitle
                                                                        attribute:NSLayoutAttributeLeading
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:cell.textLabel
                                                                        attribute:NSLayoutAttributeLeading
                                                                       multiplier:1 constant:83];
    
    NSLayoutConstraint * _VerConstraints = [NSLayoutConstraint constraintWithItem:_middleTitle
                                                                        attribute:NSLayoutAttributeCenterY
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:cell.contentView
                                                                        attribute:NSLayoutAttributeCenterY
                                                                       multiplier:1 constant:0];
    
        BOOL isConnected = [[LandiMPOS getInstance] isConnectToDevice];
        
        switch (indexPath.row) {
                
            case 0:
            {
                cell.textLabel.text = @"设备ID    ：";
                if (isConnected) {
                    cell.textLabel.text = _deviceId?[NSString stringWithFormat:@"设备ID  ：%@",_deviceId]:[NSString stringWithFormat:@"设备ID      ：%@",@"空"];
                   
                }else {
                    cell.textLabel.text = [NSString stringWithFormat:@"设备ID    ：%@",@"空"];
                   
                }
            }
                break;
            case 1:
            {
                cell.textLabel.text = @"设备名称：";
                if (isConnected) {
                    cell.textLabel.text = _deviceName?[NSString stringWithFormat:@"设备名称：%@",_deviceName]:[NSString stringWithFormat:@"设备名称：%@",@"空"];
                   
                }else {
                    cell.textLabel.text = [NSString stringWithFormat:@"设备名称：%@",@"空"];
                }
            }
                break;
            case 2:
            {
                [cell.contentView addSubview:switchBtn];
                [cell addConstraint:_VConstraints];
                [cell addConstraint:_TrailingConstraints];

                [cell.contentView addSubview:_middleTitle];
                [cell addConstraint:_HorConstraints];
                [cell addConstraint:_VerConstraints];
                
                cell.textLabel.text = @"连接状态：";
                if(isConnected) {
                    [switchBtn setOn:YES];
                    _middleTitle.textColor = [UIColor blueColor];
                    _middleTitle.text = @"已连接刷卡器";

                }else {
                    [switchBtn setOn:NO animated:YES];
                    
                    _middleTitle.textColor = [UIColor blueColor];
                    _middleTitle.text = @"未连接";
                }
            }
                break;
            case 3:
            {
                cell.textLabel.text = @"密钥：    重新下载";
           
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
            case 4:
            {
                cell.textLabel.text = @"添加：    手动搜索刷卡器";
                
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
            case 5:
            {
                cell.textLabel.text = @"固件更新";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
            default:
                break;
        }
 
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    UITableViewHeaderFooterView *headview = (UITableViewHeaderFooterView *)view;
    [headview.textLabel setTextColor:[UIColor blueColor]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 33;
}

- (void)changeStatues:(UISwitch *)switchBtn {
    
    if (switchBtn.on) {
        
        if (![[LandiMPOS getInstance] isConnectToDevice]) {
            [[[YRAutoConnectDevice alloc] init] autoConnectDeviceWithUIViewController:self SearchMPOSEnterType:SearchMPOSEnterTypeSetting success:^{
               [self.tableView reloadData];
                
                
            } failure:^(NSString *errInfo) {
                [MBProgressHUD hideHUD];
                [YRFunctionTools showAlertViewTitle:nil message:@"未搜索到绑定设备，请尝试手动搜索！" cancelButton:TIPS_CONFIRM];
                [switchBtn setOn:NO animated:YES];
            }];

        }else {
            
            [switchBtn setOn:NO animated:YES];
            [self.tableView reloadData];
            
        }
    
    }else {
        
        if ([[LandiMPOS getInstance] isConnectToDevice]) {
            
            [[LandiMPOS getInstance] closeDevice];
            
        }
        [self.tableView reloadData];
    }
}



#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        if (indexPath.row == 3) {//进入密钥灌装
            if (![[LandiMPOS getInstance] isConnectToDevice]) {//没连接设备
                
                [self autoConnectDevice];
                
            }else {//已连接设备
                YRBondDeviceController * bondDeviceVC = [YRBondDeviceController new];
                bondDeviceVC.loadingType = LoadingKeyType_Checkins;
                [self.navigationController pushViewController:bondDeviceVC animated:YES];
            }
            
        }else if (indexPath.row == 4) {
            QHSelectVersionViewController *selectVC = [[QHSelectVersionViewController alloc] init];
            selectVC.selecType = setType;
            [self.navigationController pushViewController:selectVC animated:YES];
        }else {
            if ([[LandiMPOS getInstance] isConnectToDevice]) {
                [self updateDeviceComponent:self];
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"设备未连接，请连接设备" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert setTag:10001];
                [alert show];
            }
        }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)updateDeviceComponent:(UIViewController *)viewController {
    NSString * fileName = nil;
    if ([[YRLoginManager shareLoginManager].deviceType isEqualToString:@"M35"]) {
        fileName = M35_UNS_FILENAME;
    }
    else if ([[YRLoginManager shareLoginManager].deviceType isEqualToString:@"M36"]) {
        fileName = M36_UNS_FILENAME;
    }
    else if ([[YRLoginManager shareLoginManager].deviceType isEqualToString:@"M15"]) {
        fileName = M15_UNS_FILENAME;
    }
    
    NSString * filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"uns"];
    [[LandiMPOS getInstance] getDeviceInfo:^(LDC_DeviceInfo *deviceInfo) {      
        if (deviceInfo.userSoftVer.doubleValue < [self getDeviceVersion].doubleValue) {
            [[LandiMPOS getInstance] enterFirmwareUpdateMode:^{
                [[LandiMPOS getInstance] updateFirmware:filePath completeBlock:^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        sleep(3);
                        [MBProgressHUD hideHUD];
                        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"固件更新成功!" message:@"请连接设备进行签到" delegate:self cancelButtonTitle:nil otherButtonTitles:@"点击连接设备签到", nil];
                        [alertview setTag:1234];
                    });
                } progressBlock:^(unsigned int current, unsigned int total) {
                    CGFloat progress = current*1.0/total;
                    NSString * character = @"\%";
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUD];
                        [MBProgressHUD showMessage:[NSString stringWithFormat:@"已更新...%.1f%@",progress*100,character]];
                        
                    });
                } errorBlock:^(int code) {
                    
                    [self displayDeviceError:[NSString stringWithFormat:@"%d",code]];
                }];
                
            } failedBlock:^(NSString *errCode, NSString *errInfo) {
                
                [self displayDeviceError:errInfo];
            }];
        }else {
            
            [YRFunctionTools showAlertViewTitle:nil message:@"当前版本已为最新" cancelButton:TIPS_CONFIRM];
        }
        
    } failedBlock:^(NSString *errCode, NSString *errInfo) {
        
        [self displayDeviceError:errInfo];
    }];
}

- (void)displayDeviceError:(NSString *)errInfo {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [MBProgressHUD hideHUD];
        [YRFunctionTools showAlertViewTitle:nil message:errInfo cancelButton:TIPS_CONFIRM];
        
    });
}

//自动连接
- (void)autoConnectDevice{
    [[[YRAutoConnectDevice alloc] init] autoConnectDeviceWithUIViewController:self SearchMPOSEnterType:SearchMPOSEnterTypeSetting success:^{
        
        YRBondDeviceController * bondDeviceVC = [YRBondDeviceController new];
        bondDeviceVC.loadingType = LoadingKeyType_Checkins;
        [self.navigationController pushViewController:bondDeviceVC animated:YES];
        
        _deviceId = [SFHFKeychainManager loadValueForKey:[YRLoginManager shareLoginManager].busrID];
        _deviceName = [SFHFKeychainManager loadValueForKey:[NSString stringWithFormat:@"%@%@",[YRLoginManager shareLoginManager].busrID,[YRLoginManager shareLoginManager].busrID]];
        [self.tableView reloadData];
        
    } failure:^(NSString *errInfo) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"连接设备失败!!!" message:@"请确保设备或手机蓝牙已打开" delegate:self cancelButtonTitle:nil otherButtonTitles:@"重试",@"前往手动搜索", nil];
        [alertView show];
    }];
}

#pragma mark - 蓝牙代理
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{

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
        else if ([fileName hasPrefix:@"M36"]) {
            str2 = M36_UNS_USERSOFTVERSION;
        }
    }
    return str2;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 10001) {
        if (buttonIndex == 1) {
            [self autoConnectDevice];
        }
    }
    else if (alertView.tag == 1234){
         [self autoConnectDevice];
    }
    else{
        if (buttonIndex == 1) {
            QHSelectVersionViewController *selectVersionVC = [[QHSelectVersionViewController alloc] init];
            selectVersionVC.selecType = setType;
            [self.navigationController pushViewController:selectVersionVC animated:YES];
        }else{
            [self autoConnectDevice];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - 更新固件
@end
