//
//  syapi.h
//  syapp
//
//  Created by 路 on 2018/4/21.
//  Copyright © 2018年 路. All rights reserved.
//

/**
 * 接口文档: http://192.168.0.253:81/
 * 开发文档: http://doc.hzshuyu.com/cpzx/
 */

#define BASE_HOST               [LZLive_AppConfig __BASE_HOST]
#define RESOURCES_HOST          [LZLive_AppConfig __RESOURCES_HOST]
#define RESOURCES_OSS_HOST      [LZLive_AppConfig __RESOURCES_OSS_HOST]
#define BASE_H5_HOST            [LZLive_AppConfig __BASE_H5_HOST]

#define BASE_PACKAGE_TYPE  [LZLive_AppConfig GET_PACKAGE_TYPE]

static NSString *const REQUEST_ERROR_MESSAGE = @"请求失败，请稍后重试";

// 渠道
#define APP_CHANNEL_ID [[LZLive_AppConfig sharedInstance] channel_id]

#pragma mark - 公共接口
/** 客户端事件统计*/
#define APP_EVENT_LOG           @"yekong_api/app/event/log"
/** 文件上传 */
#define SIMPLE_UPLOAD           @"simples/upload"
/** 日志上传 */
#define APP_LOG_COMMINT         @"open/logscil"
/** 首次激活接口 */
#define APP_ACTIVED             @"channel/actived"

/** 不同用户分配不同线路*/
#define APP_USER_URL            @"simple/user_url"

/** 获取省份列表 */
#define SIMPLE_PROVINCE         @"simple/province"

/** 根据省份code获取城市列表 */
#define SIMPLE_CITY             @"simple/city"

/** 直播间举报类型 */
#define SIMPLE_REPORT           @"simple/report"

/** 发送短信 */
#define VIDEO_SMS               @"video/sms"
/** 注销校验验证码*/
#define MEMBER_CANCEL_PHONE     @"member/member_cancel_phone"
/** 校验之前手机*/
#define VERIFY_PHONE            @"video/verify_phone"

/** 校验手机验证码*/
#define STEP_PHONE            @"video/step_phone"

/** 换绑新手机号 */
#define BIND_PHONE            @"video/bind_phone"

/** 获取礼物列表 */
#define SIMPLE_GIFT             @"simple/gift"

/** 获取背包礼物 **/
#define PROPSLIST_GIFT          @"active/propslist"

/** 开启应用刷新token */
#define MEMBER_TOKEN            @"member/token"

/** 公共配置接口 */
#define SIMPLE_CONFIG           @"simple/config"

/** 公共配置接口 */
#define GUARD_CONFIG            @"guard/guard_config"

/** 守护配置*/
#define GUARD_PRIVILEGE         @"guard/guard_privilege"

/** 直播间守护坐骑接口*/
#define GUARD_FRAME_MOUNT       @"yekong_api/app/guard/frame_mount"

/** 守护头像框坐骑更新佩戴*/
#define GUARD_FRAME_MOUNT_EDIT  @"yekong_api/app/guard/frame_mount_edit"

/** 轮盘配置*/
#define TURNTABle_CONFIG            @"truntable/truntable_config"

/** 启动页 */
#define SIMPLE_SPLASH_SCREEN    @"simple/splash_screen"

//查询首充状态
#define RECHARGE_FIRST          @"yekong_api/app/recharge/receive_first_v2"

/** 靓号签到 */
#define SIMPLE_REWARD            ,@"broadcast/reward_info"

/** 靓号领取 */
#define REWARD_NUMBER           @"broadcast/reward_apply"

#pragma mark - 动态相关
///OSS
#define OSS_INFO                @"shumei_audit/audit/info"
///OSS
#define OSS_INFO_LOG            @"shumei_audit/audit/info_app"
///动态消息
#define DYNAMIC_NOTICE          @"dynamic/dy_notice_list"

///动态列表
#define DYNAMIC_LIST            @"dynamic/dynamic_list"

///话题列表 //3热门话题，4所有话题,5话题列表
#define DYNAMIC_TOPLIST         @"dynamic/topic_list"

///话题详情
#define DYNAMIC_INFO            @"dynamic/dy_info"

///话题详情
#define DYNAMIC_TOPINFO         @"dynamic/topic_info"

///发布动态
#define DYNAMIC_RELEASE         @"dynamic/release"

