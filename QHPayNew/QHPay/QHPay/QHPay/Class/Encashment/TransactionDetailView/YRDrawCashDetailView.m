//
//  YRDrawCashDetailView.m
//  YunRichMPCR
//
//  Created by YunRich on 15/5/16.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//
#define Order_Key   @"OrderKey"

#import "YRDrawCashDetailView.h"
#import "YRSelectDateView.h"
#import "MBProgressHUD+MJ.h"


@implementation YRDrawCashDetailView {
    
    __weak IBOutlet UITableView *_tableView;
    
    __weak IBOutlet UILabel *_dateTitleLabel;
    __weak IBOutlet UILabel *_transactionsTotalLabel;
    __weak IBOutlet UILabel *_transcationCashTotalLabel;
    __weak IBOutlet UIView *_bottomView;
    
    DateDurationType _dateType;
    MJRefreshFooterView * _footView;
    NSInteger _times;
    BOOL _isLoadingMore;
    NSMutableDictionary * _orderLists;
    YRDrawCashRequest * _drawCashRequest;
    NSTimer * _timer;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    
    _orderLists = [NSMutableDictionary dictionary];
    [_tableView registerNib:[UINib nibWithNibName:@"YRDrawCashDetailCell" bundle:nil] forCellReuseIdentifier:@"reusedCell"];
    _footView = [MJRefreshFooterView footer];
    _footView.scrollView = _tableView;
    _footView.delegate = self;
    _drawCashRequest = [[YRDrawCashRequest alloc] init];
    
    _tableView.layer.contents = (id)[UIImage imageNamed:@"qh_rootbg"].CGImage;
}

- (void)startSendRequest {
    
    _times = 1;
    _dateType = DateDurationType_Today;
    [MBProgressHUD showMessage:@"查询取现明细中..."];
    [self sendRequestAndUpdateDataSourcesWith:_dateType andPageNum:_times];
}

- (void)cancelRequest {
    
    if (_drawCashRequest) {
        
        [_drawCashRequest cancel];
    }
}

#pragma mark -- 请求API
- (void)sendRequestAndUpdateDataSourcesWith:(DateDurationType)dateType andPageNum:(NSInteger)pageNum {
    
    if (!_drawCashRequest) {
        
        _drawCashRequest = [[YRDrawCashRequest alloc] init];
    }
    
    [YRDrawCashDetailModel getDrawCashDetalWithDateType:dateType pageNum:pageNum drawCashRequest:_drawCashRequest successBlock:^(id responseObject) {
        
        [MBProgressHUD hideHUD];
        [_footView endRefreshing];
        if ([responseObject[YR_OUTPUT_KEY_STATES_RESP_CODE] isEqualToString:YR_STATIC_SUCCESS_STATES_CODE]) {
            
            [self updateAllDateSourcesWith:responseObject];
        }else {
            if (_times > 1) {
                
                _times--;
            }
            [YRFunctionTools showAlertViewTitle:@"错误提示" message:[NSString stringWithFormat:@"[%@]%@",responseObject[YR_OUTPUT_KEY_STATES_RESP_DESC],responseObject[YR_OUTPUT_KEY_STATES_RESP_CODE]] cancelButton:TIPS_CONFIRM];
        }
        
    } failureBlock:^(NSString *errorInfo) {
        
        [MBProgressHUD hideHUD];
        if (_times > 1) {
            
            _times--;
        }
        [_footView endRefreshing];
    }];
}

