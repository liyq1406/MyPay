//
//  YRSignController.m
//  YunRichMPCR
//
//  Created by YunRich on 15/5/27.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//


#import "YRSignController.h"
#import "YRSignView.h"
#import "Config.h"
#import "YRSignPreview.h"
#import "YRTransactionMessage.h"
#import "YRLoginManager.h"
#import "YRDeviceRelative.h"
#import "YRRequestTool.h"
#import "MBProgressHUD+MJ.h"
#import "JBIGUtil.h"

//gyj--import
//#import "QHPay-Swift.h"
//#import "Header-oc-swift.h"
#define Print_TAG       1004

@interface YRSignController () <UIAlertViewDelegate>
{
    CGRect _viewFrame;
    YRSignView * _signView;
    YRSignPreview * _signPreview;
    UIImage * _image;
    YRDeviceRelative * _deviceRelative;
    
//    SignDoneVC *signDVC;
//    SettlementVC *sett;
    UILabel *_conditionCodeLabel;
}
@property (weak, nonatomic) IBOutlet UIImageView *lineDown;
@property (weak, nonatomic) IBOutlet UIImageView *lineUp;
@property (weak, nonatomic) IBOutlet UIView *signBackView;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UIButton *signCompleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *rewriteBtn;

@end

@implementation YRSignController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildUI];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //设置签名界面
    if (self.showType == ShowType_Sign) {
        
        [self buildSignUI];
        
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    
    //回复向左滑动返回
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)buildUI{
    self.title = @"电子签购单";
    _deviceRelative = [YRDeviceRelative shareDeviceRelative];
    self.storeNameLabel.text = _deviceRelative.merName;
    
    if ([self.typeGyj isEqualToString:@"e"]) {

        _transMessage.AMT = [self.dictGyj valueForKey:@"AMT"];
    }
    self.amountLabel.text = [NSString stringWithFormat:@"消费金额 %@",_transMessage.AMT] ;
    
    if (self.showType == ShowType_Check) {
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithIcon:nil highlightedIcon:nil target:self action:@selector(back) barButtonItemType:BarButtonItemTypePopToView];
        
        UIGraphicsBeginImageContext(_viewFrame.size);
        [_signView.layer renderInContext:UIGraphicsGetCurrentContext()];
        _image = UIGraphicsGetImageFromCurrentImageContext();
        
        _signPreview = [YRSignPreview signPreview];
        _signPreview.frame = self.view.bounds;
        
        [self showDetailList];
        [self.view addSubview:_signPreview];
    }else{
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithIcon:nil highlightedIcon:nil target:nil action:nil barButtonItemType:BarButtonItemTypePopToView];
    }

}

- (void)buildSignUI{
    
    //签名view
    
    CGFloat viewFrameW = self.signBackView.frame.size.width;
    CGFloat viewFrameY = CGRectGetMaxY(self.lineUp.frame) + 10;
//    CGFloat viewFrameH = self.lineDown.frame.origin.y - viewFrameY + 5;
    CGFloat viewFrameH = self.lineDown.frame.origin.y - viewFrameY + 5;
//    _viewFrame = CGRectMake((_signBackView.bounds.size.width-600)/2, CGRectGetMaxY(self.lineUp.frame) + 10, 600, 200);
    _viewFrame = CGRectMake(self.signBackView.frame.origin.x, viewFrameY, viewFrameW, viewFrameH);
    
    _signView = [[YRSignView alloc]initWithFrame:_viewFrame];
    _signView.backgroundColor = [UIColor whiteColor];//签名 bg
    
    NSString * date = [_transMessage.DATE substringFromIndex:4];
    if (!(_transMessage.REF.length > 0)) {
        _transMessage.REF = @"000000000000";
    }
    
    //拼接特征码并进行亦或运算
    NSString * conditionCode = [NSString stringWithFormat:@"%@%@",date,_transMessage.REF];
    NSString * head = [conditionCode substringToIndex:8];
    NSString * tail = [conditionCode substringFromIndex:8];
    conditionCode = [YRFunctionTools pinxCreator:head withPinv:tail];
    
    //添加特征码
    _conditionCodeLabel = [[UILabel alloc] init];
    [_conditionCodeLabel setTextColor:[UIColor grayColor]]; //特征码 bg
    
    CGFloat conditionH = 30;
    CGFloat conditionW = _signView.frame.size.width * 0.8;
    CGFloat conditionX = (_signView.frame.size.width - conditionW) * 0.5;
    CGFloat conditionY = (_signView.frame.size.height - conditionH) * 0.5;
    _conditionCodeLabel.frame = CGRectMake(conditionX, conditionY, conditionW, conditionH);
    
    _conditionCodeLabel.tintColor = [UIColor grayColor];//gyj
    
    _conditionCodeLabel.font = [UIFont systemFontOfSize:35];
    _conditionCodeLabel.text = conditionCode;
    _conditionCodeLabel.textAlignment = NSTextAlignmentCenter;
    
    [_signView addSubview:_conditionCodeLabel];
    [_signView sendSubviewToBack:_conditionCodeLabel];
    [_signBackView addSubview:_signView];
    [self.signCompleteBtn.layer setCornerRadius:5.0];
    [self.rewriteBtn.layer setCornerRadius:5.0];
    
    //向左滑动返回不可使用
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:@selector(goBack)];
    [self.navigationItem.leftBarButtonItem setEnabled:NO];
}