///动态点赞
#define DYNAMIC_PRAISE          @"dynamic/praise"

///动态详情
#define DYNAMIC_DETAIL          @"dynamic/comment_detail"

///评论列表
#define DYNAMIC_COMMENT_LIST    @"dynamic/comment_list"

///评论动态
#define DYNAMIC_COMMENT         @"dynamic/comment"

///删除动态
#define DYNAMIC_DELETE         @"dynamic/delete"

///举报动态
#define DYNAMIC_REPORT          @"dynamic/report"

#pragma mark - 支付
///支付校验
#define ApplePay_Check          @"simple/apple_pay_check"

///座驾列表
#define PAY_CARMALL             @"yekong_api/app/mount/buy_list"

///座驾详情
#define PAY_CARMALL_DETAIL      @"yekong_api/app/mount/mount_detail"

///购买座驾
#define PAY_CARM                @"yekong_api/app/mount/buy"


///提交实名制信息
#define PAY_CERIFY              @"member/cerify"
///是否可以正常充值
#define PAY_RECHARGE_CHECK      @"pay/recharge_limit_check"
///充值/打赏限额配置（包含获取用户认证信息）
#define PAY_RECHARGE_REWARD      @"simple/recharge_reward"
///政策开关
#define POLICY_SWITCH_LIST      @"yekong_api/app/config/policy_switch_list"
///检测是否可以送礼
#define PAY_LIMIT_CHECK          @"pay/pri_limit_check"
///严重身份
#define PAY_VERIFY_CARD         @"member/verify_card"

#pragma mark - 登录、注册
/** 手机登录 */
#define MEMBER_LOGIN            @"member/login"

/** 游客登录*/
#define MEMBER_TOURISTS         @"yekong_api/app/visitors_login"

/** apple id登录*/
#define MEMBER_APPLELOGIN       @"go_app/v2/home/apple/login"

/**一键登录*/
#define MEMBER_LOGIN_GEE        @"member/one_login"

/** 验证昵称是否存在 */
#define MEMBER_NICKNAME         @"member/nickname"

/** 填写昵称、头像、性别 */
#define MEMBER_MODIFY           @"member/modify"

/** 获取主播申请开播认证状态 */
#define MEMBER_APPLY_STATUS     @"member/apply_status"

/** 主播认证工会认证状态 */
#define MEMBER_ANCHOR_STATUS     @"yekong_api/app/anchor/anchor_family_get"

/** 申请开播认证 */
#define MEMBER_APPLY            @"member/apply"

/** 第三方登陆 */
#define MEMBER_PLATFORM         @"simple/platform"

/** 拉黑 */
#define MEMBER_ACCESS           @"member/pullblack"

/** 语音、视频聊天自定义收费设置 */
#define MEMBER_CHAT_COST        @"member/chat_cost"

#pragma mark - 选秀
/** 应援礼物列表 */
#define VIDEO_SHOW_GIFT             @"show/show_gift"

/** 选秀老师列表 */
#define VIDEO_SHOW_TEACHER             @"show/show_teacher"

/** 选秀历史中奖记录 */
#define VIDEO_SHOW_HISTORY             @"show/show_history"

/** 选秀排行榜（上一轮/昨日/今日） */
#define VIDEO_SHOW_RANK             @"show/show_rank"

#pragma mark - 直播间
/** 关注、取消关注 */
#define MEMBER_FOLLOW           @"member/follow"

/** 用户卡片信息 */
#define MEMBER_CARD             @"member/card"

/** 举报主播 */
#define VIDEO_REPORT            @"video/report"

/** 关播推荐主播 */
#define ROOM_CLOSE              @"yekong_api/app/hot_module/close_list"

/** 举报聊天*/
#define ROOM_REPORT             @"yekong_api/app/room/report"

/** 直播间榜单*/
#define ROOM_RED_PERSON_TOP             @"rank/room_rank_gold"

/** 申请直播 */
#define VIDEO_APPLY             @"video/apply"

//// 申请开播IP推流
#define VIDEO_APPLY_RETRY             @"video/apply_retry"

/** 直播间获取主播详细信息 */
#define VIDEO_ANCHOR            @"video/anchor"

/** 主播禁言、剔除房间，设置、取消管理员 */
#define VIDEO_ACCESS            @"video/access"

