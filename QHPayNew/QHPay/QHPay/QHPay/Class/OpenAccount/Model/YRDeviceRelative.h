//
//  YRDeviceRelative.h
//  YunRichMPCR
//
//  Created by YunRich on 15/4/22.
//  Copyright (c) 2015年 yunrich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LandiMPOS.h"

@interface YRDeviceRelative : NSObject

@property (strong, nonatomic) NSString * fillCode;
@property (strong, nonatomic) NSString * posDeviceId; // pos 设备号
@property (strong, nonatomic) NSString * posId; //POS终端号 系统分配，9位数字，在POS上手工输入
@property (strong, nonatomic) NSString * merName;

@property (nonatomic, strong) NSString * cardNum;
@property (nonatomic, strong) NSString * cardNumStar;

+ (id)shareDeviceRelative;

- (void)saveSNMessage:(NSDictionary *)customPara successBlock:(void (^) (BOOL isSuccessed))successBlock failureBlock:(void (^) (NSString * errorInfo))failureBlock;

- (void)getSNMessageSuccessBlock:(void (^)(NSDictionary * dict))successBlock failureBlock:(void (^) (NSString * errorInfo))failureBlock;

@end
