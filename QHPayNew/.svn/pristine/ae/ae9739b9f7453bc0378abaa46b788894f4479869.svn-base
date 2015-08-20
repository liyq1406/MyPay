//
//  BaseRequest.m
//  YunRichMPCR
//
//  Created by 李向阳 on 15/4/7.
//  Copyright (c) 2015年 yunrich. All rights reserved.
//

#import "YRBaseRequest.h"
#import "YRMD5Encryption.h"
#import "YRLoginManager.h"
#import "MBProgressHUD+MJ.h"
#import "YRSwitchEnviroment.h"
#import "NSString+PSM.h"

@implementation YRBaseRequest
@synthesize requestOperation;

#pragma mark normal post request   通用 post 请求
- (void)processServiceRequestPostURL:(NSString *)requestURL parameters:(NSDictionary *)dictParameters successBlock:(void (^)(id responseObject))successBlock failureBlock:(void (^)(NSString *errInfo))failureBlock
{
    AFHTTPRequestOperationManager * operationManager = [AFHTTPRequestOperationManager manager];
    operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 转换协议的报文形式
    NSDictionary * parameter = nil;
    if (self.isMessageNeedCalculateMacValue) {
        
        parameter = dictParameters;
    }else {
        
        parameter = [self convertJsonDataIntoString:dictParameters];
    }
    NSString * iP_Str = [NSString stringWithFormat:@"%@%@",[YRSwitchEnviroment shareSwitchEnviroment].server_MTP_IP,requestURL];
    NSLog(@"Input Parameters:%@\n requestURL:%@",parameter,iP_Str);
    
    requestOperation = [operationManager POST:iP_Str parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self subResponseString:responseObject successBlock:^(id responseObject) {
            
            successBlock(responseObject);
            
        } failureBlock:^(NSString *errInfo) {
            
            failureBlock(errInfo);
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failureBlock([error localizedDescription]);
    }];
}

#pragma mark 处理贷款的请求
- (void)processLoanWithURLStr:(NSString *)requestURL parameters:(NSDictionary *)dictParameters successBlock:(void (^)(id responseObject))successBlock failureBlock:(void (^)(NSString *errInfo))failureBlock {
    
    AFHTTPRequestOperationManager * operationManager = [AFHTTPRequestOperationManager manager];
    operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 转换协议的报文形式
    NSMutableDictionary * mutableDict = [NSMutableDictionary dictionaryWithDictionary:dictParameters];
    [mutableDict setObject:YR_LOAN_VALUE_VER forKey:YR_INPUT_KEY_VER];
    NSError * error = nil;
    NSData * data = [NSJSONSerialization dataWithJSONObject:mutableDict
                                                    options:NSJSONWritingPrettyPrinted
                                                      error:&error];
    NSString * dictStr = [[NSString alloc] initWithData:data
                                               encoding:NSUTF8StringEncoding];
    [self addSessionIdToCookie];

    dictStr = [NSString stringReplaceSpacingAndLinefeedWithString:dictStr];
  
    NSDictionary * parameter = @{YR_INPUT_KEY_JSONSTR : dictStr};
    NSString * iP_Str = [NSString stringWithFormat:@"%@%@",[YRSwitchEnviroment shareSwitchEnviroment].server_MTP_IP,requestURL];
    NSLog(@"Input Parameters:%@\n requestURL:%@",parameter,iP_Str);
    
    requestOperation = [operationManager POST:iP_Str parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self subResponseString:responseObject successBlock:^(id responseObject) {
            
            successBlock(responseObject);
            
        } failureBlock:^(NSString *errInfo) {
            
            failureBlock(errInfo);
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        failureBlock([error localizedDescription]);
    }];
}

