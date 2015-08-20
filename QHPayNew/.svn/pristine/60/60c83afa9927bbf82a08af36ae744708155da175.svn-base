//
//  YRLoginManager.m
//  YunRichMPCR
//
//  Created by YunRich on 15/4/9.
//  Copyright (c) 2015年 yunrich. All rights reserved.
//

#import "YRLoginManager.h"


@implementation YRLoginManager


+ (YRLoginManager *)shareLoginManager {
    
    static YRLoginManager * loginManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        loginManager = [[YRLoginManager alloc] init];
    });
    return loginManager;
    
    
}

- (BOOL)isLogin {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:YR_INPUT_KEY_SESSION_ID]) {
        
        return YES;
    }else {
        
        return NO;
    }
}

- (void)saveSessionId:(NSString *)sessionId {
    
    [[NSUserDefaults standardUserDefaults] setObject:sessionId forKey:YR_INPUT_KEY_SESSION_ID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)sessionId {
    
    NSString * SESSIONID = [[NSUserDefaults standardUserDefaults] objectForKey:YR_INPUT_KEY_SESSION_ID];
    if (SESSIONID) {
        
        return SESSIONID;
    }else
        return nil;
}

- (void)setDeviceType:(NSString *)deviceType {
    _deviceType = deviceType;
    if ([deviceType isEqualToString:@"M35"] || [deviceType isEqualToString:@"M36"] || [deviceType isEqualToString:@"M15"]) {
        _factoryName = QH_LD_FACTORY_NAME;
    }
    else if ([deviceType isEqualToString:@"ME11"]) {
        _factoryName = QH_XDL_FACTORY_NAME;
    }
}

@end