- (void)goBack {
    
    
}

- (IBAction)rewriteBtn:(UIButton *)sender {
    [_signView clear];
}

#pragma mark 上传签名
- (IBAction)signComplete:(UIButton *)sender {
    [_conditionCodeLabel setTextColor:[UIColor blackColor]]; //上传前 特征码黑色
    
    UIGraphicsBeginImageContext(_viewFrame.size);
    [_signView.layer renderInContext:UIGraphicsGetCurrentContext()];
    _image = UIGraphicsGetImageFromCurrentImageContext();

    if ([self.typeGyj isEqualToString:@"e"]) { //上传签名
        self.signImage = _image;
        
//        [sett signUpload:_image yrSignVC:self];
        
//        UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        signDVC = [mainSB instantiateViewControllerWithIdentifier:@"SignDone"];
//        [self.navigationController pushViewController: signDVC animated:YES];
        
    }else {
        
        if (_signView.isEmptyName) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请签名后再提交！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
            [alert show];
        }
        else{
           [MBProgressHUD showMessage:@"签名上传中"];
           [self uploadSign];
        }
        
    }
}

- (void)uploadSign{
    
    NSString * customerID = [YRLoginManager shareLoginManager].custID;
    customerID = customerID ? customerID : @"";
    [YRRequestTool uploadSignWithORDID:_transMessage.ORDID customerID:customerID signImage:_image success:^(id responseObject) {
        
        [MBProgressHUD hideHUD];
        _signPreview = [YRSignPreview signPreview];
        _signPreview.frame = self.view.bounds;
        
        [self showDetailList];
        [self.view addSubview:_signPreview];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithIcon:nil highlightedIcon:nil target:self action:@selector(back) barButtonItemType:BarButtonItemTypePopToView];
        
        if ([YRLoginManager shareLoginManager].supportPrinter) {
            //打印清单
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否打印签购清单" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"打印", nil];
            alertView.tag = Print_TAG;
            [alertView show];
        }
        
    } failure:^(NSString *errorInfo) {
        
        [MBProgressHUD hideHUD];
    }];
    
}

