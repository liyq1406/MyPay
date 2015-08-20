//
//  YRMD5Encryption.m
//  YunRichMPCR
//
//  Created by 李向阳 on 15/4/7.
//  Copyright (c) 2015年 yunrich. All rights reserved.
//


#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "YRMD5Encryption.h"
#import "LandiMPOS.h"
#import "YRDeviceRelative.h"
#import "YRSwitchEnviroment.h"
#import "NSString+PSM.h"
#import "GTMBase64.h"

#define kFixStr @"35d79cb9f64b11b1625795e9cb9ee461"
//#define kLoginPWStr @"ec78642aec3024206dbebf0b339e8a52"
//#define kTransPWStr @"ad37b591867b766bae6ea02cb02af48b"
#define kLoginPWStr [YRMD5Encryption makeLoginChangeStr]
#define kTransPWStr [YRMD5Encryption makeTransChangeStr]

static const NSUInteger LENGTH = 16;



@implementation YRMD5Encryption

+ (NSString *)makeLoginChangeStr {
    NSString *enviroment = [YRSwitchEnviroment shareSwitchEnviroment].server_MTP_IP;
    if ([enviroment isEqualToString:@"http://tech.yunrich.com"]) {
        return @"ec78642aec3024206dbebf0b339e8a52";
    }else {
        return @"5ece445ca5f0ac4aea3a0f7cdc080e26";
    }
}

+ (NSString *)makeTransChangeStr {
    NSString *enviroment = [YRSwitchEnviroment shareSwitchEnviroment].server_MTP_IP;
    if ([enviroment isEqualToString:@"http://tech.yunrich.com"]) {
        return @"ad37b591867b766bae6ea02cb02af48b";
    }else {
        return @"f16ccb833f4af5ac52b5e853cf08ac68";
    }
}

+ (NSString *)mainKeyEncryptionUsedMD5WithDictionary:(NSDictionary *)inputParameters {
    
    NSString * results = nil;
    if (inputParameters.count > 0) {
        
        NSError * error = nil;
        NSData * data = [NSJSONSerialization dataWithJSONObject:inputParameters options:NSJSONWritingPrettyPrinted error:&error];
        results = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMdd"];
        YRDeviceRelative * deviceRelative = [YRDeviceRelative shareDeviceRelative];

        results = [NSString stringWithFormat:@"%@%@",results,deviceRelative.fillCode];
        results = [YRMD5Encryption md5:results];
        results = [results substringToIndex:LENGTH];
        return results;
    }
    return nil;
}

+ (NSString *)generalEncryptionUsedMD5WithDictionary:(NSDictionary *)inputParameters {
    
    NSString * results = nil;
    if (inputParameters.count > 0) {
        
        NSError * error = nil;
        NSData * data = [NSJSONSerialization dataWithJSONObject:inputParameters options:NSJSONWritingPrettyPrinted error:&error];
        results = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMdd"];
        NSString * timeStr = [dateFormatter stringFromDate:[NSDate date]];
        results = [NSString stringWithFormat:@"%@%@%@",results,[YRSwitchEnviroment shareSwitchEnviroment].supply_MD5Salt,timeStr];
        results = [YRMD5Encryption md5:results];
        results = [results substringToIndex:LENGTH];
        return results;
    }
    return nil;
}

+ (NSString *)mainKeyEncryptionUsedMD5WithString:(NSString *)jsonString {
    YRDeviceRelative * deviceRelative = [YRDeviceRelative shareDeviceRelative];
    NSString * results = nil;
    results = [NSString stringWithFormat:@"%@%@",jsonString,deviceRelative.fillCode];

    results = [YRMD5Encryption md5:results];
    results = [results substringToIndex:LENGTH];
    return results;
}

+ (NSString *)generalEncryptionUsedMD5WithString:(NSString *)jsonString {
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString * timeStr = [dateFormatter stringFromDate:[NSDate date]];
    NSString * results = nil;
    results = [NSString stringWithFormat:@"%@%@%@",jsonString,[YRSwitchEnviroment shareSwitchEnviroment].supply_MD5Salt,timeStr];
    results = [YRMD5Encryption md5:results];
    results = [results substringToIndex:LENGTH];
    NSLog(@"results:%@",results);
    return results;
}


+ (NSString *)encryptionMD5WithPassword:(NSString *)password passwordType:(PasswordType)passwordType{
    
    NSString * md5PasswordStr = [[NSString alloc] init];
    if (passwordType == PasswordTypeLogin){
        md5PasswordStr = [NSString stringWithFormat:@"%@%@%@",kFixStr,kLoginPWStr,password];
    }else{
        md5PasswordStr = [NSString stringWithFormat:@"%@%@%@",kFixStr,kTransPWStr,password];
    }
    md5PasswordStr = [YRMD5Encryption md5:md5PasswordStr];
    md5PasswordStr = [md5PasswordStr lowercaseString];
    return md5PasswordStr;
}


