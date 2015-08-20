//
//  YRTransactionMessage.h
//  YunRichMPCR
//
//  Created by 李向阳 on 15/4/8.
//  Copyright (c) 2015年 yunrich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YRBaseModal.h"

@interface YRTransactionMessage : YRBaseModal


@property (strong, nonatomic) NSString * VER ; // version number
@property (strong, nonatomic) NSString * PR ;   //   处理码1001
@property (strong, nonatomic) NSString * PAN; // 账号
@property (strong, nonatomic) NSString * AMT; // 交易金额 以元为单位，格式为小数点后保留2位，例如：12.00
@property (strong, nonatomic) NSString * PSEQ;// pos 流水号
@property (strong, nonatomic) NSString * TIME;// 主机时间
@property (strong, nonatomic) NSString * DATE;// 主机日期
@property (strong, nonatomic) NSString * EXP;// 具有有效期的卡存在
@property (strong, nonatomic) NSString * ICSEQ;// 卡序列号 当POS能够获得该值时存在，对于IC交易
@property (strong, nonatomic) NSString * REF; // 参考号
@property (strong, nonatomic) NSString * AUTH;// 授权号
@property (strong, nonatomic) NSString * RESP;// 返回码
@property (strong, nonatomic) NSString * RESPDESC;// 应答描述
@property (strong, nonatomic) NSString * POSID;// POS在银行申请分配的8位终端号
@property (strong, nonatomic) NSString * BKTERMID; // 银行分配给pos的终端号 8位数字
@property (strong, nonatomic) NSString * BKMERID; //银行分配给pos的商户号，15位数字
@property (strong, nonatomic) NSString * ORDID; // 订单号
@property (strong, nonatomic) NSString * PRT ;// 打印 如该域返回不为空，则POS在小票的备注栏的下一行打印该值，支持#换行

@end
