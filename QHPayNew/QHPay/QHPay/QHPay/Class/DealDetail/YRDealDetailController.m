//
//  YRDealDetailController.m
//  YunRichMPCR
//
//  Created by YunRich on 15/4/1.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//
#define Time_Order_Key  @"timeOrderKey"

#import "YRDealDetailController.h"
#import "YROpenAccountViewController.h"
#import "YRSelectDateView.h"
#import "YRDealDetailModel.h"
#import "YRDrawCashDetailCell.h"
#import "YRTransactionMessage.h"
#import "YRSignController.h"
#import "YRMainViewController.h"
#import "MBProgressHUD+MJ.h"

#import "MJRefresh.h"

#define kDisplayViewH 60
#define kDealFont [UIFont systemFontOfSize:15]
#define kNumOfDeal 200
#define kMoneyOfDeal 100000

@interface YRDealDetailController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate,YRSignDelegate>

@end

@implementation YRDealDetailController {
    
    YRSelectDateView * _selectDateView;
    __weak IBOutlet UILabel *_totalNumsLabel;
    __weak IBOutlet UILabel *_totalCashLabel;
    __weak IBOutlet UITableView *_loadTableView;
    __weak IBOutlet UIView *_bottomView;
    __weak IBOutlet UIButton *_dateBtn;
    
    DateDurationType _dateType;
    MJRefreshFooterView * _footView;
    NSInteger _times;
    BOOL _isLoadingMore;
    NSMutableDictionary * _orderLists;
    
    BOOL _isNeedFresh;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _footView = [MJRefreshFooterView footer];
    _footView.scrollView = _loadTableView;
    _footView.delegate = self;
    _orderLists = [NSMutableDictionary dictionary];
    _isNeedFresh = NO;
    _loadTableView.layer.contents = (id)[UIImage imageNamed:@"qh_rootbg"].CGImage;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
     _times = 1;
    
    if (_dateBtn.selected) {
        
        [_selectDateView setHidden:YES];
        _dateBtn.selected = NO;
    }
    
    if (!_isNeedFresh) {
        
        [MBProgressHUD showMessage:@"查询交易明细中..."];
        [self sendRequestAndUpdateDataSourcesWith:DateDurationType_Today andPageNum:_times];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    NSArray * singleDayOrders = _orderLists[Time_Order_Key];
    return singleDayOrders.count > 0 ? singleDayOrders.count : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSArray * singleDayOrders = _orderLists[Time_Order_Key];
    if (_orderLists.count > 1) {
        
        NSArray * orderKeys = _orderLists[singleDayOrders[section]];
        
        return [orderKeys count] > 0 ? [orderKeys count] : 0;
    }else {
        
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * Identifier = @"Cell";
    
    YRDrawCashDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YRDrawCashDetailCell" owner:self options:nil] objectAtIndex:0];
    }
    NSArray * orderKeys = [_orderLists objectForKey:Time_Order_Key];
    
    if (orderKeys.count > 0) {
        
        NSString * keys = orderKeys[indexPath.section];
        
        NSArray * singleDayOrders = _orderLists[keys];
        NSDictionary * dict = singleDayOrders[indexPath.row];
        
        [cell setTransDetailType:TransactionDetailType_MakeCollections];
        [cell setTransDetailDict:dict];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSArray * orderKeys = [_orderLists objectForKey:Time_Order_Key];
    
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

- (IBAction)chooseDate:(UIButton *)sender {
    
    if (!_selectDateView) {
        
        _selectDateView = [[[NSBundle mainBundle] loadNibNamed:@"YRSelectDateView" owner:self options:nil] objectAtIndex:0];
        [self.view addSubview:_selectDateView];
        CGRect dateViewRect = self.view.bounds;
        dateViewRect.size.height = 123;//444/1920 * self.bounds.size.height;
        dateViewRect.origin.y = _bottomView.frame.origin.y - dateViewRect.size.height;
        dateViewRect.size.width = sender.frame.size.width;
        [_selectDateView setFrame:dateViewRect];
    }
    if (_selectDateView) {
        __weak YRDealDetailController * detailView = self;
        [_selectDateView setSelectDateBlock:^(NSString *title, NSInteger tag) {
            
            [detailView updateDateTitle:title withButton:sender andTag:tag];
        }];
    }
    if (sender.selected) {
        
        sender.selected = NO;
        [_selectDateView setHidden:YES];
    }else {
        
        sender.selected = YES;
        [_selectDateView setHidden:NO];
    }
}

- (void)updateDateTitle:(NSString *)title withButton:(UIButton *)btn andTag:(NSInteger)tag{
    
    [btn setTitle:title forState:UIControlStateNormal];
    [_selectDateView setHidden:YES];
    btn.selected = NO;
    
    //DateDurationType dateType ;
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
    [MBProgressHUD showMessage:[NSString stringWithFormat:@"正在查询“%@”的交易记录",title]];
    [self sendRequestAndUpdateDataSourcesWith:_dateType andPageNum:_times];
}

- (void)sendRequestAndUpdateDataSourcesWith:(DateDurationType)dateType andPageNum:(NSInteger)pageNum {
    
    [YRDealDetailModel queryDealDetailWithDateType:dateType pageNum:pageNum successBlock:^(id responseObject) {
        
        [MBProgressHUD hideHUD];
        [_footView endRefreshing];
        if ([responseObject[YR_OUTPUT_KEY_STATES_RESP_CODE] isEqualToString:YR_STATIC_SUCCESS_STATES_CODE]) {
            
            [self updateAllDateSources:responseObject];
        }else {
            
            if (_times > 1) {
                
                _times--;
            }
            [YRFunctionTools showAlertViewTitle:@"错误提示" message:[NSString stringWithFormat:@"[%@]%@",responseObject[YR_OUTPUT_KEY_STATES_RESP_DESC],responseObject[YR_OUTPUT_KEY_STATES_RESP_CODE]] cancelButton:TIPS_CONFIRM];
        }
        _isLoadingMore = NO;
    } failureBlock:^(NSString *errorInfo) {
        [MBProgressHUD hideHUD];
        _isLoadingMore = NO;
        if (_times > 1) {
            
            _times--;
        }
        [_footView endRefreshing];
        [YRFunctionTools showAlertViewTitle:nil message:TIPS_MESSAGES cancelButton:TIPS_CONFIRM];
    }];
}

#pragma mark -- 更新数据源
- (void)updateAllDateSources:(NSDictionary *)responseObject {
    
    if (_isLoadingMore) {
        
        id sourceObject = responseObject[@"ORDLOGLIST"];
        if ([sourceObject isKindOfClass:[NSArray class]]) {
            
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
            _totalCashLabel.text = [NSString stringWithFormat:@"%@元",responseObject[@"TOTALAMT"] ? responseObject[@"TOTALAMT"] : @"0.00"];
            NSString * transactionNums = responseObject[@"TOTALCNT"] ? responseObject[@"TOTALCNT"] : @"0";
            _totalNumsLabel.text = [NSString stringWithFormat:@"共%@笔",transactionNums];
        }else {
            
            //[YRFunctionTools showAlertViewTitle:nil message:responseObject[YR_OUTPUT_KEY_STATES_RESP_DESC] cancelButton:TIPS_CONFIRM];
            [self showAlertViewTitle:nil message:[NSString stringWithFormat:@"[%@]%@",responseObject[YR_OUTPUT_KEY_STATES_RESP_DESC],responseObject[YR_OUTPUT_KEY_STATES_RESP_CODE]] cancelButton:nil];
        }
        
    }else {
        
        id sourceObject = responseObject[@"ORDLOGLIST"];
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

            _totalCashLabel.text = [NSString stringWithFormat:@"%@元",responseObject[@"TOTALAMT"] ? responseObject[@"TOTALAMT"] : @"0.00"];
            NSString * transactionNums = responseObject[@"TOTALCNT"] ? responseObject[@"TOTALCNT"] : @"0";
            _totalNumsLabel.text = [NSString stringWithFormat:@"共%@笔",transactionNums];
        }else {
            
            [self showAlertViewTitle:nil message:[NSString stringWithFormat:@"[%@]%@",responseObject[YR_OUTPUT_KEY_STATES_RESP_DESC],responseObject[YR_OUTPUT_KEY_STATES_RESP_CODE]] cancelButton:nil];
        }
    }
    if (![responseObject[@"ORDLOGLIST"] isKindOfClass:[NSNull class]] && [responseObject[@"ORDLOGLIST"] count] > 0) {
        
        if (_isLoadingMore) {
            
            [_orderLists removeObjectForKey:Time_Order_Key];
        }
        
        NSArray * orderKeys = [_orderLists allKeys];
        NSArray * allKeys = [orderKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            if ([obj1 compare:obj2] == NSOrderedDescending) {
                
                return NSOrderedAscending;
            }else
                return NSOrderedDescending;
        }];
        [_orderLists setObject:allKeys forKey:Time_Order_Key];
        [_loadTableView reloadData];
    }
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
    
    NSArray * singleDayOrders = _orderLists[Time_Order_Key];
    NSString * keys = singleDayOrders[indexPath.section];
    NSArray * orders = _orderLists[keys];
    NSDictionary * dict = orders[indexPath.row];
    
    YRTransactionMessage * message = [[YRTransactionMessage alloc] init];
    message.BKMERID = dict[@"BANKMERID"] ? dict[@"BANKMERID"] : @"";
    message.BKTERMID = dict[@"BANKTERMID"] ? dict[@"BANKTERMID"] : @"";
    message.PAN = dict[@"CARDID"] ? dict[@"CARDID"] : @"";
    message.ORDID = dict[@"ORDID"] ? dict[@"ORDID"] : @"";
    message.EXP = dict[@"EXPDATE"] ? dict[@"EXPDATE"] : @"";
    //message.t = dict[@"TRANSTYPE"] ? dict[@"TRANSTYPE"] : @"";
    message.PSEQ = dict[@"POSSEQID"] ? dict[@"POSSEQID"] : @"";
    message.AUTH = dict[@"AUTHCODE"] ? dict[@"AUTHCODE"] : @"";
    message.DATE = dict[@"TRANSDATE"] ? dict[@"TRANSDATE"] : @"";
    message.TIME = dict[@"SYSTIME"] ? dict[@"SYSTIME"] : @"";
    message.AMT = dict[@"TRANSAMT"] ? dict[@"TRANSAMT"] : @"";
    message.REF = dict[@"REFNUM"] ? dict[@"REFNUM"] : @"";
    
    YRSignController * signC = [YRSignController new];
    signC.delegate = self;
    signC.transMessage = message;
    signC.showType = ShowType_Check;
    [self.navigationController pushViewController:signC animated:YES];
}

#pragma mark -- YRSignDelegate 
- (void)popBackSignController:(UIViewController *)vc {
    
    _isNeedFresh = YES;
}

// 开始进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView {
    
    _isLoadingMore = YES;
    _times++;
    [self sendRequestAndUpdateDataSourcesWith:_dateType andPageNum:_times];
}

-(void)dealloc{
    
    [_footView free];
}

@end
