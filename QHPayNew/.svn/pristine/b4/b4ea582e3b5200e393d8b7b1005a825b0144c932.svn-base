//
//  YRFunctionTools.h
//  YunRichMPCR
//
//  Created by YunRich on 15/5/10.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YRFunctionTools : NSObject


+ (void)setAlertViewWithTitle:(NSString *)title buttonTitle:(NSString *)buttonTitle;

+ (void)showAlertViewTitle:(NSString *)title message:(NSString *)content cancelButton:(NSString *)btnTitle;

+ (void)logoutWithViewController:(UIViewController *)viewController;

+ (void)logoutWithViewController;

#pragma mark string转hexString
+ (NSString *)hexStringFromString:(NSString *)string;

#pragma mark hexString转string
+ (NSString *)stringFromHexString:(NSString *)hexString isConvertToBase64:(BOOL)base64;

#pragma mark data转hexString
+ (NSString*) nsdata2HexStr:(NSData*) data;

#pragma mark hexString转data
+ (NSData *)HexConvertToASCII:(NSString *)hexString;

+ (void)displayMessage:(NSString *) message;

#pragma mark 异或运算
+ (NSString *)pinxCreator:(NSString *)pan withPinv:(NSString *)pinv;

@end
