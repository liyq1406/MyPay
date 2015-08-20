//
//  YRDrawCashDetailModel.h
//  YunRichMPCR
//
//  Created by YunRich on 15/5/18.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YRDrawCashRequest.h"
#import "YRSelectDateView.h"

@interface YRDrawCashDetailModel : NSObject


+ (void)getDrawCashDetalWithDateType:(DateDurationType)dateType pageNum:(NSInteger)pageNum drawCashRequest:(id)request successBlock:(void (^)(id))successBlock failureBlock:(void (^)(NSString *))failureBlock;

@end
