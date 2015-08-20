//
//  NString+PSM.m
//  YunRichMPCR
//
//  Created by YunRich on 15/6/11.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//

#import "NSString+PSM.h"

@implementation NSString (PSM)

#pragma mark 去掉字符串中的空格和换行
+ (NSString *)stringReplaceSpacingAndLinefeedWithString:(NSString *)string{
    NSString * newString = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    newString = [newString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return newString;
}

@end
