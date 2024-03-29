//
//  YRRequestDevice.m
//  YunRichMPCR
//
//  Created by YunRich on 15/4/21.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//

#import "YRRequestDeviceTool.h"
#import "YRTransactionTool.h"
#import "GTMBase64.h"
#import "YRDeviceRelative.h"
#import "YRTransactionMessage.h"
#import "YRMD5Encryption.h"
#import "YRSignController.h"
//#import "DESUtil.h"
//gyj--import
//#import "QHPay-Swift.h"
//#import "Header-oc-swift.h"

#define DES_ENCRY_KEY   @"YunZhiFu"

@implementation YRRequestDeviceTool {
 
    //gyj
//    SettlementVC * sett; //e管家的结算收款
//    ReturnVC * retu; //退款
    YRTransactionMessage * _transMessage;
    BOOL _isSuccessed;
   
    //音频时需要(获取密码是从快速收款界面传过来的)
    LDE_CardType _cardtype;
    //1.磁条卡
    LDC_TrackDataInfo *_audioTrackData;
    NSString          *_carNum;

}

#pragma mark 拼接密钥
+ (NSString *)appendKey:(NSString *)key KVC:(NSString *)KVC{
    NSString * newKVC = [KVC substringToIndex:8];
    
    NSString * MKEY = [key stringByAppendingString:newKVC];
    return MKEY;
}

#pragma mark 导入密钥
+ (void)loadKey:(NSString *)key keyType:(LDE_KEYTYPE)keyType success:(void (^)())success failure:(void (^)(NSString * errInfo))failure{
    LandiMPOS * manger = [LandiMPOS getInstance];
    LFC_LoadKey * loadKey = [[LFC_LoadKey alloc] init];
    

    loadKey.keyData = key;
    loadKey.keyType = keyType;

    if (keyType == KEYTYPE_MKEY) {
        loadKey.MkeyID = 0x00;
    }else{
        loadKey.keyId = 0x00;
    }
    [manger loadKey:loadKey successBlock:^{
        
        success();
    } failedBlock:^(NSString *errCode, NSString *errInfo) {
        failure(errInfo);
    }];
}

#pragma mark 导入IC卡公钥

+ (void)downloadPublicKey:(NSString*)publicKey num:(NSInteger)num success:(void (^)())success failure:(void (^)(NSString * errInfo))failure{
    LandiMPOS * manger = [LandiMPOS getInstance];
    if (num == 1) {
        [manger clearPubKey:^{
            [manger addPubKey:publicKey successBlock:^{
                success();
            } failedBlock:^(NSString *errCode, NSString *errInfo) {
                failure(errInfo);
                [MBProgressHUD hideHUD];
                [YRFunctionTools showAlertViewTitle:nil message:errInfo cancelButton:TIPS_CONFIRM];
            }];
        } failedBlock:^(NSString *errCode, NSString *errInfo) {
            
            [MBProgressHUD hideHUD];
            [YRFunctionTools showAlertViewTitle:nil message:errInfo cancelButton:TIPS_CONFIRM];
            failure(errInfo);
        }];
    }else{
        [manger addPubKey:publicKey successBlock:^{
            success();
        } failedBlock:^(NSString *errCode, NSString *errInfo) {
            
            [MBProgressHUD hideHUD];
            [YRFunctionTools showAlertViewTitle:nil message:errInfo cancelButton:TIPS_CONFIRM];
            failure(errInfo);
        }];
    }

    
}

#pragma mark 导入IC卡参数

+ (void)downloadAid:(NSString *)aid num:(NSInteger)num success:(void (^)())success failure:(void (^)(NSString * errInfo))failure{
    LandiMPOS * manger = [LandiMPOS getInstance];
    if (num == 1) {
        [manger clearAids:^{
            [manger AddAid:aid successBlock:^{
                success();
            } failedBlock:^(NSString *errCode, NSString *errInfo) {
                
                [MBProgressHUD hideHUD];
                [YRFunctionTools showAlertViewTitle:nil message:errInfo cancelButton:TIPS_CONFIRM];
                failure(errInfo);
            }];
        } failedBlock:^(NSString *errCode, NSString *errInfo) {
            
            [MBProgressHUD hideHUD];
            [YRFunctionTools showAlertViewTitle:nil message:errInfo cancelButton:TIPS_CONFIRM];
        }];
    }else{
        [manger AddAid:aid successBlock:^{
            success();
        } failedBlock:^(NSString *errCode, NSString *errInfo) {
            
            [MBProgressHUD hideHUD];
            [YRFunctionTools showAlertViewTitle:nil message:errInfo cancelButton:TIPS_CONFIRM];
            failure(errInfo);
        }];
    }
    
}

/*
#pragma mark VC传参
-(void)initWithVC:(UIViewController *)uivc {
    self.uivc = uivc;
    if([self.uivc isKindOfClass:[SettlementVC class]]) {
        sett = (SettlementVC *)self.uivc; //结算
    }else {
        retu = (ReturnVC *)self.uivc; //退货
    }
}*/

#pragma mark 开始交易

