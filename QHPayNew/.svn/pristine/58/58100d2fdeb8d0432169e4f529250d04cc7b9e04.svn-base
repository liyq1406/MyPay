//
//  YRTransactionMessageRequest.m
//  YunRichMPCR
//
//  Created by 李向阳 on 15/4/8.
//  Copyright (c) 2015年 yunrich. All rights reserved.
//

#import "YRTransactionRequest.h"
#import "YRMD5Encryption.h"

@implementation YRTransactionRequest

- (void)getMD5SupportStringSuccessBlock:(void (^)(id))successBlock failureBlock:(void (^)(NSString * errInfo))failureBlock {
    
//    self.isInitingCardKey = YES;
    NSDictionary * dictParameters = @{YR_INPUT_KEY_VER : YR_INPUT_VALUE_VER};
    [self processServiceRequestPostURL:URL_GET_SN_MESSAGE parameters:dictParameters successBlock:successBlock failureBlock:failureBlock];
}

//秘钥管理阶段获取
- (void)manageStageForLoadingKey:(NSDictionary *)dictParameters successBlock:(void (^) (id responseObject))successBlock failureBlock:(void (^) (NSString * errInfo))failureBlock {
    
    self.messageEncryptionMode = MessageEncryptionMode_None;
    [self processServiceRequestPostURL:URL_MANAGE_STAGE_LOADING_KEY parameters:dictParameters successBlock:successBlock failureBlock:failureBlock];
}

// 9006 获取主密钥  需要序列化
- (void)getMainKey:(NSDictionary *)dictParameters successBlock:(void (^) (id responseObject))successBlock failureBlock:(void (^) (NSString * errInfo))failureBlock {
    self.messageType = MessageType9006;
    self.messageEncryptionMode = MessageEncryptionMode_LoadMainKey;
    self.isResponseNeedSerialized = YES;
    [self processServiceRequestPostURL:URL_GET_MAIN_KEY parameters:dictParameters successBlock:successBlock failureBlock:failureBlock];
}

// 9007 通知后台密钥加载完成   需要序列化
- (void)remindBackendSuccessToLoadKey:(NSDictionary *)dictParameters successBlock:(void (^) (id responseObject))successBlock failureBlock:(void (^) (NSString * errInfo))failureBlock {
    
    self.messageEncryptionMode = MessageEncryptionMode_LoadMainKey;
    
    [self processServiceRequestPostURL:URL_CONFIRM_FINISH_LOAD_MAIN_KEY parameters:dictParameters successBlock:successBlock failureBlock:failureBlock];
}

// 9008 终端绑定 POS 设备号和终端号  需要序列化
- (void)bindingPOSDevice:(NSDictionary *)dictParameters successBlock:(void (^) (id responseObject))successBlock failureBlock:(void (^) (NSString * errInfo))failureBlock {
    
    self.messageEncryptionMode = MessageEncryptionMode_LoadMainKey;
    
    [self processServiceRequestPostURL:URL_BINDING_POS_DEVICE parameters:dictParameters successBlock:successBlock failureBlock:failureBlock];
}

// 9009 签到 获取工作密钥    需要序列化
- (void)signOn:(NSDictionary *)dictParameters successBlock:(void (^) (id responseObject))successBlock failureBlock:(void (^) (NSString * errInfo))failureBlock {
    self.messageType = MessageType9009;
    self.messageEncryptionMode = MessageEncryptionMode_LoadMainKey;
    self.isResponseNeedSerialized = YES;
    [self processServiceRequestPostURL:URL_GET_WORK_KEY parameters:dictParameters successBlock:successBlock failureBlock:failureBlock];
}

// 9015 公玥下载   需要序列化
- (void)getPublicKey:(NSDictionary *)dictParameters successBlock:(void (^) (id responseObject))successBlock failureBlock:(void (^) (NSString * errInfo))failureBlock {
    
    self.messageType = MessageType9015;
    self.messageEncryptionMode = MessageEncryptionMode_LoadMainKey;
    self.isResponseNeedSerialized = YES;
    [self processServiceRequestPostURL:URL_GET_PUBLIC_KEY parameters:dictParameters successBlock:successBlock failureBlock:failureBlock];
}

