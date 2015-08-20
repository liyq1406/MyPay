//
//  YRLoginManager.h
//  YunRichMPCR
//
//  Created by YunRich on 15/4/9.
//  Copyright (c) 2015年 yunrich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "LDCommon.h"

@interface YRLoginManager : NSObject

@property (strong, nonatomic) NSString * longitudeStr;
@property (strong, nonatomic) NSString * latitudeStr;

@property (strong, nonatomic) NSString * deviceId;
@property (strong, nonatomic) NSString * deviceName;
@property (assign, nonatomic) LDE_CHANNEL channel;

@property (strong, nonatomic) NSString * storeName; // 店铺名
@property (strong, nonatomic) NSString * username; // 户名
@property (strong, nonatomic) NSString * busrID;//客户号
@property (strong, nonatomic) NSString * userAccount; // 手机号
@property (strong, nonatomic) NSString * custID;//唯一客户号

@property (nonatomic)             BOOL   supportPrinter;
@property (nonatomic, strong) NSString * unsVersion;//固件版本号
@property (nonatomic, strong) NSString * productSN;
@property (nonatomic, strong) NSString * deviceType;
@property (nonatomic, strong) NSString * PSEQ;//流水号
@property (nonatomic, strong) NSString * factoryName;//厂商 eg:   LD、XDL

//gyj_参数_start
@property (nonatomic, strong) NSString * EhomeOrd;//订单号
@property (nonatomic, strong) NSString * EhomeOrdxfcz;//消费冲正订单号
@property (nonatomic, strong) NSString * EhomeLsh;//流水号
@property (nonatomic, strong) NSString * EhomeDate;
@property BOOL isYHK;//连接成功返回
@property (nonatomic, strong) UIViewController *vc;
@property (nonatomic, strong) UIViewController *settvc;
@property (nonatomic, strong) NSString * cardAmount; //gyj
@property (nonatomic, strong) UIImage * gyjImage; //gyj
@property (nonatomic, strong) NSString * gyjImageName;
@property (nonatomic, strong) NSString * dir;

@property (nonatomic, strong) NSURL * gyjNSurl;
@property (nonatomic, strong) NSData * imageData;
@property (nonatomic, strong) NSString * orgId;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * tell;
@property (nonatomic, strong) NSString * strUrl;

@property (nonatomic, strong) NSString * returnId;//退货单号
@property (nonatomic, strong) NSString * returnLsh;//退货流水号
@property (nonatomic, strong) NSString * re_orgId;//退货时原订单号
@property (nonatomic, strong) NSMutableDictionary * signDict;
@property (nonatomic, strong) NSString * shortName;//
@property (nonatomic, strong) NSString * userId;//

+ (YRLoginManager *)shareLoginManager;

- (void)saveSessionId:(NSString *)sessionId;

- (BOOL)isLogin;

- (id)sessionId;

@end
