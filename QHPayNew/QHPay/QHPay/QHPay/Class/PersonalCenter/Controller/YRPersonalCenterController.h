//
//  YRPersonalCenterController.h
//  YunRichMPCR
//
//  Created by YunRich on 15/3/26.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QHPayBaseViewController.h"
typedef NS_ENUM(NSInteger, ShowStyle) {

    ShowStyle_Present = 0,
    ShowStyle_Pop = 1

};

@interface YRPersonalCenterController : QHPayBaseViewController

@property (assign, nonatomic) ShowStyle showStyle;

@end
