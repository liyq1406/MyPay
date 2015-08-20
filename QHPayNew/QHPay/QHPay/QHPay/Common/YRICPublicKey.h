//
//  YRPublicKey.h
//  YunRichMPCR
//
//  Created by YunRich on 15/4/17.
//  Copyright (c) 2015年 yunrich. All rights reserved.
//

#import "YRBaseModal.h"

@interface YRICPublicKey : YRBaseModal

@property (strong, nonatomic) NSString * VER; //
@property (strong, nonatomic) NSString * PR;// 处理码 固定填写9015
@property (strong, nonatomic) NSString * PSEQ;// POS流水号

@property (strong, nonatomic) NSString * TIME;//
@property (strong, nonatomic) NSString * DATE;//POS收到后重置本地日期和时间
@property (strong, nonatomic) NSString * RESP;//返回码
@property (strong, nonatomic) NSString * RESPDESC;//如果有值，则POS优先显示该描述

@property (strong, nonatomic) NSString * POSID; // POS终端号
@property (strong, nonatomic) NSString * KEYCNT;//公钥条目数 最大2位数字，POS收到条目数后，后续应循环发起下载所有公钥
@property (strong, nonatomic) NSString * INX;//公钥下标  最大2位数字，如1代表第一个公钥
@property (strong, nonatomic) NSString * PUBKEY; //公钥 下发的公钥数据

@end
