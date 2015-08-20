//
//  YRVerifyRegexTool.h
//  YunRichMPCR
//
//  Created by YunRich on 15/5/8.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YRVerifyRegexTool : NSObject
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
+ (BOOL)verifyIDCardNumber:(NSString *)value;
#pragma mark 判断输入是否为数字或字母
+ (BOOL)validtaeUserName:(NSString *)userName;
@end
