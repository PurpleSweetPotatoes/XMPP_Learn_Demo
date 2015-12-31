//
//  BaseViewController.h
//  XMPP_cheat
//
//  Created by baiqiang on 15/12/13.
//  Copyright © 2015年 baiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

/**
 *  初始化数据
 */
- (void)initDataSource;
/**
 *  初始化界面
 */
- (void)initUI;
/**
 *  注册通知
 */
- (void)registerNotification;

@end
