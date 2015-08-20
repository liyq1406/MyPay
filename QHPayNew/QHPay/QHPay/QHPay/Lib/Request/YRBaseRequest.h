//
//  BaseRequest.h
//  YunRichMPCR
//
//  Created by YunRich on 15/4/7.
//  Copyright (c) 2015年 yunrich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "JSONModel.h"

typedef enum {
    
    MessageEncryptionMode_None, //session
    MessageEncryptionMode_General, //登入前需要macStr
    MessageEncryptionMode_LoadMainKey //交易
    
}MessageEncryptionMode;


@interface YRBaseRequest : NSObject

@property (strong, nonatomic) AFHTTPRequestOperation * requestOperation;
@property (assign, nonatomic) BOOL isResponseNeedSerialized;
@property (assign, nonatomic) BOOL isMessageNeedCalculateMacValue;

@property (assign, nonatomic) MessageEncryptionMode messageEncryptionMode;

// common post request  通用的post请求
- (void)processServiceRequestPostURL:(NSString *)requestURL parameters:(NSDictionary *)dictParameters successBlock:(void (^)(id))successBlock failureBlock:(void (^)(NSString *errInfo))failureBlock;

// upload file   处理多个图片文件的请求
- (void)processUploadMultiPartRequestURL:(NSString *)requestURL parameters:(NSDictionary *)dictParameters imageKeyFiles:(NSDictionary *)imageDict successBlock:(void (^)(id responseObject))successBlock failureBlock:(void (^)(NSString *errInfo))failureBlock;

// download file  下载文件成功后  此处只返回一个文件路径
- (void)processDownloadTaskRequestWithURL:(NSString *)requestURL successBlock:(void (^)(id responseObject))successBlock failureBlock:(void (^)(NSString *errInfo))failureBlock;


- (void)processLoanWithURLStr:(NSString *)urlStr parameters:(NSDictionary *)dictParameters successBlock:(void (^)(id responseObject))successBlock failureBlock:(void (^)(NSString *errInfo))failureBlock;

- (NSString *)getSubClassName;

- (void)cancel;

@end

