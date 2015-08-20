//
//  YRLoanModel.h
//  YunRichMPCR
//
//  Created by lixiangyang on 15/6/10.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YRLoanModel : NSObject
@property (nonatomic,strong) NSString *VER;//版本号
@property (nonatomic,strong) NSString *CUSTID;//客户号
@property (nonatomic,strong) NSString *LOANBANKID;//贷款银行代号
@property (nonatomic,strong) NSString *EXPECTEDRANGE;//贷款范围
@property (nonatomic,strong) NSString *LOANPURPOSES;//贷款用途

@property (nonatomic,strong) NSString *RESP;//返回码
@property (nonatomic,strong) NSString *RESPDESC;//错误信息
@property (nonatomic,strong) NSString *REGDATE;//申请日期
@property (nonatomic,strong) NSString *REGSEQID;//流水号
@property (nonatomic,strong) NSString *REGTIME;//申请时间
@property (nonatomic,strong) NSString *STAT;//申请状态

@end
