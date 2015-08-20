//
//  YRAutoConnectDevice.m
//  YunRichMPCR
//
//  Created by YunRich on 15/5/21.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//

#import "YRAutoConnectDevice.h"
#import "QHLoginController.h"
#import "YRLoginManager.h"
#import "LandiMPOS.h"
#import "MBProgressHUD+MJ.h"
#import "YRRequestDeviceTool.h"
#import "YRDeviceRelative.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "QHSelectVersionViewController.h"

@interface YRAutoConnectDevice () <CBCentralManagerDelegate>
@property (nonatomic, strong) LandiMPOS * manager;
@property (nonatomic, strong) YRLoginManager * loginManager;
@property (nonatomic, retain) CBCentralManager *centralManager;
@property (nonatomic, assign) BOOL isOpenBlueTooth;
@end

@implementation YRAutoConnectDevice
@synthesize manager;
@synthesize loginManager;

- (id)init{
    self = [super init];
    if (self) {
        loginManager = [YRLoginManager shareLoginManager];
        manager = [LandiMPOS getInstance];
      
    }
    return self;
}

- (void)showMessage:(NSString *)message {
    [MBProgressHUD hideHUD];
    if (message == nil || [message isEqualToString:@""]) {
        
    }
    else {
        [MBProgressHUD showMessage:message];
    }
}

//自动连接设备
- (void)autoConnectDeviceWithUIViewController:(UIViewController *)viewController SearchMPOSEnterType:(SearchMPOSEnterType)SearchMPOSEnterType success:(void (^)())success failure:(void (^)(NSString * errInfo))failure{
    NSString * identifier = [SFHFKeychainManager loadValueForKey:loginManager.busrID];
    NSString * channel = [SFHFKeychainManager loadValueForKey:YR_DEVICE_CHANNEL];
    if (identifier.length > 0) {
        
        if ([channel isEqualToString:YR_DEVICE_CHANNEL_VALUE_BLUETOOTH]) {//走蓝牙通道
            [MBProgressHUD showMessage:@"连接设备中请确保设备已开启..."];
            [manager openDevice:identifier channel:CHANNEL_BLUETOOTH mode:COMMUNICATIONMODE_MASTER successBlock:^{
                
                [self getDeviceInfoSuccess:^{
                    if (SearchMPOSEnterType == SearchMPOSEnterTypeSetting) {
                        [self performSelectorOnMainThread:@selector(showMessage:) withObject:@"" waitUntilDone:YES];
                    }
                    else if (SearchMPOSEnterType == SearchMPOSEnterTypeDeal) {
                        [self performSelectorOnMainThread:@selector(showMessage:) withObject:@"交易中..." waitUntilDone:YES];
                    }
                    success();
                } failure:^(NSString *errInfo) {
                    [MBProgressHUD hideHUD];
                    failure(errInfo);
                }];
            } failedBlock:^(NSString *errCode, NSString *errInfo) {
                [MBProgressHUD hideHUD];
                failure(errInfo);
            }];
        }
        else if([channel isEqualToString:YR_DEVICE_CHANNEL_VALUE_AUDIOJACK]){//走音频通道
            [MBProgressHUD showMessage:@"连接设备中 请勿断开"];
            [manager openDevice:identifier channel:CHANNEL_AUDIOJACK mode:COMMUNICATIONMODE_MASTER successBlock:^{
                
                [self getDeviceInfoSuccess:^{
                    if (SearchMPOSEnterType == SearchMPOSEnterTypeSetting) {
                        [self performSelectorOnMainThread:@selector(showMessage:) withObject:@"" waitUntilDone:YES];
                    }
                    else if (SearchMPOSEnterType == SearchMPOSEnterTypeDeal) {
                        [self performSelectorOnMainThread:@selector(showMessage:) withObject:@"处理中..." waitUntilDone:YES];
                    }
                    success();
                } failure:^(NSString *errInfo) {
                    [MBProgressHUD hideHUD];
                    failure(errInfo);
                }];
                
            } failedBlock:^(NSString *errCode, NSString *errInfo) {
                [MBProgressHUD hideHUD];
                failure(errInfo);
            }];
        } 
    }else{//没有连接设备进入 设备搜索界面
        if (viewController == nil) {
            failure(nil);
            return;
        }
        QHSelectVersionViewController *selectVersionVC = [[QHSelectVersionViewController alloc] init];
        selectVersionVC.selecType = setType;
        [viewController.navigationController pushViewController:selectVersionVC animated:YES];
    }
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    if (central.state == CBCentralManagerStatePoweredOn){
   
    
    }
}

- (void)getDeviceInfoSuccess:(void (^)())success failure:(void (^)(NSString * errInfo))failure{
    [manager getDeviceInfo:^(LDC_DeviceInfo *deviceInfo) {
        [[[YRRequestDeviceTool alloc] init] hanlePOSFlowNumber:nil operationType:HandleFlowNumberType_Get successBlock:^(NSString *serialNO) {
            //读取SN，流水号等信息并存到单例中
            
            loginManager.supportPrinter = deviceInfo.terminalConfig.isSuportPrinter;
            loginManager.unsVersion = deviceInfo.userSoftVer;
            loginManager.productSN = deviceInfo.productSN;
            loginManager.deviceType = deviceInfo.deviceType;
            loginManager.PSEQ = serialNO;
            [[YRDeviceRelative shareDeviceRelative] getSNMessageSuccessBlock:^(NSDictionary *dict) {
                success();
            } failureBlock:^(NSString *errorInfo) {
                failure(errorInfo);
            }];
        } failureBlock:^(NSString *errInfo) {
            failure(errInfo);
        }];
    } failedBlock:^(NSString *errCode, NSString *errInfo) {
        failure(errInfo);
    }];
}

@end