// 9016 参数下载  需要序列化
- (void)getParameter:(NSDictionary *)dictParameters successBlock:(void (^) (id responseObject))successBlock failureBlock:(void (^) (NSString * errInfo))failureBlock {
    
    self.messageType = MessageType9016;
    self.messageEncryptionMode = MessageEncryptionMode_LoadMainKey;
    self.isResponseNeedSerialized = YES;
    [self processServiceRequestPostURL:URL_GET_PARAMETER parameters:dictParameters successBlock:successBlock failureBlock:failureBlock];
}

// 9017 TC上送 需要序列化
- (void)uploadTC:(NSDictionary *)dictParameters successBlock:(void (^) (id responseObject))successBlock failureBlock:(void (^) (NSString * errInfo))failureBlock {
    self.messageType = MessageType9017;
    self.isMessageNeedCalculateMacValue = YES;
//    self.isResponseNeedSerialized = YES;
    self.messageEncryptionMode = MessageEncryptionMode_LoadMainKey;
    [YRMD5Encryption calculateMacValue:dictParameters successBlock:^(NSDictionary *dict) {
        [self processServiceRequestPostURL:URL_UPLOAD_TC parameters:dict successBlock:successBlock failureBlock:failureBlock];
    } failureBlock:^(NSString *errInfo) {
        failureBlock(errInfo);
    }];
}

// 1001 交易报文
- (void)getTransactionMessage:(NSDictionary *)dictParameters successBlock:(void (^)(id responseObject))successBlock failureBlock:(void (^)(NSString * errInfo))failureBlock  {
    
    self.messageType = MessageType1001;
    self.isMessageNeedCalculateMacValue = YES;
    self.isResponseNeedSerialized = YES;
    self.messageEncryptionMode = MessageEncryptionMode_LoadMainKey;
    [YRMD5Encryption calculateMacValue:dictParameters successBlock:^(NSDictionary *dict) {
        [self processServiceRequestPostURL:URL_GET_TRANSACTION_MESSAGE parameters:dict successBlock:successBlock failureBlock:failureBlock];
    } failureBlock:^(NSString *errInfo) {
        failureBlock(errInfo);
    }];
}
// pos 交易流水获取
- (void)getPOSTransactionFlow:(NSDictionary *)dictParameters successBlock:(void (^)(id responseObject))successBlock failureBlock:(void (^)(NSString * errInfo))failureBlock  {
    
    [self processServiceRequestPostURL:URL_GET_POS_TRANSACTION_FLOW parameters:dictParameters successBlock:successBlock failureBlock:failureBlock];
}

// 交易订单详情
- (void)queryTransactionDetail:(NSDictionary *)dictParameters successBlock:(void (^)(id responseObject))successBlock failureBlock:(void (^)(NSString * errInfo))failureBlock  {
    
    self.isResponseNeedSerialized = YES;
    [self processServiceRequestPostURL:URL_GET_TRANSACTION_ORDER_DETAIL parameters:dictParameters successBlock:successBlock failureBlock:failureBlock];
}

// 交易订单记录
- (void)queryTransactionRecords:(NSDictionary *)dictParameters successBlock:(void (^)(id responseObject))successBlock failureBlock:(void (^)(NSString * errInfo))failureBlock  {
    
    //self.isResponseNeedSerialized = YES;
    self.messageEncryptionMode = MessageEncryptionMode_General;
    [self processServiceRequestPostURL:URL_GET_TRANSACTION_ORDER parameters:dictParameters successBlock:successBlock failureBlock:failureBlock];
}

- (NSString *)getSubClassName {
    switch (self.messageType) {
        case MessageType9006:
            return @"YRMainKey";
            break;
            
        case MessageType9009:
            return @"YRWorkKey";
            break;
            
        case MessageType9015:
            return @"YRICPublicKey";
            break;
            
        case MessageType9016:
            return @"YRICParameter";
            break;
            
        case MessageType9017:
            return @"";
            break;
            
        case MessageType1001:
            return @"YRTransactionMessage";
            break;
            
        default:
            break;
    }
    return nil;
}

@end