#pragma mark -- 更新所有信息
- (void)updateAllDateSourcesWith:(NSDictionary *)responseObject {
    
    if (_isLoadingMore) {
        
        id sourceObject = responseObject[@"CASHLOGLIST"];
        if (sourceObject && [sourceObject isKindOfClass:[NSArray class]]) {
            
            NSArray * orderLists = (NSArray *)sourceObject;
            
            NSMutableDictionary * allOrderList = [NSMutableDictionary dictionary];
            
            // 判断 有多少个section，也就是有多少天
            for (NSDictionary * orderDict in orderLists) {
                
                [allOrderList setObject:orderDict forKey:orderDict[@"TRANSDATE"]];
            }
            
            // 把相同时间的数据 放到一个数组中 再把所有的数据放到字典中 key值是时间
            for (NSString * transDate in [allOrderList allKeys]) {
                
                NSMutableArray * sameDateOrders = nil;
                
                if (_orderLists[transDate] && [_orderLists[transDate] count] > 0 ) {
                    
                    sameDateOrders = [NSMutableArray arrayWithArray:_orderLists[transDate]];
                }else {
                    
                    sameDateOrders = [NSMutableArray array];
                }
                
                for (NSDictionary * singleTransDict in orderLists) {
                    
                    if ([singleTransDict[@"TRANSDATE"] isEqualToString:transDate]) {
                        
                        [sameDateOrders addObject:singleTransDict];
                    }
                }
                [_orderLists setObject:sameDateOrders forKey:transDate];
            }
            _transcationCashTotalLabel.text = [NSString stringWithFormat:@"%@元",responseObject[@"TOTALAMT"] ? responseObject[@"TOTALAMT"] : @"0.00"];
            NSString * transactionNums = responseObject[@"TOTALNUM"] ? responseObject[@"TOTALNUM"] : @"0";
            _transactionsTotalLabel.text = [NSString stringWithFormat:@"共%@笔",transactionNums];
        }else {
            
            //[YRFunctionTools showAlertViewTitle:nil message:[NSString stringWithFormat:@"“%@” 的取现记录已加载完毕",_dateTitleLabel.text] cancelButton:TIPS_CONFIRM];
            [self showAlertViewTitle:nil message:[NSString stringWithFormat:@"“%@” 的取现记录已加载完毕",_dateTitleLabel.text] cancelButton:nil];
        }
        
    }else {
        
        id sourceObject = responseObject[@"CASHLOGLIST"];
        if ([sourceObject isKindOfClass:[NSArray class]]) {
            
            [_orderLists removeAllObjects];
            NSArray * orderLists = (NSArray *)sourceObject;
            
            NSMutableDictionary * allOrderList = [NSMutableDictionary dictionary];
            
            // 判断 有多少个section，也就是有多少天
            for (NSDictionary * orderDict in orderLists) {
                
                [allOrderList setObject:orderDict forKey:orderDict[@"TRANSDATE"]];
            }
            // 把相同时间的数据 放到一个数组中 再把所有的数据放到字典中 key值是时间
            for (NSString * transDate in [allOrderList allKeys]) {
                
                NSMutableArray * sameDateOrders = [NSMutableArray array];
                
                for (NSDictionary * singleTransDict in orderLists) {
                    
                    if ([singleTransDict[@"TRANSDATE"] isEqualToString:transDate]) {
                        
                        [sameDateOrders addObject:singleTransDict];
                    }
                }
                [_orderLists setObject:sameDateOrders forKey:transDate];
            }
            _transcationCashTotalLabel.text = [NSString stringWithFormat:@"%@元",responseObject[@"TOTALAMT"] ? responseObject[@"TOTALAMT"] : @"0.00"];
            NSString * transactionNums = responseObject[@"TOTALNUM"] ? responseObject[@"TOTALNUM"] : @"0";
            _transactionsTotalLabel.text = [NSString stringWithFormat:@"共%@笔",transactionNums];
        }else {

            [self showAlertViewTitle:nil message:[NSString stringWithFormat:@"没有查询到“%@”的取现记录",_dateTitleLabel.text] cancelButton:nil];
        }
    }
    if (![responseObject[@"CASHLOGLIST"] isKindOfClass:[NSNull class]] && [responseObject[@"CASHLOGLIST"] count] > 0) {
        
        if (_isLoadingMore) {
            
            [_orderLists removeObjectForKey:Order_Key];
        }
        NSArray * orderKeys = [_orderLists allKeys];
        NSArray * allKeys = [orderKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            if ([obj1 compare:obj2] == NSOrderedDescending) {
                
                return NSOrderedAscending;
            }else
                return NSOrderedDescending;
        }];
        [_orderLists setObject:allKeys forKey:Order_Key];
        [_tableView reloadData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSArray * singleDayOrders = _orderLists[Order_Key];
    return singleDayOrders.count > 0 ? singleDayOrders.count : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray * singleDayOrders = _orderLists[Order_Key];
    if (_orderLists.count > 1) {
        
        NSArray * orderKeys = _orderLists[singleDayOrders[section]];
        
        return [orderKeys count] > 0 ? [orderKeys count] : 0;
    }else {
        
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * Identifier = @"reusedCell";
    YRDrawCashDetailCell * detailCell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!detailCell) {
        
        detailCell = [[[NSBundle mainBundle] loadNibNamed:@"YRDrawCashDetailCell" owner:self options:nil] objectAtIndex:0];
    }
    NSArray * orderKeys = [_orderLists objectForKey:Order_Key];
    NSString * keys = orderKeys[indexPath.section];
    NSArray * singleDayOrders = _orderLists[keys];
    if (singleDayOrders.count > 0) {
        
        NSDictionary * dict = singleDayOrders[indexPath.row];
        [detailCell setTransDetailType:TransactionDetailType_DrawCash];
        [detailCell setTransDetailDict:dict];
    }
    
    return detailCell;
}

#pragma mark --选择日期
- (IBAction)selectDate:(id)sender {
    
    UIButton * selectBtn = (UIButton *)sender;
    if (!_selectDateView) {
        
        _selectDateView = [[[NSBundle mainBundle] loadNibNamed:@"YRSelectDateView" owner:self options:nil] objectAtIndex:0];
        [self addSubview:_selectDateView];
        CGRect dateViewRect = self.bounds;
        dateViewRect.size.height = 123;//444/1920 * self.bounds.size.height;
        dateViewRect.origin.y = _bottomView.frame.origin.y - dateViewRect.size.height;
        dateViewRect.size.width = selectBtn.frame.size.width;
        [_selectDateView setFrame:dateViewRect];
    }
    if (_selectDateView) {
        
        __weak YRDrawCashDetailView * detailView = self;
        [_selectDateView setSelectDateBlock:^(NSString *title, NSInteger tag) {
            
            [detailView updateDateTitle:title withButton:selectBtn andTag:tag];
        }];
    }
    if (selectBtn.selected) {
        
        selectBtn.selected = NO;
        [_selectDateView setHidden:YES];
    }else {
        
        selectBtn.selected = YES;
        [_selectDateView setHidden:NO];
    }
}

- (void)updateDateTitle:(NSString *)title withButton:(UIButton *)btn andTag:(NSInteger)tag{
    
    _dateTitleLabel.text = title;
    [_selectDateView setHidden:YES];
    btn.selected = NO;
    
    switch (tag) {
        case 111:
        {
            _dateType = DateDurationType_ThreeMonth;
        }
            break;
        case 112:
        {
            _dateType = DateDurationType_CurrentMonth;
        }
            break;
        case 113:
        {
            _dateType = DateDurationType_CurrentWeek;
        }
            break;
        case 114:
        {
            _dateType = DateDurationType_Yesterday;
        }
            break;
        case 115:
        {
            _dateType = DateDurationType_Today;
        }
            break;
        default:
            break;
    }
    _times = 1;
    [MBProgressHUD showMessage:[NSString stringWithFormat:@"正在查询“%@”的取现记录",title]];
    [self sendRequestAndUpdateDataSourcesWith:_dateType andPageNum:_times];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSArray * orderKeys = [_orderLists objectForKey:Order_Key];
    NSString * keys = nil;
    
    if (orderKeys.count > 0) {
        
        keys = orderKeys[section];
        NSString * yearStr = [keys substringToIndex:4];
        NSString * monthStr = [keys substringWithRange:NSMakeRange(4, 2)];
        NSString * dayStr = [keys substringFromIndex:6];
        keys = [NSString stringWithFormat:@"%@-%@-%@",yearStr,monthStr,dayStr];
    }
    return keys;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 53;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
    NSArray * orderKeys = [_orderLists allKeys];
    NSString * keys = orderKeys[indexPath.section];
    
    NSArray * singleDayOrders = _orderLists[keys];
    NSDictionary * dict = singleDayOrders[indexPath.row];
    */
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView {
    
    _times++;
    [self sendRequestAndUpdateDataSourcesWith:_dateType andPageNum:_times];
}

// 可以自动消失的alertView
- (void)showAlertViewTitle:(NSString *)title message:(NSString *)content cancelButton:(NSString *)btnTitle
{
    UIAlertView * alertView = nil;
    if (btnTitle) {
        alertView = [[UIAlertView alloc] initWithTitle:title
                                               message:content
                                              delegate:self
                                     cancelButtonTitle:btnTitle
                                     otherButtonTitles:nil, nil];
        
    }else {
        alertView = [[UIAlertView alloc] initWithTitle:title
                                               message:content
                                              delegate:self
                                     cancelButtonTitle:nil
                                     otherButtonTitles:nil, nil];
        
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:self
                                                    selector:@selector(hiddenAlertView:)
                                                    userInfo:[NSDictionary dictionaryWithObject:alertView forKey:@"alertView"]
                                                     repeats:NO];
    }
    [alertView setNeedsLayout];
    [alertView show];
}

- (void)hiddenAlertView:(NSTimer *)timer
{
    UIAlertView * alertView = [timer.userInfo objectForKey:@"alertView"];
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)dealloc {
    
//    [_timer invalidate];
//    _timer = nil;
    [_footView free];
}

@end
