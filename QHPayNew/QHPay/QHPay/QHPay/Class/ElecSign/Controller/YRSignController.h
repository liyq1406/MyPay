//
//  YRSignController.h
//  YunRichMPCR
//
//  Created by YunRich on 15/5/27.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QHPayBaseViewController.h"
typedef enum {
    ShowType_Check = 0,
    ShowType_Sign = 1
}ShowType;


@class YRTransactionMessage,YRSignController;

@protocol YRSignDelegate <NSObject>

- (void)popBackSignController:(UIViewController *)vc;

@end

@interface YRSignController : QHPayBaseViewController

@property (assign, nonatomic) id<YRSignDelegate> delegate;

@property (nonatomic, strong) YRTransactionMessage * transMessage;

@property (assign, nonatomic) ShowType showType;

@property (strong, nonatomic) NSString * typeGyj;
@property (nonatomic, strong) UIImage * signImage; //gyj
@property (strong, nonatomic) NSMutableDictionary *dictGyj;


@end
