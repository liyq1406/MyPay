//
//  AppDelegate.m
//  QHPay
//
//  Created by chenlizhu on 15/7/13.
//  Copyright (c) 2015年 chenlizhu. All rights reserved.
//

#import "AppDelegate.h"
#import "QHNavigationController.h"
#import "QHLoginController.h"
#import "YRSwitchEnviroment.h"
#import "YRUserProfileRequest.h"
#import "YRMD5Encryption.h"
#import "YRRequestTool.h"
@interface AppDelegate ()<UIAlertViewDelegate>
{
    BOOL _appIsConnectDevice;
    LandiMPOS * _liandiMPOS;
    NSString * _downloadLink;
    NSString * _companyName;//记录公司的名字
    NSTimer * _tcTimer;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self saveIPAndSaltValue]; //配置环境
    [self umengTrack];
    [self deleteRequestCookie];
    [self judgeCompanyName];
    [self updateApp];
    NSLog(@"%@",[[LandiMPOS getInstance] getLibVersion]);
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    QHLoginController *qhLogin = [[QHLoginController alloc] initWithNibName:@"QHLoginController" bundle:nil];
    QHNavigationController *qhNav = [[QHNavigationController alloc] initWithRootViewController:qhLogin];
    qhNav.navigationBarHidden = YES;
    self.window.rootViewController = qhNav;
    
     self.window.backgroundColor = [UIColor whiteColor];
     [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark -- 判断公司的名字
- (void)judgeCompanyName {
    NSString *companyStr = [[NSBundle mainBundle] bundleIdentifier];
    if ([companyStr isEqualToString:@"com.qianhai.qhpay"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"QHPay" forKey:COMPANYNAME];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else if ([companyStr isEqualToString:@"com.yuanda.ydpay"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"YDPay" forKey:COMPANYNAME];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark -- 友盟统计
- (void)umengTrack{
    [MobClick startWithAppkey:MOBCLICK_APPKEY reportPolicy:BATCH channelId:@"itms-services"];//友盟统计
    NSString *version = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick setCrashReportEnabled:YES];
    [MobClick setBackgroundTaskEnabled:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
}


- (void)onlineConfigCallBack:(NSNotification *)note {
    
    NSLog(@"online config has fininshed and note = %@", note.userInfo);
}

#pragma mark -- 第一次使用  存储静态 数据

- (void)saveIPAndSaltValue {
    YRSwitchEnviroment * switchEnviroment = [YRSwitchEnviroment shareSwitchEnviroment];
#if defined(RELEASE)
    switchEnviroment.server_MTP_IP = SERVER_MTP_HOST_Relese_IP;
    switchEnviroment.server_ZFPad_IP = SERVER_ZFPAD_HOST_Relese_IP;
    switchEnviroment.supply_MD5Salt = SP_SUPPLY_MD5Salt_Release;
#elif defined(DEBUG_TEST)
    switchEnviroment.server_MTP_IP = SERVER_MTP_HOST_Test_IP;
    switchEnviroment.server_ZFPad_IP = SERVER_ZFPAD_HOST_Test_IP;
    switchEnviroment.supply_MD5Salt = SP_SUPPLY_MD5Salt_Test;
#elif defined(LOCAL)
    switchEnviroment.server_MTP_IP = SERVER_MTP_HOST_Local_IP;
    switchEnviroment.server_ZFPad_IP = SERVER_ZFPAD_HOST_Test_IP;
    switchEnviroment.supply_MD5Salt = SP_SUPPLY_MD5Salt_Test;
#else 
    switchEnviroment.server_MTP_IP = SERVER_MTP_HOST_Relese_IP;
    switchEnviroment.server_ZFPad_IP = SERVER_ZFPAD_HOST_Relese_IP;
    switchEnviroment.supply_MD5Salt = SP_SUPPLY_MD5Salt_Release;
#endif
}

#pragma mark -- App更新
- (void)updateApp {
    
    YRUserProfileRequest * profileRquest = [[YRUserProfileRequest alloc] init];
    NSDictionary * infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString * currentVersion = infoDict[@"CFBundleShortVersionString"];
    NSDictionary * parameters = nil;
    NSString *companyName = [[NSUserDefaults standardUserDefaults] objectForKey:COMPANYNAME];
    if ([companyName isEqualToString:@"YDPay"]) {
        parameters = @{@"CLIENTTYPE":@"YDPAYQ",@"ORGVERSION":currentVersion,@"SOFTTYPE":@"IOS"};
    }
    else if ([companyName isEqualToString:@"QHPay"]) {
        parameters = @{@"ORGVERSION":currentVersion,@"SOFTTYPE":@"IOS"};
    }
    [profileRquest judgeAppVersionIsNeedUpdate:parameters successBlock:^(id responseObject) {
        
        if ([responseObject[YR_OUTPUT_KEY_STATES_RESP_CODE] isEqualToString:YR_STATIC_SUCCESS_STATES_CODE]) {
            
            if ([currentVersion compare:responseObject[@"NEWVERSION"]] == NSOrderedAscending) {
                _downloadLink = responseObject[@"DOWNURL"];
                NSString * flag = responseObject[@"FROCEUPFLAG"];
                
                if ([flag isEqualToString:@"Y"]) {
                    
                    [self handleAppUpdate:responseObject[@"NEWVERSION"]];
                }
            }
        }
        
    } failureBlock:^(NSString *errInfo) {
        
        [YRFunctionTools showAlertViewTitle:nil message:TIPS_MESSAGES cancelButton:TIPS_CONFIRM];
    }];
}

- (void)handleAppUpdate:(NSString *)version {
    
    NSString * newVersion = [NSString stringWithFormat:@"当前有新版本%@可用", version];
    
    UIAlertView * updateAlertView = [[UIAlertView alloc] initWithTitle:nil message:newVersion delegate:self cancelButtonTitle:@"立即更新" otherButtonTitles:nil, nil];
    updateAlertView.tag = 322;
    [updateAlertView show];
}


#pragma mark - 删除缓存
- (void)deleteRequestCookie {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:YR_INPUT_KEY_SESSION_ID];
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *tmpArray = [NSArray arrayWithArray:[cookieJar cookies]];
    for (id obj in tmpArray) {
        [cookieJar deleteCookie:obj];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 322) {
        
        NSString * httpStr = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@",_downloadLink];
        NSURL * url = [NSURL URLWithString:httpStr];
        
        if (buttonIndex == 0) {
            
            [[UIApplication sharedApplication] openURL:url];
        }
    }else if (alertView.tag == 321) {
        
        if (buttonIndex == 0) {
            QHNavigationController * navi = (QHNavigationController *)(self.window.rootViewController);
            [navi popToRootViewControllerAnimated:YES];
        }
    }
}

#pragma mark - 退出登录
- (void)relogIn {
    
    UIAlertView * relogInAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"长时间未操作，请重新登录！" delegate:self cancelButtonTitle:@"登录" otherButtonTitles:nil, nil];
    relogInAlertView.tag = 321;
    [relogInAlertView show];
}

#pragma mark - 生命周期
- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self stopUploadTC];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self fireUploadTC];
}

- (void)applicationWillTerminate:(UIApplication *)application {

}

#pragma mark - TC 循环上送
- (void)fireUploadTC {
    NSArray *localTCParams = [[NSUserDefaults standardUserDefaults] objectForKey:Key_TCParams_Array];
    if (localTCParams != nil && localTCParams.count > 0) {
        if (_tcTimer == nil || ![_tcTimer isValid]) {
            _tcTimer = [NSTimer scheduledTimerWithTimeInterval:120 target:self selector:@selector(startUploadTC) userInfo:nil repeats:NO];
        }
    }
}

- (void)startUploadTC {
    [YRRequestTool cycleUploadTC];
}

- (void)stopUploadTC {
    if ([_tcTimer isValid]) {
        [_tcTimer invalidate];
    }
    _tcTimer = nil;
}

@end
