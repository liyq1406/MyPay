//
//  YRFogetPasswordTool.h
//  YunRichMPCR
//
//  Created by YunRich on 15/4/13.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YRRestPWController.h"
#import "YRLoanModel.h"
//typedef NS_ENUM(NSInteger, ModifyPasswordType) {
//
//    ModifyPasswordType_Login = 0,
//    ModifyPasswordType_Transaction
//};

@interface YRRequestTool : NSObject

#pragma mark — 登录前接口
#pragma mark 获取验证码
+ (void)userSendPhoneNum:(NSString *)phoneNum syetemtype:(NSString *)systemType busrId:(NSString *)busrId success:(void (^)(id responseObject))success failure:(void (^)(NSString *errInfo))failure;

#pragma mark 登录
+ (void)loginWithBusrId:(NSString *)busrId loginPwd:(NSString *)loginPwd success:(void (^)(NSString * isCompLogin,NSString * sessionID, NSString * loginSucceedOrFailed,NSString * userName,NSString * custID))success failure:(void (^)(NSString *errInfo))failure;

#pragma mark 注册
+ (void)registerInfoWithUsrmp:(NSString *)usrmp authcode:(NSString *)authcode loginpwd:(NSString *)loginpwd transpwd:(NSString *)transpwd busrId:(NSString *)busrid factory:(NSString *)factory machineno:(NSString *)machineno success:(void (^)(id responseObject))success failure:(void (^)(NSString *errInfo))failure;

#pragma mark 忘记密码
+ (void)forgetPasswordWithUserMP:(NSString *)userMP verifyCode:(NSString *)verfycode newPassword:(NSString *)newPassword certId:(NSString *)certId busrId:(NSString *)busrId success:(void (^)(id responseObject))success failure:(void (^)(NSString *))failure;

#pragma mark 修改密码
+ (void)resetPasswordWithOldPassword:(NSString *)oldPS  newPassword:(NSString *)newPassword passwordType:(ChangePasswordType)passwordType success:(void (^)(id responseObject))success failure:(void (^)(NSString *errInfo))failure;

#pragma mark - 登录后接口

#pragma mark 签名上送
+ (void)uploadSignWithORDID:(NSString *)ORDID customerID:(NSString *)custId signImage:(UIImage *)signImage success:(void (^)(id responseObject))success failure:(void (^)(NSString * errorInfo))failure;

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
                            busiAddr:(NSString *)busAddress successBlock:(void (^)(id responseObject))successBlock failureBlock:(void (^)(NSString *errInfo))failureBlock;

#pragma mark 密钥灌装查询
+ (void)getPosSequenceWithPOSDEVID:(NSString *)POSDEVID POSID:(NSString *)POSID success:(void (^)(id responseObject))success failure:(void (^)(NSString *errInfo))failure;

#pragma mark 取现
+ (void)extractCashWithAMT:(NSString *)AMT CASHTYPE:(NSString *)CASHTYPE TRANSPWD:(NSString *)TRANSPWD success:(void (^)(id responseObject))success failure:(void (^)(NSString *errInfo))failure;

#pragma mark T0取现权限查询
+ (void)queryT0CashAuthWithCASHTYPE:(NSString *)CASHTYPE success:(void (^)(id responseObject))success failure:(void (^)(NSString *errInfo))failure;

#pragma mark T0取现申请
+ (void)applyCashForT0WithCASHTYPE:(NSString *)CASHTYPE success:(void (^)(id responseObject))success failure:(void (^)(NSString *errInfo))failure;

#pragma mark 交易查询
+ (void)queryDealWithBEGINDATE:(NSString *)BEGINDATE ENDDATE:(NSString *)ENDDATE PAGESIZE:(NSString *)PAGESIZE PAGENUM:(NSString *)PAGENUM success:(void (^)(id responseObject))success failure:(void (^)(NSString *errInfo))failure;

#pragma mark 个人中心信息查询
+ (void)queryPersonMessageSuccess:(void (^)(id responseObject))success failure:(void (^)(NSString *errInfo))failure;

#pragma mark - 9006~1001接口
#pragma mark 9006
+ (void)send9006WithPR:(NSString *)PR psEQ:(NSString *)psEQ mobType:(NSString *)mobType machineType:(NSString *)machineType factory:(NSString *)factory machineNO:(NSString *)machineNo isNeedHMS:(NSString *)isNeedHMS success:(void (^)(id responseObject))success failure:(void (^)(NSString *errInfo))failure;

#pragma mark 9007
+ (void)send9007WithPR:(NSString *)PR PSEQ:(NSString *)PSEQ POSDEVID:(NSString *)POSDEVID success:(void (^)(id responseObject))success failure:(void (^)(NSString *errInfo))failure;

#pragma mark 9008
+ (void)send9008WithPR:(NSString *)PR PSEQ:(NSString *)PSEQ POSDEVID:(NSString *)POSDEVID POSID:(NSString *)POSID success:(void (^)(id responseObject))success failure:(void (^)(NSString *errInfo))failure;

#pragma mark 9009
+ (void)send9009WithPR:(NSString *)PR PSEQ:(NSString *)PSEQ POSID:(NSString *)POSID BATCHID:(NSString *)BATCHID success:(void (^)(id responseObject))success failure:(void (^)(NSString *errInfo))failure;

#pragma mark 9015
+ (void)send9015WithPR:(NSString *)PR PSEQ:(NSString *)PSEQ POSID:(NSString *)POSID INX:(NSString *)INX success:(void (^)(id responseObject))success failure:(void (^)(NSString *errInfo))failure;

#pragma mark 9016
+ (void)send9016WithPR:(NSString *)PR PSEQ:(NSString *)PSEQ POSID:(NSString *)POSID INX:(NSString *)INX success:(void (^)(id responseObject))success failure:(void (^)(NSString *errInfo))failure;

#pragma mark 9017(TC上送)
+ (void)send9017WithPAN:(NSString *)PAN PR:(NSString *)PR moneyNum:(NSString *)moneyNum PSEQ:(NSString *)PSEQ POSID:(NSString *)POSID ICData:(NSString *)icData orderNum:(NSString *)orderNum success:(void (^)(id responseObject))success failure:(void (^)(NSString * errInfo))failure;

#pragma mark 9017(TC循环上送)
+ (void)cycleUploadTC;

#pragma mark 1001
+ (void)send1001WithPR:(NSString *)PR PAN:(NSString *)PAN AMT:(NSString *)AMT PSEQ:(NSString *)PSEQ EXP:(NSString *)EXP SVR:(NSString *)SVR ICSEQ:(NSString *)ICSEQ SENS:(NSString *)SENS POSID:(NSString *)POSID ORDID:(NSString *)ORDID IC:(NSString *)IC LONGITUDE:(NSString *)LONGITUDE LATITUDE:(NSString *)LATITUDE CUSTID:(NSString *)CUSTID success:(void (^)(id responseObject))success failure:(void (^)(NSString *errInfo))failure;

#pragma mark 生意贷
+ (void)loanWithVER:(NSString *)VER CUSTID:(NSString *)CUSTID LOANBANKID:(NSString *)LOANBANKID EXPECTEDRANGE:(NSString *)EXPECTEDRANGE LOANPURPOSES:(NSString *)LOANPURPOSES success:(void (^)(id responseObject))success failure:(void (^)(NSString * errInfo))failure;
@end
