//
//  YRSignPreview.m
//  YunRichMPCR
//
//  Created by YunRich on 15/5/28.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//

#import "YRSignPreview.h"

@interface YRSignPreview ()
@property (weak, nonatomic) IBOutlet UIImageView *middleBack;
@property (weak, nonatomic) IBOutlet UIImageView *top;

@end

@implementation YRSignPreview

+ (instancetype)signPreview{
    return [[NSBundle mainBundle] loadNibNamed:@"YRSignPreview" owner:nil options:nil][0];
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
}

- (void)awakeFromNib{
 
}



@end