- (void)showDetailList{
    
    _transMessage = [self checkWhetherIsNilWithYrtransactionMessage:_transMessage];
    
//    if (_transMessage.REF == nil) {
//        _transMessage.REF = @"";
//    }
    NSString * merName = [[YRDeviceRelative shareDeviceRelative] merName];
    if (!merName) {
        NSString * merchantKey = [NSString stringWithFormat:@"%@%@",[[YRLoginManager shareLoginManager] username],YR_MERNAME];
        merName = [[NSUserDefaults standardUserDefaults] objectForKey:merchantKey];
    }
    merName = merName ? merName : @" ";
    _signPreview.merchantNameLabel.text = [NSString stringWithFormat:@"%@    %@",_signPreview.merchantNameLabel.text,merName];
    _signPreview.merchantNoLabel.text = [NSString stringWithFormat:@"%@ %@",_signPreview.merchantNoLabel.text,_transMessage.BKMERID];
    _signPreview.terminalNoLabel.text = [NSString stringWithFormat:@"%@    %@",_signPreview.terminalNoLabel.text,_transMessage.BKTERMID];
    _signPreview.operatorNoLabel.text = [NSString stringWithFormat:@"%@ %@",_signPreview.operatorNoLabel.text,@"01"];
    _signPreview.cardNoLabel.text = [NSString stringWithFormat:@"%@        %@",_signPreview.cardNoLabel.text,_transMessage.PAN];
    _signPreview.orderNoLabel.text =[NSString stringWithFormat:@"%@    %@",_signPreview.orderNoLabel.text, _transMessage.ORDID];
    
    NSString * validityDateFront = [_transMessage.EXP substringFromIndex:2];
    NSString * validityDateLast = [_transMessage.EXP substringToIndex:2];
    
    
    _signPreview.expDateLabel.text = [NSString stringWithFormat:@"%@    %@/%@",_signPreview.expDateLabel.text,validityDateFront,validityDateLast];
    _signPreview.transTypeLabel.text = [NSString stringWithFormat:@"%@ %@",_signPreview.transTypeLabel.text,@"消费"];
    _signPreview.batchNoLabel.text = [NSString stringWithFormat:@"%@    000001",_signPreview.batchNoLabel.text];
    _signPreview.voucherNoLabel.text =[NSString stringWithFormat:@"%@    %@",_signPreview.voucherNoLabel.text, _transMessage.PSEQ];
    _signPreview.authNoLabel.text = [NSString stringWithFormat:@"%@    %@",_signPreview.authNoLabel.text,_transMessage.AUTH];
    _signPreview.REFLabel.text = [NSString stringWithFormat:@"%@    %@",_signPreview.REFLabel.text,_transMessage.REF];
    NSMutableString * date = [_transMessage.DATE mutableCopy];
    [date insertString:@"/" atIndex:4];
    [date insertString:@"/" atIndex:7];
    NSMutableString * time = [_transMessage.TIME mutableCopy];
    [time insertString:@":" atIndex:2];
    [time insertString:@":" atIndex:5];
    NSString * dateTime = [NSString stringWithFormat:@"%@ %@",date,time];
    _signPreview.dataTimeLabel.text = [NSString stringWithFormat:@"%@ %@",_signPreview.dataTimeLabel.text,dateTime];
    _signPreview.amountLabel.text = [NSString stringWithFormat:@"%@ %@",_signPreview.amountLabel.text,_transMessage.AMT];
    if (self.showType == ShowType_Sign){
        _signPreview.signImage.image = _image;
    }
}