/** 批量获取用户信息 */
#define VIDEO_MEMBER_LIST       @"video/member_list"

/** 主播关播 */
#define VIDEO_CLOSE             @"video/close"

/** 猜你喜欢 */
#define VIDEO_LIKE              @"video/like"

/** 直播间内贡献榜 */
#define VIDEO_RANK              @"video/rank_v2"

/** 直播间按钮隐藏🫥*/
#define ROOM_RANK_HIDDEN        @"yekong_api/app/rooms/room_hidden_rank_open"

/** 获取榜单是否隐藏 */
#define VIDEO_RANK_HIDDEN_TOTAL @"yekong_api/app/rooms/get_hidden_total"
/** 设置直播总榜是否隐藏*/
#define VIDEO_RANK_HIDDEN_SET @"yekong_api/app/rooms/set_hidden_total"
/** 主播收益任务 */
#define VIDEO_FANS_FANSINFO     @"yekong_api/app/fans/fans_info"

/** 粉丝团和列表收益记录*/
#define VIDEO_FANS_FANSTASK_LOG @"yekong_api/app/fans/fans_task_log"

/* 已开盲盒数和累计拉新人数*/
#define FIRST_RECHARGE_BOX_PEOPLE_NUM @"yekong_api/app/recharge/box_people_num"

/* 首充开盲盒*/
#define FIRST_OPEN_BLIND_BOX    @"yekong_api/app/recharge/open_blind_box"

/** 直播间分享统计 */
#define VIDEO_SHARE             @"video/share"

/** 通知连麦端主播已经加入频道 */
#define RTMP_TOKEN              @"video/rtmptoken"
#define RTMP_TOKEN_V2          @"video/rtmptoken_v2"

/** 获取用户的推流拉流地址*/
#define APPLY_STREAM            @"video/apply_stream"
/** 用户开始推流告诉服务端监听*/
#define APPLY_STREAM_TAG        @"video/stream_tag"

/**礼物墙列表*/
#define GIFT_WALLGIFT           @"wallgift/wall_gift_list"

/**点亮礼物前8逻辑*/
#define GIFT_LIGHT_EIGHT_RANK   @"yekong_api/app/member/light_eight_rank"

/**礼物墙排行榜*/
#define GIFT_WALLGIFT_RANK      @"wallgift/wall_gift_rank"

#pragma mark - 直播间游戏
///优宝游戏列表
#define YOUBAO_GAME_LIST        @"yekong_api/app/youbao/youbao_game_list/v2"
///游戏优宝兑换道具
#define YOUBAO_GAME_PROP        @"yekong_api/app/youbao/youbao_youbao_prop"
///优宝道具列表
#define YOUBAO_PROP_LIST        @"yekong_api/app/youbao/youbao_prop_list"
///游戏自动开关
#define YOUBAO_AUTO_OPEN        @"yekong_api/app/youbao/youbao_auto_open"
///游戏金币兑换优宝
#define YOUBAO_GOLD_YOUBAO        @"yekong_api/app/youbao/youbao_gold_youbao"
///优宝兑换金币
#define YOUBAO_YOUBAO_GOLD      @"yekong_api/app/youbao/youbao_youbao_gold"
///兑换界面
#define YOUBAO_YOUBAO_INFO      @"yekong_api/app/youbao/youbao_info"

#pragma mark - 青少年模式
///青少年视频
#define TEENAGERS_VIDEO               @"yekong_api/app/teenagers/juvenile_video"
///是否青少年模式
#define TEENAGERS_INFO_INDEX          @"yekong_api/app/teenagers/juvenile_index"
///青少年每天弹窗
#define TEENAGERS_TODAY_OPEN          @"yekong_api/app/teenagers/juvenile_today_open"
///设置青少年密码
#define TEENAGERS_SET_PASSWORD          @"yekong_api/app/teenagers/juvenile_enter"
///退出青少年密码
#define TEENAGERS_PASSWORD_EXIT       @"yekong_api/app/teenagers/juvenile_exit"

