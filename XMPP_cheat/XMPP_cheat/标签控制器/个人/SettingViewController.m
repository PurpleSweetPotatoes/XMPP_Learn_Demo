//
//  SettingViewController.m
//  XMPP_cheat
//
//  Created by baiqiang on 15/12/19.
//  Copyright © 2015年 baiqiang. All rights reserved.
//

#import "SettingViewController.h"
#import "MyInfoView.h"
#import "InfoTableViewController.h"


@interface SettingViewController ()
@property (nonatomic, strong) MyInfoView *infoView;
@end

@implementation SettingViewController

#pragma mark - 类方法

#pragma mark - 创建方法

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    [self registerNotification];
    self.view.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    XMPPvCardTemp *myvCardTemp = [BQXMPPTool sharedXMPPTool].vCard.myvCardTemp;
    if (myvCardTemp.photo != nil) {
        self.infoView.imageView.image = [UIImage imageWithData: myvCardTemp.photo];
    }else {
        self.infoView.imageView.image = [UIImage imageNamed:@"tabbar_me"];
    }
    self.infoView.nameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:USER_NAME];
}
#pragma mark - 实例方法
- (void)initData{
    
}

- (void)initUI{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:UIBarButtonItemStylePlain target:self action:@selector(logout:)];
    self.navigationItem.rightBarButtonItem = item;
    [self.view addSubview:self.infoView];

}
- (void)registerNotification{
    
}
#pragma mark - 事件响应方法
- (void)logout:(UIBarButtonItem *)btn{
    [[BQXMPPTool sharedXMPPTool] XMPPLogoutCompeleted:^{
        self.tabBarController.selectedIndex = 0;
        [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_LOGINVC object:nil];
    }];
}
- (void)tapMyInfoView {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"InfoStoryboard" bundle:nil];
    InfoTableViewController *infoVc = [storyBoard instantiateViewControllerWithIdentifier:@"InfoTableViewController"];
    [self.navigationController pushViewController:infoVc animated:YES];
}
#pragma mark - Method


#pragma mark - set方法

#pragma mark - get方法
- (MyInfoView *)infoView {
    if (_infoView == nil) {
        _infoView = [[MyInfoView alloc] initWithFrame:CGRectMake(0, 20 * BQAdaptationHeight(), self.view.width, 100 * BQAdaptationHeight())];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMyInfoView)];
        [_infoView addGestureRecognizer:tap];
    }
    return _infoView;
}
@end
