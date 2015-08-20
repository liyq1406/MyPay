//
//  SelectVersionViewController.m
//  QHPay
//
//  Created by liqunfei on 15/7/16.
//  Copyright (c) 2015年 chenlizhu. All rights reserved.
//

#import "QHSelectVersionViewController.h"
#import "QHLoginController.h"
#import "QHNavigationController.h"
#import "YRSearchMPOSController.h"

#define CELLIDENTIFIER @"cellID"

@interface QHSelectVersionViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *versionTableView;

@end

@implementation QHSelectVersionViewController {
    NSInteger _celectLineNumber;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _celectLineNumber = -1;
    self.title = @"选择设备型号";
    self.view.layer.contents = (id)[UIImage imageNamed:@"qh_rootbg"].CGImage;
    
    self.versionTableView.backgroundColor = [UIColor clearColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithIcon:nil highlightedIcon:nil target:self action:@selector(selectVersionBack) barButtonItemType:BarButtonItemTypePopToView];
}

- (void)selectVersionBack {
    if (self.selecType == registerType) {
        NSArray *controllerArr = self.navigationController.viewControllers;
        QHLoginController *loginVC = controllerArr[controllerArr.count - 3];
        [self.navigationController popToViewController:loginVC animated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.versionTableView dequeueReusableCellWithIdentifier:CELLIDENTIFIER];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLIDENTIFIER];
    }
    cell.imageView.layer.frame = CGRectMake(5, 5, 20, 20);
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"联迪-M35";
    } else if (indexPath.row == 1) {
        cell.textLabel.text  = @"联迪-M15";
    } else if (indexPath.row == 2) {
        cell.textLabel.text  = @"联迪-M36";
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"新大陆-ME11";
    }
    
    if (indexPath.row == _celectLineNumber) {
        cell.imageView.image = [UIImage imageNamed:@"qh_select_y"];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"qh_select_n"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _celectLineNumber = indexPath.row;
    
    [self.versionTableView reloadData];
    
}
- (IBAction)confirmBtn:(UIButton *)sender {
    //确保已经选择好设备之后跳转到搜索设备界面
    if (_celectLineNumber > -1) {
        YRSearchMPOSController *searchVC = [[YRSearchMPOSController alloc] init];
        
        if (_celectLineNumber == 0) {
            searchVC.deviceVersion = Landi_M35;
        } else if (_celectLineNumber == 1) {
            searchVC.deviceVersion = Landi_M15;
        } else if (_celectLineNumber == 2) {
            searchVC.deviceVersion =Landi_M36;
        } else if (_celectLineNumber == 3) {
            searchVC.deviceVersion = XDL_ME11;
        };
        
        if (self.selecType == registerType) {//注册
            searchVC.searchMPOSEnterType = SearchMPOSEnterTypeRegister;
        } else if (self.selecType == setType) {//设置
            searchVC.searchMPOSEnterType = SearchMPOSEnterTypeSetting;
        } else if (self.selecType == loginType) {//登录
            searchVC.searchMPOSEnterType = SearchMPOSEnterTypeLogin;
        } else if (self.selecType == changeNumberType) {//登录手机号有变化时
            searchVC.searchMPOSEnterType = SearchMPOSEnterTypeChangeNumber;
        }
        
        [self.navigationController pushViewController:searchVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
