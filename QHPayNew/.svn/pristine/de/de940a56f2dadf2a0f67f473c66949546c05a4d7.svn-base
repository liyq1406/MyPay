//
//  YRFogetPasswordTool.m
//  YunRichMPCR
//
//  Created by YunRich on 15/4/13.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//

#import "YRRequestTool.h"
#import "YRUserProfileRequest.h"
#import "YRMD5Encryption.h"
#import "YRTransactionRequest.h"
#import "YRDrawCashRequest.h"
#import "LandiMPOS.h"
#import "YRDeviceRelative.h"
#import "MBProgressHUD+MJ.h"
#import "AppDelegate.h"

@implementation YRRequestTool

#pragma mark — 登录前接口

#pragma mark 获取验证码
+ (void)userSendPhoneNum:(NSString *)phoneNum syetemtype:(NSString *)systemType busrId:(NSString *)busrId success:(void (^)(id responseObject))success failure:(void (^)(NSString *errInfo))failure{
    NSDictionary * dict = nil;
    NSString *companyName = [[NSUserDefaults standardUserDefaults] objectForKey:COMPANYNAME];
    if ([companyName isEqualToString:@"QHPay"]) {//钱海
        if ([systemType isEqualToString:@"REG"]) {//注册
            dict = @{@"USRMP":phoneNum,@"SMSTYPE":systemType};
        }
        else {//忘记密码
            dict = @{@"BUSRID":busrId,@"USRMP":phoneNum,@"SMSTYPE":systemType};
        }
    }
    else {//O单商
        if ([systemType isEqualToString:@"REG"]) {//注册
            dict = @{@"USRMP":phoneNum,@"SMSTYPE":systemType,@"MACHINENO":[YRLoginManager shareLoginManager].productSN,@"FACTORY":[YRLoginManager shareLoginManager].factoryName};
        }
        else {//忘记密码
            dict = @{@"BUSRID":busrId,@"USRMP":phoneNum,@"SMSTYPE":systemType};
        }
    }
    
    YRUserProfileRequest * request = [[YRUserProfileRequest alloc] init];

    [request getVertificationCode:dict successBlock:^(id responseObject) {
        
        success(responseObject);
        
    } failureBlock:^(NSString *errInfo) {
        failure(errInfo);
    }];
}

#pragma mark 登录
+ (void)loginWithBusrId:(NSString *)busrId loginPwd:(NSString *)loginPwd success:(void (^)(NSString * isCompLogin,NSString * sessionID, NSString * loginSucceedOrFailed,NSString * userName,NSString * custID))success failure:(void (^)(NSString *errInfo))failure{
    NSString * md5loginPwd = [YRMD5Encryption encryptionMD5WithPassword:loginPwd passwordType:PasswordTypeLogin];
    NSDictionary * dict = @{@"BUSRID":busrId,@"LOGINPWD":md5loginPwd};
    YRUserProfileRequest * request = [[YRUserProfileRequest alloc] init];
    [request logIn:dict successBlock:^(id responseObject) {
        NSString * isCompLogin = responseObject[@"ISCOMPLOGIN"];
        NSString * sessionID = responseObject[@"SESSIONID"];
        NSString * loginSucceedOrFailed = responseObject[YR_OUTPUT_KEY_STATES_RESP_CODE];
        NSString * userName = responseObject[@"NAME"];
        NSString * custID = responseObject[@"CUSTID"];
        success(isCompLogin,sessionID,loginSucceedOrFailed,userName,custID);
    } failureBlock:^(NSString *errInfo) {
        failure(errInfo);
    }];
}

