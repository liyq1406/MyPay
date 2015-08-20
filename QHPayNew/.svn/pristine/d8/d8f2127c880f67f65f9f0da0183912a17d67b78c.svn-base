//各种配置信息
/*
 特别注明:UserDefault与本地归档中所使用的key
 UserDefault:
 SESSIONID
 area
 isComplete9009 是否完成9009
 isRememberUserName
 alreadyRememberUserName
 merchantKey(userName + @"merName") 店铺名
 
 归档:
 deviceChannel 蓝牙/音频通道
*/

#define kNaviHeight 64
#define kBorder 10

//颜色
#define kColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

//加载cell
#define ClassName(obj) [NSString stringWithUTF8String:object_getClassName(obj)]


#pragma mark -- sessionId key
#define YR_INPUT_KEY_SESSION_ID              @"SESSIONID"

#define YR_JSON_STR         @"jsonStr="
#define YR_MAC_STR          @"&macStr="

#pragma mark Cookie Object
#define YR_COOKIE_NAME              @"MTPSESSIONID"



#pragma mark -- 网络异常 无法连接到服务器，请检查网络
#define TIPS_MESSAGES   @"无法连接到服务器，请检查网络设置"
#define TIPS_CONFIRM    @"知道了"

#pragma mark --静态数据版本
#define AREA_KEY        @"area"
#define AREA_VERSION    @"1"

#pragma mark timeout
#define YR_TIMEOUT_INTERVAL  20

#pragma mark -- 手刷设备的 ID 和 deviceName key
//#define LANDI_DEVICE_ID_KEY       @"deviceId"  //用户名 key
//#define LANDI_DEVICE_NAME_KEY    @"deviceName"  //用户账号 key

#pragma mark -- ********** Server Reponse Status Code ********** --

#define YR_INPUT_KEY_VER         @"VER"
#define YR_INPUT_VALUE_VER       @"66"
#define YR_LOAN_VALUE_VER        @"1.0"

#define YR_INPUT_KEY_PHONENUMBER @"USRMP"

#define YR_INPUT_KEY_JSONSTR                 @"jsonStr"   // jsonStr key
#define YR_INPUT_KEY_MACSTR                  @"macStr"

#define YR_OUTPUT_KEY_STATES_RESP_CODE            @"RESP"     // 返回码
#define YR_OUTPUT_KEY_STATES_RESP_DESC            @"RESPDESC"   //  返回描述
#define YR_STATIC_SUCCESS_STATES_CODE            @"000"
#define YR_STATIC_REPEAT_SUCCESS_STATUES_CODE    @"001"
#define YR_STATIC_WRONG_USERNAME_CODE            @"156"
#define YR_STATIC_WRONG_PASSWORD_CODE            @"355"
#define YR_STATIC_REGIERPHONE_IS_EXIST_CODE      @"M22"
#define YR_STATIC_SESSION_INVALIDE               @"M26"

#define YR_OUTPUT_KEY_DATA                       @"data"  // 返回的结果 客户端添加的 非后台返回的key

#define QH_LD_FACTORY_NAME                       @"LD"
#define QH_XDL_FACTORY_NAME                      @"XDL"

#define YR_MERNAME                               @"merName"


#pragma mark 开户信息存储key
#define YR_DEVICE_RELATIVE_FILLCODE              @"fillCode"
#define YR_DEVICE_RELATIVE_POSDEVICE             @"posDeviceId"
#define YR_DEVICE_RELATIVE_POSID                 @"posId"
#define YR_DEVICE_RELATIVE_MERNAME               @"merName"


#define YR_DEVICE_CHANNEL                        @"deviceChannel"//保存的设备格式

#define YR_DEVICE_CHANNEL_VALUE_BLUETOOTH        @"blueTooth"
#define YR_DEVICE_CHANNEL_VALUE_AUDIOJACK        @"audioJack"

#define IS_COMPLETE_9009 @"isComplete9009"

#pragma mark -- ********** Host address *********** --


//#define SERVER_HOST_IP     @"http://tech.yunrich.com/mtp"
//#define SERVER_HOST_IP   @"https://m.yunrich.com/mtp"
//#define SERVER_HOST_IP   @"http://d.yunrich.com:51001/mtp"

#define SERVER_ADDRESS      @"/mtp"

#pragma mark -- MD5 Salt
//#define SP_SUPPLY_MD5Salt        @"D01C751CDA791A092E0337C731F473D0"      // test
//#define SP_SUPPLY_MD5Salt        @"A524CF7DE4512245903737367973317F"    // distribution


//#define SP_SUPPLY_LOGIN_PASSWORD  @"ec78642aec3024206dbebf0b339e8a52"   // login password for test
//#define SP_SUPPLY_LOGIN_PASSWORD  @"ec78642aec3024206dbebf0b339e8a52"   // login password for distribution
//#define SP_SUPPLY_TRANSACTION_PASSWORD  @"ad37b591867b766bae6ea02cb02af48b" // transaction password for test
//#define SP_SUPPLY_TRANSACTION_PASSWORD  @"ad37b591867b766bae6ea02cb02af48b" // transaction password for distribution
#define SP_SUPPLY_FIX                   @"35d79cb9f64b11b1625795e9cb9ee461" //固定补充码



#pragma mark -- ********  Service URL  ******** --

#pragma mark -- get phone verification code 手机验证码
#define URL_GET_PHONE_VERIFICATION_CODE             SERVER_ADDRESS@"/cloud/getAuthCode.do"