#pragma mark - 个人中心
///首页引导（信任奖励弹框）
#define ME_INFO_REWARD          @"yekong_api/app/home/novice_guide"
///用户大冒险任务列表
#define GAME_TASK_LIST          @"go_app/v1/game/user/task_list"
///添加，修改 活删除 冒险任务列表
#define GAME_TASK_CREATE        @"go_app/v1/game/user/task_create"
/// 周榜
#define WEEK_RANKING            @"go_app/v1/activity/province/week_ranking"
/// 周榜位置修改
#define WEEK_LOCATION            @"go_app/v1/activity/province/week_location"
///我的守护
#define ME_GUARD                @"guard/guard_list"
///粉丝团
#define ME_FANS                 @"fans/fans_my"
///粉丝团昵称修改
#define Fans_NICKNAME_MODIFY    @"fans/fans_nickname_modify"
///粉丝团续费
#define Fans_RENEW    @"fans/fans_renew"
///粉丝勋章佩戴
#define Fans_WEAR    @"fans/fans_wear"
///粉丝团成员列表
#define Fans_LIST    @"fans/fans_list"
/** 个人中心基础信息 */
#define MEMBER_INFO             @"member/info"
/** 饰品列表*/
#define MEMBER_ORNAMENT_LIST    @"ornament/ornament_list"
/** 佩戴饰品*/
#define MEMBER_ORNAMENT_WEAR    @"ornament/ornament_wear"
/**任务详情列表*/
#define MEMBER_TASK_LIST        @"go_app/v1/activity/task/list"
/**任务领取奖励*/
#define MEMBER_TASK_GET        @"member/task_get"
/**任务签到*/
#define MEMBER_TASK_SIGN        @"member/task_sign"
/** 头像框列表*/
#define HEAD_FRAME              @"member/head_frame"

/** 头像框佩戴*/
#define HEAD_FRAME_WEAR         @"member/head_frame_wear"

/** 我的靓号 */
#define MY_REWARD               @"broadcast/user_number"

/** 靓号佩戴和取消 */
#define REWARD_WEAR             @"broadcast/number_wear"

/** vip配置信息接口 */
#define MEMBER_VIPINFO          @"vipapp/vipinfo"

/** 贵族配置 */
#define NOBILITY_LIST           @"nobilitynoble/nobility_list"

/** 个性签名 */
#define MEMBER_INTR             @"member/intr"

/** 上传图片、视频 */
#define MEMBER_MEDIA            @"member/media"

/** 查看照片墙 */
#define MEMBER_PICLIST          @"member/piclist"

/** 删除相册上传图片 */
#define MEMBER_MEDIA_DEL        @"member/media_del"

/** 修改昵称、性别、生日、省份城市 */
#define MEMBER_MODIFY_INFO      @"member/modify_info"

///性别修改
#define MEMBER_MODIFY_SEX       @"yekong_api/app/member/modify_sex"

/** 0 是开启隐藏， 1是关闭隐藏 */
#define MEMBER_LOCATION         @"home/fixed"

/** 意见反馈 */
#define MEMBER_FEEDBACK         @"member/feedback"

/** 账户余额 */
#define MEMBER_WEALTH           @"member/wealth"

/** 绑定宝 */
#define BAOBAO_Str             @"支付宝"
#define BAOBAO_PAY             @"alipay"
#define MEMBER_A_PAY           @"member/alipay"
///app端芝麻认证
#define MEMBER_SIMPLE_APP      @"simple/zmxy_app"

/** 提现申请 */
#define MEMBER_EXTRACT          @"member/extract"

/** 收到的礼物 */
#define MEMBER_GIFT             @"member/gift"

/** 分页获取交易记录 */
#define MEMBER_WEALTHS          @"member/wealths"

/** 分页获取收到礼物列表 */
#define MEMBER_GIFT_LIST        @"member/gift_list"

/** 查询宝账号是否绑定 */
#define HOME_ALI_ACCOUNT        @"home/ali_account"

/** 绑定银行卡 */
#define HOME_WITHDRAW_BANK        @"yekong_api/app/withdraw/bank_withdraw"

/** 礼物箱接口 */
#define MEMBER_GIFTLIST         @"member/giftlist"

/** 送出人礼物详情 */
#define MEMBER_GIFTLISTDETAIL   @"member/giftlistdetail"

/** 亲密榜单 */
#define MEMBER_WEEKDAYCLOSE     @"member/weekdayclose"

/** 榜单隐藏0查询1设置*/
#define MEMBER_HIDDENTOP     @"vipapp/vip_rank_set"

/**保险箱初始化*/
#define MEMBER_STRONG_BOX_INIT  @"yekong_api/app/wealths/strongbox_init"

