//
//  YRMD5Encryption.h
//  YunRichMPCR
//
//  Created by 李向阳 on 15/4/7.
//  Copyright (c) 2015年 yunrich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

typedef enum {
    PasswordTypeLogin,
    PasswordTypeTrans,
}PasswordType;


@interface YRMD5Encryption : NSObject



+ (NSString *)mainKeyEncryptionUsedMD5WithDictionary:(NSDictionary *)inputParameters;
+ (NSString *)generalEncryptionUsedMD5WithDictionary:(NSDictionary *)inputParameters;

+ (NSString *)mainKeyEncryptionUsedMD5WithString:(NSString *)inputString;
+ (NSString *)generalEncryptionUsedMD5WithString:(NSString *)inputString;


+ (NSString *)encryptionMD5WithPassword:(NSString *)password passwordType:(PasswordType)passwordType;

+ (void)calculateMacValue:(NSDictionary *)dict successBlock:(void (^)(NSDictionary *))successBlock failureBlock:(void (^)(NSString *errInfo))failureBlock;

+ (void)checkTransactionMessageMacStr:(NSString *)macStr jsonStr:(NSString *)jsonStr sucessBlock:(void (^)(BOOL isSuccess))successBlock failureBlock:(void (^)(NSString * errInfo))failureBlock;

// 用于接口传值和存储的加密算法
+(NSString *)TripleDES_decode:(NSString *)encoded_text key:(NSString *)key;
+(NSString *)TripleDES_Encode:(NSString *)encoded_text key:(NSString *)key;

@end
