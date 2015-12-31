//
//  XMPPTool.m
//  XMPP_cheat
//
//  Created by baiqiang on 15/12/14.
//  Copyright © 2015年 baiqiang. All rights reserved.
//

#import "BQXMPPTool.h"
//XMPP自动链接类
#import <XMPPReconnect.h>

//static NSString *const host = @"192.168.0.95";
static NSString *const host = @"127.0.0.1";
static NSInteger const port = 5222;
static NSString *const domain = @"rimidemacbook-pro-2.local";

static NSString *const XMPPUserOutline = @"unavailable";
static NSString *const XMPPUseronLine = @"available";

@interface BQXMPPTool ()<XMPPStreamDelegate>
{
    //与服务器交互的socket流
    XMPPStream *_xmppStream;
    
    //用于登录注册结果回调的block
    void (^_ResultBlock)(ResultType type);
    
    //判断是否正在注册
    BOOL _isRegister;
    
    //用于做电子名片缓存的对象
    XMPPvCardCoreDataStorage *_vCardStorage;
    
    //断线自动重连
    XMPPReconnect *_reconnect;
}

/**
 *  初始化xmppStream
 */
- (void)setupStream;

/**
 *  链接到主机
 */
- (void)connectToHost;

/**
 *  发送密码到主机
 */
- (void)sendPwdToHost;

/**
 *  发送用户状态到服务器
 */
- (void)sendOnlineToHost;
@end

@implementation BQXMPPTool

#pragma mark - 初始化方法
+ (instancetype)sharedXMPPTool {
    return [[BQXMPPTool alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static BQXMPPTool *xmppTool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        xmppTool = [super allocWithZone:zone];
        
    });
    return xmppTool;
}

#pragma mark - Method
- (void)setupStream {
    
    //创建xmpp流
    _xmppStream = [[XMPPStream alloc] init];
    //添加代理及队列
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    _hostName = domain;
#pragma mark 配置XMPP模块对象
    
    //创建电子名片对象存取器
    _vCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    //创建电子名片对象
    _vCard = [[XMPPvCardTempModule alloc] initWithvCardStorage:_vCardStorage];
    //电子名片需要被激活(电子名片一般配合头像模块一起使用)
    [_vCard activate:_xmppStream];
    
    //头像模块
    _avatar = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:_vCard];
    //激活头像模块
    [_avatar activate:_xmppStream];
    
    //创建花名册存储器
    _rosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    //创建花名册模块
    _roster = [[XMPPRoster alloc] initWithRosterStorage:_rosterStorage];
    //激活花名册模块
    [_roster activate:_xmppStream];
    
    //创建聊天模块存储器
    _messageStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    //创建聊天模块
    _message = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:_messageStorage];
    //激活聊天模块
    [_message activate:_xmppStream];
    
    //创建自动链接模块
    _reconnect = [[XMPPReconnect alloc] init];
    //激活自动链接模块
    [_reconnect activate:_xmppStream];
    
}
- (void)teardownStream {
    //移除代理
    [_xmppStream removeDelegate:self];
    
    //关闭模块
    [_vCard deactivate];
    [_avatar deactivate];
    [_roster deactivate];
    [_message deactivate];
    [_reconnect deactivate];
    //断开链接
    [_xmppStream disconnect];
    
    //属性置空
    _xmppStream = nil;
    _vCard = nil;
    _vCardStorage = nil;
    _avatar = nil;
    _message = nil;
    _messageStorage = nil;
    _reconnect = nil;
}
- (void)XMPPLoginWithResult:(void (^)(ResultType type))block {
    _isRegister = NO;
    [self connectToHostWithResult:block];
}
- (void)XMPPRegisterWithResult:(void (^)(ResultType))block {
    _isRegister = YES;
    [self connectToHostWithResult:block];
}

- (void)connectToHostWithResult:(void (^)(ResultType))block {
    if (_xmppStream == nil) {
        [self setupStream];
    }
    _ResultBlock = [block copy];
    
    [self connectToHost];
}