+ (void)calculateMacValue:(NSDictionary *)dict successBlock:(void (^)(NSDictionary *))successBlock failureBlock:(void (^)(NSString *errInfo))failureBlock {
    
    NSMutableDictionary * mutableDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [mutableDict setObject:YR_INPUT_VALUE_VER forKey:YR_INPUT_KEY_VER];
    
    NSData * data = [NSJSONSerialization dataWithJSONObject:mutableDict options:NSJSONWritingPrettyPrinted error:nil];
    NSString * dictStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    dictStr = [NSString stringReplaceSpacingAndLinefeedWithString:dictStr];
    NSData * dictData = [dictStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString * str = [self nsdata2HexStr:dictData];
    
    [[LandiMPOS getInstance] calculateMac:0x00 macData:str successBlock:^(NSData *dateCB) {
        //
        NSString * macStr = [self nsdata2HexStr:dateCB];
        NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
        
        
        [dictionary setObject:macStr forKey:YR_INPUT_KEY_MACSTR];
        [dictionary setObject:dictStr forKey:YR_INPUT_KEY_JSONSTR];
        successBlock(dictionary);
    } failedBlock:^(NSString *errCode, NSString *errInfo) {
        //
        failureBlock(errInfo);
    }];
}

+(NSString*) nsdata2HexStr:(NSData*) data
{
    Byte srcBytes[[data length]];
    [data getBytes:(srcBytes) length:([data length])];
    NSMutableString* srcHexString = [NSMutableString stringWithCapacity:(16)];
    for(int i=0;i<[data length];++i)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%02x",srcBytes[i]&0xff];
        [srcHexString appendString:(newHexStr)];
    }
    return srcHexString;
}


+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_LONG len = (CC_LONG)strlen(cStr);
    // CC_MD5(cStr,strlen(cStr),result);
    CC_MD5(cStr,len,result);
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0],result[1],result[2],result[3],
            result[4],result[5],result[6],result[7],
            result[8],result[9],result[10],result[11],
            result[12],result[13],result[14],result[15]
            ];
    
}

#pragma mark 计算银联算法mac值
+ (void)checkTransactionMessageMacStr:(NSString *)macStr jsonStr:(NSString *)jsonStr sucessBlock:(void (^)(BOOL isSuccess))successBlock failureBlock:(void (^)(NSString * errInfo))failureBlock {
    
    jsonStr = [NSString stringReplaceSpacingAndLinefeedWithString:jsonStr];
    
    NSString * hexStr = [YRFunctionTools hexStringFromString:jsonStr];
    
    [[LandiMPOS getInstance] calculateMac:0x00 macData:hexStr successBlock:^(NSData *dateCB) {
        
        NSString * newMacStr = [self nsdata2HexStr:dateCB];
        
        if ([newMacStr caseInsensitiveCompare:macStr] == NSOrderedSame) {
            
            successBlock(YES);
        }else {
            
            successBlock(NO);
        }
    } failedBlock:^(NSString *errCode, NSString *errInfo) {
        //
        failureBlock(errInfo);
    }];
}


+ (NSString *)TripleDES_Encode:(NSString *)encoded_text key:(NSString *)key;
{
    //kCCEncrypt 加密
    return [self encrypt:encoded_text encryptOrDecrypt:kCCEncrypt key:key];
}

+ (NSString *)TripleDES_decode:(NSString *)encoded_text key:(NSString *)key
{
    //kCCDecrypt 解密
    return [self encrypt:encoded_text encryptOrDecrypt:kCCDecrypt key:key];
}

+ (NSString *)encrypt:(NSString *)sText encryptOrDecrypt:(CCOperation)encryptOperation key:(NSString *)key
{
    const void *dataIn;
    size_t dataInLength;
    
    if (encryptOperation == kCCDecrypt)//传递过来的是decrypt 解码
    {
        //解码 base64
        NSData *decryptData = [GTMBase64 decodeData:[sText dataUsingEncoding:NSUTF8StringEncoding]];//转成utf-8并decode
        dataInLength = [decryptData length];
        dataIn = [decryptData bytes];
    }
    else  //encrypt
    {
        NSData* encryptData = [sText dataUsingEncoding:NSUTF8StringEncoding];
        dataInLength = [encryptData length];
        dataIn = (const void *)[encryptData bytes];
    }
    
    /*
     DES加密 ：用CCCrypt函数加密一下，然后用base64编码下，传过去
     DES解密 ：把收到的数据根据base64，decode一下，然后再用CCCrypt函数解密，得到原本的数据
     */
    CCCryptorStatus ccStatus;
    uint8_t *dataOut = NULL; //可以理解位type/typedef 的缩写（有效的维护了代码，比如：一个人用int，一个人用long。最好用typedef来定义）
    size_t dataOutAvailable = 0; //size_t  是操作符sizeof返回的结果类型
    size_t dataOutMoved = 0;
    
    dataOutAvailable = (dataInLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 0x0, dataOutAvailable);//将已开辟内存空间buffer的首 1 个字节的值设为值 0
    
    NSString *initIv = @"12345678";
    const void *vkey = (const void *) [key UTF8String];
    const void *iv = (const void *) [initIv UTF8String];
    
    //CCCrypt函数 加密/解密
    ccStatus = CCCrypt(encryptOperation,//  加密/解密
                       kCCAlgorithmDES,//  加密根据哪个标准（des，3des，aes。。。。）
                       kCCOptionPKCS7Padding,//  选项分组密码算法(des:对每块分组加一次密  3DES：对每块分组加三个不同的密)
                       vkey,  //密钥    加密和解密的密钥必须一致
                       kCCKeySizeDES,//   DES 密钥的大小（kCCKeySizeDES=8）
                       nil, //  可选的初始矢量
                       dataIn, // 数据的存储单元
                       dataInLength,// 数据的大小
                       (void *)dataOut,// 用于返回数据
                       dataOutAvailable,
                       &dataOutMoved);
    
    NSString *result = nil;
    
    if (encryptOperation == kCCDecrypt)//encryptOperation==1  解码
    {
        //得到解密出来的data数据，改变为utf-8的字符串
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved] encoding:NSUTF8StringEncoding];
    }
    else //encryptOperation==0  （加密过程中，把加好密的数据转成base64的）
    {
        //编码 base64
        NSData *data = [NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved];
        result = [YRFunctionTools nsdata2HexStr:data];
        
    }
    
    return result;
}

@end
