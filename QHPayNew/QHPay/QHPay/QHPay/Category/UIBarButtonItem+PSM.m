//
//  UIBarButtonItem+PSM.m
//  新浪微博
//
//  Created by Goodsoft Inc. on 14-11-7.
//  Copyright (c) 2014年 panshengmao. All rights reserved.
//

#import "UIBarButtonItem+PSM.h"
#import <Foundation/Foundation.h>

@interface UIBarButtonItem ()<UINavigationControllerDelegate>
@end

@implementation UIBarButtonItem (PSM)
- (id)initWithIcon:(NSString *)icon highlightedIcon:(NSString *)highlightedIcon target:(id)target action:(SEL)action barButtonItemType:(BarButtonItemType)barButtonItemType{
    
    //创建按钮
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //设置普通背景图片
//    UIImage * image = [UIImage imageNamed:@"ic_g_return"];
    [btn setBackgroundImage:[UIImage imageNamed:@"ic_g_return"] forState:UIControlStateNormal];
    
    //设置高亮背景图片
    [btn setBackgroundImage:[UIImage imageNamed:@"ic_g_return"] forState:UIControlStateHighlighted];
    
    //设置尺寸
//    btn.bounds = (CGRect){CGPointZero, image.size};
    btn.bounds = (CGRect){CGPointZero,CGSizeMake(25, 25)};
    
    if (barButtonItemType == BarButtonItemTypeCustom) {
        //设置普通背景图片
        [btn setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
        
        //设置高亮背景图片
        [btn setBackgroundImage:[UIImage imageNamed:highlightedIcon] forState:UIControlStateHighlighted];
        
    }
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [self initWithCustomView:btn];
}

@end