#pragma mark 注册
+ (void)registerInfoWithUsrmp:(NSString *)usrmp authcode:(NSString *)authcode loginpwd:(NSString *)loginpwd transpwd:(NSString *)transpwd busrId:(NSString *)busrid factory:(NSString *)factory machineno:(NSString *)machineno success:(void (^)(id responseObject))success failure:(void (^)(NSString *errInfo))failure{
    NSString * md5PasswordLogin = [YRMD5Encryption encryptionMD5WithPassword:loginpwd passwordType:PasswordTypeLogin];
    NSString * md5PasswordTrans = [YRMD5Encryption encryptionMD5WithPassword:transpwd passwordType:PasswordTypeTrans];
    NSString * orginalStr = [NSString stringWithFormat:@"%@%@%@",usrmp,factory,machineno];
    NSString * hexStr = [YRFunctionTools hexStringFromString:orginalStr];
    [[LandiMPOS getInstance] encryptDataUseFactoyKey:0x00 clearData:hexStr successBlock:^(NSString *stringCB) {
        NSDictionary * dict = @{@"BUSRID":busrid,@"USRMP":usrmp,@"AUTHCODE":authcode,@"LOGINPWD":md5PasswordLogin,@"TRANSPWD":md5PasswordTrans,@"FACTORY":factory,@"MACHINENO":machineno,@"SECRETDATA":stringCB,@"ISMPLOGIN":@"N"};
        YRUserProfileRequest * resqust = [[YRUserProfileRequest alloc] init];
        [resqust registerAccount:dict successBlock:^(id responseObject) {
            success(responseObject);
        } failureBlock:^(NSString *errInfo) {
            failure(errInfo);
        }];
    } failedBlock:^(NSString *errCode, NSString *errInfo) {
        [MBProgressHUD hideHUD];
        [YRFunctionTools showAlertViewTitle:nil message:[NSString stringWithFormat:@"[%@]%@",errCode,errInfo] cancelButton:TIPS_CONFIRM];
    }];
}

#pragma mark 忘记密码

+ (void)forgetPasswordWithUserMP:(NSString *)userMP verifyCode:(NSString *)verfycode newPassword:(NSString *)newPassword certId:(NSString *)certId busrId:(NSString *)busrId success:(void (^)(id responseObject))success failure:(void (^)(NSString *))failure {
    NSString * md5PasswordLogin = [YRMD5Encryption encryptionMD5WithPassword:newPassword passwordType:PasswordTypeLogin];
    YRUserProfileRequest * request = [[YRUserProfileRequest alloc] init];
    NSDictionary * dict = @{@"BUSRID":busrId,@"USRMP":userMP,@"AUTHCODE":verfycode,@"NEWPWD":md5PasswordLogin,@"CERTID":certId};
    [request forgetAndResetPassword:dict successBlock:^(id responseObject) {
        success(responseObject);
    } failureBlock:^(NSString *errInfo) {
        
        failure(errInfo);
    }];
}

#pragma mark 签名上送

+ (void)uploadSignWithORDID:(NSString *)ORDID customerID:(NSString *)custId signImage:(UIImage *)signImage success:(void (^)(id))success failure:(void (^)(NSString *))failure {
    NSDictionary * dict = @{
                            @"ORDID":ORDID,
                            @"CUSTID":custId
                            };
    NSDictionary * imageDict = @{
                                 @"ELECSIGN":signImage,
                                 };
    YRUserProfileRequest * request = [[YRUserProfileRequest alloc] init];
    [request uploadSignature:dict imageKeyFiles:imageDict successBlock:^(id responseObject) {
        success(responseObject);
    } failureBlock:^(NSString *errInfo) {
        failure(errInfo);
    }];
}


#pragma mark 修改密码

+ (void)resetPasswordWithOldPassword:(NSString *)oldPS newPassword:(NSString *)newPassword passwordType:(ChangePasswordType)passwordType success:(void (^)(id))success failure:(void (^)(NSString *))failure {
    NSString * changeType = nil;
    NSString * md5Password = nil;
    NSString * oldPassword = nil;
    if (passwordType == ChangePasswordType_Login) {
        md5Password = [YRMD5Encryption encryptionMD5WithPassword:newPassword passwordType:PasswordTypeLogin];
        oldPassword = [YRMD5Encryption encryptionMD5WithPassword:oldPS passwordType:PasswordTypeLogin];
        changeType = @"L";
    }else if (passwordType == ChangePasswordType_Transaction){
        md5Password = [YRMD5Encryption encryptionMD5WithPassword:newPassword passwordType:PasswordTypeTrans];
        oldPassword = [YRMD5Encryption encryptionMD5WithPassword:oldPS passwordType:PasswordTypeTrans];
        changeType = @"T";
    }
    NSDictionary * dict = @{@"OLDPWD":oldPassword, @"NEWPWD" : md5Password, @"CHANGETYPE" : changeType};
    YRUserProfileRequest * request = [[YRUserProfileRequest alloc] init];
    [request changePassword:dict successBlock:^(id responseObject) {
        success(responseObject);
    } failureBlock:^(NSString *errInfo) {
        
        failure(errInfo);
    }];
}

#pragma mark - 登录后接口

#pragma mark 商户开通