-(void)beginDealWithMoenyNum:(NSString *)moneyNum payType:(PayType)payType{
    self.payType = payType;
    self.moneyNum = moneyNum;
    YRDeviceRelative * device = [YRDeviceRelative shareDeviceRelative];
    self.posID = device.posId;
    LandiMPOS * manager = [LandiMPOS getInstance];
    //获取卡的类型
    [manager waitingCard:@"消费" timeOut:30 CheckCardTp:SUPPORTCARDTYPE_MAG_IC_RF moneyNum:moneyNum successBlock:^(LDE_CardType cardtype) {
        [MBProgressHUD hideHUD];
        [self performSelectorOnMainThread:@selector(showMessage:) withObject:@"交易中..." waitUntilDone:NO];
        _cardtype = cardtype;
        //获取流水号
        [self hanlePOSFlowNumber:nil operationType:HandleFlowNumberType_Get successBlock:^(NSString *serialNO) {
            self.serialNO = serialNO;
            switch (cardtype) {    
                case CARDTYPE_MAGNETIC: // 磁卡 021 022
                {
                    [self reciveCardID];
                }
                    break;
                case CARDTYPE_ICC: // IC 卡  051 052
                {
                    NSString * channel = [SFHFKeychainManager loadValueForKey:YR_DEVICE_CHANNEL];
                    if ([channel isEqualToString:YR_DEVICE_CHANNEL_VALUE_BLUETOOTH]) {
                        [self startProcessICCard];
                    }
                    else if ([channel isEqualToString:YR_DEVICE_CHANNEL_VALUE_AUDIOJACK]) {
                        //让用户输入密码
                        if (_delegate && [_delegate respondsToSelector:@selector(inputDealPWD)]) {
                            [MBProgressHUD hideHUD];
                            [_delegate inputDealPWD];
                        }

                    }
                    
                }
                    break;
                case CARDTYPE_RF: // 冲正
                {
                    
                }
                    break;
                default:
                    break;
            }
            
        } failureBlock:^(NSString *errInfo) {
            
            [self performSelectorOnMainThread:@selector(setHUDHidden:) withObject:errInfo waitUntilDone:YES];
        }];
    } progressMsg:^(NSString *stringCB) {

        [self performSelectorOnMainThread:@selector(showMessage:) withObject:stringCB waitUntilDone:NO];
        
    } failedBlock:^(NSString *errCode, NSString *errInfo) {
        
        [self performSelectorOnMainThread:@selector(setHUDHidden:) withObject:errInfo waitUntilDone:YES];
    }];
}

#pragma mark - 磁卡交易
#pragma mark 获取卡号    /** step 1 **/
- (void)reciveCardID{
    // 获取 卡号
   
        [[LandiMPOS getInstance] getPAN:PANDATATYPE_PLAIN successCB:^(NSString *stringCB) {
//            [MBProgressHUD hideHUD];
//            [MBProgressHUD showMessage:@"交易中..."];

            YRDeviceRelative * deviceRelative = [YRDeviceRelative shareDeviceRelative];
            deviceRelative.cardNum = stringCB;
            deviceRelative.cardNumStar = [YRTransactionTool encryptCardNum:stringCB];
            [self receiveTrackDataWithCardNum:stringCB];
        } failedBlock:^(NSString *errCode, NSString *errInfo) {
            
            [self performSelectorOnMainThread:@selector(setHUDHidden:) withObject:errInfo waitUntilDone:YES];
        }];
  
}

#pragma mark - 获取磁道 密文  /** step 2 **/
- (void)receiveTrackDataWithCardNum:(NSString *)cardNum {

    // 获取磁道 密文
    [[LandiMPOS getInstance] getTrackData:0x00 needEncTrack:TRACKTYPE_ENCRYPT successCB:^(LDC_TrackDataInfo *trackData) {
        
        NSString * channel = [SFHFKeychainManager loadValueForKey:YR_DEVICE_CHANNEL];
        if ([channel isEqualToString:YR_DEVICE_CHANNEL_VALUE_AUDIOJACK]) {//音频
            //让用户输入密码
            _carNum = cardNum;
            _audioTrackData = trackData;
            if (_delegate && [_delegate respondsToSelector:@selector(inputDealPWD)]) {
                [MBProgressHUD hideHUD];
                [_delegate inputDealPWD];
            }
        }
        else if ([channel isEqualToString:YR_DEVICE_CHANNEL_VALUE_BLUETOOTH]) {
            [self receivePinkBlockWithTrackData:trackData andCardNum:cardNum];
        }

    } failedBlock:^(NSString *errCode, NSString *errInfo) {
        
        [self performSelectorOnMainThread:@selector(setHUDHidden:) withObject:errInfo waitUntilDone:YES];
    } ];
}