- (void)XMPPLogoutCompeleted:(void(^)())block {
    
    //发送离线消息
    XMPPPresence *presence = [XMPPPresence presenceWithType:XMPPUserOutline];
    [_xmppStream sendElement:presence];
    
    //断开连接
    [_xmppStream disconnect];
    
    //若有block，则执行
    if (block != nil) {
        block();
    }

}
#pragma mark - connect Method
- (void)connectToHost {
    //若有链接需要断开链接后重新配置消息并进行链接
    [_xmppStream disconnect];
    //设置用户登录信息,resource为手机类型
    XMPPJID *userJid;
    if (_isRegister == YES) {
        userJid = [XMPPJID jidWithUser:[[NSUserDefaults standardUserDefaults] objectForKey:REGISTER_NAME] domain:_hostName resource:@"iphone"];
    }else {
        userJid = [XMPPJID jidWithUser:[[NSUserDefaults standardUserDefaults] objectForKey:USER_NAME] domain:_hostName resource:@"iphone"];
    }
    
    _xmppStream.myJID = userJid;
    //设置服务器及端口
    _xmppStream.hostName = host;
    _xmppStream.hostPort = port;
    //发起链接
    NSError *error;
    [_xmppStream connectWithTimeout:20 error:&error];
    
    if (error != nil) {
        BQLog(@"发起链接失败:%@",error.localizedDescription);
    }
}
- (void)sendPwdToHost {
    NSError *error;
    if (_isRegister == YES) {
        [_xmppStream registerWithPassword:[[NSUserDefaults standardUserDefaults] objectForKey:REGISTER_PWD] error:&error];
    }else {
        [_xmppStream authenticateWithPassword:[[NSUserDefaults standardUserDefaults] objectForKey:PASS_WORD] error:&error];
    }
    if (error != nil) {
        BQLog(@"信息发送失败%@",error.localizedDescription);
    }
}

- (void)sendOnlineToHost {
    //在线类,(XMPPPresence为DDXMLElement子类)
    XMPPPresence *presence = [XMPPPresence presenceWithType:XMPPUseronLine];
    //发送在线信息到服务器
    [_xmppStream sendElement:presence];
}
#pragma mark - XMPPStreamDelegate
/**
 *  链接到主机
 */
- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    BQLog(@"链接成功");
    [self sendPwdToHost];
}

/**
 *  链接到主机超时
 */
- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender {
    BQLog(@"链接主机超时");
    _ResultBlock(XmppResultTypeConnectFail);
}

/**
 *  密码验证成功
 */
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    BQLog(@"登录成功");
    dispatch_async(dispatch_get_main_queue(), ^{
        _ResultBlock(XmppResultTypeLoginSuccess);
    });
    [self sendOnlineToHost];
}
/**
 *  密码验证失败
 */
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error {
    BQLog(@"登录失败:%@",error);
    dispatch_async(dispatch_get_main_queue(), ^{
        _ResultBlock(XmppResultTypeLoginFail);
    });
}

/**
 *  注册成功调用
 */
- (void)xmppStreamDidRegister:(XMPPStream *)sender{
    BQLog(@"用户名注册成功");
    dispatch_async(dispatch_get_main_queue(), ^{
        _ResultBlock(XmppResultTypeRegisterSuccess);
    });
}
/**
 *  注册失败调用
 */
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error {
    BQLog(@"用户名注册失败");
    dispatch_async(dispatch_get_main_queue(), ^{
        _ResultBlock(XmppResultTypeRegisterFail);
    });
}
#pragma mark 处理加好友回调,加好友
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    //取得好友状态
    NSString *presenceType = [NSString stringWithFormat:@"%@", [presence type]]; //online/offline
    //请求的用户
    NSString *presenceFromUser =[NSString stringWithFormat:@"%@", [[presence from] user]];
    BQLog(@"presenceType:%@",presenceType);
    
    BQLog(@"presence2:%@  sender2:%@",presence,sender);
    
    XMPPJID *jid = [XMPPJID jidWithString:presenceFromUser];
    //接受该好友订阅并订阅该好友
    [_roster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
    
}
@end
