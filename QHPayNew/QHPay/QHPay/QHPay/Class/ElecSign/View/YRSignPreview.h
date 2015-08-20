//
//  YRSignPreview.h
//  YunRichMPCR
//
//  Created by YunRich on 15/5/28.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YRSignPreview : UIView
@property (weak, nonatomic) IBOutlet UILabel *merchantNameLabel;//商户名
@property (weak, nonatomic) IBOutlet UILabel *merchantNoLabel;//商户编号
@property (weak, nonatomic) IBOutlet UILabel *terminalNoLabel;//终端号
@property (weak, nonatomic) IBOutlet UILabel *operatorNoLabel;//操作员号
@property (weak, nonatomic) IBOutlet UILabel *cardNoLabel;//卡号
@property (weak, nonatomic) IBOutlet UILabel *orderNoLabel;//订单号
@property (weak, nonatomic) IBOutlet UILabel *expDateLabel;//有效期
@property (weak, nonatomic) IBOutlet UILabel *transTypeLabel;//交易类别
@property (weak, nonatomic) IBOutlet UILabel *batchNoLabel;//批次号
@property (weak, nonatomic) IBOutlet UILabel *voucherNoLabel;//凭证号-流水号
@property (weak, nonatomic) IBOutlet UILabel *authNoLabel;//授权码
@property (weak, nonatomic) IBOutlet UILabel *REFLabel;//参考号
@property (weak, nonatomic) IBOutlet UILabel *dataTimeLabel;//日期时间
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;//交易金额
@property (weak, nonatomic) IBOutlet UIImageView *signImage;

+ (instancetype)signPreview;
@end
