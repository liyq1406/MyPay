//
//  SelectVersionViewController.m
//  QHPay
//
//  Created by liqunfei on 15/7/16.
//  Copyright (c) 2015年 chenlizhu. All rights reserved.
//

#import "QHSelectStoreViewController.h"
#import "QHLoginController.h"
#import "QHNavigationController.h"
#import "YRSearchMPOSController.h"
#import "YRMainViewController.h"
#define CELLIDENTIFIER @"cellID"

@interface QHSelectStoreViewController ()<UITableViewDataSource,UITableViewDelegate> {
    NSIndexPath *_selectedIndexPath;
}
@property (weak, nonatomic) IBOutlet UITableView *versionTableView;
@property (weak, nonatomic) IBOutlet UIButton *commit;

@end

@implementation QHSelectStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectedIndexPath = [NSIndexPath indexPathForRow:100 inSection:100];
    
    self.title = @"店铺类型";
    self.view.layer.contents = (id)[UIImage imageNamed:@"qh_rootbg"].CGImage;
    self.versionTableView.backgroundColor = [UIColor clearColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithIcon:nil highlightedIcon:nil target:self action:@selector(selectVersionBack) barButtonItemType:BarButtonItemTypePopToView];
}

- (void)selectVersionBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CELLIDENTIFIER];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLIDENTIFIER];
        cell.imageView.layer.frame = CGRectMake(5, 5, 20, 20);
        cell.imageView.image = [UIImage imageNamed:@"qh_select_n"];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"百货商店";
    } else if (indexPath.row == 1) {
        cell.textLabel.text  = @"批发商铺";
    }
    else {
        cell.textLabel.text = @"";
    }
    if (_selectedIndexPath.row == indexPath.row) {
        cell.imageView.image = [UIImage imageNamed:@"qh_select_y"];
    }
    else {
        cell.imageView.image = [UIImage imageNamed:@"qh_select_n"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedIndexPath = indexPath;
    [tableView reloadData];
    [self.commit setEnabled:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (IBAction)confirmBtn:(UIButton *)sender {
    //确保已经选择好设备之后跳转到搜索设备界面
      YRMainViewController *conllectVC = [[YRMainViewController alloc]init];
    if (_selectedIndexPath.row == 0) {
        conllectVC.storeType = DepartmentStore;
    } else if (_selectedIndexPath.row == 1) {
        conllectVC.storeType = WholeSale;
    }
    else {
        conllectVC.storeType = ElseStore;
    }
     conllectVC.dealType = DealTypeConllection;
     [self.navigationController pushViewController:conllectVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
