//
//  YRSettingTableViewController.h
//  YunRichMPCR
//
//  Created by YunRich on 15/5/21.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ShowViewStyle) {

    ShowViewStyle_Present = 0,
    ShowViewStyle_Pop = 1
};

@interface YRSettingTableViewController : UITableViewController

@property (assign, nonatomic) ShowViewStyle showViewStyle;

@end