/**设置宝箱密码*/
#define MEMBER_STRONG_BOX_SET  @"yekong_api/app/wealths/strongbox_set"

/**保险箱存入取出*/
#define MEMBER_STRONG_BOX_IN_OUT  @"yekong_api/app/wealths/strongbox_into_out"

/**保险箱重置验证码*/
#define MEMBER_STRONG_BOX_PWD_RESET  @"yekong_api/app/wealths/strongbox_pwd_reset"
#pragma mark - 直播
///新人引导弹框
#define HOME_PULL_NEWUSER           @"yekong_api/app/guide/pop_up"
///拉新是否弹出
#define HOME_PULL_NEW           @"yekong_api/app/pullnew_2022/pop_up"
///热门模块列表
#define HOME_MODULE             @"yekong_api/app/hot_module"

///首页4个模块
#define HOME_MODULE_LIST_TYPE   @"yekong_api/app/home/four_module_list"

/** 热门、推荐主播、关注主播 */
#define HOME_ANCHOR             @"home/anchor"

///后台配置的模块列表
#define HOME_MODULE_LIST        @"yekong_api/app/hot_module_list"

/** 附近 身份列表*/
#define HOME_ACTIVITY             @"go_app/v1/activity/province/user_info"

/** 省份热门接口*/
#define HOME_ACTIVITY_ANCHOR_LIST             @"go_app/v1/activity/province/anchor_ranking"

/** PK列表 */
#define HOME_PK_LIST            @"go_app/v1/home/pk_list"
/** 家族列表 */
#define ROOM_FAMILY             @"rooms/family"
/** 直播间PK列表 */
#define ROOM_PK_LIST            @"home/pk_log_list"
/** banner 轮播图 */
#define HOME_BANNER             @"simple/banner_v2"

/** 我关注的、我的粉丝、我的好友 */
#define HOME_FOLLOWS            @"home/follows"

/** 守护好友列表 */
#define HOME_FOLLOWS_GUARD      @"home/follows_guard"

/** 拉黑列表 */
#define HOME_ACCESS             @"home/access"

/** 红包领取列表*/
#define REDPACKET_DATAIL        @"active/redpacket_detail"

/** 发现列表 */
#define HOME_FIND               @"home/find"

/** 发现列表 */
#define HOME_ENCOUNTER               @"go_app/v1/home/encounter"

/** 排行榜列表 */
#define HOME_RANK               @"home/rank"

/** 魅力值详情 */
#define RANK_DETAIL             @"video/rank_detail"

/** 发现-搜索 */
#define HOME_SEARCH             @"home/search"

/** 榜单前三 */
#define SEARCH_RANK             @"yekong_api/app/search/rank"

/** 声网 Token */
#define HOME_AGORA              @"home/agora"

/** 搜索智能提示 */
#define HOME_PROMPT             @"home/prompt"

/** 腾讯IMsdk签名 */
#define HOME_IMSIGN             @"home/imsign"

/**声网rtc推流**/
#define HOME_AGORA_PUSH         @"video/agoraPush"

/** 声网授权 */
#define HOME_AGORA_ACCESS       @"home/agora_access"

/** 支付配置接口 */
#define PAY_CONFIG              @"pay/config"

/** 支付会员ID搜索接口 */
#define PAY_SEARCH              @"pay/search"

/** 支付 */
#define PAY                     @"pay"

/** 支付行为*/
#define PAY_RECODE              @"go_app/v1/pay/pay_recode"

/** 校验苹果支付 */
#define PAY_APPLE               @"pay/apple_pay"

///苹果首充
#define PAY_APPLE_FIRST         @"pay/apple_first"

#define VIP_PAY_APPLE           @"/pay/apple_vip_pay"

/**检测是否能开通粉丝团**/
#define CHEACK_FANS_PAY_APPLE          @"/pay/apple_fans_check"

/** 校验苹果粉丝团支付 */
#define FANS_PAY_APPLE          @"pay/apple_fans"

/** 校验苹果支付 */
#define GUARD_PAY_APPLE         @"pay/apple_guard"

/** 积分转金币 */
#define MEMBER_CONVERT          @"member/convert"

/** 私聊、语音、视频开关配置 */
#define HOME_CHAT_CONFIG        @"home/chat_config"