//检测是否为nil
- (YRTransactionMessage *) checkWhetherIsNilWithYrtransactionMessage:(YRTransactionMessage *)message {
    if (message.VER == nil || [message.VER rangeOfString:@"null"].location != NSNotFound) {
        message.VER = @"";
    }
    if (message.PR == nil || [message.PR rangeOfString:@"null"].location != NSNotFound) {
        message.PR = @"";
    }
    if (message.PAN == nil || [message.PAN rangeOfString:@"null"].location != NSNotFound) {
        message.PAN = @"";
    }
    if (message.AMT == nil || [message.AMT rangeOfString:@"null"].location != NSNotFound) {
        message.AMT = @"";
    }
    if (message.PSEQ == nil || [message.PSEQ rangeOfString:@"null"].location != NSNotFound) {
        message.PSEQ = @"";
    }
    if (message.TIME == nil || [message.TIME rangeOfString:@"null"].location != NSNotFound) {
        message.TIME = @"";
    }
    if (message.DATE == nil || [message.DATE rangeOfString:@"null"].location != NSNotFound) {
        message.DATE = @"";
    }
    if (message.EXP == nil || [message.EXP rangeOfString:@"null"].location != NSNotFound) {
        message.EXP = @"";
    }
    if (message.ICSEQ == nil || [message.ICSEQ rangeOfString:@"null"].location != NSNotFound) {
        message.ICSEQ = @"";
    }
    if (message.REF == nil || [message.REF rangeOfString:@"null"].location != NSNotFound) {
        message.REF = @"";
    }
    if (message.AUTH == nil || [message.AUTH rangeOfString:@"null"].location != NSNotFound) {
        message.AUTH = @"";
    }
    if (message.RESP == nil || [message.RESP rangeOfString:@"null"].location != NSNotFound) {
        message.RESP = @"";
    }
    if (message.RESPDESC == nil || [message.RESPDESC rangeOfString:@"null"].location != NSNotFound) {
        message.RESPDESC = @"";
    }
    if (message.POSID == nil || [message.POSID rangeOfString:@"null"].location != NSNotFound) {
        message.POSID = @"";
    }
    if (message.BKTERMID == nil || [message.BKTERMID rangeOfString:@"null"].location != NSNotFound) {
        message.BKTERMID = @"";
    }
    if (message.BKMERID == nil || [message.BKMERID rangeOfString:@"null"].location != NSNotFound) {
        message.BKMERID = @"";
    }
    if (message.ORDID == nil || [message.ORDID rangeOfString:@"null"].location != NSNotFound) {
        message.ORDID = @"";
    }
    if (message.PRT == nil || [message.PRT rangeOfString:@"null"].location != NSNotFound) {
        message.PRT = @"";
    }
    return message;
}

