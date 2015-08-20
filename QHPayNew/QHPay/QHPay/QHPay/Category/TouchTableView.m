//
//  TouchTableView.m
//  QHPay
//
//  Created by chenlizhu on 15/8/18.
//  Copyright (c) 2015年 chenlizhu. All rights reserved.
//

#import "TouchTableView.h"

@implementation TouchTableView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesBegan:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}

@end
