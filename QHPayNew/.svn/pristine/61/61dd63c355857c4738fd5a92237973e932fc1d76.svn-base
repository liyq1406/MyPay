//
//  YRUserProfileRequest.h
//  YunRichMPCR
//
//  Created by 李向阳 on 15/4/8.
//  Copyright (c) 2015年 yunrich. All rights reserved.
//

#import "YRBaseRequest.h"

typedef enum {
   UserProfileTypePersonMessage,
}UserProfileType;

@interface YRUserProfileRequest : YRBaseRequest

@property (nonatomic, assign)UserProfileType userProfileType;

// 获取个人信息

// 获取个人信息
- (void)getUserProfileInformation:(NSDictionary *)parameters successBlock:(void (^) (id responseObject))successBlock failureBlock:(void (^) (NSString * errInfo))failureBlock;


// 获取手机验证码     AUTHCODE
- (void)getVertificationCode:(NSDictionary *)parameters successBlock:(void (^) (id responseObject))successBlock failureBlock:(void (^) (NSString * errInfo))failureBlock;

// 注册
- (void)registerAccount:(NSDictionary *)parameters successBlock:(void (^) (id responseObject))successBlock failureBlock:(void (^) (NSString * errInfo))failureBlock;

// 忘记密码 重置
- (void)forgetAndResetPassword:(NSDictionary *)parameters successBlock:(void (^) (id responseObject))successBlock failureBlock:(void (^) (NSString * errInfo))failureBlock;

// 登录
- (void)logIn:(NSDictionary *)parameters successBlock:(void (^) (id responseObject))successBlock failureBlock:(void (^) (NSString * errInfo))failureBlock;

// 更改密码
- (void)changePassword:(NSDictionary *)parameters successBlock:(void (^) (id responseObject))successBlock failureBlock:(void (^) (NSString * errInfo))failureBlock;

// 商户开通  多图
- (void)openAccount:(NSDictionary *)dictParameters imageKeyFiles:(NSDictionary *)imagesDict successBlock:(void (^)(id responseObject))successBlock failureBlock:(void (^)(NSString * errInfo))failureBlock;

// 额度提升 申请
- (void)applyPromoteLimit:(NSDictionary *)dictParameters imageKeyFiles:(NSDictionary *)imagesDict successBlock:(void (^)(id responseObject))successBlock failureBlock:(void (^)(NSString * errInfo))failureBlock;

// 上传 签名 图
- (void)uploadSignature:(NSDictionary *)dictParameters imageKeyFiles:(NSDictionary *)imagesDict successBlock:(void (^)(id responseObject))successBlock failureBlock:(void (^)(NSString * errInfo))failureBlock;

- (NSString *)getSubClassName;

// 判断 省份数据是否需要更新
- (void)judgeStaticDataIsNeedUpdate:(NSDictionary *)parameters successBlock:(void (^) (id responseObject))successBlock failureBlock:(void (^) (NSString * errInfo))failureBlock;

// 更新 省份数据
- (void)updateProviceData:(NSDictionary *)parameters successBlock:(void (^) (id responseObject))successBlock failureBlock:(void (^) (NSString * errInfo))failureBlock;

// App 更新
- (void)judgeAppVersionIsNeedUpdate:(NSDictionary *)parameters successBlock:(void (^) (id responseObject))successBlock failureBlock:(void (^) (NSString * errInfo))failureBlock;

// 获取 MCCCODE

- (void)getMccCode:(NSDictionary *)parameters successBlock:(void (^) (id responseObject))successBlock failureBlock:(void (^) (NSString * errInfo))failureBlock;

@end