- (void)back{
    
    [self.delegate popBackSignController:self];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == Print_TAG) {
        if (buttonIndex == 1) {//打印
            NSMutableArray *printContent = [[NSMutableArray alloc]init];
            LDC_PrintLineStu *stu0 = [self createLDC_PrintLineStuWithType:PRINTTYPE_TEXT ailg:PRINTALIGN_MID zoom:PRINTZOOM_2 position:PRINTPOSITION_PAGE1 text:@"签购清单"];
            LDC_PrintLineStu *stu1 = [self createLDC_PrintLineStuWithType:PRINTTYPE_TEXT ailg:PRINTALIGN_LEFT zoom:PRINTZOOM_12 position:PRINTPOSITION_PAGE1 text:@"  "];
            //商户
            LDC_PrintLineStu *stu2 = [self createLDC_PrintLineStuWithType:PRINTTYPE_TEXT ailg:PRINTALIGN_LEFT zoom:PRINTZOOM_12 position:PRINTPOSITION_PAGE1 text:[self switchLabelTextToPrintStyleWithStr:_signPreview.merchantNameLabel.text andFrontBit:3 andAddEnglishStr:@"(MERCHANT NAME):" andBackBit:3]];
            
            
            //商户编号
            LDC_PrintLineStu *stu3 = [self createLDC_PrintLineStuWithType:PRINTTYPE_TEXT ailg:PRINTALIGN_LEFT zoom:PRINTZOOM_12 position:PRINTPOSITION_PAGE1 text:[self switchLabelTextToPrintStyleWithStr:_signPreview.merchantNoLabel.text andFrontBit:4 andAddEnglishStr:@"(BKMERID):       " andBackBit:4]];
            
            
            //终端号
            LDC_PrintLineStu *stu4 = [self createLDC_PrintLineStuWithType:PRINTTYPE_TEXT ailg:PRINTALIGN_LEFT zoom:PRINTZOOM_12 position:PRINTPOSITION_PAGE1 text:[self switchLabelTextToPrintStyleWithStr:_signPreview.terminalNoLabel.text andFrontBit:3 andAddEnglishStr:@"(TER):          " andBackBit:3]];
            
            //操作员号
            LDC_PrintLineStu *stu5 = [self createLDC_PrintLineStuWithType:PRINTTYPE_TEXT ailg:PRINTALIGN_LEFT zoom:PRINTZOOM_12 position:PRINTPOSITION_PAGE1 text:[self switchLabelTextToPrintStyleWithStr:_signPreview.operatorNoLabel.text andFrontBit:4 andAddEnglishStr:@"(OPERATOR NO):   " andBackBit:4]];
            
            //卡号
            LDC_PrintLineStu *stu6 = [self createLDC_PrintLineStuWithType:PRINTTYPE_TEXT ailg:PRINTALIGN_LEFT zoom:PRINTZOOM_12 position:PRINTPOSITION_PAGE1 text:[self switchLabelTextToPrintStyleWithStr:_signPreview.cardNoLabel.text andFrontBit:2 andAddEnglishStr:@"(CARD NO):    " andBackBit:2]];
            
            //订单号
            LDC_PrintLineStu *stu7 = [self createLDC_PrintLineStuWithType:PRINTTYPE_TEXT ailg:PRINTALIGN_LEFT zoom:PRINTZOOM_12 position:PRINTPOSITION_PAGE1 text:[self switchLabelTextToPrintStyleWithStr:_signPreview.orderNoLabel.text andFrontBit:3 andAddEnglishStr:@"(ORDID):    " andBackBit:3]];
            
            //有效期
            LDC_PrintLineStu *stu8 = [self createLDC_PrintLineStuWithType:PRINTTYPE_TEXT ailg:PRINTALIGN_LEFT zoom:PRINTZOOM_12 position:PRINTPOSITION_PAGE1 text:[self switchLabelTextToPrintStyleWithStr:_signPreview.expDateLabel.text andFrontBit:3 andAddEnglishStr:@"(EXP DATE):    " andBackBit:3]];
            
            //交易类型
            LDC_PrintLineStu *stu9 = [self createLDC_PrintLineStuWithType:PRINTTYPE_TEXT ailg:PRINTALIGN_LEFT zoom:PRINTZOOM_12 position:PRINTPOSITION_PAGE1 text:[self switchLabelTextToPrintStyleWithStr:_signPreview.transTypeLabel.text andFrontBit:4 andAddEnglishStr:@"(TRANS TYPE):   " andBackBit:4]];
            
            //批次号
            LDC_PrintLineStu *stu10 = [self createLDC_PrintLineStuWithType:PRINTTYPE_TEXT ailg:PRINTALIGN_LEFT zoom:PRINTZOOM_12 position:PRINTPOSITION_PAGE1 text:[self switchLabelTextToPrintStyleWithStr:_signPreview.batchNoLabel.text andFrontBit:3 andAddEnglishStr:@"(BATCH NO):    " andBackBit:3]];
            
            //凭证号
            LDC_PrintLineStu *stu11 = [self createLDC_PrintLineStuWithType:PRINTTYPE_TEXT ailg:PRINTALIGN_LEFT zoom:PRINTZOOM_12 position:PRINTPOSITION_PAGE1 text:[self switchLabelTextToPrintStyleWithStr:_signPreview.voucherNoLabel.text andFrontBit:3 andAddEnglishStr:@"(VOUCHER NO):  " andBackBit:3]];
            
            //授权码
            NSString *text = [NSString stringWithFormat:@"%@%@",_signPreview.authNoLabel.text,_transMessage.AUTH];
            LDC_PrintLineStu *stu12 = [self createLDC_PrintLineStuWithType:PRINTTYPE_TEXT ailg:PRINTALIGN_LEFT zoom:PRINTZOOM_12 position:PRINTPOSITION_PAGE1 text:[self switchLabelTextToPrintStyleWithStr:text andFrontBit:3 andAddEnglishStr:@"(AUTHORIZATION NO):" andBackBit:3]];
            
            //参考号
            LDC_PrintLineStu *stu13 = [self createLDC_PrintLineStuWithType:PRINTTYPE_TEXT ailg:PRINTALIGN_LEFT zoom:PRINTZOOM_12 position:PRINTPOSITION_PAGE1 text:[self switchLabelTextToPrintStyleWithStr:_signPreview.REFLabel.text andFrontBit:3 andAddEnglishStr:@"(REFER NO):    " andBackBit:3]];
           
            //日期时间
            LDC_PrintLineStu *stu14 = [self createLDC_PrintLineStuWithType:PRINTTYPE_TEXT ailg:PRINTALIGN_LEFT zoom:PRINTZOOM_12 position:PRINTPOSITION_PAGE1 text:[self switchLabelTextToPrintStyleWithStr:_signPreview.dataTimeLabel.text andFrontBit:4 andAddEnglishStr:@"(DATE/TIME):    " andBackBit:4]];
            
            //交易金额
            LDC_PrintLineStu *stu15 = [self createLDC_PrintLineStuWithType:PRINTTYPE_TEXT ailg:PRINTALIGN_LEFT zoom:PRINTZOOM_12 position:PRINTPOSITION_PAGE1 text:[self switchLabelTextToPrintStyleWithStr:_signPreview.amountLabel.text andFrontBit:4 andAddEnglishStr:@"(AMOUNT):       " andBackBit:4]];
            
            LDC_PrintLineStu *stu16 = [self createLDC_PrintLineStuWithType:PRINTTYPE_TEXT ailg:PRINTALIGN_LEFT zoom:PRINTZOOM_12 position:PRINTPOSITION_PAGE1 text:@"备注：本人确认以上交易，同意将其记入本卡账户"];
            LDC_PrintLineStu *stu17 = [self createLDC_PrintLineStuWithType:PRINTTYPE_TEXT ailg:PRINTALIGN_LEFT zoom:PRINTZOOM_12 position:PRINTPOSITION_PAGE1 text:@"持卡人签名  "];
            UIImage *zipImage = [self image:_image byScalingToSize:CGSizeMake(240, 80)];
            NSData *imagedata = [JBIGUtil JBIGCompressColorReverse:zipImage];
            NSString *imageStr = [YRFunctionTools nsdata2HexStr:imagedata];;
            LDC_PrintLineStu *stu18 = [self createLDC_PrintLineStuWithType:PRINTTYPE_SINGE ailg:PRINTALIGN_RIGHT zoom:PRINTZOOM_33 position:PRINTPOSITION_PAGE1 text:imageStr];
            [printContent addObject:stu0];
            [printContent addObject:stu1];
            [printContent addObject:stu2];
            [printContent addObject:stu3];
            [printContent addObject:stu4];
            [printContent addObject:stu5];
            [printContent addObject:stu6];
            [printContent addObject:stu7];
            [printContent addObject:stu8];
            [printContent addObject:stu9];
            [printContent addObject:stu10];
            [printContent addObject:stu11];
            [printContent addObject:stu12];
            [printContent addObject:stu13];
            [printContent addObject:stu14];
            [printContent addObject:stu15];
            [printContent addObject:stu16];
            [printContent addObject:stu17];
            [printContent addObject:stu18];
            
            [[LandiMPOS getInstance] printText:1 withPrintContent:printContent successBlock:^{
                NSLog(@"打印成功");
            } failedBlock:^(NSString *errCode, NSString *errInfo) {
                NSLog(@"打印失败");
            }];
        }
    }
}

