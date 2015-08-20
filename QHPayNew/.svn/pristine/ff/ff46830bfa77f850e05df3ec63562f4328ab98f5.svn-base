//
//  YRSwitchEnviroment.m
//  YunRichMPCR
//
//  Created by YunRich on 15/6/2.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//

#import "YRSwitchEnviroment.h"

@implementation YRSwitchEnviroment


+ (YRSwitchEnviroment *)shareSwitchEnviroment {
    
    static YRSwitchEnviroment * switchManager = nil;
    
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        
        switchManager = [[YRSwitchEnviroment alloc] init];
    });
    
    return switchManager;
}

@end
