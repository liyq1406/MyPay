//
//  YRSelectDateView.m
//  YunRichMPCR
//
//  Created by YunRich on 15/5/18.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//

#import "YRSelectDateView.h"

@implementation YRSelectDateView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)selectedQueryDate:(UIButton *)sender {
    
    NSString * title = nil;
    title = sender.titleLabel.text;
    self.selectDateBlock(title,sender.tag);
    //self selectDateBlock:<#^(NSString *title, NSInteger tag)selectBlock#>
    /*
    switch (sender.tag) {
        case 110:
        {
            
        }
            break;
        case 111:
        {
            
        }
            break;
        case 112:
        {
            
        }
            break;
        case 113:
        {
            
        }
            break;
        case 114:
        {
            
        }
            break;
        case 115:
        {
            
        }
            break;
        default:
            break;
    }*/
}


@end
