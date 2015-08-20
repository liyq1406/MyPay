//
//  YRDrawCashDetailCell.h
//  YunRichMPCR
//
//  Created by YunRich on 15/5/16.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, TransactionDetailType) {

    TransactionDetailType_MakeCollections = 0,
    TransactionDetailType_DrawCash = 1
};

@interface YRDrawCashDetailCell : UITableViewCell

@property (assign, nonatomic) TransactionDetailType transDetailType;

@property (strong, nonatomic) NSDictionary * transDetailDict;
/*
@property (strong, nonatomic) NSString * acutalTime;
@property (strong, nonatomic) NSString * middleContent;
@property (strong, nonatomic) NSString * trailingContent;
*/
@end
