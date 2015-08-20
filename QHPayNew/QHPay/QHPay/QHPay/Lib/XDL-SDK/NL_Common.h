//
//  NL_Common.h
//  NLSwiperController
//
//  Created by Wayne on 15/8/11.
//  Copyright (c) 2015年 ChenJinxiang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    NLDeviceMe11 = 1,
    NLDeviceMe30,
    NLDeviceMe15
}NLDeviceTypeValue;

typedef enum
{
    NL_TRACKTYPE_PLAIN = 1,//明文
    NL_TRACKTYPE_ENCRYPT = 2//密文
}NL_TRACKTYPE;


@interface keyData : NSObject

//pin密钥
@property (nonatomic, strong)NSString * pinKey;
//pin密钥校验值
@property (nonatomic, strong)NSString * pinKcv;

//mac密钥
@property (nonatomic, strong)NSString * macKey;
//mac密钥校验值
@property (nonatomic, strong)NSString * macKcv;

//磁道密钥
@property (nonatomic, strong)NSString * traceKey;
//磁道密钥校验值
@property (nonatomic, strong)NSString * traceKcv;

@end



@interface deviceInfo : NSObject

@property (nonatomic, strong)NSString * SN;
@property (nonatomic, strong)NSString * CSN;
@property (nonatomic, strong)NSString * KSN;
@property (nonatomic, strong)NSString * AppVer;
@property (assign, nonatomic)int batteryPercent;

@end



@interface SwipeResult : NSObject
//卡号，二磁道，三磁道，磁道………
@property (nonatomic, copy) NSString *acctId;
@property (nonatomic, copy) NSData *secondTrackData;
@property (nonatomic, copy) NSData *thirdTrackData;
@property (nonatomic, copy) NSData *trackDatas;
@property (nonatomic, copy) NSString *validDate;
@property (nonatomic, copy) NSString *serviceCode;
@property (nonatomic, copy) NSData *ksn;
@property (nonatomic, copy) NSData *extInfo;

@end


@interface NL_Common : NSObject


@end

