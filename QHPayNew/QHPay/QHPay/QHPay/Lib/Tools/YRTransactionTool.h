//
//  YRTransactionTool.h
//  YunRichMPCR
//
//  Created by YunRich on 15/4/21.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface YRTransactionTool : NSObject

+ (void)requestFor9006success:(void (^)(id responseObject))success failure:(void (^)(NSString * errInfo))failure;

+ (void)requestFor9007success:(void (^)(id responseObject))success failure:(void (^)(NSString * errInfo))failure;

+ (void)requestFor9008success:(void (^)(id responseObject))success failure:(void (^)(NSString * errInfo))failure;

+ (void)requestFor9009success:(void (^)(id responseObject))success failure:(void (^)(NSString * errInfo))failure;

+ (void)requestFor9015WithINXNum:(int)INXNum success:(void (^)(id responseObject))success failure:(void (^)(NSString * errInfo))failure;

+ (void)requestFor9016WithINXNum:(int)INXNum success:(void (^)(id responseObject))success failure:(void (^)(NSString * errInfo))failure;

+ (void)requestFor9017WithCardNumPlain:(NSString *)cardNumPlain moneyNum:(NSString *)moneyNum PSEQ:(NSString *)PSEQ ICData:(NSString *)icData orderNum:(NSString *)orderNum success:(void (^)(id responseObject))success failure:(void (^)(NSString * errInfo))failure;

- (void)requestFor1001WithCardNumPlain:(NSString *)cardNumPlain moneyNum:(NSString *)moneyNum PSEQ:(NSString *)PSEQ  EXP:(NSString *)EXP ICSEQ:(NSString *)ICSEQ SVR:(NSString *)SVR SENS:(NSString *)SENS IC:(NSString *)IC success:(void (^)(id responseObject))success failure:(void (^)(NSString * errInfo))failure;

+ (NSString *)generateOrderNumberWithPosId:(NSString *)posId transactionFlowNum:(NSString *)flowNum;

+ (NSString *)encryptCardNum:(NSString *)cardNum;



@end