#pragma mark 把json对象转换成 协议的报文格式
- (NSDictionary *)convertJsonDataIntoString:(NSDictionary *)dictParameters {
    
    if (dictParameters) {
        
        NSMutableDictionary * mutableDict = [NSMutableDictionary dictionaryWithDictionary:dictParameters];
        [mutableDict setObject:YR_INPUT_VALUE_VER forKey:YR_INPUT_KEY_VER];
        NSError * error = nil;
        NSData * data = [NSJSONSerialization dataWithJSONObject:mutableDict
                                                        options:NSJSONWritingPrettyPrinted
                                                          error:&error];
        NSString * dictStr = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];

        NSDictionary * parameter = nil;
        switch (self.messageEncryptionMode) {
                
            case MessageEncryptionMode_General:
            {
                NSString * macStr = [YRMD5Encryption generalEncryptionUsedMD5WithDictionary:mutableDict];
                parameter = @{YR_INPUT_KEY_JSONSTR : dictStr,
                              YR_INPUT_KEY_MACSTR : macStr};
            }
                break;
            case MessageEncryptionMode_LoadMainKey:
            {
                NSString * macStr = [YRMD5Encryption mainKeyEncryptionUsedMD5WithDictionary:mutableDict];
                parameter = @{YR_INPUT_KEY_JSONSTR : dictStr,
                              YR_INPUT_KEY_MACSTR : macStr};
            }
                break;
            case MessageEncryptionMode_None:
            {
                [self addSessionIdToCookie];
                parameter = @{YR_INPUT_KEY_JSONSTR : dictStr};
            }
                break;
            default:
                break;
        }
        return parameter;
    }
    return nil;
}

#pragma mark common upload multi files  上传多个文件
- (void)processUploadMultiPartRequestURL:(NSString *)requestURL parameters:(NSDictionary *)dictParameters imageKeyFiles:(NSDictionary *)imageDict successBlock:(void (^)(id responseObject))successBlock failureBlock:(void (^)(NSString * errInfo))failureBlock {
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary * parameters = [self convertJsonDataIntoString:dictParameters];

    NSString * iP_Str = [NSString stringWithFormat:@"%@%@",[YRSwitchEnviroment shareSwitchEnviroment].server_MTP_IP,requestURL];
    
    [manager POST:iP_Str parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSArray * filesArray = [imageDict allKeys];
        for (NSString * imageKey in filesArray) {
            
            NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString * imageName = [dateFormatter stringFromDate:[NSDate date]];
            imageName = [NSString stringWithFormat:@"%@.jpg",imageName];
            
            NSData * data = UIImageJPEGRepresentation(imageDict[imageKey], 0.2);
            [formData appendPartWithFileData:data
                                        name:imageKey
                                    fileName:imageName
                                    mimeType:@"image/jpeg"];
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self subResponseString:responseObject successBlock:^(id responseObject) {
            //
            successBlock(responseObject);
        } failureBlock:^(NSString *errInfo) {
            //
            failureBlock(errInfo);
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failureBlock([error description]);
    }];
}

#pragma mark download
- (void)processDownloadTaskRequestWithURL:(NSString *)requestURL successBlock:(void (^)(id))successBlock failureBlock:(void (^)(NSString * errInfo))failureBlock {
    
    NSString * iP_Str = [NSString stringWithFormat:@"%@%@",[YRSwitchEnviroment shareSwitchEnviroment].server_MTP_IP,requestURL];
    NSURL * url = [NSURL URLWithString:iP_Str];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager * sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSProgress * progress = nil;
    NSURLSessionDownloadTask * downloadTask = [sessionManager downloadTaskWithRequest:request progress:&progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSURL * documentDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                                              inDomain:NSUserDomainMask
                                                                     appropriateForURL:nil
                                                                                create:NO
                                                                                 error:nil];
        return [documentDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        if (error) {
            
            failureBlock([error localizedDescription]);

        }else {
            
            successBlock(filePath);
        }
    }];
    [downloadTask resume];
}

/******************************************************************************************************
 Function : cancel
 Purpose  : cancel AFHTTPRequestOperation for the service method, cancel will be called from view
 controllers
 ******************************************************************************************************/

- (void)cancel {
    
    if (requestOperation) {
        [requestOperation cancel];
    }
}


#pragma mark 截取字符串 报文 转换成 NSDictionary