+ (void)finishOpenAccountWithFactory:(NSString *)posFactory
                           machineNo:(NSString *)posNum
                             mername:(NSString *)merchantName
                              certID:(NSString *)idCardNo
                    certPicProsImage:(UIImage *)idCardFrontImage
                    certPicConsImage:(UIImage *)idCardBackImage
                       perPhotoImage:(UIImage *)personalImage
                            cardName:(NSString *)cardName
                             cardNum:(NSString *)cardNo
                          taxRegCode:(NSString *)taxRegCode
                    taxRegPhotoImage:(UIImage *)taxRegImage
                         busiRegCode:(NSString *)busiRegCode
                        busiRegPhoto:(UIImage *)busiRegPhoto
                           instuCode:(NSString *)instuCode
                     instuPhotoImage:(UIImage *)instuImage
                              provId:(NSString *)provId
                              areaId:(NSString *)areaId
                            busiAddr:(NSString *)busAddress successBlock:(void (^)(id responseObject))successBlock failureBlock:(void (^)(NSString *errInfo))failureBlock {
    YRUserProfileRequest * request = [[YRUserProfileRequest alloc]init];
    NSDictionary * dictStr = @{
                               @"FACTORY":posFactory,@"MACHINENO":posNum,
                               @"MERNAME":merchantName,
                               @"CERTID":idCardNo,@"CARDNAME":cardName,
                               @"CARDNO":cardNo,@"PROVID":provId,
                               @"AREAID":areaId
                               };
    NSMutableDictionary * parameters = [NSMutableDictionary dictionaryWithDictionary:dictStr];
    if (areaId) {
        [parameters setObject:areaId forKey:@"AREAID"];
    }
    NSMutableDictionary * dictPic = [NSMutableDictionary dictionary];
    [dictPic setObject:idCardFrontImage forKey:@"CERTPICPROS"];
    [dictPic setObject:idCardBackImage forKey:@"CERTPICCONS"];
    [dictPic setObject:personalImage forKey:@"PERPHOTO"];
    [request openAccount:dictStr imageKeyFiles:dictPic successBlock:^(id responseObject) {
        successBlock(responseObject);
    } failureBlock:^(NSString * errInfo) {
        failureBlock(errInfo);
    }];
}

#pragma mark 密钥灌装查询
+ (void)getPosSequenceWithPOSDEVID:(NSString *)POSDEVID POSID:(NSString *)POSID success:(void (^)(id responseObject))success failure:(void (^)(NSString *errInfo))failure{
    NSDictionary * dict = @{
                            @"FACTORY":[YRLoginManager shareLoginManager].factoryName,
                            @"MACHINENO":[YRLoginManager shareLoginManager].productSN,
                            @"POSDEVID":POSDEVID,
                            @"POSID":POSID,
                            };
    YRTransactionRequest * request = [[YRTransactionRequest alloc] init];
    [request manageStageForLoadingKey:dict successBlock:^(id responseObject) {
        success(responseObject);
    } failureBlock:^(NSString *errInfo) {
        failure(errInfo);
    }];
}

#pragma mark 取现
+ (void)extractCashWithAMT:(NSString *)AMT CASHTYPE:(NSString *)CASHTYPE TRANSPWD:(NSString *)TRANSPWD success:(void (^)(id responseObject))success failure:(void (^)(NSString *errInfo))failure{
    NSString * md5PasswordTrans = [YRMD5Encryption encryptionMD5WithPassword:TRANSPWD passwordType:PasswordTypeTrans];
    YRDrawCashRequest * requset = [[YRDrawCashRequest alloc] init];
    NSDictionary * dict = @{
                            @"AMT":AMT,
                            @"CASHTYPE":CASHTYPE,
                            @"TRANSPWD":md5PasswordTrans,
                            };
    [requset drawCash:dict successBlock:^(id responseObject) {
        success(responseObject);
    } failureBlock:^(NSString *errInfo) {
        failure(errInfo);
    }];
}

#pragma mark T0取现权限查询
+ (void)queryT0CashAuthWithCASHTYPE:(NSString *)CASHTYPE success:(void (^)(id responseObject))success failure:(void (^)(NSString *errInfo))failure{
    YRDrawCashRequest * request = [[YRDrawCashRequest alloc] init];
    NSDictionary * dict = @{
                            @"CASHTYPE":CASHTYPE,
                            };
    [request queryAuthorityForDrawCash:dict successBlock:^(id responseObject) {
        success(responseObject);
    } failureBlock:^(NSString *errInfo) {
        failure(errInfo);
    }];
}

