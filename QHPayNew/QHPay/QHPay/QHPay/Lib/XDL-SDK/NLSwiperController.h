//
//  NLSwiperController.h
//  NLSwiperController
//
//  Created by Wayne on 15/8/11.
//  Copyright (c) 2015年 ChenJinxiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NL_Common.h"




@interface NLSwiperController : NSObject

/**
 *  获取NLSwiperController的实例，所有的接口都是在这个类实现的
 */
+(id)sharedInstance;

/**
 *  获取SDK版本号
 *
 *  @return 返回SDK版本号
 */
-(NSString *)getSDKVersion;


/**
 *  扫描设备(蓝牙设备使用，未完全实现，勿调)
 *
 *  @param timeout           扫描的时间，单位为秒
 *  @param searchOneDeviceCB 扫描到一个设备回调
 *  @param searchCompleteCB  扫描设备结束回调
 */
-(void)startSearchDev:(NSInteger)timeout searchOneDeviceBlcok:(void(^)(NSMutableDictionary *deviceDic)) searchOneDeviceCB completeBlock:(void(^)(NSMutableArray *deviceArr))searchCompleteCB;

/**
 *  停止搜索设备
 */
-(void)stopSearchDev;

/**
 *  打开设备连接
 *
 *  @param uuid       设备uuid，音频时为空
 *  @param completion 连接成功回调
 *  @param error      连接失败回调
 */
-(void)requestOpenDevice:(NSString *)uuid success:(void(^)(BOOL blnIsOpenSuc))completion error:(void(^)(NSString *strStausCode,NSString *strMsgInfo))error;

/**
 *  关闭设备；
 */
-(void)closeDevice;

/**
 *  判断设备是否保持连接
 *
 *  @return 返回YES则表示设备保持连接
 */
-(BOOL)DeviceisAlive;

/**
 *  获取设备信息
 *
 *  @param completion 获取设备信息成功回调；
 *  @param error      获取设备信息失败回调；
 */
-(void)requestDeviceInfosuccess:(void(^)(deviceInfo *info))completion error:(void(^)(NSString *strStausCode,NSString *strMsgInfo))error;

/**
 *  POS签到
 *
 *  @param intPosType 设备类型；
 *  @param key        用于灌装的密钥；
 *  @param completion 灌装成功返回；
 *  @param error      灌装失败返回；
 */
-(void)requestPosSignUp:(NLDeviceTypeValue)intPosType andkey:(keyData *)key success:(void(^)(BOOL blnIsSignUpSuc)) completion error:(void(^)(NSString *strStausCode,NSString *strMsgInfo))error;

/**
 *  ME11打开磁条卡读卡器
 *
 *  @param timeout    刷卡超时时间
 *  @param isEncrypt  磁道是否加密
 *  @param completion 读卡成功回调信息
 *  @param error      读卡失败回调
 */
-(void)startReadCardWithTimeout:(int)timeout needEnctrack:(NL_TRACKTYPE)isEncrypt success:(void(^)(SwipeResult *result))completion error:(void(^)(NSString *strStausCode,NSString *strMsgInfo))error;

/**
 *  撤销当前操作指令
 *
 *  @param completion 撤销成功返回
 *  @param error      撤销失败返回
 */
-(void)requestTransCancelOnSuccess:(void(^)(BOOL blnIsCancelSuc))completion error:(void(^)(NSString *strStausCode,NSString *strMsgInfo))error;


@end
