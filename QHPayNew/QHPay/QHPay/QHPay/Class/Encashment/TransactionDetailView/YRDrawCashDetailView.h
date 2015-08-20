//
//  YRDrawCashDetailView.h
//  YunRichMPCR
//
//  Created by YunRich on 15/5/16.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YRDrawCashDetailCell.h"
#import "YRDrawCashDetailModel.h"
#import "MJRefresh.h"

@interface YRDrawCashDetailView : UIView<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *dateBtn;


@property (strong, nonatomic) NSMutableDictionary * allTransactions;
@property (strong, nonatomic) YRSelectDateView * selectDateView;

- (void)startSendRequest;
- (void)cancelRequest;

@end