#pragma mark T0取现申请
+ (void)applyCashForT0WithCASHTYPE:(NSString *)CASHTYPE success:(void (^)(id responseObject))success failure:(void (^)(NSString *errInfo))failure{
    YRDrawCashRequest * request = [[YRDrawCashRequest alloc] init];
    NSDictionary * dict = @{
                            @"CASHTYPE":CASHTYPE,
                            };
    [request applyDrawCash:dict successBlock:^(id responseObject) {
        success(responseObject);
    } failureBlock:^(NSString *errInfo) {
        failure(errInfo);
    }];
}

#pragma mark 交易查询
+ (void)queryDealWithBEGINDATE:(NSString *)BEGINDATE ENDDATE:(NSString *)ENDDATE PAGESIZE:(NSString *)PAGESIZE PAGENUM:(NSString *)PAGENUM success:(void (^)(id responseObject))success failure:(void (^)(NSString *errInfo))failure{
    YRTransactionRequest * request = [[YRTransactionRequest alloc] init];
    NSDictionary * dict = @{
                            @"BEGINDATE":BEGINDATE,
                            @"ENDDATE":ENDDATE,
                            @"PAGESIZE":PAGESIZE,
                            @"PAGENUM":PAGENUM,
                            };
    [request queryTransactionRecords:dict successBlock:^(id responseObject) {
        success(responseObject);
    } failureBlock:^(NSString *errInfo) {
        failure(errInfo);
    }];
}

#pragma mark 个人中心信息查询
+ (void)queryPersonMessageSuccess:(void (^)(id responseObject))success failure:(void (^)(NSString *errInfo))failure{
    YRUserProfileRequest * request = [[YRUserProfileRequest alloc] init];
    NSDictionary * dict = @{};
    [request getUserProfileInformation:dict successBlock:^(id responseObject) {
        success(responseObject);
    } failureBlock:^(NSString *errInfo) {
        failure(errInfo);
    }];
}

#pragma mark - 9006~1001接口
#pragma mark 9006
+ (void)send9006WithPR:(NSString *)PR psEQ:(NSString *)psEQ mobType:(NSString *)mobType machineType:(NSString *)machineType factory:(NSString *)factory machineNO:(NSString *)machineNo isNeedHMS:(NSString *)isNeedHMS success:(void (^)(id responseObject))success failure:(void (^)(NSString *errInfo))failure{
    YRTransactionRequest * request = [[YRTransactionRequest alloc] init];
    
    NSDictionary * dict = @{
                            @"PR":PR,
                            @"PSEQ":psEQ,
                            @"MOBTYPE":mobType,
                            @"MACHINETYPE":machineType,
                            @"FACTORY":factory,
                            @"MACHINENO":machineNo,
                            @"ISNEEDHMS":isNeedHMS
                            };
    
    [request getMainKey:dict successBlock:^(id responseObject) {
        success(responseObject);
    } failureBlock:^(NSString *errInfo) {
        failure(errInfo);
    }];
}

#pragma mark 9007
+ (void)send9007WithPR:(NSString *)PR PSEQ:(NSString *)PSEQ POSDEVID:(NSString *)POSDEVID success:(void (^)(id responseObject))success failure:(void (^)(NSString *errInfo))failure{
    YRTransactionRequest * request = [[YRTransactionRequest alloc] init];
    
    NSDictionary * dict = @{
                            @"PR":PR,
                            @"PSEQ":PSEQ,
                            @"POSDEVID":POSDEVID
                            };
    
    [request remindBackendSuccessToLoadKey:dict successBlock:^(id responseObject) {
        success(responseObject);
    } failureBlock:^(NSString *errInfo) {
        failure(errInfo);
    }];
}

#pragma mark 9008
+ (void)send9008WithPR:(NSString *)PR PSEQ:(NSString *)PSEQ POSDEVID:(NSString *)POSDEVID POSID:(NSString *)POSID success:(void (^)(id responseObject))success failure:(void (^)(NSString *errInfo))failure{
    YRTransactionRequest * requset = [[YRTransactionRequest alloc] init];
    NSDictionary * dict = @{
                            @"PR":PR,
                            @"PSEQ":PSEQ,
                            @"POSDEVID":POSDEVID,
                            @"POSID":POSID
                            };
    [requset bindingPOSDevice:dict successBlock:^(id responseObject) {
        success(responseObject);
    } failureBlock:^(NSString *errInfo) {
        failure(errInfo);
    }];
}

