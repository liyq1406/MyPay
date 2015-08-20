//
//  YRSelectDrawCashWayViewController.m
//  YunRichMPCR
//
//  Created by YunRich on 15/5/26.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//

#import "YRSelectDrawCashWayViewController.h"

@interface YRSelectDrawCashWayViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation YRSelectDrawCashWayViewController {
    
    __weak IBOutlet UILabel *_choseDrawCashWay;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithIcon:nil highlightedIcon:nil target:self action:@selector(goBack) barButtonItemType:BarButtonItemTypePopToView];
    // Do any additional setup after loading the view from its nib.

    self.title = @"选择取现方式";
}

- (void)goBack {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * Identifier = @"ReusedCell";
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier];
    
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UIImageView * selectedImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-51, 6, 31, 31)];
    
    [cell.contentView addSubview:selectedImage];
    
    if (indexPath.row == 0) {
        
        if (![_drawCash isEqualToString:@"T0"]) {
            
            [selectedImage setImage:[UIImage imageNamed:@"ic_cb_selected"]];
            cell.textLabel.textColor = [UIColor colorWithRed:43.0/255 green:139.0/255 blue:217.0/255 alpha:1];
        }else {
            
            [selectedImage setImage:[UIImage imageNamed:@"ic_cb_unselected"]];
        }
        cell.textLabel.text = @"普通取现";
        //cell.detailTextLabel.text = @"下一工作日到账";
    }else if (indexPath.row == 1){
        
        cell.textLabel.text = @"即时取现";
        if (self.isGotAuth) {
            
            if (![_drawCash isEqualToString:@"T1"]) {
                
                cell.textLabel.textColor = [UIColor colorWithRed:43.0/255 green:139.0/255 blue:217.0/255 alpha:1];
                [selectedImage setImage:[UIImage imageNamed:@"ic_cb_selected"]];
            }else {
                
                [selectedImage setImage:[UIImage imageNamed:@"ic_cb_unselected"]];
            }
        }else {
            
            //cell.textLabel.textColor = [UIColor colorWithRed:43.0/255 green:139.0/255 blue:217.0/255 alpha:1];
            cell.detailTextLabel.text = @"暂未开通";
            cell.textLabel.textColor = cell.detailTextLabel.textColor;
        }
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        _drawCash = @"T1"; //@"普通取现";
       
    }else if (indexPath.row == 1){
        
        if (self.isGotAuth) {
            
            _drawCash = @"T0";
        }else {
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        
    }else {
        
        //drawCash = @"T0"; // @"即时取现";
    }
    [self.delegate selectDrawCashWay:self whichOne:_drawCash];
    [self.tableView reloadData];
    //[self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 13;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 100;
    }else
        return 120;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    if ([_drawCash isEqualToString:@"T0"]) {
        
       NSString * tips = @"即时取现： 您的初始即时取现额度为50000元/日，会根据信用记录浮动上调。手续费：即时取现金额的0.3%。到账时间：2小时内（因不同银行处理时间不同，部分银行入账可能出现延迟）。";
        return tips;
    }else if ([_drawCash isEqualToString:@"T1"]){
        
        NSString * tips = @"普通取现： 免手续费，到账时间为下个工作日下午3时-4时；如在夜间10点以后进行普通提款操作，则到账时间为第2个工作日下午3时-4时（因不同银行处理时间不同，部分银行入账可能会出现延迟）；";
        return tips;
    }else
        return @"";
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
