//
//  YRFunctionTools.m
//  YunRichMPCR
//
//  Created by YunRich on 15/5/10.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//

#import "YRFunctionTools.h"
#import "AppDelegate.h"
#import "LandiMPOS.h"
#import "GTMBase64.h"

@implementation YRFunctionTools


+ (void)displayMessage:(NSString *)message {
    
    [[LandiMPOS getInstance] displayLines:message Row:2 Col:5 Timeout:5 ClearScreen:CLEARFLAG_YES successBlock:^{
    
    } failedBlock:^(NSString *errCode, NSString *errInfo) {
    
    }];
}

+ (void)setAlertViewWithTitle:(NSString *)title buttonTitle:(NSString *)buttonTitle{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:buttonTitle otherButtonTitles:nil];
    [alert show];
}

+ (void)showAlertViewTitle:(NSString *)title message:(NSString *)content cancelButton:(NSString *)btnTitle
{
    UIAlertView * alertView;
    if (btnTitle) {
        
        alertView = [[UIAlertView alloc] initWithTitle:title message:content delegate:self cancelButtonTitle:btnTitle otherButtonTitles:nil, nil];
        
    }else {
        
        alertView = [[UIAlertView alloc] initWithTitle:title message:content delegate:nil cancelButtonTitle:TIPS_CONFIRM otherButtonTitles:nil, nil];
        
        
        //[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(hiddenAlertView:) userInfo:[NSDictionary dictionaryWithObject:alertView forKey:@"alertView"] repeats:NO];
    }
    [alertView setNeedsLayout];
    [alertView show];
}

- (void)hiddenAlertView:(NSTimer *)timer
{
    UIAlertView * alertView = [timer.userInfo objectForKey:@"alertView"];
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    
}

#pragma mark 登出
+ (void)logoutWithViewController:(UIViewController *)viewController{
    [[LandiMPOS getInstance] closeDevice];
    
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate deleteRequestCookie];
    UINavigationController * navigationC = (UINavigationController *)(delegate.window.rootViewController);
    [navigationC popToRootViewControllerAnimated:YES];
}

#pragma mark 登出
+ (void)logoutWithViewController{
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate deleteRequestCookie];
    [delegate relogIn];
}

#pragma mark string 转 hexString
+(NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}

#pragma mark hexString转string
+ (NSString *)stringFromHexString:(NSString *)hexString isConvertToBase64:(BOOL)base64{ //
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    
    NSString * unicodeString = @"";
    if (base64) {
        unicodeString = [GTMBase64 stringByEncodingBytes:myBuffer length:(hexString.length / 2)];
    }else{
        unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    }
    return unicodeString;
}


#pragma mark data转hexString
+ (NSString*) nsdata2HexStr:(NSData*) data
{
    Byte srcBytes[[data length]];
    [data getBytes:(srcBytes) length:([data length])];
    NSMutableString* srcHexString = [NSMutableString stringWithCapacity:(16)];
    for(int i=0;i<[data length];++i)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%02x",srcBytes[i]&0xff];
        [srcHexString appendString:(newHexStr)];
    }
    return srcHexString;
}

#pragma mark hexString转data
+ (NSData *)HexConvertToASCII:(NSString *)hexString{
    int j=0;
    Byte bytes[8];  ///3ds key的Byte 数组， 128位
    for(int i=0;i<[hexString length];i++)
    {
        int int_ch;  /// 两位16进制数转化后的10进制数
        
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        
        int int_ch1;
        
        if(hex_char1 >= '0' && hex_char1 <='9')
            
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        
        else
            
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        
        int int_ch2;
        
        if(hex_char2 >= '0' && hex_char2 <='9')
            
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        
        else
            
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        
        int_ch = int_ch1+int_ch2;
        
        //        NSLog(@"int_ch=%d",int_ch);
        
        bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
        
        j++;
        
    }
    
    NSData *newData = [[NSData alloc] initWithBytes:bytes length:8];
    return newData;
}

#pragma mark 异或运算
+(NSString *)pinxCreator:(NSString *)pan withPinv:(NSString *)pinv
{
    if (pan.length != pinv.length)
    {
        return nil;
    }
    
    const char *panchar = [pan UTF8String];
    const char *pinvchar = [pinv UTF8String];
    
    
    NSString *temp = [[NSString alloc] init];
    
    for (int i = 0; i < pan.length; i++)
    {
        int panValue = [self charToint:panchar[i]];
        int pinvValue = [self charToint:pinvchar[i]];
        
        temp = [temp stringByAppendingString:[NSString stringWithFormat:@"%X",panValue^pinvValue]];
    }
    return temp;
    
}

+(int)charToint:(char)tempChar
{
    if (tempChar >= '0' && tempChar <='9')
    {
        return tempChar - '0';
    }
    else if (tempChar >= 'A' && tempChar <= 'F')
    {
        return tempChar - 'A' + 10;
    }
    
    return 0;
}


@end