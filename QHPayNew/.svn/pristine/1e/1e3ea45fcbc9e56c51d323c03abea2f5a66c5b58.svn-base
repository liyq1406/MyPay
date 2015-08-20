//
//  YRDrawCashRequest.h
//  YunRichMPCR
//
//  Created by 李向阳 on 15/4/8.
//  Copyright (c) 2015年 yunrich. All rights reserved.
//

#import "YRBaseRequest.h"

@interface YRDrawCashRequest : YRBaseRequest

// 提现
- (void)drawCash:(NSDictionary *)parameters successBlock:(void (^) (id responseObject))successBlock failureBlock:(void (^) (NSString * errInfo))failureBlock;

// 提现查询
- (void)queryDrawCashRecords:(NSDictionary *)parameters successBlock:(void (^)(id responseObject))successBlock failureBlock:(void (^)(NSString *errInfo))failureBlock;

// T ＋ 0 提现权限查询
- (void)queryAuthorityForDrawCash:(NSDictionary *)parameters successBlock:(void (^)(id responseObject))successBlock failureBlock:(void (^)(NSString *errInfo))failureBlock;

// T + 0 申请提现
- (void)applyDrawCash:(NSDictionary * )parameters successBlock:(void (^)(id responseObject))successBlock failureBlock:(void (^)(NSString *errInfo))failureBlock;

// 取现手续费 试算
- (void)calculateFee:(NSDictionary * )parameters successBlock:(void (^)(id responseObject))successBlock failureBlock:(void (^)(NSString *errInfo))failureBlock;

// 贷款
- (void)provideALoan:(NSDictionary * )parameters successBlock:(void (^)(id responseObject))successBlock failureBlock:(void (^)(NSString *errInfo))failureBlock;

- (NSString *)getSubClassName;
@end