- (void)subResponseString:(id)responseObject successBlock:(void (^) (id responseObject))successBlock failureBlock:(void (^) (NSString * errInfo))failureBlock{
    
    NSString * responseStr = [[NSString alloc] initWithData:responseObject
                                                   encoding:NSUTF8StringEncoding];
    NSLog(@"responseStr:%@",responseStr);
    
    
    switch (self.messageEncryptionMode) {
            
        case MessageEncryptionMode_General:
        {
            [self handleResponseForBeforeLogInAndInitDeviceLoadingMainKey:responseStr successBlock:^(id responseObject) {
                
                successBlock(responseObject);
                
            } failureBlock:^(NSString *errInfo) {
                
                failureBlock(errInfo);
            }];
        }
            break;
        case MessageEncryptionMode_None:
        {
            [self handleResponseForNoneEncryption:responseStr successBlock:^(id responseObject) {
                
                successBlock(responseObject);
                
            } failureBlock:^(NSString *errInfo) {
                
                failureBlock(errInfo);
            }];
        }
            break;
        case MessageEncryptionMode_LoadMainKey:
        { 
            [self handleResponseForBeforeLogInAndInitDeviceLoadingMainKey:responseStr successBlock:^(id responseObject) {
                
                successBlock(responseObject);
                
            } failureBlock:^(NSString *errInfo) {
                
                failureBlock(errInfo);
            }];
        }
            break;
    }
}

