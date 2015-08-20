//
//  YRCustomTableView.m
//  YunRichMPCR
//
//  Created by YunRich on 15/5/18.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//

#import "YRCustomTableView.h"

@implementation YRCustomTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (NSArray *)dataSources {
    
    if (!_dataSources) {
        _dataSources = @[@"起止日期",@"3个月",@"本月",@"本周",@"昨天"];
    }
    return _dataSources;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    
    return 6;
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}
*/
@end
