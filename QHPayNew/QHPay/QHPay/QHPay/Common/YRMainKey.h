//
//  YRMainKey.h
//  YunRichMPCR
//
//  Created by YunRich on 15/4/17.
//  Copyright (c) 2015年 yunrich. All rights reserved.
//

#import "YRBaseModal.h"

@interface YRMainKey : YRBaseModal

@property (strong, nonatomic) NSString * VER; //
@property (strong, nonatomic) NSString * PR;// 固定填写9006
@property (strong, nonatomic) NSString * PSEQ;// POS流水号

@property (strong, nonatomic) NSString * TIME;//
@property (strong, nonatomic) NSString * DATE;//POS收到后重置本地日期和时间
@property (strong, nonatomic) NSString * RESP;//返回码
@property (strong, nonatomic) NSString * RESPDESC;//如果有值，则POS优先显示该描述
@property (strong, nonatomic) NSString * POSDEVID;//唯一标识每台物理设备号，9位数字，由POSP系统分配，密钥下载完成后回传给POS机具
@property (strong, nonatomic) NSString * MAINKEY;//32位长度，由POSP回传时通过3DES加密生成，密钥为POSDEVID+FILLCODE+ DATE+ TIME，不足32位右补0
@property (strong, nonatomic) NSString * KVC;// 16位，主密钥明文对8个0x00进行3Des的ASC码
@property (nonatomic, strong) NSString * MAC;

@end
