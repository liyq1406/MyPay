//
//  YRAboutViewController.h
//  YunRichMPCR
//
//  Created by YunRich on 15/5/27.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QHPayBaseViewController.h"
typedef NS_ENUM(NSInteger, ShowAboutViewStyle) {
    
    ShowAboutViewStyle_Present = 0,
    ShowAboutViewStyle_Pop = 1
};

@interface YRAboutViewController : QHPayBaseViewController

@property (assign, nonatomic) ShowAboutViewStyle aboutViewStyle;

@end