#pragma mark -- 处理登录前和设备初始化的时候 后台返回的reponse 报文加密 验签
- (void)handleResponseForBeforeLogInAndInitDeviceLoadingMainKey:(NSString *)responseStr successBlock:(void (^) (id responseObject))successBlock failureBlock:(void (^) (NSString * errInfo))failureBlock{
    
    if (self.messageEncryptionMode == MessageEncryptionMode_LoadMainKey) {
        
        responseStr = [responseStr stringByReplacingOccurrencesOfString:@"<body>" withString:@""];
        responseStr = [responseStr stringByReplacingOccurrencesOfString:@"</body>" withString:@""];
        responseStr = [responseStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        responseStr = [responseStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
    
    // 过滤空格
    responseStr = [responseStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    responseStr = [responseStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSError * error = nil;
    NSRange rangeJsonStr = [responseStr rangeOfString:YR_JSON_STR];
    NSRange rangeMacStr = [responseStr rangeOfString:YR_MAC_STR];
    //NSDictionary * jsonDict = nil;
    
    if (rangeJsonStr.length == 8 && rangeMacStr.length == 8) {
        
        NSString * macString = [responseStr substringWithRange:NSMakeRange(rangeMacStr.location+rangeMacStr.length, rangeMacStr.length * 2)];
        NSString * jsonString = [responseStr substringWithRange:NSMakeRange(rangeJsonStr.length, rangeMacStr.location-rangeMacStr.length)];
        NSData * jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                  options:NSJSONReadingAllowFragments
                                                                    error:&error];
        
        if ([NSJSONSerialization isValidJSONObject:jsonDict]) {
            
            if ([jsonDict[YR_OUTPUT_KEY_STATES_RESP_CODE] isEqualToString:YR_STATIC_SESSION_INVALIDE]) { // session 失效 重新登陆
                
                [YRFunctionTools logoutWithViewController];
            }else if ([jsonDict[YR_OUTPUT_KEY_STATES_RESP_CODE] isEqualToString:YR_STATIC_SUCCESS_STATES_CODE]) {// 成功时 验签
                
                if (self.isMessageNeedCalculateMacValue) { // 1001 交易报文验签
                    [self checkTransactionMessageMacStr:macString jsonStr:jsonString sucessBlock:^(BOOL isSuccess) {
                        
                        if (isSuccess) {
                            
                            id jsonModal = [self formatJSONToDataModal:jsonDict];
                            successBlock(jsonModal);
                        }else {
                            
                            successBlock(jsonDict);
                            [MBProgressHUD hideHUD];
                            [[[UIAlertView alloc] initWithTitle:nil message:@"交易验签失败" delegate:nil cancelButtonTitle:TIPS_CONFIRM otherButtonTitles:nil, nil] show];
                        }
                    } failureBlock:^(NSString *errInfo) {
                        
                        [MBProgressHUD hideHUD];
                        [[[UIAlertView alloc] initWithTitle:nil message:@"交易验签失败" delegate:nil cancelButtonTitle:TIPS_CONFIRM otherButtonTitles:nil, nil] show];
                    }];
                }else if([self checkMacStr:macString withJsonStr:jsonString messsageEncryptionMode:self.messageEncryptionMode]) {
                    
                    id jsonModal = [self formatJSONToDataModal:jsonDict];
                    successBlock(jsonModal);
                    
                }else {
                    
                    [[[UIAlertView alloc] initWithTitle:nil message:@"验签失败" delegate:nil cancelButtonTitle:TIPS_CONFIRM otherButtonTitles:nil, nil] show];
                    successBlock(jsonDict);
                }
            }else { // 返回码 非 000
                
                successBlock(jsonDict);
            }
        }else { // 返回 非Json格式
            
            [YRFunctionTools showAlertViewTitle:nil message:@"数据异常，请稍后重试！" cancelButton:TIPS_CONFIRM];
        }

    }else if ([responseStr rangeOfString:YR_JSON_STR].length == 8) {
        
        NSError * error = nil;
        NSRange rangeJsonStr = [responseStr rangeOfString:YR_JSON_STR];
        NSString * jsonStr = [responseStr substringFromIndex:rangeJsonStr.location+rangeJsonStr.length];
        NSData * jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                  options:NSJSONReadingAllowFragments
                                                                    error:&error];
        if ([NSJSONSerialization isValidJSONObject:jsonDict]) {
            
            if ([jsonDict[YR_OUTPUT_KEY_STATES_RESP_CODE] isEqualToString:YR_STATIC_SESSION_INVALIDE]) { // session 失效 重新登陆
                
                [MBProgressHUD hideHUD];
                [YRFunctionTools logoutWithViewController];
            }else {
                
                successBlock(jsonDict);
            }
            
        }else {
            
            [MBProgressHUD hideHUD];
            [YRFunctionTools showAlertViewTitle:nil message:@"数据异常，请稍后重试！" cancelButton:TIPS_CONFIRM];
        }
    }else {
        
        NSData * jsonData = [responseStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                  options:NSJSONReadingAllowFragments
                                                                    error:&error];
        if ([NSJSONSerialization isValidJSONObject:jsonDict]) {
            
            if ([jsonDict[YR_OUTPUT_KEY_STATES_RESP_CODE] isEqualToString:YR_STATIC_SESSION_INVALIDE]) { // session 失效 重新登陆
                
                [MBProgressHUD hideHUD];
                [YRFunctionTools logoutWithViewController];
            }else {
                
                successBlock(jsonDict);
            }
        }else {
            
            [MBProgressHUD hideHUD];
            [YRFunctionTools showAlertViewTitle:nil message:@"数据异常，请稍后重试！" cancelButton:TIPS_CONFIRM];
        }
    }
}

#pragma mark -- 处理 不需要加密验签的response
- (void)handleResponseForNoneEncryption:(NSString *)responseStr successBlock:(void (^) (id responseObject))successBlock failureBlock:(void (^) (NSString * errInfo))failureBlock {
    // 过滤空格
    responseStr = [responseStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    responseStr = [responseStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSRange rangeJsonStr = [responseStr rangeOfString:YR_JSON_STR];
    NSError * error = nil;
    if (rangeJsonStr.length == 8) {
        
        NSString * jsonStr = [responseStr substringFromIndex:rangeJsonStr.location+rangeJsonStr.length];
        NSData * jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                  options:NSJSONReadingAllowFragments
                                                                    error:&error];
        if ([NSJSONSerialization isValidJSONObject:jsonDict]) {
            
            if ([jsonDict[YR_OUTPUT_KEY_STATES_RESP_CODE] isEqualToString:YR_STATIC_SESSION_INVALIDE]) { // session 失效 重新登陆
                
                [MBProgressHUD hideHUD];
                [YRFunctionTools logoutWithViewController];
            }else {
                
                id jsonModal = [self formatJSONToDataModal:jsonDict];
                successBlock(jsonModal);
            }
            
        }else {
            
            [MBProgressHUD hideHUD];
            [YRFunctionTools showAlertViewTitle:nil message:@"数据异常，请稍后重试！" cancelButton:TIPS_CONFIRM];
        }
    }else {
        
        NSData * jsonData = [responseStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                  options:NSJSONReadingAllowFragments
                                                                    error:&error];
        if ([NSJSONSerialization isValidJSONObject:jsonDict]) {
            
            if ([jsonDict[YR_OUTPUT_KEY_STATES_RESP_CODE] isEqualToString:YR_STATIC_SESSION_INVALIDE]) { // session 失效 重新登陆
                
                [MBProgressHUD hideHUD];
                [YRFunctionTools logoutWithViewController];
            }else {
                
                successBlock(jsonDict);
            }
        }else {
            
            [MBProgressHUD hideHUD];
            [YRFunctionTools showAlertViewTitle:nil message:@"数据异常，请稍后重试！" cancelButton:TIPS_CONFIRM];
        }
    }
}


#pragma mark 转换model
- (id)formatJSONToDataModal:(NSDictionary *)jsonObject {
    
    if (!self.isResponseNeedSerialized) {
        
        return jsonObject;
    }
    NSMutableDictionary * dataModalDict = [NSMutableDictionary dictionary];
    
    
    if ([jsonObject isKindOfClass:[NSDictionary class]] && jsonObject) {
        
        // 返回状态是否成功
        if ([jsonObject[YR_OUTPUT_KEY_STATES_RESP_CODE] isEqualToString:YR_STATIC_SUCCESS_STATES_CODE]) {
            
            //#warning need a key
            NSError * error = nil;
            NSString * modalClassName = [self getSubClassName];
            id modalClassInstance = [[NSClassFromString(modalClassName) alloc] initWithDictionary:jsonObject
                                                                                            error:&error];
            [dataModalDict setObject:modalClassInstance forKey:YR_OUTPUT_KEY_DATA];
            [dataModalDict setObject:jsonObject[YR_OUTPUT_KEY_STATES_RESP_CODE] forKey:YR_OUTPUT_KEY_STATES_RESP_CODE];
            [dataModalDict setObject:jsonObject[YR_OUTPUT_KEY_STATES_RESP_DESC] forKey:YR_OUTPUT_KEY_STATES_RESP_DESC];
            
        }else if ([jsonObject[YR_OUTPUT_KEY_STATES_RESP_CODE] isEqualToString:YR_STATIC_REPEAT_SUCCESS_STATUES_CODE]) {
            
            // 重复操作
            [[[UIAlertView alloc] initWithTitle:nil message:@"重复操作" delegate:nil cancelButtonTitle:TIPS_CONFIRM otherButtonTitles:nil, nil] show];
            return jsonObject;
        }else {
            return jsonObject;
        }
    }
    return dataModalDict;
}

#pragma mark -- reponse 对报文加密 验签
- (BOOL)checkMacStr:(NSString *)macStr withJsonStr:(NSString *)jsonStr messsageEncryptionMode:(MessageEncryptionMode)encryptionMode{
    
    switch (encryptionMode) {
        case MessageEncryptionMode_LoadMainKey:
        {
            if ([[YRMD5Encryption mainKeyEncryptionUsedMD5WithString:jsonStr] caseInsensitiveCompare:macStr] == NSOrderedSame) {
                return YES;
            }
        }
        case MessageEncryptionMode_General:
        {
            NSLog(@"macStr:%@",macStr);
            if ([[YRMD5Encryption generalEncryptionUsedMD5WithString:jsonStr] caseInsensitiveCompare:macStr] == NSOrderedSame) {
                return YES;
            }
        }
        case MessageEncryptionMode_None:
        {
        
        }
    }
    return NO;
}


#pragma mark 1001 报文  验签
- (void)checkTransactionMessageMacStr:(NSString *)macStr jsonStr:(NSString *)jsonStr sucessBlock:(void (^)(BOOL isSuccess))successBlock failureBlock:(void (^)(NSString * errInfo))failureBlock{
    
    [YRMD5Encryption checkTransactionMessageMacStr:macStr jsonStr:jsonStr sucessBlock:^(BOOL isSuccess) {
        //
        successBlock(isSuccess);
    } failureBlock:^(NSString *errInfo) {
        //
        failureBlock(errInfo);
    }];
}

#pragma mark set cookie 设置Cookie
- (void)addSessionIdToCookie {
    
    NSMutableDictionary * mutDict = [NSMutableDictionary dictionary];
    [mutDict setObject:YR_COOKIE_NAME forKey:NSHTTPCookieName];
    if ([[YRLoginManager shareLoginManager] isLogin]) {
        [mutDict setObject:[YRLoginManager shareLoginManager].sessionId forKey:NSHTTPCookieValue];
    }
    [mutDict setObject:@".yunrich.com" forKey:NSHTTPCookieDomain];
    [mutDict setObject:@"" forKey:NSHTTPCookieOriginURL];
    [mutDict setObject:@"/" forKey:NSHTTPCookiePath];
    [mutDict setObject:@"0" forKey:NSHTTPCookieVersion];
    NSHTTPCookie * cookie = [NSHTTPCookie cookieWithProperties:mutDict];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
}

- (NSString *)getSubClassName
{
    return nil;
}

@end