#pragma mark 获取pinBlock（密码）  /** step 3 **/
- (void)receivePinkBlockWithTrackData:(LDC_TrackDataInfo *)trackDataInfo andCardNum:(NSString *)cardNum {
    LFC_GETPIN * getPin = [[LFC_GETPIN alloc]init];
    getPin.panBlock = cardNum;
    getPin.moneyNum = self.moneyNum;
    Byte timeout = 30;
    getPin.timeout = timeout;
    
    NSString * channel = [SFHFKeychainManager loadValueForKey:YR_DEVICE_CHANNEL];
    if ([channel isEqualToString:YR_DEVICE_CHANNEL_VALUE_BLUETOOTH]) {
        //蓝牙刷卡设备
        //获取交易密码
        [[LandiMPOS getInstance] inputPin:getPin successBlock:^(NSData *dateCB) {
            //ASCII转BCD
            NSString * password = [YRFunctionTools nsdata2HexStr:dateCB];
            self.password = password;
            NSData * noCard = [YRFunctionTools HexConvertToASCII:@"ffffffffffffffff"];
            
            //判断有无密码
            if ([dateCB isEqualToData:noCard]) {//无密码
                self.servicePoint = @"022";
                
            }else{
                self.servicePoint = @"021";
                
            }
            [self encryptionByDes:trackDataInfo andCardNum:cardNum andExpiredData:nil andPinBlock:dateCB];
            
        } failedBlock:^(NSString *errCode, NSString *errInfo) {
            
            [self performSelectorOnMainThread:@selector(setHUDHidden:) withObject:errInfo waitUntilDone:YES];
        }];
    } else if ([channel isEqualToString:YR_DEVICE_CHANNEL_VALUE_AUDIOJACK]) {
        //音频设备
        /*
        //还未确定加密方式
        NSData *data = [self.audioPassWordStr dataUsingEncoding:NSUTF8StringEncoding];
        
        NSString *password = [YRFunctionTools nsdata2HexStr:data];
        
        self.password = password;
        
        NSData * noCard = [YRFunctionTools HexConvertToASCII:@"ffffffffffffffff"];
        
        //判断有无密码
        if ([data isEqualToData:noCard]) {//无密码
            self.servicePoint = @"022";
            
        }else{
            self.servicePoint = @"021";
            
        }
        [self encryptionByDes:trackDataInfo andCardNum:cardNum andExpiredData:nil andPinBlock:data];
         */
    }
}

#pragma mark 音频交易 获取pinBlock（密码）
- (void)passDealPWD:(NSString *)password {
    [MBProgressHUD showMessage:@"交易中..."];
    
    self.password = password;
    
    if (_cardtype == CARDTYPE_MAGNETIC) {//磁条卡
        if ([password isEqualToString:@""]) {//无密交易
            self.servicePoint = @"022";
            NSData * noCard = [YRFunctionTools HexConvertToASCII:@"ffffffffffffffff"];
            self.password = @"ffffffffffffffff";
            [self encryptionByDes:_audioTrackData andCardNum:_carNum andExpiredData:nil andPinBlock:noCard];
        }
        else {//有密交易
            NSString *encpwd = [YRMD5Encryption TripleDES_Encode:password key:DES_ENCRY_KEY];
            [[LandiMPOS getInstance] encClearPIN:encpwd withPan:_carNum successBlock:^(NSString *stringCB) {
                
                self.password = stringCB;
                NSData * dateCB = [YRFunctionTools HexConvertToASCII:stringCB];
                self.servicePoint = @"021";
                
                [self encryptionByDes:_audioTrackData andCardNum:_carNum andExpiredData:nil andPinBlock:dateCB];
                
            } failedBlock:^(NSString *errCode, NSString *errInfo) {
                [self performSelectorOnMainThread:@selector(setHUDHidden:) withObject:errInfo waitUntilDone:YES];
            }];
        }
    }
    else {//IC卡
        [self startProcessICCard];
    }
    
    
}


#pragma mark 生成sense域    /** step 4 **/

- (NSString *)encryptionByDes:(LDC_TrackDataInfo *)trackDataInfo andCardNum:(NSString *)cardNum andExpiredData:(NSString *)expiredData andPinBlock:(NSData *)pinBlock{
    double moneyNum = [self.moneyNum doubleValue];
    NSString * posId = self.posID;
    NSString * flowNum = self.serialNO;
    NSString * orderNum = [YRTransactionTool generateOrderNumberWithPosId:posId transactionFlowNum:flowNum];
    self.orderID = orderNum;
    if(!trackDataInfo.track2) {
        trackDataInfo.track2 = @"";
    }
    if (!trackDataInfo.track3) {
        trackDataInfo.track3 = @"";
    }
    if (!cardNum) {
        cardNum = @"";
    }
    if (!expiredData) {
        expiredData = @"";
    }
    
//    NSString * dominStr = [NSString stringWithFormat:@"%@|%@|%.2f|%@|%@|%@|%@|%@|",posId,orderNum,moneyNum,cardNum,trackDataInfo.track2,trackDataInfo.track3,expiredData,self.password];
    NSString * userData = [NSString stringWithFormat:@"%@|%@|%.2f|%@",posId,orderNum,moneyNum,cardNum];
    userData = [YRFunctionTools nsdata2HexStr:[userData dataUsingEncoding:NSUTF8StringEncoding]];
    self.password = [YRFunctionTools nsdata2HexStr:[self.password dataUsingEncoding:NSUTF8StringEncoding]];
    expiredData = [YRFunctionTools nsdata2HexStr:[expiredData dataUsingEncoding:NSUTF8StringEncoding]];
    
//    NSData * data = [dominStr dataUsingEncoding:NSUTF8StringEncoding];
//    dominStr = [YRFunctionTools nsdata2HexStr:data];
    [[LandiMPOS getInstance] encryptPackData:0x00 userData:userData track2Data:trackDataInfo.track2 track3Data:trackDataInfo.track3 validDate:expiredData pinBlock:self.password successBlock:^(NSString *stringCB) {
        NSString * money = [NSString stringWithFormat:@"%.2f",[self.moneyNum doubleValue]];
        NSString * sensStr = [YRFunctionTools stringFromHexString:stringCB isConvertToBase64:YES];
        sensStr = [sensStr stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
        sensStr = [sensStr stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
        
        if (self.payType == payTypeQuick) {//手刷的快速收款
            YRTransactionTool * transactionTool = [[YRTransactionTool alloc] init];
            
            [transactionTool requestFor1001WithCardNumPlain:cardNum moneyNum:money PSEQ:self.serialNO EXP:@"" ICSEQ:@"" SVR:self.servicePoint SENS:sensStr IC:@"" success:^(id responseObject) {
                
                [MBProgressHUD hideHUD];
                if ([responseObject[YR_OUTPUT_KEY_STATES_RESP_CODE] isEqualToString:YR_STATIC_SUCCESS_STATES_CODE]) {
                    
                    _isSuccessed = YES;
                    _transMessage = responseObject[YR_OUTPUT_KEY_DATA];
                    [[[UIAlertView alloc] initWithTitle:nil message:@"交易成功" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil] show];
                }else {
                    
                    [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"[%@]%@",responseObject[YR_OUTPUT_KEY_STATES_RESP_DESC],responseObject[YR_OUTPUT_KEY_STATES_RESP_CODE]] delegate:self cancelButtonTitle:TIPS_CONFIRM otherButtonTitles:nil] show];
                }
                
            } failure:^(NSString *error) {
                
                [self performSelectorOnMainThread:@selector(setHUDHidden:) withObject:error waitUntilDone:YES];
            }];
        }
        
    } failedBlock:^(NSString *errCode, NSString *errInfo) {
        [self performSelectorOnMainThread:@selector(setHUDHidden:) withObject:errInfo waitUntilDone:YES];
    }];
 
    return nil;
}