#pragma mark - 将签购单转换为打印格式
- (NSString *)switchLabelTextToPrintStyleWithStr:(NSString *)labelTextStr
                                     andFrontBit:(NSInteger)frontBit
                                andAddEnglishStr:(NSString *)englishStr
                                      andBackBit:(NSInteger)backBit {
    NSString *printStyleStr = [NSString stringWithFormat:@"%@%@%@",[labelTextStr substringToIndex:frontBit],englishStr,[labelTextStr substringFromIndex:backBit]];
    return printStyleStr;
}

- (LDC_PrintLineStu *)createLDC_PrintLineStuWithType:(LDE_PRINTTYPE)type ailg:(LDE_PRINTALIGN)ailg zoom:(LDE_PRINTZOOM)zoom position:(LDE_PRINTPOSITION)position text:(NSString *)text {
    LDC_PrintLineStu *oneLine = [[LDC_PrintLineStu alloc]init];
    oneLine.type = type;
    oneLine.ailg = ailg;
    oneLine.zoom = zoom;
    oneLine.position = position;
    oneLine.text = text;
    return oneLine;
}

- (UIImage *)image:(UIImage*)image byScalingToSize:(CGSize)targetSize {
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = CGPointZero;
    thumbnailRect.size.width  = targetSize.width;
    thumbnailRect.size.height = targetSize.height;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage ;
}
@end

