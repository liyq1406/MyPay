//
//  YRWorkKey.h
//  YunRichMPCR
//
//  Created by YunRich on 15/4/17.
//  Copyright (c) 2015年 yunrich. All rights reserved.
//

#import "YRBaseModal.h"

@interface YRWorkKey : YRBaseModal

@property (strong, nonatomic) NSString * VER; //
@property (strong, nonatomic) NSString * PR;// 处理码 固定填写9009
@property (strong, nonatomic) NSString * PSEQ;// POS流水号

@property (strong, nonatomic) NSString * TIME;//
@property (strong, nonatomic) NSString * DATE;//POS收到后重置本地日期和时间
@property (strong, nonatomic) NSString * RESP;//返回码
@property (strong, nonatomic) NSString * RESPDESC;//如果有值，则POS优先显示该描述
@property (strong, nonatomic) NSString * POSID;// POS 终端号
@property (strong, nonatomic) NSString * PINKEY; // pin 密钥 32位ASC字符，被终端主密钥加密
@property (strong, nonatomic) NSString * PACKKEY; // 整包密钥 32位ASC字符，被终端主密钥加密
@property (strong, nonatomic) NSString * MACKEY;  // MAC签名密钥 32位ASC字符，被终端主密钥加密
@property (strong, nonatomic) NSString * PINKVC;//PIN密钥校验值 16位，PIN密钥明文对8个0x00进行3Des的ASC码
@property (strong, nonatomic) NSString * PACKKVC;// PACK密钥校验值 16位，PACK密钥明文对8个0x00进行3Des的ASC码
@property (strong, nonatomic) NSString * MACKVC; //MAC密钥校验值 16位，MAC密钥明文对8个0x00进行3Des的ASC码
@property (strong, nonatomic) NSString * PRTNAME; //小票打印商户简称
@property (strong, nonatomic) NSString * WAITDISP; // 待机画面显示的名称，如：十里河灯饰城
//对于01版本，应答时为空
//对于02、66版本，应答时必填
//固定为5行，\n表示换行，如:\n\n十里河灯饰城\n统一收银\n，表示在第3、4行显示



@property (strong, nonatomic) NSString * REMARK;//20个定长字符，每个字符代表特定含义，POS完成签到后根据特定含义完成特定动作；如比较公钥版本号和本地不符，向POSP发起9015请求交易
//1-2位：IC公钥版本号，目前为01
//3-4位：IC参数版本号，目前为01
//5位：是否支持降级交易，1代表支持，0代表不支持

@end
