//
//  YRPersonMessage.h
//  YunRichMPCR
//
//  Created by YunRich on 15/5/14.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//

#import "YRBaseModal.h"

@interface YRPersonMessage : YRBaseModal
@property (nonatomic, strong) NSString * VER;            //版本
@property (nonatomic, strong) NSString * RESP;           //返回码
@property (nonatomic, strong) NSString * RESPDESC;       //应答描述
@property (nonatomic, strong) NSString * USRMP;          //手机号

@property (nonatomic, strong) NSString * CERTID;         //身份证
@property (nonatomic, strong) NSString * IDCHKSTAT;      //证件验证状态 ‘U’ – 未验证 ‘F’ – 验证失败 ‘S’ – 验证成功
@property (nonatomic, strong) NSString * CARDNO;         //结算卡号
@property (nonatomic, strong) NSString * REALFLAG;       //是否实名卡 ‘R’ – 实名卡 ‘N’ –  非实名卡
@property (nonatomic, strong) NSString * ACCTAVL;        //账户余额
@property (nonatomic, strong) NSString * BANKNAME;
@end
