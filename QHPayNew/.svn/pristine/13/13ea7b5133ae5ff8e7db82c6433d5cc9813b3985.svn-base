//
//  YRSearchMPOSController.h
//  YunRichMPCR
//
//  Created by YunRich on 15/4/15.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QHPayBaseViewController.h"
typedef enum {
    SearchMPOSEnterTypeDefult,
    SearchMPOSEnterTypeLogin,
    SearchMPOSEnterTypeRegister,
    SearchMPOSEnterTypeDeal,
    SearchMPOSEnterTypeBank, //e管家银行卡
    SearchMPOSEnterTypeSetting,
    SearchMPOSEnterTypePromote,
    SearchMPOSEnterTypeSettingForLoadingMainKey,
    SearchMPOSEnterTypeChangeNumber
}SearchMPOSEnterType;

//区分设备型号
typedef enum {
    Landi_M35,
    Landi_M15,
    Landi_M36,
    XDL_ME11
}DeviceVersion;

@interface YRSearchMPOSController : QHPayBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) SearchMPOSEnterType searchMPOSEnterType;

@property (nonatomic,assign) DeviceVersion deviceVersion;

- (void)getDeviceInfo;
@end