/** 获取主播最后一次开播封面，房间名称 */
#define VIDEO_LAST_LIVE         @"video/last_live"

/**设置密码房开关*/
#define ROOM_PASSWORD           @"go_v3/room/password"

/** 轮盘排行 */
#define TURNTABLE_RANK          @"go_app/v1/home/turntable/turntable_rank"

/**转盘中奖纪录*/
#define TURNTABLE_LIST          @"truntable/draw_list"

/**锻造*/
#define TURNTABLE_FORGING          @"truntable/forging_user"

///锻造抽奖
#define TURNTABLE_DRAW_FORGING      @"go_app/v1/home/turntable/draw_forging"
#pragma mark - 接口版本
/** 礼物列表 */
#define SIMPLE_GIFT_VERSION @"1.0"


#pragma mark - h5页面地址  企业包1
#define H5_ContentStr              [NSString stringWithFormat:@"version=%@&package_type=%@&user_id=%@&token=%@&device=%@&channel_id=%@&time_diff=%@&audit=%@",[LZLive_BaseFuntion getAppVersion],BASE_PACKAGE_TYPE,MyUserID,[LZLive_UserManager sharedInstance].token,[LZLive_BaseFuntion getAppTermId],APP_CHANNEL_ID,@([LZLive_AppConfig sharedInstance].system_time),@([LZLive_AppConfig sharedInstance].ios_audit)]
#define H5_ContentStr_Nid              [NSString stringWithFormat:@"version=%@&package_type=%@&token=%@&device=%@&channel_id=%@&time_diff=%@&audit=%@",[LZLive_BaseFuntion getAppVersion],BASE_PACKAGE_TYPE,[LZLive_UserManager sharedInstance].token,[LZLive_BaseFuntion getAppTermId],APP_CHANNEL_ID,@([LZLive_AppConfig sharedInstance].system_time),@([LZLive_AppConfig sharedInstance].ios_audit)]

///三方充值
#define H5_PROTOCOL_URL         [NSString stringWithFormat:@"%@/%@?%@" ,BASE_H5_HOST ,@"recharge",H5_ContentStr]
/** 充值协议 */
#define H5_PROTOCOL_RECHARGE    [NSString stringWithFormat:@"%@/%@?%@" ,BASE_H5_HOST ,@"protocol/recharge",H5_ContentStr]

/** 隐私协议 */
#define H5_PROTOCOL_SERVICE     [NSString stringWithFormat:@"%@/%@?%@" ,BASE_H5_HOST ,@"protocol/service",H5_ContentStr]
/** 用户*/
#define H5_PROTOCOL_USER     [NSString stringWithFormat:@"%@/%@?%@" ,BASE_H5_HOST ,@"protocol/register",H5_ContentStr]

/** 主播规范协议*/
#define H5_PROTOCOL_SESAME      [NSString stringWithFormat:@"%@/%@?%@" ,BASE_H5_HOST ,@"protocol/sesame",H5_ContentStr]

/** 游戏中心*/
#define H5_GAME_CENTER          [NSString stringWithFormat:@"%@/game?%@" ,BASE_H5_HOST,H5_ContentStr]

/** 邀请好友*/
#define H5_AGENT_SHARE          [NSString stringWithFormat:@"%@/agent/share?%@" ,BASE_H5_HOST,H5_ContentStr]

/** 靓号商城*/
#define H5_REWARD               [NSString stringWithFormat:@"%@/nicenum/home?%@" ,BASE_H5_HOST,H5_ContentStr]

/** 贵宾席*/
#define H5_GUARD                [NSString stringWithFormat:@"%@/guard?%@" ,BASE_H5_HOST,H5_ContentStr]

/**贵族*/
#define H5_NOBILITY             [NSString stringWithFormat:@"%@/noble?%@" ,BASE_H5_HOST,H5_ContentStr]

///贵族规则
#define H5_NOBILITY_INFO        [NSString stringWithFormat:@"%@/noble/intro?%@" ,BASE_H5_HOST,H5_ContentStr]

///我的守护
#define H5_MY_GUARD             [NSString stringWithFormat:@"%@/myguard?%@" ,BASE_H5_HOST,H5_ContentStr]

/** 注销账户*/
#define H5_LOGOUT               [NSString stringWithFormat:@"%@/logout/rule?%@" ,BASE_H5_HOST,H5_ContentStr]

