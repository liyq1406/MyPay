//
//  YRBondDeviceController.h
//  YunRichMPCR
//
//  Created by YunRich on 15/5/16.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QHPayBaseViewController.h"
typedef NS_ENUM(NSInteger, LoadingKeyType) {

    LoadingKeyType_Checkins,// 设置界面进入 签到 灌装工作密钥
    LoadingKeyType_Initization, // 设备初始化
    LoadingKeyType_Pay, //支付界面进入
};

typedef enum {
    PosSequenceType9006,
    PosSequenceType9007,
    PosSequenceType9008,
    PosSequenceType9009,
    PosSequenceTypeFinish,
}PosSequenceType;

@interface YRBondDeviceController : QHPayBaseViewController

@property (assign, nonatomic) LoadingKeyType loadingType;
@property (assign, nonatomic) PosSequenceType posSequenceType;

- (void)sendOut9006;
- (void)sendOut9007;
- (void)sendOut9008;

@end
