//
//  YRPersonMessage.m
//  YunRichMPCR
//
//  Created by YunRich on 15/5/14.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//

#import "YRPersonMessage.h"

@implementation YRPersonMessage


-(void)setIDCHKSTAT:(NSString *)IDCHKSTAT{
    _IDCHKSTAT = IDCHKSTAT;
    if ([IDCHKSTAT isEqualToString:@"U"]) {
        _IDCHKSTAT = @"未验证";
    }else if ([IDCHKSTAT isEqualToString:@"F"]){
        _IDCHKSTAT = @"验证失败";
    }else{
        _IDCHKSTAT = @"验证成功";
    }
    
}

-(void)setREALFLAG:(NSString *)REALFLAG{
    _REALFLAG = REALFLAG;
    if ([REALFLAG isEqualToString:@"R"]) {
        _REALFLAG = @"实名卡";
    }else{
        _REALFLAG = @"非实名卡";
    }
    
}
@end
