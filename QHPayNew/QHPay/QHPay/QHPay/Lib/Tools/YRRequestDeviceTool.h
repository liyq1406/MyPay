//
//  YRRequestDevice.h
//  YunRichMPCR
//
//  Created by YunRich on 15/4/21.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LandiMPOS.h"

typedef NS_ENUM(int, HandleFlowNumberType) {
    
    HandleFlowNumberType_Save = 0,
    HandleFlowNumberType_Get = 1
};

typedef enum{
    payTypeQuick,//快速收款
    payTypeSett,//结算收款
    payTypeXfcz,//消费冲正
}PayType;

@class YRRequestDeviceTool,YRTransactionMessage;
@protocol YRRequestDeviceDelegate <NSObject>
@optional
- (void)requestDeviceTool:(YRRequestDeviceTool *)requestDeviceTool transMessage:(YRTransactionMessage *)transMessage;
- (void)inputDealPWD;
@end

@interface YRRequestDeviceTool : NSObject


@property (nonatomic, strong) UIViewController * uivc;

@property (nonatomic, strong) NSString *cardNum;//卡号
@property (nonatomic, strong) NSString * moneyNum;//金额
@property (nonatomic, strong) NSString * servicePoint;//服务点
@property (nonatomic, strong) NSString * serialNO;//流水号
@property (nonatomic, strong) NSString * password;//密码
@property (nonatomic, strong) NSString * posID;//posID
@property (nonatomic, strong) NSString * orderID;//订单号
@property (nonatomic, assign) PayType payType;
@property (nonatomic, weak) id <YRRequestDeviceDelegate> delegate;

@property (nonatomic, strong) NSString * gyjOrd;//订单号
@property (nonatomic, strong) NSString * gyjCard;//卡号
@property (nonatomic, strong) NSString * gyjCardStar;//星卡号
@property (nonatomic, strong) NSString * gyjcustId;
@property (nonatomic, strong) NSString * gyjExp;// 卡有效期	4	格式为YYMM
@property (nonatomic, strong) NSString * gyjICSEQ;//IC卡序列号
@property (nonatomic, strong) NSString * gyjIC;//IC卡数据	C		同原交易
@property (nonatomic, strong) NSString * gyjPR;//pr
@property (nonatomic, strong) NSString * gyjSensStr;

@property (nonatomic, strong) NSString * gyjIC_TC;//TC上送时的IC


#pragma mark 拼接密钥
+(NSString *)appendKey:(NSString *)key KVC:(NSString *)KVC;

#pragma mark 导入密钥
+ (void)loadKey:(NSString *)key keyType:(LDE_KEYTYPE)keyType success:(void (^)())success failure:(void (^)(NSString * errInfo))failure;

#pragma mark 导入IC卡公钥
+ (void)downloadPublicKey:(NSString*)publicKey num:(NSInteger)num success:(void (^)())success failure:(void (^)(NSString * errInfo))failure;

#pragma mark 导入IC卡参数
+ (void)downloadAid:(NSString *)aid num:(NSInteger)num success:(void (^)())success failure:(void (^)(NSString * errInfo))failure;

#pragma mark 开始交易
- (void)beginDealWithMoenyNum:(NSString *)moneyNum payType:(PayType)payType;

#pragma mark 音频交易 传入密码
- (void)passDealPWD:(NSString *)password;

#pragma mark 存取流水号

- (void)hanlePOSFlowNumber:(NSString *)flowNum operationType:(HandleFlowNumberType)type successBlock:(void (^)(NSString * serialNO))successBlock failureBlock:(void (^)(NSString * errInfo))failureBlock;

#pragma mark 消费冲正
//-(void)xfcz: (NSString *)ordXZ;

#pragma mark 消费前参数传递--
- (void)initWithVC:(UIViewController *)uivc;

#pragma mark 校验消费返回结果
-(void)checkData:(NSString *)IC jsonB:(NSMutableDictionary *)jsonB;

#pragma mark 停止交易
-(void)PBOCStop;

#pragma mark 退货成功PBOC
-(void)returnData:(NSString *)IC jsonB:(NSMutableDictionary *)jsonB;

-(void)ESign; //e电签

@end