///粉丝团规则
#define H5_FANRULES             [NSString stringWithFormat:@"%@/activity/fanrules?%@" ,BASE_H5_HOST,H5_ContentStr]

///探险游戏
#define H5_GAMES_WEB            [NSString stringWithFormat:@"%@/activity/explorelottery?%@" ,BASE_H5_HOST,H5_ContentStr]

///同城排行规则
#define H5_LOCATION             [NSString stringWithFormat:@"%@/activity/locationrules?%@" ,BASE_H5_HOST,H5_ContentStr]

///帮助中心
#define H5_HELP_CENTER          [NSString stringWithFormat:@"%@/onlineservice?%@" ,BASE_H5_HOST,H5_ContentStr]

///开发票
#define H5_SHOW_INVOICE         [NSString stringWithFormat:@"%@/invoice/index?%@" ,BASE_H5_HOST,H5_ContentStr]

///盲盒说明
#define H5_BOXGIFT               [NSString stringWithFormat:@"%@/activity/giftbox?%@" ,BASE_H5_HOST,H5_ContentStr]

///轮盘说明
#define H5_TURNRULE             [NSString stringWithFormat:@"%@/activity/turnrule?%@" ,BASE_H5_HOST,H5_ContentStr]

///签约
#define H5_Walletsign             [NSString stringWithFormat:@"%@/walletsign?%@" ,BASE_H5_HOST,H5_ContentStr]

///游戏规则
#define H5_ACTIVITY_PKRULE        [NSString stringWithFormat:@"%@/activity/pkrule?%@" ,BASE_H5_HOST,H5_ContentStr]

/** 选秀商店说明 */
#define H5_DRAFT_STORE_DESCRIPTION             [NSString stringWithFormat:@"%@/activity/draftshoprule?%@" ,BASE_H5_HOST ,H5_ContentStr]

///选秀玩法说明
#define H5_DRAFT_DRAFTRULE          [NSString stringWithFormat:@"%@/activity/draftrule?%@" ,BASE_H5_HOST ,H5_ContentStr]

///优宝玩法说明
#define H5_DRAFT_YOUBAO           [NSString stringWithFormat:@"%@/game/ybrule?%@" ,BASE_H5_HOST ,H5_ContentStr]

///天启宝箱
#define H5_TIANQI                 [NSString stringWithFormat:@"%@/activity/tqlottery?%@" ,BASE_H5_HOST ,H5_ContentStr]

///守护规则
#define H5_GUARDULE               [NSString stringWithFormat:@"%@/guardrule?%@" ,BASE_H5_HOST ,H5_ContentStr]

///新年活动（万元夺宝大作战）
#define H5_NEWYEAR_CARD             [NSString stringWithFormat:@"%@/activity/springfestival?%@" ,BASE_H5_HOST ,H5_ContentStr]

///五一活动（最强打工人）
#define H5_MAYDAY_CARD             [NSString stringWithFormat:@"%@/activity/mayday?%@" ,BASE_H5_HOST ,H5_ContentStr]

///段位PK规则
#define H5_DRAFT_PK_RANK            [NSString stringWithFormat:@"%@/activity/pkgraderule?%@" ,BASE_H5_HOST ,H5_ContentStr]

///招募令
#define H5_RECRUITORDER             [NSString stringWithFormat:@"%@/activity/recruitorder?%@" ,BASE_H5_HOST ,H5_ContentStr]

/// 主播认证帮助
#define H5_ANCHOR_HELP              [NSString stringWithFormat:@"%@/activity/anchorhelp?%@" ,BASE_H5_HOST ,H5_ContentStr]

/// 新人告白榜
#define H5_ACTIVITY              [NSString stringWithFormat:@"%@/activity/firstpay?%@" ,BASE_H5_HOST ,H5_ContentStr]

/// 新人邀请框
#define H5_PULL_NEW              [NSString stringWithFormat:@"%@/activity/hundredbag?%@" ,BASE_H5_HOST ,H5_ContentStr]

///游戏商城
#define H5_GAME_MALL                [NSString stringWithFormat:@"%@/gameshop?%@" ,BASE_H5_HOST ,H5_ContentStr]

///加入家族
#define H5_JOINFAMILY              [NSString stringWithFormat:@"%@/join_family?%@" ,BASE_H5_HOST ,H5_ContentStr]
