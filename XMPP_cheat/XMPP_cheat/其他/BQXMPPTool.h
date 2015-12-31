//
//  XMPPTool.h
//  XMPP_cheat
//
//  Created by baiqiang on 15/12/14.
//  Copyright © 2015年 baiqiang. All rights reserved.
//


/*
 1.初始化xmppStream
 2.链接到服务器
 3.链接成功后发送密码
 4.设置用户状态信息
 */

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ResultType) {
    XmppResultTypeLoginSuccess = 200,//登录成功
    XmppResultTypeLoginFail,//登录失败
    XmppResultTypeRegisterSuccess,//注册成功
    XmppResultTypeRegisterFail,//注册失败
    XmppResultTypeConnectFail//连接失败
};

typedef NS_ENUM(NSUInteger, UserState) {
    UserOnLine = 0,//在线
    UserGoOut,//离开
    UserOffLine,//离线
};

@interface BQXMPPTool : NSObject

/**
 *  XMPP输入输出流(socket核心类)
 */
@property (nonatomic, strong, readonly) XMPPStream *xmppStream;

/**
 *  服务器域名
 */
@property (nonatomic, strong, readonly) NSString *hostName;

/**
 *  电子名片对象
 */
@property (nonatomic, strong, readonly) XMPPvCardTempModule *vCard;

/**
 *  电子名片头像对象
 */
@property (nonatomic, strong, readonly) XMPPvCardAvatarModule *avatar;

/**
 *  花名册
 */
@property (nonatomic, strong, readonly) XMPPRoster *roster;

/**
 *  花名册存储器
 */
@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage *rosterStorage;

/**
 *  聊天归档模块
 */
@property (nonatomic, strong, readonly) XMPPMessageArchiving *message;

/**
 *  聊天模块存储器
 */
@property (nonatomic, strong, readonly) XMPPMessageArchivingCoreDataStorage *messageStorage;

/**
 *  结果类型
 */
@property (nonatomic, assign) ResultType teyp;



/**
 *  初始化单例
 */
+ (instancetype)sharedXMPPTool;

/**
 *  XMPP登录
 */
- (void)XMPPLoginWithResult:(void (^)(ResultType type))block;

/**
 *  XMPP注销
 */
- (void)XMPPLogoutCompeleted:(void(^)())block;

/**
 *  XMPP注册
 */
- (void)XMPPRegisterWithResult:(void (^)(ResultType type))block;

@end
