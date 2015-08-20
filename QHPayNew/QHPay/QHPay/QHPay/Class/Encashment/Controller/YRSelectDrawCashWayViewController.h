//
//  YRSelectDrawCashWayViewController.h
//  YunRichMPCR
//
//  Created by YunRich on 15/5/26.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QHPayBaseViewController.h"
@class YRSelectDrawCashWayViewController ;

@protocol YRSelectDrawCashWayDelegate <NSObject>

- (void)selectDrawCashWay:(YRSelectDrawCashWayViewController *)selectVC whichOne:(NSString *)way;

@end

@interface YRSelectDrawCashWayViewController : QHPayBaseViewController

@property (assign, nonatomic) id<YRSelectDrawCashWayDelegate> delegate;

@property (assign, nonatomic) BOOL isGotAuth;
@property (strong, nonatomic) NSString * drawCash;

@end