#pragma mark 消费冲正- jsonStr-- macStr:
/*
-(void)xfcz:(NSString *)ordXZ {
    self.gyjPR = @"2001";
    
//    NSString *cardNum = [[YRDeviceRelative shareDeviceRelative] cardNum]; //卡号
//    NSString *orderNum = [YRLoginManager shareLoginManager].EhomeOrd;
//    
//    NSString * money = [NSString stringWithFormat:@"%.2f",[self.moneyNum floatValue]];
//    NSString * pan = [YRTransactionTool encryptCardNum:cardNum];//将银行卡生成星号
//    YRDeviceRelative *yrdr = [YRDeviceRelative shareDeviceRelative];
//    
//    NSString *EhomeLsh = [YRLoginManager shareLoginManager].EhomeLsh; //流水号
//    NSString *posId = yrdr.posId; //取posID
    
    //生成jsonStr--macStr
    NSDictionary * dict = @{
                            @"PR":self.gyjPR,//
                            @"PAN":self.gyjCardStar,//星号的卡号
                            @"AMT":self.moneyNum, //刷卡金额
                            @"PSEQ":self.serialNO,//流水号
                            @"EXP":self.gyjExp,//有效期--磁条卡*明文磁道
                            @"SVR":self.servicePoint,
                            @"ICSEQ":self.gyjICSEQ,
                            @"SENS":sett.sensStr,
                            @"POSID":self.posID,
                            @"ORDID":ordXZ,//消费冲正新订单号
                            @"ORG":self.gyjOrd,//订单号
                            @"IC":self.gyjIC,
                            @"LONGITUDE":@"",
                            @"LATITUDE":@"",
                            };
    
    [YRMD5Encryption calculateMacValue:dict successBlock:^(NSDictionary *strDict) {

        NSString *jsonStr = [strDict objectForKey:@"jsonStr"];
        NSString *macStr = [strDict objectForKey:@"macStr"];
        
//        UIStoryboard *zjzySb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        sett = [zjzySb instantiateViewControllerWithIdentifier:@"settlementVC"];
//        [sett requestConsumerCorrection:jsonStr macStr:macStr];//消费冲正请求
        [MBProgressHUD showMessage:@"消费冲正"];
        [sett requestConsumerCorrection:jsonStr macStr:macStr];//消费冲正请求
        
    } failureBlock:^(NSString *errInfo) {
        
        [self performSelectorOnMainThread:@selector(setHUDHidden:) withObject:errInfo waitUntilDone:YES];
    }];
}*/

#pragma mark - IC卡交易
#pragma mark 开始处理 IC 卡 /** step 1 **/
- (void)startProcessICCard {
    
    LFC_EMVTradeInfo * tradeInfo = [[LFC_EMVTradeInfo alloc] init];
    tradeInfo.flag = FORCEONLINE_YES;
    tradeInfo.type = TRADETYPE_PURCHASE;
    tradeInfo.moneyNum = self.moneyNum;
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyMMdd"];
    tradeInfo.date = [dateFormatter stringFromDate:[NSDate date]];

    [dateFormatter setDateFormat:@"HHmmss"];
    tradeInfo.time = [dateFormatter stringFromDate:[NSDate date]];

    
    [[LandiMPOS getInstance] startPBOC:tradeInfo trackInfoSuccess:^(LFC_EMVProgress *emvProgress) {
        //
        YRDeviceRelative * deviceRelative = [YRDeviceRelative shareDeviceRelative];
        deviceRelative.cardNum = emvProgress.pan;
        deviceRelative.cardNumStar = [YRTransactionTool encryptCardNum:emvProgress.pan];
        
        if (self.payType == payTypeSett) {
//            self.gyjCard = emvProgress.pan;
//            self.gyjCardStar = [YRTransactionTool encryptCardNum:emvProgress.pan];
        }
        else if (self.payType == payTypeQuick) {
            
            NSString *channel = [SFHFKeychainManager loadValueForKey:YR_DEVICE_CHANNEL];
            if ([channel isEqualToString:YR_DEVICE_CHANNEL_VALUE_BLUETOOTH]) {
                [self continueProcessICCardWithTrackData:emvProgress.track2data
                                                 cardNum:emvProgress.pan
                                             cardExpired:emvProgress.cardExpired
                                           cardSerialNum:emvProgress.panSerialNO];
            }
            else if ([channel isEqualToString:YR_DEVICE_CHANNEL_VALUE_AUDIOJACK]) {
                if ([self.password isEqualToString:@""]) {//无密交易
                    self.password = @"ffffffffffffffff";
                    [self continueProcessICCardWithTrackData:emvProgress.track2data
                                                     cardNum:emvProgress.pan
                                                 cardExpired:emvProgress.cardExpired
                                               cardSerialNum:emvProgress.panSerialNO];
                }
                else {//有密交易
                    NSString *encpwd = [YRMD5Encryption TripleDES_Encode:self.password key:DES_ENCRY_KEY];
                    [[LandiMPOS getInstance] encClearPIN:encpwd withPan:emvProgress.pan successBlock:^(NSString *stringCB) {
                        
                        self.password = stringCB;
                        [self continueProcessICCardWithTrackData:emvProgress.track2data
                                                         cardNum:emvProgress.pan
                                                     cardExpired:emvProgress.cardExpired
                                                   cardSerialNum:emvProgress.panSerialNO];
                        
                    } failedBlock:^(NSString *errCode, NSString *errInfo) {
                        
                    }];
                }
            }
        }
    } failedBlock:^(NSString *errCode, NSString *errInfo) {
        
        [self performSelectorOnMainThread:@selector(setHUDHidden:) withObject:errInfo waitUntilDone:YES];
    }];
}