#pragma mark -- register 注册
#define URL_REGISTER                                SERVER_ADDRESS@"/cloud/regist.do"

#pragma mark -- reset password 忘记密码 重置
#define URL_RESET_PASSWORD                          SERVER_ADDRESS@"/cloud/resetPwd.do"


#pragma mark -- logIn 登录
#define URL_LOGIN                                   SERVER_ADDRESS@"/cloud/login.do"

#pragma mark -- open an account  开户
#define URL_OPEN_ACCOUNT                            SERVER_ADDRESS@"/cloud/merInfoComp.do"

#pragma mark -- upload signature file  上传签名文件
#define URL_UPLOAD_SIGNATURE_FILE                   SERVER_ADDRESS@"/cloud/elecSignSend.do"



#pragma mark -- get user profile  获取个人信息
#define URL_GET_USER_PROFILE                        SERVER_ADDRESS@"/cloud/queryPersonMsg.do"

#pragma mark -- change password  修改密码
#define URL_CHANGE_PASSWORD                         SERVER_ADDRESS@"/cloud/changePwd.do"


#pragma mark -- T + 0 apply for withdraw cash T＋0申请提现
#define URL_PLAY_WITHDRAW_CASH                      SERVER_ADDRESS@"/cloud/applyCash.do"

#pragma mark -- T + 0 query authority for withdraw cash  查询提现权限
#define URL_QUERY_AUTHORITY_WITHDRAW_CASH           SERVER_ADDRESS@"/cloud/queryCashAuth.do"

#pragma mark -- query withdraw cash records     查询提现纪录
#define URL_QUERY_WITHDRAW_CASH_RECORDS             SERVER_ADDRESS@"/cloud/queryCashLog.do"

#pragma mark -- withdraw cash   提现
#define URL_WITHDRAW_CASH                           SERVER_ADDRESS@"/cloud/cash.do"

#pragma mark -- 计算手续费
#define URL_CALCULATE_FEE                           SERVER_ADDRESS@"/cloud/cashCalcFee.do"

#pragma mark -- query transaction orders  查询交易订单
#define URL_GET_TRANSACTION_ORDER                   SERVER_ADDRESS@"/cloud/queryTrans.do"

#pragma mark -- query transaction orders detail  查询交易订单详情
#define URL_GET_TRANSACTION_ORDER_DETAIL            SERVER_ADDRESS@"/cloud/queryTransDetails.do"

#pragma mark -- get the transaction flow from POS   获取POS交易流水
#define URL_GET_POS_TRANSACTION_FLOW                SERVER_ADDRESS@"/cloud/getPosSequence.do"

#pragma mark -- get transaction message     1001交易报文
#define URL_GET_TRANSACTION_MESSAGE                 SERVER_ADDRESS@"/trans.do"


#pragma mark -- MCCCODE  商户开通时 使用
#define URL_GET_MCCCODE                     SERVER_ADDRESS@"/cloud/queryMccData.do"

#pragma mark -- MCCCODE  额度提升 申请
#define URL_APPLY_PROMOTE_LIMIT             SERVER_ADDRESS@"/cloud/applyPromoteLimit.do"

#pragma mark -- 判断省份地区数据是否需要更新
#define URL_JUDGE_PROVICE_IS_NEED_UPDATE    SERVER_ADDRESS@"/cloud/queryStaticDataVersion.do"

#pragma mark -- 省份地区请求地址
#define URL_GET_PROVICE_CITY_AREA           SERVER_ADDRESS@"/cloud/queryProvAreaData.do"


#pragma mark -- App 程序更新
#define URL_JUDGE_APP_IS_NEED_UPDATE        SERVER_ADDRESS@"/cloud/queryAppVersion.do"

#pragma mark -- 密钥管理阶段获取
#define URL_MANAGE_STAGE_LOADING_KEY        SERVER_ADDRESS@"/cloud/getPRStep.do"

#pragma mark 9006 - 9009 9015 9016 9017

#define URL_GET_SN_MESSAGE               SERVER_ADDRESS@"/cloud/getSNMessage.do"  // 获取 md5 补充串
#define URL_GET_MAIN_KEY                 SERVER_ADDRESS@"/keyload.do" // 9006 get main key 获取主密钥
#define URL_CONFIRM_FINISH_LOAD_MAIN_KEY SERVER_ADDRESS@"/keyloadnotify.do" // 9007 confirm finish load main key
#define URL_BINDING_POS_DEVICE          SERVER_ADDRESS@"/termbind.do"  // 9008 binding pos device 绑定设备
#define URL_GET_WORK_KEY                SERVER_ADDRESS@"/signin.do"    // 9009 get work key

#define URL_GET_PUBLIC_KEY              SERVER_ADDRESS@"/downpublickey.do"  // IC 公玥下载
#define URL_GET_PARAMETER               SERVER_ADDRESS@"/downpara.do"       // 参数下载
#define URL_UPLOAD_TC                   URL_GET_TRANSACTION_MESSAGE         // TC上送


#pragma mark -- 贷款
#define URL_PROVIDE_LOAN                            @"/bloansv/applyForLoanReg"



#pragma mark -- 版本号  版本控制key
#define APP_CURRENT_VERSION_KEY         @"AppcurrentVersion"


#pragma mark --友盟统计APPKEY
#define MOBCLICK_APPKEY                 @"55938db367e58ee46b00533f"
