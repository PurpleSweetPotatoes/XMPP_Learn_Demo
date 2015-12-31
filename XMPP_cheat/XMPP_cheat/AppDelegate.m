//
//  AppDelegate.m
//  XMPP_cheat
//
//  Created by baiqiang on 15/12/13.
//  Copyright © 2015年 baiqiang. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <IQKeyboardManager.h>
#import "DDTTYLogger.h"
#import "DDLog.h"
#import <AVFoundation/AVFoundation.h>

#warning mykey has delete
static NSString *const BmobKey = @"";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //配置XMPP的日志
//    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    //配置键盘管理者
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    //注册Bmob
    [Bmob registerWithAppKey:BmobKey];
    
    //打开红外线模式
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    
    //配置真机录音及音效播放
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];

    //设置扬声器可用
    NSError *err;
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:&err];
    //进行音频激活
    NSError *activeErr;
    [audioSession setActive:YES error:&activeErr];
    if (err || activeErr) {
        BQLog(@"err:%@\nactive:%@",err.localizedDescription, activeErr.localizedDescription);
    }
    
    return YES;
}

@end
