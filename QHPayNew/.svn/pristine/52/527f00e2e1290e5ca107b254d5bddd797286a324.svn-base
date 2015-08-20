//
//  YRDrawCashDetailCell.m
//  YunRichMPCR
//
//  Created by YunRich on 15/5/16.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//

#import "YRDrawCashDetailCell.h"

@implementation YRDrawCashDetailCell {
    
    __weak IBOutlet UILabel *_bankCardLabel;
    __weak IBOutlet UILabel *_timeLabel;
    __weak IBOutlet UILabel *_cashValueLabel;
    __weak IBOutlet UILabel *_statusLabel;
    __weak IBOutlet UILabel *_feeLabel;
    
    __weak IBOutlet UIImageView *_imageView;
}


- (void)setTransDetailType:(TransactionDetailType)transDetailType {
    
    _transDetailType = transDetailType;
    
    if (_transDetailType == TransactionDetailType_DrawCash) {
        
        [_imageView setImage:[UIImage imageNamed:@"ic_g_money_small_blue"]];
    }else if (_transDetailType == TransactionDetailType_MakeCollections) {
        
        [_imageView setImage:[UIImage imageNamed:@"ic_list_money_blue"]];
    }
}

- (void)setTransDetailDict:(NSDictionary *)transDetailDict {
    
    _transDetailDict = transDetailDict;
    
    if (_transDetailDict) {
        
        NSString * timeStr = [_transDetailDict[@"SYSTIME"] substringToIndex:4];
        NSString * hourStr = [timeStr substringToIndex:2];
        NSString * minStr = [timeStr substringFromIndex:2];
        _timeLabel.text = [NSString stringWithFormat:@"%@:%@",hourStr,minStr];
        
        _bankCardLabel.text = _transDetailDict[@"CARDID"] ? _transDetailDict[@"CARDID"] : @"";
        _statusLabel.text = _transDetailDict[@"TRANSSTATDESC"] ? _transDetailDict[@"TRANSSTATDESC"] : @"";
        _cashValueLabel.text = _transDetailDict[@"TRANSAMT"] ? _transDetailDict[@"TRANSAMT"] : @"";
        _feeLabel.text = [NSString stringWithFormat:@"手续费:%@",_transDetailDict[@"FEEAMT"] ? _transDetailDict[@"FEEAMT"] : @""];

        if (self.transDetailType == TransactionDetailType_DrawCash) {
            
            
        }else if (self.transDetailType == TransactionDetailType_MakeCollections){
            
        }
    }
    
    
    
}

- (void)awakeFromNib {
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
