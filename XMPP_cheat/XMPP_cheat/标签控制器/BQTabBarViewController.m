//
//  BQTabBarViewController.m
//  XMPP_cheat
//
//  Created by baiqiang on 15/12/13.
//  Copyright © 2015年 baiqiang. All rights reserved.
//

#import "BQTabBarViewController.h"
#import "CheatViewController.h"
#import "FirendsViewController.h"
#import "SettingViewController.h"

@interface BQTabBarViewController ()
@property (nonatomic, strong) NSMutableArray *vcArray;
@end

@implementation BQTabBarViewController

#pragma mark - 类方法

#pragma mark - 创建方法
- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _vcArray = [NSMutableArray array];
        [self initUI];
    }
    return self;
}
#pragma mark - 生命周期

#pragma mark - 实例方法
- (void)initUI{
    [self addVcWithName:@"CheatViewController" title:@"聊天"  imageName:@"火焰"];
    [self addVcWithName:@"FirendsViewController" title:@"好友" imageName:@"火焰"];
    [self addVcWithName:@"SettingViewController" title:@"个人" imageName:@"火焰"];
    
    self.viewControllers = _vcArray;
    self.tabBar.translucent = NO;
}
- (void)addVcWithName:(NSString *)className title:(NSString *)title imageName:(NSString *)imageName {
    Class class = NSClassFromString(className);
    UIViewController *vc = [[class alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.navigationBar.translucent = NO;
    vc.title = title;
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:title image:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    vc.tabBarItem = item;
    [_vcArray addObject:nav];
}

#pragma mark - 事件响应方法

#pragma mark - Method

#pragma mark - set方法

#pragma mark - get方法

@end
