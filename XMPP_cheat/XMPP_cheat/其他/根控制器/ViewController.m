//
//  ViewController.m
//  XMPP_cheat
//
//  Created by baiqiang on 15/12/13.
//  Copyright © 2015年 baiqiang. All rights reserved.
//

#import "ViewController.h"
#import "BQTabBarViewController.h"
#import "LoginViewController.h"
#import <ReactiveCocoa.h>

@interface ViewController ()

/**
 *  显示登陆界面
 */
- (void)showLogingVc;
@end

@implementation ViewController

#pragma mark - 类方法

#pragma mark - 创建方法

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    [self registerNotification];
}
#pragma mark - 实例方法
- (void)initData{
    
}

- (void)initUI{
    BQTabBarViewController *tabBarVc = [[BQTabBarViewController alloc] init];
    [self addChildViewController:tabBarVc];
    [self.view addSubview:tabBarVc.view];
    
    [self showLogingVc];
}

- (void)showLogingVc {
    LoginViewController *loginVc = [[LoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVc];
    [self addChildViewController:nav];
    [self.view addSubview:nav.view];
}
- (void)registerNotification{
    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:SHOW_LOGINVC object:nil] subscribeNext:^(id x) {
        @strongify(self)
        [self showLogingVc];
    }];
}
#pragma mark - 事件响应方法

#pragma mark - Method

#pragma mark - set方法

#pragma mark - get方法

@end
