//
//  YRDrawCashRequest.m
//  YunRichMPCR
//
//  Created by 李向阳 on 15/4/8.
//  Copyright (c) 2015年 yunrich. All rights reserved.
//

#import "YRDrawCashRequest.h"

@implementation YRDrawCashRequest

// 提现
- (void)drawCash:(NSDictionary *)parameters successBlock:(void (^)(id responseObject))successBlock failureBlock:(void (^)(NSString *errInfo))failureBlock {
    
    self.messageEncryptionMode = MessageEncryptionMode_None;
    [self processServiceRequestPostURL:URL_WITHDRAW_CASH parameters:parameters successBlock:successBlock failureBlock:failureBlock];
}

// 提现查询
- (void)queryDrawCashRecords:(NSDictionary *)parameters successBlock:(void (^)(id responseObject))successBlock failureBlock:(void (^)(NSString *errInfo))failureBlock {
    
    self.messageEncryptionMode = MessageEncryptionMode_General;
    [self processServiceRequestPostURL:URL_QUERY_WITHDRAW_CASH_RECORDS parameters:parameters successBlock:successBlock failureBlock:failureBlock];
}

// T ＋ 0 提现权限查询
- (void)queryAuthorityForDrawCash:(NSDictionary *)parameters successBlock:(void (^)(id responseObject))successBlock failureBlock:(void (^)(NSString *errInfo))failureBlock {
    
    self.messageEncryptionMode = MessageEncryptionMode_None;
    [self processServiceRequestPostURL:URL_QUERY_AUTHORITY_WITHDRAW_CASH parameters:parameters successBlock:successBlock failureBlock:failureBlock];
}

// T + 0 申请提现权限
- (void)applyDrawCash:(NSDictionary *)parameters successBlock:(void (^)(id responseObject))successBlock failureBlock:(void (^)(NSString *errInfo))failureBlock {
    
    self.messageEncryptionMode = MessageEncryptionMode_None;
    [self processServiceRequestPostURL:URL_PLAY_WITHDRAW_CASH parameters:parameters successBlock:successBlock failureBlock:failureBlock];
}

// 取现手续费 试算
- (void)calculateFee:(NSDictionary * )parameters successBlock:(void (^)(id responseObject))successBlock failureBlock:(void (^)(NSString *errInfo))failureBlock {
    
    self.messageEncryptionMode = MessageEncryptionMode_General;
    [self processServiceRequestPostURL:URL_CALCULATE_FEE parameters:parameters successBlock:successBlock failureBlock:failureBlock];
}

//申请贷款
- (void)provideALoan:(NSDictionary * )parameters successBlock:(void (^)(id responseObject))successBlock failureBlock:(void (^)(NSString *errInfo))failureBlock {
    self.isResponseNeedSerialized = YES;
    self.messageEncryptionMode = MessageEncryptionMode_None;
    [self processLoanWithURLStr:URL_PROVIDE_LOAN parameters:parameters successBlock:successBlock failureBlock:failureBlock];
}

- (NSString *)getSubClassName{
    return nil;
}

@end