#pragma mark 9009
+ (void)send9009WithPR:(NSString *)PR PSEQ:(NSString *)PSEQ POSID:(NSString *)POSID BATCHID:(NSString *)BATCHID success:(void (^)(id responseObject))success failure:(void (^)(NSString *errInfo))failure{
    YRTransactionRequest * request = [[YRTransactionRequest alloc] init];
    NSDictionary * dict = @{
                            @"PR":PR,
                            @"PSEQ":PSEQ,
                            @"POSID":POSID,
                            @"BATCHID":BATCHID
                            };
    [request signOn:dict successBlock:^(id responseObject) {
        success(responseObject);
    } failureBlock:^(NSString *errInfo) {
        failure(errInfo);
    }];
}

#pragma mark 9015
+ (void)send9015WithPR:(NSString *)PR PSEQ:(NSString *)PSEQ POSID:(NSString *)POSID INX:(NSString *)INX success:(void (^)(id responseObject))success failure:(void (^)(NSString *errInfo))failure{
    YRTransactionRequest * request = [[YRTransactionRequest alloc] init];
    NSDictionary * dict = @{
                            @"PR":PR,
                            @"PSEQ":PSEQ,
                            @"POSID":POSID,
                            @"INX":INX,
                            };
    [request getPublicKey:dict successBlock:^(id responseObject) {
        success(responseObject);
    } failureBlock:^(NSString *errInfo) {
        failure(errInfo);
    }];
 
}

#pragma mark 9016
+ (void)send9016WithPR:(NSString *)PR PSEQ:(NSString *)PSEQ POSID:(NSString *)POSID INX:(NSString *)INX success:(void (^)(id responseObject))success failure:(void (^)(NSString *errInfo))failure{
    YRTransactionRequest * request = [[YRTransactionRequest alloc] init];
    NSDictionary * dict = @{
                            @"PR":PR,
                            @"PSEQ":PSEQ,
                            @"POSID":POSID,
                            @"INX":INX,
                            };
    [request getParameter:dict successBlock:^(id responseObject) {
        success(responseObject);
    } failureBlock:^(NSString *errInfo) {
        failure(errInfo);
    }];
}

#pragma mark 9017(TC上送)
+ (void)send9017WithPAN:(NSString *)PAN PR:(NSString *)PR moneyNum:(NSString *)moneyNum PSEQ:(NSString *)PSEQ POSID:(NSString *)POSID ICData:(NSString *)icData orderNum:(NSString *)orderNum success:(void (^)(id responseObject))success failure:(void (^)(NSString * errInfo))failure {
    YRTransactionRequest * request = [[YRTransactionRequest alloc] init];
    NSDictionary * dict = @{
                            @"PAN":PAN,
                            @"PR":PR,
                            @"AMT":moneyNum,
                            @"PSEQ":PSEQ,
                            @"POSID":POSID,
                            @"ORG":orderNum,
                            @"IC":icData
                            };

    [request uploadTC:dict successBlock:^(id responseObject) {
        success(responseObject);
    } failureBlock:^(NSString *errInfo) {
        NSArray *localTCParams = [[NSUserDefaults standardUserDefaults] objectForKey:Key_TCParams_Array];
        NSMutableArray *currentTCParams = [NSMutableArray array];
        if (localTCParams != nil && localTCParams.count > 0) {
            [currentTCParams addObjectsFromArray:localTCParams];
        }
        [currentTCParams addObject:dict];
        [[NSUserDefaults standardUserDefaults] setObject:currentTCParams forKey:Key_TCParams_Array];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appdelegate fireUploadTC];
    }];
}

