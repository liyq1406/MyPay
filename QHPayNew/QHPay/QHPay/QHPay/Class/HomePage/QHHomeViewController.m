//
//  QHHomeViewController.m
//  YunRichMPCR
//
//  Created by liqunfei on 15/6/23.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//

#import "QHHomeViewController.h"
#import "YRMainViewController.h"
#import "YREncashmentViewController.h"
#import "YRPersonalCenterController.h"
#import "YRSettingTableViewController.h"
#import "YRAboutViewController.h"
#import "QHSurveyViewController.h"
#import "CycleScrollView.h"
#import "QHSelectStoreViewController.h"
#import "AppDelegate.h"
@interface QHHomeViewController ()
{
    CycleScrollView *mainScrollView;
    NSString *_companyStr;
}
@property (weak, nonatomic) IBOutlet UIView *scrollExampleView;

@end

@implementation QHHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _companyStr = [[NSUserDefaults standardUserDefaults] objectForKey:COMPANYNAME];
    if ([_companyStr isEqualToString:@"QHPay"]) {
        self.title = @"钱海支付";
    } else if ([_companyStr isEqualToString:@"YDPay"]) {
        self.title = @"源达支付";
    }
    self.view.layer.contents = (id)[UIImage imageNamed:@"qh_rootbg"].CGImage;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 25, 25);
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"qh_tel"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(tel) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.hidesBackButton = YES;
    [self createImageScroll];
}

- (void)tel {
    NSString *phoneNum = [[NSString alloc] init];
    if ([_companyStr isEqualToString:@"QHPay"]) {
        phoneNum = @"4000785777";
    } else if ([_companyStr isEqualToString:@"YDPay"]) {
        phoneNum = @"4008273973";
    }

    NSString *telUrl = [NSString stringWithFormat:@"telprompt:%@",phoneNum];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createImageScroll{
    NSMutableArray *imageviews = [@[] mutableCopy];
    NSArray *images = [[NSArray alloc] init];
    //根据公司名自来操作
    _companyStr = [[NSUserDefaults standardUserDefaults] objectForKey:COMPANYNAME];
    if ([_companyStr isEqualToString:@"QHPay"]) {
        images = @[@"qh_home_topImagine.jpg",@"qh_home_topImage1.jpg",@"qh_home_topImage2.jpg"];
    } else if ([_companyStr isEqualToString:@"YDPay"]) {
        images = @[@"qh_home_topImagine.jpg",@"qh_home_topImage1.jpg"];
    }
    for (int i = 0; i<images.count; i++) {
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.scrollExampleView.frame.size.height)];
        imageview.image = [UIImage imageNamed:[images objectAtIndex:i]];
        if (i == 2) {
            UIButton *but = [[UIButton alloc]initWithFrame:imageview.frame];
            [but setTag:105];
            [but addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [imageview addSubview:but];
        }
        [imageviews addObject:imageview];
    }
   mainScrollView = [[CycleScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.scrollExampleView.frame.size.height) animationDuration:5.];
    mainScrollView.totalPagesCount = ^NSInteger(void){
        return imageviews.count;
    };
    mainScrollView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return imageviews[pageIndex];
    };
    [self.view addSubview:mainScrollView];
}

- (IBAction)btnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 101://快速取款
        {
            YRMainViewController * dealMainVC = [[YRMainViewController alloc] initWithNibName:@"YRMainViewController" bundle:nil];
            dealMainVC.dealType = DealTypeConllection;
            dealMainVC.storeType = ElseStore;
            [self.navigationController pushViewController:dealMainVC animated:YES];
        }
            break;
        case 102://取现
        {
            YREncashmentViewController * encashmentVC = [YREncashmentViewController new];
            [self.navigationController pushViewController:encashmentVC animated:YES];
        }
            break;
        case 103://个人
        {
            YRPersonalCenterController * personalCenterC = [YRPersonalCenterController new];
            personalCenterC.showStyle = ShowStyle_Pop;
            [self.navigationController pushViewController:personalCenterC animated:YES];
        }
            break;
        case 104://设置
        {
            YRSettingTableViewController * settingVC = [YRSettingTableViewController new];
            settingVC.showViewStyle = ShowViewStyle_Pop;
            [self.navigationController pushViewController:settingVC animated:YES];
        }
            break;
        case 105://问卷
        {
            QHSurveyViewController *surveyVC = [[QHSurveyViewController alloc] init];
            [self.navigationController pushViewController:surveyVC animated:YES];
        }
            break;
        case 106://关于
        {
            YRAboutViewController * aboutVC = [YRAboutViewController new];
            aboutVC.aboutViewStyle = ShowAboutViewStyle_Present;
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
            break;
        case 107://多店铺
        {
            QHSelectStoreViewController *selectStoreVC = [[QHSelectStoreViewController alloc]init];
            [self.navigationController pushViewController:selectStoreVC animated:YES];
        }
        default:
            break;
    }
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
