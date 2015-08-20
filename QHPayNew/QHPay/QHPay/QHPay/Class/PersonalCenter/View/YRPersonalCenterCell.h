//
//  YRPersonalCenterCell.h
//  YunRichMPCR
//
//  Created by YunRich on 15/5/22.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YRPersonalCenterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
+(UINib *)nib;
@end
