//
//  YRTransactionMessageRequest.h
//  YunRichMPCR
//
//  Created by 李向阳 on 15/4/8.
//  Copyright (c) 2015年 yunrich. All rights reserved.
//

#import "YRBaseRequest.h"

typedef enum {
    MessageType9006,
    MessageType9009,
    MessageType9015,
    MessageType9016,
    MessageType9017,
    MessageType1001,
}MessageType;

@interface YRTransactionRequest : YRBaseRequest

@property (nonatomic, assign) MessageType messageType;

// 获取 MD5补充串  用来为下面六个接口加密
- (void)getMD5SupportStringSuccessBlock:(void (^)(id))successBlock failureBlock:(void (^)(NSString * errInfo))failureBlock;

//秘钥管理阶段获取
- (void)manageStageForLoadingKey:(NSDictionary *)dictParameters successBlock:(void (^) (id responseObject))successBlock failureBlock:(void (^) (NSString * errInfo))failureBlock;

// 9006 获取密钥  需要序列化
- (void)getMainKey:(NSDictionary *)dictParameters successBlock:(void (^) (id responseObject))successBlock failureBlock:(void (^) (NSString * errInfo))failureBlock;

// 9007 通知后台密钥加载完成   需要序列化
- (void)remindBackendSuccessToLoadKey:(NSDictionary *)dictParameters successBlock:(void (^) (id responseObject))successBlock failureBlock:(void (^) (NSString * errInfo))failureBlock;

// 9008 终端绑定 POS 设备号和终端号  需要序列化
- (void)bindingPOSDevice:(NSDictionary *)dictParameters successBlock:(void (^) (id responseObject))successBlock failureBlock:(void (^) (NSString * errInfo))failureBlock;

// 9009 签到    需要序列化
- (void)signOn:(NSDictionary *)dictParameters successBlock:(void (^) (id responseObject))successBlock failureBlock:(void (^) (NSString * errInfo))failureBlock;

// 9015 公玥下载   需要序列化
- (void)getPublicKey:(NSDictionary *)dictParameters successBlock:(void (^) (id responseObject))successBlock failureBlock:(void (^) (NSString * errInfo))failureBlock;

// 9016 参数下载  需要序列化
- (void)getParameter:(NSDictionary *)dictParameters successBlock:(void (^) (id responseObject))successBlock failureBlock:(void (^) (NSString * errInfo))failureBlock;

// 9017 TC上送 需要序列化
- (void)uploadTC:(NSDictionary *)dictParameters successBlock:(void (^) (id responseObject))successBlock failureBlock:(void (^) (NSString * errInfo))failureBlock;


// 1001 交易报文
- (void)getTransactionMessage:(NSDictionary *)dictParameters successBlock:(void (^) (id responseObject))successBlock failureBlock:(void (^) (NSString * errInfo))failureBlock ;

// pos 交易流水获取
- (void)getPOSTransactionFlow:(NSDictionary *)dictParameters successBlock:(void (^) (id responseObject))successBlock failureBlock:(void (^) (NSString * errInfo))failureBlock ;

// 查询交易记录
- (void)queryTransactionRecords:(NSDictionary *)dictParameters successBlock:(void (^)(id))successBlock failureBlock:(void (^)(NSString * errInfo))failureBlock;

// 交易明细 详情
- (void)queryTransactionDetail:(NSDictionary *)dictParameters successBlock:(void (^)(id))successBlock failureBlock:(void (^)(NSString * errInfo))failureBlock;

- (NSString *)getSubClassName;
@end
