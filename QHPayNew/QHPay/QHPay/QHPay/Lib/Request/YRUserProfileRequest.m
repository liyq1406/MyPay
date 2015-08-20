//
//  YRUserProfileRequest.m
//  YunRichMPCR
//
//  Created by 李向阳 on 15/4/8.
//  Copyright (c) 2015年 yunrich. All rights reserved.
//

#import "YRUserProfileRequest.h"

@implementation YRUserProfileRequest

// 获取个人信息

- (void)getUserProfileInformation:(NSDictionary *)parameters successBlock:(void (^)(id))successBlock failureBlock:(void (^)(NSString * errInfo))failureBlock
{
    self.userProfileType = UserProfileTypePersonMessage;
    self.isResponseNeedSerialized = YES;
    self.messageEncryptionMode = MessageEncryptionMode_None;
    [self processServiceRequestPostURL:URL_GET_USER_PROFILE parameters:parameters successBlock:successBlock failureBlock:failureBlock];
}

// 获取手机验证码
- (void)getVertificationCode:(NSDictionary *)parameters successBlock:(void (^)(id responseObject))successBlock failureBlock:(void (^)(NSString * errInfo))failureBlock {
    
    self.messageEncryptionMode = MessageEncryptionMode_General;
    [self processServiceRequestPostURL:URL_GET_PHONE_VERIFICATION_CODE parameters:parameters successBlock:successBlock failureBlock:failureBlock];
}

// 注册
- (void)registerAccount:(NSDictionary *)parameters successBlock:(void (^) (id responseObject))successBlock failureBlock:(void (^) (NSString * errInfo))failureBlock {
    
    self.messageEncryptionMode = MessageEncryptionMode_General;
    [self processServiceRequestPostURL:URL_REGISTER parameters:parameters successBlock:successBlock failureBlock:failureBlock];
}

// 忘记密码 重置
- (void)forgetAndResetPassword:(NSDictionary *)parameters successBlock:(void (^) (id responseObject))successBlock failureBlock:(void (^) (NSString * errInfo))failureBlock {
    
    self.messageEncryptionMode = MessageEncryptionMode_General;
    [self processServiceRequestPostURL:URL_RESET_PASSWORD parameters:parameters successBlock:successBlock failureBlock:failureBlock];
}

// 登录
- (void)logIn:(NSDictionary *)parameters successBlock:(void (^) (id responseObject))successBlock failureBlock:(void (^) (NSString * errInfo))failureBlock {
    
    self.messageEncryptionMode = MessageEncryptionMode_General;
    [self processServiceRequestPostURL:URL_LOGIN parameters:parameters successBlock:successBlock failureBlock:failureBlock];
}

// 更改密码
- (void)changePassword:(NSDictionary *)parameters successBlock:(void (^)(id responseObject))successBlock failureBlock:(void (^)(NSString * errInfo))failureBlock {
    
    self.messageEncryptionMode = MessageEncryptionMode_General;
    [self processServiceRequestPostURL:URL_CHANGE_PASSWORD parameters:parameters successBlock:successBlock failureBlock:failureBlock];
}

// 商户开通  多图
- (void)openAccount:(NSDictionary *)dictParameters imageKeyFiles:(NSDictionary *)imagesDict successBlock:(void (^)(id responseObject))successBlock failureBlock:(void (^)(NSString * errInfo))failureBlock   {
    
    self.messageEncryptionMode = MessageEncryptionMode_None;
    [self processUploadMultiPartRequestURL:URL_OPEN_ACCOUNT parameters:dictParameters imageKeyFiles:imagesDict successBlock:successBlock failureBlock:failureBlock];
}

// 额度提升 申请  多图
- (void)applyPromoteLimit:(NSDictionary *)dictParameters imageKeyFiles:(NSDictionary *)imagesDict successBlock:(void (^)(id responseObject))successBlock failureBlock:(void (^)(NSString * errInfo))failureBlock {
    
    self.messageEncryptionMode = MessageEncryptionMode_None;
    [self processUploadMultiPartRequestURL:URL_APPLY_PROMOTE_LIMIT parameters:dictParameters imageKeyFiles:imagesDict successBlock:successBlock failureBlock:failureBlock];
}

// 上传 签名
- (void)uploadSignature:(NSDictionary *)dictParameters imageKeyFiles:(NSDictionary *)imagesDict successBlock:(void (^)(id responseObject))successBlock failureBlock:(void (^)(NSString * errInfo))failureBlock  {
    
    self.messageEncryptionMode = MessageEncryptionMode_General;
    [self processUploadMultiPartRequestURL:URL_UPLOAD_SIGNATURE_FILE parameters:dictParameters imageKeyFiles:imagesDict successBlock:successBlock failureBlock:failureBlock];
}

// 判断 省份数据是否需要更新
- (void)judgeStaticDataIsNeedUpdate:(NSDictionary *)parameters successBlock:(void (^) (id responseObject))successBlock failureBlock:(void (^) (NSString * errInfo))failureBlock {
    
    self.messageEncryptionMode = MessageEncryptionMode_General;
    [self processServiceRequestPostURL:URL_JUDGE_PROVICE_IS_NEED_UPDATE parameters:parameters successBlock:successBlock failureBlock:failureBlock];
}

// 更新 省份数据
- (void)updateProviceData:(NSDictionary *)parameters successBlock:(void (^) (id responseObject))successBlock failureBlock:(void (^) (NSString * errInfo))failureBlock {

    self.messageEncryptionMode = MessageEncryptionMode_General;
    [self processServiceRequestPostURL:URL_GET_PROVICE_CITY_AREA parameters:parameters successBlock:successBlock failureBlock:failureBlock];
}

// App 更新
- (void)judgeAppVersionIsNeedUpdate:(NSDictionary *)parameters successBlock:(void (^) (id responseObject))successBlock failureBlock:(void (^) (NSString * errInfo))failureBlock {
    
    self.messageEncryptionMode = MessageEncryptionMode_General;
    [self processServiceRequestPostURL:URL_JUDGE_APP_IS_NEED_UPDATE parameters:parameters successBlock:successBlock failureBlock:failureBlock];
}

// 获取 MCCCODE

- (void)getMccCode:(NSDictionary *)parameters successBlock:(void (^) (id responseObject))successBlock failureBlock:(void (^) (NSString * errInfo))failureBlock {
    
    self.messageEncryptionMode = MessageEncryptionMode_General;
    [self processServiceRequestPostURL:URL_GET_MCCCODE parameters:parameters successBlock:successBlock failureBlock:failureBlock];
}

- (NSString *)getSubClassName {
    switch (self.userProfileType) {
        case UserProfileTypePersonMessage:
            return @"YRPersonMessage";
            break;
            
        default:
            break;
    }
}

@end
