//
//  YRDeviceRelative.m
//  YunRichMPCR
//
//  Created by YunRich on 15/4/22.
//  Copyright (c) 2015年 yunrich. All rights reserved.
//

#import "YRDeviceRelative.h"
#import "GTMBase64.h"
#import "MBProgressHUD+MJ.h"
#import "YRLoginManager.h"

@implementation YRDeviceRelative

+ (id)shareDeviceRelative {
    
    static YRDeviceRelative * deviceRelative;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        
        deviceRelative = [[YRDeviceRelative alloc] init];
    });
    return deviceRelative;
}
// 获取 customParam
- (void)getSNMessageSuccessBlock:(void (^)(NSDictionary *))successBlock failureBlock:(void (^)(NSString *))failureBlock {
    
    [[LandiMPOS getInstance] getTerminalParam:^(LDC_TerminalBasePara *terminalPara) {

        if (terminalPara.customParam.length == 0) {
            NSDictionary * dict = @{};
            successBlock(dict);
            return;
        }
        NSString * loadStr = [YRFunctionTools stringFromHexString:terminalPara.customParam isConvertToBase64:NO];
        NSArray * loadStrArray = [loadStr componentsSeparatedByString:@"|"];

        NSDictionary * dict = @{
//                                YR_DEVICE_RELATIVE_POSDEVICE:loadStrArray[0],
//                                YR_DEVICE_RELATIVE_POSID:loadStrArray[1],
//                                YR_DEVICE_RELATIVE_FILLCODE:loadStrArray[2],
//                                YR_DEVICE_RELATIVE_MERNAME:loadStrArray[3],
                                };
        
        if (loadStrArray.count >= 4) {
            self.posDeviceId = loadStrArray[0];
            self.posId = loadStrArray[1];
            self.fillCode = loadStrArray[2];
            self.merName = loadStrArray[3];
            NSString * merchantKey = [NSString stringWithFormat:@"%@%@",[[YRLoginManager shareLoginManager] username],YR_MERNAME];
            [[NSUserDefaults standardUserDefaults] setObject:self.merName forKey:merchantKey];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }

        successBlock(dict);
        
    } failedBlock:^(NSString *errCode, NSString *errInfo) {
        
        failureBlock(errInfo);
        
    }];
}

/**
 *	@brief	保存终端参数信息
 *	@param 	merchantNO   商户号
 *	@param 	merchantName 商户名称
 *	@param 	terminalNO   终端号
 *	@param 	serialNO     流水号
 *	@param 	bathcNO      批次号
    @customParam
 */

- (void)saveSNMessage:(NSDictionary *)customPara successBlock:(void (^)(BOOL isSuccessed))successBlock failureBlock:(void (^)(NSString * errorInfo))failureBlock {
    
    __block BOOL isSaved ;
    
    if (customPara) {

        NSString * posDeviceId = customPara[YR_DEVICE_RELATIVE_POSDEVICE];
        NSString * posId = customPara[YR_DEVICE_RELATIVE_POSID];
        NSString * fillCode = customPara[YR_DEVICE_RELATIVE_FILLCODE];
        NSString * merName = customPara[YR_DEVICE_RELATIVE_MERNAME];
        NSString * saveStr = [NSString stringWithFormat:@"%@|%@|%@|%@",posDeviceId,posId,fillCode,merName];
        
        saveStr = [YRFunctionTools hexStringFromString:saveStr];
        LDC_TerminalBasePara * terminalBasePara = [[LDC_TerminalBasePara alloc] init];
        terminalBasePara.customParam = saveStr;
//
//        terminalBasePara.merchantName = @"";
//        terminalBasePara.merchantNO = @"";
//        terminalBasePara.terminalNO = @"";
//        terminalBasePara.serialNO = nil;
//        terminalBasePara.bathcNO = @"";
        
        [[LandiMPOS getInstance] setTerminalParam:terminalBasePara successBlock:^{
            
            isSaved = YES;
            successBlock(isSaved);
        } failedBlock:^(NSString *errCode, NSString *errInfo) {
            
            failureBlock(errInfo);
        }];
    }else {
        
        failureBlock(@"数据不能为空");
    }
}

@end