- (void)setHUDHidden:(NSString *)info {
    
    [MBProgressHUD hideHUD];
    [YRFunctionTools showAlertViewTitle:nil message:info cancelButton:TIPS_CONFIRM];
}

- (void)showMessage:(NSString *)message {
    [MBProgressHUD hideHUD];
    [MBProgressHUD showMessage:message];
}

#pragma mark 继续处理 IC 卡 /** step 2 **/
- (void)continueProcessICCardWithTrackData:(NSString *)trackData cardNum:(NSString *)cardNum cardExpired:(NSString *)cardExpired cardSerialNum:(NSString *)cardSerialNum {
    
    /**
     *	@brief	读取PIN密文输入数据
     *	@param 	panBlock    卡号
     *	@param 	moneyNum      交易金额（6字节）
     *	@param 	timeout     PIN输入超时时间（单位：秒）
     */
    LFC_GETPIN * getPin = [[LFC_GETPIN alloc] init];
    getPin.panBlock = cardNum;
    getPin.moneyNum = self.moneyNum;
    getPin.timeout = 60;
    cardExpired = [cardExpired substringToIndex:4];
    [[LandiMPOS getInstance] continuePBOC:getPin successBlock:^(LFC_EMVResult *emvResult) {
        
        if(emvResult.result == EMVTRADERETCODE_REQONLINE) {
            NSString * newDol = [emvResult.dol substringFromIndex:2];
            NSString  * base64Dol = [YRFunctionTools stringFromHexString:newDol isConvertToBase64:YES]; //先压缩  后转base64
            base64Dol = [base64Dol stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
            base64Dol = [base64Dol stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
            
            if (self.payType == payTypeSett) {
//                self.gyjIC_TC = newDol;
//                self.gyjIC = base64Dol;
            }
            else if (self.payType == payTypeQuick) {
                if ([self.password isEqualToString:@"ffffffffffffffff"]) {
                    NSData *pinBlock = [YRFunctionTools HexConvertToASCII:self.password];
                    [self handleICCardSensDominWithTrackData:trackData
                                                     cardNum:cardNum
                                                 cardExpired:cardExpired
                                               cardSerialNum:cardSerialNum
                                                    pinBlock:pinBlock
                                                         dol:base64Dol];
                }
                else {
                    [self handleICCardSensDominWithTrackData:trackData
                                                     cardNum:cardNum
                                                 cardExpired:cardExpired
                                               cardSerialNum:cardSerialNum
                                                    pinBlock:emvResult.password
                                                         dol:base64Dol];
                }
            }
        }else{
            [MBProgressHUD hideHUD];
            [YRFunctionTools setAlertViewWithTitle:@"交易异常" buttonTitle:TIPS_CONFIRM];
        }
    } failedBlock:^(NSString *errCode, NSString *errInfo) {
        
        [self performSelectorOnMainThread:@selector(setHUDHidden:) withObject:errInfo waitUntilDone:YES];
    }];
}

#pragma mark 继续处理 IC 卡 /** step 3 **/

- (void)handleICCardSensDominWithTrackData:(NSString *)trackData cardNum:(NSString *)cardNum cardExpired:(NSString *)cardExpired cardSerialNum:(NSString *)cardSerialNum pinBlock:(NSData *)pinBlock dol:(NSString *)dol {
    
    double moneyNum = [self.moneyNum doubleValue];
    NSString * posId = self.posID;
    NSString * flowNum = self.serialNO;
    NSString * orderNum = [YRTransactionTool generateOrderNumberWithPosId:posId transactionFlowNum:flowNum];
    self.orderID = orderNum;
    if (!orderNum) {
        orderNum = @"";
    }
    if(!trackData) {
        trackData = @"";
    }
    if (!cardNum) {
        cardNum = @"";
    }
    if (!cardExpired) {
        cardExpired = @"";
    }

   
    NSString * pinStr = nil;
    NSString *channel = [SFHFKeychainManager loadValueForKey:YR_DEVICE_CHANNEL];
    if ([channel isEqualToString:YR_DEVICE_CHANNEL_VALUE_BLUETOOTH]) {
        pinStr = [YRFunctionTools nsdata2HexStr:pinBlock];
    }
    else if ([channel isEqualToString:YR_DEVICE_CHANNEL_VALUE_AUDIOJACK]) {
        pinStr = self.password;
    }
//    NSString * dominStr = [NSString stringWithFormat:@"%@|%@|%.2f|%@|%@|%@|%@|%@|",posId,orderNum,moneyNum,cardNum,trackData,@"",cardExpired,pinStr];
//    
//    NSData * data = [dominStr dataUsingEncoding:NSUTF8StringEncoding];
//    dominStr = [YRFunctionTools nsdata2HexStr:data];
    pinStr = [YRFunctionTools nsdata2HexStr:[pinStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString * userData = [NSString stringWithFormat:@"%@|%@|%.2f|%@",posId,orderNum,moneyNum,cardNum];
    userData = [YRFunctionTools nsdata2HexStr:[userData dataUsingEncoding:NSUTF8StringEncoding]];
    cardExpired = [YRFunctionTools nsdata2HexStr:[cardExpired dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [[LandiMPOS getInstance] encryptPackData:0x00 userData:userData track2Data:trackData track3Data:@"" validDate:cardExpired pinBlock:pinStr successBlock:^(NSString *stringCB) {
        
        NSString * senseStr = [YRFunctionTools stringFromHexString:stringCB isConvertToBase64:YES];
        senseStr = [senseStr stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
        senseStr = [senseStr stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
        
        if (self.payType == payTypeSett) {
           
        }
        else if (self.payType == payTypeQuick) {
            [self sendICCardTransactionRequestWithcardNum:cardNum
                                              cardExpired:cardExpired
                                            cardSerialNum:cardSerialNum
                                                 pinBlock:pinBlock
                                                      dol:dol
                                                     sens:senseStr];
        }
        
    } failedBlock:^(NSString *errCode, NSString *errInfo) {
        
        [self performSelectorOnMainThread:@selector(setHUDHidden:) withObject:errInfo waitUntilDone:YES];
    }];
}

#pragma mark 继续处理 IC 卡 /** step 4 **/

- (void)sendICCardTransactionRequestWithcardNum:(NSString *)cardNum cardExpired:(NSString *)cardExpired cardSerialNum:(NSString *)cardSerialNum pinBlock:(NSData *)pinBlock dol:(NSString *)dol sens:(NSString *)sens {
    self.cardNum = cardNum;
    
    NSString * money = [NSString stringWithFormat:@"%.2f",[self.moneyNum doubleValue]];

    NSString * servicePoint = nil;
    NSData * staticData = [YRFunctionTools HexConvertToASCII:@"ffffffffffffffff"];
    if ([pinBlock isEqualToData:staticData]) {
        
        servicePoint = @"052";
    }else {
        
        servicePoint = @"051";
    }
    
    if (self.payType == payTypeSett) { //e管家 IC卡
        /*
        self.moneyNum = money;
        self.gyjcustId = [YRLoginManager shareLoginManager].custID;
        self.servicePoint = servicePoint;
        NSDictionary *dict =[[NSDictionary alloc] init];
        
        
        [YRMD5Encryption calculateMacValue:dict successBlock:^(NSDictionary *dict) {
            
        } failureBlock:^(NSString *errInfo) {
            
            [self performSelectorOnMainThread:@selector(setHUDHidden:) withObject:errInfo waitUntilDone:YES];
        }];
        */
    }
    else if (self.payType == payTypeQuick) {
        
        YRTransactionTool * transactionTool = [[YRTransactionTool alloc] init];
        
        [transactionTool requestFor1001WithCardNumPlain:cardNum moneyNum:money PSEQ:self.serialNO EXP:cardExpired ICSEQ:cardSerialNum SVR:servicePoint SENS:sens IC:dol success:^(id responseObject) {
            
            [MBProgressHUD hideHUD];
            if ([responseObject[YR_OUTPUT_KEY_STATES_RESP_CODE] isEqualToString:YR_STATIC_SUCCESS_STATES_CODE]) {
                
                _isSuccessed = YES;
                _transMessage = responseObject[YR_OUTPUT_KEY_DATA];
                [[[UIAlertView alloc] initWithTitle:nil message:@"交易成功" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil] show];
                [self uploadTC:responseObject];
                
            }else {
                
                [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"[%@]%@",responseObject[YR_OUTPUT_KEY_STATES_RESP_DESC],responseObject[YR_OUTPUT_KEY_STATES_RESP_CODE]] delegate:self cancelButtonTitle:TIPS_CONFIRM otherButtonTitles:nil] show];
            }
            /*
            [self checkDataByPOSWith:responseObject successBlock:^(BOOL isSuccess) {
                
                [MBProgressHUD hideHUD];
                if (isSuccess) {
                    
                    NSLog(@"交易流程检验结束 检验成功！");
                }else {
                    
                    NSLog(@"交易流程检验结束 检验失败！");
                }
                
            } failureBlock:^(NSString *errInfo) {
                
                [self performSelectorOnMainThread:@selector(setHUDHidden:) withObject:errInfo waitUntilDone:YES];
            }];*/
            
        } failure:^(NSString *error) {
            
            [self performSelectorOnMainThread:@selector(setHUDHidden:) withObject:error waitUntilDone:YES];
        }];
    }
}

// TC上送
- (void)uploadTC:(NSDictionary *)responseObject {
    LFC_EMVOnlineData * onlineData = [[LFC_EMVOnlineData alloc] init];
    onlineData.responseCode = @"00"; //@”00”交易成功 @”55”密码错误 @”35”余额不足 @”96”服务器故障等
    NSString * money = [NSString stringWithFormat:@"%.2f",[self.moneyNum doubleValue]];
    
    [[LandiMPOS getInstance] onlineDataProcess:onlineData successBlock:^(LDC_EMVResult *emvResult) {
        if (emvResult.result == EMVTRADERETCODE_PERMISION) {
            [YRTransactionTool requestFor9017WithCardNumPlain:self.cardNum moneyNum:money PSEQ:self.serialNO ICData:emvResult.dol orderNum:self.orderID success:^(id responseObject) {
                if ([responseObject[@"RESP"] isEqualToString:@"000"]) {
                    NSLog(@"TC上送成功");
                }
                else {
                    NSLog(@"TC上送失败");
                }
            } failure:^(NSString *errInfo) {
                NSLog(@"TC上送失败:%@",errInfo);
            }];
        }
    } failedBlock:^(NSString *errCode, NSString *errInfo) {
        
    }];
}

- (void)PBOCStop {
    [[LandiMPOS getInstance] PBOCStop:^{
        [[LandiMPOS getInstance] displayLines:@"交易结束！" Row:1 Col:1 Timeout:30 ClearScreen:CLEARFLAG_YES successBlock:^{
            
            
        } failedBlock:^(NSString *errCode, NSString *errInfo) {
            
            [self performSelectorOnMainThread:@selector(setHUDHidden:) withObject:errInfo waitUntilDone:YES];
        }];
    } failedBlock:^(NSString *errCode, NSString *errInfo) {
        
        [self performSelectorOnMainThread:@selector(setHUDHidden:) withObject:errInfo waitUntilDone:YES];
    }];
}

-(void)returnData:(NSString *)IC jsonB:(NSMutableDictionary *)jsonB {
    LFC_EMVOnlineData * onlineData = [[LFC_EMVOnlineData alloc] init];
    onlineData.responseCode = @"00"; //@”00”交易成功 @”55”密码错误 @”35”余额不足 @”96”服务器故障等
    //处理IC卡数据
    //     ByteArrayUtils.toByteArray(ByteUtils.byte2hex(Base64.decode(IC, Base64.URL_SAFE | Base64.NO_WRAP))));
    
    // Create NSData object
    NSData *nsdata = [IC dataUsingEncoding:NSUTF8StringEncoding];
    // Get NSString from NSData object in Base64
    NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
    onlineData.onlineData = [YRFunctionTools hexStringFromString:base64Encoded];
    
    [[LandiMPOS getInstance] onlineDataProcess:onlineData successBlock:^(LDC_EMVResult *emvResult) {
        //
        switch (emvResult.result) {
            case EMVTRADERETCODE_PERMISION:     //交易成功
            {
                [YRFunctionTools displayMessage:@"交易成功"];
            }
                break;
            case EMVTRADERETCODE_REJECT:        //交易拒绝 发起冲正
            {
            }
                break;
            case EMVTRADERETCODE_EXCEPTION:     //EMV 处理异常 发起冲正
            {
            }
                break;
            default:
                break;
        }
    } failedBlock:^(NSString *errCode, NSString *errInfo) {//失败 了 消费冲正
        
    }];
}

-(void)ESign{
    YRTransactionMessage *transMessage = [[YRTransactionMessage alloc] init];
    
    YRSignController * signVC = [[YRSignController alloc] initWithNibName:@"YRSignController" bundle:nil];
    signVC.transMessage = transMessage;
    signVC.showType = ShowType_Sign;
    //[sett.navigationController pushViewController:signVC animated:YES];
}

-(void)checkData:(NSString *)IC jsonB:(NSMutableDictionary *)jsonB {
    LFC_EMVOnlineData * onlineData = [[LFC_EMVOnlineData alloc] init];
    onlineData.responseCode = @"00"; //@”00”交易成功 @”55”密码错误 @”35”余额不足 @”96”服务器故障等
    //处理IC卡数据
//     ByteArrayUtils.toByteArray(ByteUtils.byte2hex(Base64.decode(IC, Base64.URL_SAFE | Base64.NO_WRAP))));
    
    // Create NSData object
    NSData *nsdata = [IC dataUsingEncoding:NSUTF8StringEncoding];
    // Get NSString from NSData object in Base64
    NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
    onlineData.onlineData = [YRFunctionTools hexStringFromString:base64Encoded];
    
    [[LandiMPOS getInstance] onlineDataProcess:onlineData successBlock:^(LDC_EMVResult *emvResult) {
        //
        switch (emvResult.result) {
            case EMVTRADERETCODE_PERMISION:     //交易成功 后 TC上送
            {

                
            }
            break;
            case EMVTRADERETCODE_REJECT:        //交易拒绝 发起冲正
            {
                
                [self sendCheckCorrection];
            }
            break;
            case EMVTRADERETCODE_EXCEPTION:     //EMV 处理异常 发起冲正
            {
                
                [self sendCheckCorrection];
            }
            break;
            default:
            break;
        }
    } failedBlock:^(NSString *errCode, NSString *errInfo) {//失败 了 消费冲正
   
    }];
}


#pragma mark 校验 服务器返回的数据 判断是否成功 或 冲正
- (void)checkDataByPOSWith:(NSDictionary *)responseObject successBlock:(void (^)(BOOL isSuccess))successBlock failureBlock:(void (^)(NSString *errInfo))failureBlock {
    /**
     *	@brief	EMV交易完成数据
     *	@param 	responseCode  授权响应码, 联机完成时此域必须存在，即39域数据
     *	@param 	onlineData    联机请求返回数据，即55域数据
     */
    LFC_EMVOnlineData * onlineData = [[LFC_EMVOnlineData alloc] init];

    NSString * responseCode = nil;
    if ([responseObject[YR_OUTPUT_KEY_STATES_RESP_CODE] isEqualToString:YR_STATIC_SUCCESS_STATES_CODE]) {
        
        responseCode = @"00";
    }else {
        
        responseCode = responseObject[YR_OUTPUT_KEY_STATES_RESP_CODE];
        responseCode = [responseCode substringFromIndex:responseCode.length - 1];
    }
    
    onlineData.responseCode = responseCode; //@”00”交易成功 @”55”密码错误 @”35”余额不足 @”96”服务器故障等

    NSData *nsdata = [responseObject[@"IC"] dataUsingEncoding:NSUTF8StringEncoding];
    // Get NSString from NSData object in Base64
    NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
    onlineData.onlineData = [YRFunctionTools hexStringFromString:base64Encoded];
    
    [[LandiMPOS getInstance] onlineDataProcess:onlineData successBlock:^(LDC_EMVResult *emvResult) {
        //
        switch (emvResult.result) {
                
            case EMVTRADERETCODE_PERMISION:     //交易成功
            {
                successBlock(YES);
                
                [[LandiMPOS getInstance] PBOCStop:^{
                    
                    [[LandiMPOS getInstance] displayLines:@"交易结束！" Row:2 Col:5 Timeout:5 ClearScreen:CLEARFLAG_YES successBlock:^{
                        
                    } failedBlock:^(NSString *errCode, NSString *errInfo) {
                        failureBlock(errInfo);
                    }];
                } failedBlock:^(NSString *errCode, NSString *errInfo) {
                    failureBlock(errInfo);
                }];
            }
                break;
            case EMVTRADERETCODE_REJECT:        //交易拒绝 发起冲正
            {
                successBlock(NO);
                [self sendCheckCorrection];
            }
                break;
            case EMVTRADERETCODE_EXCEPTION:     //EMV 处理异常 发起冲正
            {
                successBlock(NO);
                [self sendCheckCorrection];
            }
                break;
            default:
                break;
        }

    } failedBlock:^(NSString *errCode, NSString *errInfo) {
        
        failureBlock(errInfo);
    }];
}

#pragma mark 发起冲正
- (void)sendCheckCorrection {
    
    
}



#pragma mark 存取流水号 取流水号的时候 flowNum 传空

- (void)hanlePOSFlowNumber:(NSString *)flowNum operationType:(HandleFlowNumberType)type successBlock:(void (^)(NSString * serialNO))successBlock failureBlock:(void (^)(NSString * errInfo))failureBlock {
    
    switch (type) {
            
        case HandleFlowNumberType_Get: // 取流水号
        {
            [[LandiMPOS getInstance] getTerminalParam:^(LDC_TerminalBasePara *terminalPara) {
                
                if ([terminalPara.serialNO isEqualToString:@""]) {
                    terminalPara.serialNO = @"000001";
                    [[LandiMPOS getInstance] setTerminalParam:terminalPara successBlock:^{
                        
                        successBlock(terminalPara.serialNO);
                    } failedBlock:^(NSString *errCode, NSString *errInfo) {
                        
                        failureBlock(errInfo);
                    }];
                }else {
                    
                    successBlock(terminalPara.serialNO);
                }
                
            } failedBlock:^(NSString *errCode, NSString *errInfo) {
                
                failureBlock(errInfo);
            }];
        }
            break;
        case HandleFlowNumberType_Save: // 存流水号
        {
            if (flowNum) {
                int num = [flowNum intValue];
                
                num += 1;
                
                flowNum = [NSString stringWithFormat:@"00000%d",num];
                NSRange range = NSMakeRange(flowNum.length - 6, 6);
                flowNum = [flowNum substringWithRange:range];
                
                [[LandiMPOS getInstance] getTerminalParam:^(LDC_TerminalBasePara *terminalPara) {
                    LDC_TerminalBasePara * terminalBasePara = [[LDC_TerminalBasePara alloc] init];
                    //批次号，流水号
                    terminalBasePara.serialNO = flowNum;
                    terminalBasePara.bathcNO = flowNum;
                    terminalBasePara.customParam = terminalPara.customParam;
                    [[LandiMPOS getInstance] setTerminalParam:terminalBasePara successBlock:^{
                        //
                        
                        successBlock(terminalBasePara.serialNO);
                    } failedBlock:^(NSString *errCode, NSString *errInfo) {
                        
                        failureBlock(errInfo);
                    }];
                } failedBlock:^(NSString *errCode, NSString *errInfo) {
                    
                    [self performSelectorOnMainThread:@selector(setHUDHidden:) withObject:errInfo waitUntilDone:YES];
                }];
 
            }
            
        }
            break;
        default:
            break;
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (_isSuccessed) {
        
        [_delegate requestDeviceTool:self transMessage:_transMessage];
        _isSuccessed = NO;
    }
    
}


@end