#pragma mark 9017(TC循环上送)
+ (void)cycleUploadTC {
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    __block NSInteger uploadTimes = [[NSUserDefaults standardUserDefaults] integerForKey:Key_UploadTC_Times];
    NSArray *localTCParams = [[NSUserDefaults standardUserDefaults] objectForKey:Key_TCParams_Array];
    NSMutableArray *currentTCParams = [NSMutableArray array];
    if (localTCParams != nil && localTCParams.count > 0) {
        [currentTCParams addObjectsFromArray:localTCParams];
    }
    NSDictionary *tcParams = (currentTCParams.count > 0) ? currentTCParams[0] : nil;
    if (tcParams != nil) {
        if (uploadTimes < 4) {
            YRTransactionRequest * request = [[YRTransactionRequest alloc] init];
            [request uploadTC:tcParams successBlock:^(id responseObject) {
                [currentTCParams removeObject:tcParams];
                [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:Key_UploadTC_Times];
                if (currentTCParams.count == 0) {
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:Key_TCParams_Array];
                    [appdelegate stopUploadTC];
                }
                else {
                    [[NSUserDefaults standardUserDefaults] setObject:currentTCParams forKey:Key_TCParams_Array];
                }
                [[NSUserDefaults standardUserDefaults] synchronize];
            } failureBlock:^(NSString *errInfo) {
                uploadTimes += 1;
                [[NSUserDefaults standardUserDefaults] setInteger:uploadTimes forKey:Key_UploadTC_Times];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }];
        }
        else {
            [currentTCParams removeObject:tcParams];
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:Key_UploadTC_Times];
            if (currentTCParams.count == 0) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:Key_TCParams_Array];
                [appdelegate stopUploadTC];
            }
            else {
                [[NSUserDefaults standardUserDefaults] setObject:currentTCParams forKey:Key_TCParams_Array];
            }
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    else {
        [appdelegate stopUploadTC];
    }
}

#pragma mark 1001
+ (void)send1001WithPR:(NSString *)PR PAN:(NSString *)PAN AMT:(NSString *)AMT PSEQ:(NSString *)PSEQ EXP:(NSString *)EXP SVR:(NSString *)SVR ICSEQ:(NSString *)ICSEQ SENS:(NSString *)SENS POSID:(NSString *)POSID ORDID:(NSString *)ORDID IC:(NSString *)IC LONGITUDE:(NSString *)LONGITUDE LATITUDE:(NSString *)LATITUDE CUSTID:(NSString *)CUSTID success:(void (^)(id responseObject))success failure:(void (^)(NSString *errInfo))failure{
    YRTransactionRequest * request = [[YRTransactionRequest alloc] init];
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary * dict = appdelegate.storeTypeString?@{
                                                        @"PR":PR,
                                                        @"PAN":PAN,
                                                        @"AMT":AMT,
                                                        @"PSEQ":PSEQ,
                                                        @"EXP":EXP,
                                                        @"SVR":SVR,
                                                        @"ICSEQ":ICSEQ,
                                                        @"SENS":SENS,
                                                        @"POSID":POSID,
                                                        @"ORDID":ORDID,
                                                        @"IC":IC,
                                                        @"LONGITUDE":LONGITUDE,
                                                        @"LATITUDE":LATITUDE,
                                                        @"CUSTID":CUSTID,
                                                        @"DEVICETYPE":@"iOS",
                                                        @"ISSPEBUSI" :@"Y",
                                                        @"SPEBUSIID" :@"MSHOP",
                                                        @"SPEBUSITXN1":appdelegate.storeTypeString,
                                                        @"SPEBUSITXN2":@""
                                                        }
    :@{
                            @"PR":PR,
                            @"PAN":PAN,
                            @"AMT":AMT,
                            @"PSEQ":PSEQ,
                            @"EXP":EXP,
                            @"SVR":SVR,
                            @"ICSEQ":ICSEQ,
                            @"SENS":SENS,
                            @"POSID":POSID,
                            @"ORDID":ORDID,
                            @"IC":IC,
                            @"LONGITUDE":LONGITUDE,
                            @"LATITUDE":LATITUDE,
                            @"CUSTID":CUSTID,
 
                            };
    NSLog(@"-----------%@",dict);

    [request getTransactionMessage:dict successBlock:^(id responseObject) {
        success(responseObject);
    } failureBlock:^(NSString *errInfo) {
        failure(errInfo);
    }];
    
}

#pragma mark 生意贷

+ (void)loanWithVER:(NSString *)VER CUSTID:(NSString *)CUSTID LOANBANKID:(NSString *)LOANBANKID EXPECTEDRANGE:(NSString *)EXPECTEDRANGE LOANPURPOSES:(NSString *)LOANPURPOSES success:(void (^)(id))success failure:(void (^)(NSString *))failure{
    
    YRDrawCashRequest *request = [[YRDrawCashRequest alloc] init];
    NSDictionary *loanDic = @{@"CUSTID":CUSTID,
                              @"LOANBANKID":LOANBANKID,
                              @"EXPECTEDRANGE":EXPECTEDRANGE,
                              @"LOANPURPOSES":LOANPURPOSES
                              };
    [request provideALoan:loanDic successBlock:^(id responseObject) {
        
        success(responseObject);
    } failureBlock:^(NSString *errInfo) {
        
        failure(errInfo);
    }];
}
@end
