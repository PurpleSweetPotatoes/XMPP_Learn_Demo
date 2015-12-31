//
//  RegisterViewController.m
//  XMPP_cheat
//
//  Created by baiqiang on 15/12/15.
//  Copyright © 2015年 baiqiang. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@property (nonatomic, strong) UITextField *registerName;
@property (nonatomic, strong) UITextField *registerpwd;
@property (nonatomic, strong) UITextField *registerpwdAgain;

@end

@implementation RegisterViewController

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
    [self.view addSubview:self.registerName];
    [self.view addSubview:self.registerpwd];
    [self.view addSubview:self.registerpwdAgain];
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.backgroundColor = [UIColor redColor];
    [registerBtn addTarget:self action:@selector(registerBtnClickedEvent:) forControlEvents:UIControlEventTouchUpInside];
    registerBtn.frame = BQAdaptationFrame(0, 0, 100, 40);
    registerBtn.center = CGPointMake(SCREEN_WIDTH / 2, CGRectGetMaxY(self.registerpwdAgain.frame) + 60);
    [self.view addSubview:registerBtn];
}

- (void)registerNotification{
    
}
#pragma mark - 事件响应方法
- (void)registerBtnClickedEvent:(UIButton *)btn {
    if ([self.registerpwd.text isEqualToString:self.registerpwdAgain.text]) {
        [self registerToHost];
    }else {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"信息不匹配" message:@"两次密码不一致" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertVc animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVc dismissViewControllerAnimated:YES completion:nil];
            });
        }];
    }
}

#pragma mark - Method
- (void)registerToHost {
    [BQActivityView showActiviTy];
    [[NSUserDefaults standardUserDefaults] setObject:self.registerName.text forKey:REGISTER_NAME];
    [[NSUserDefaults standardUserDefaults] setObject:self.registerpwd.text forKey:REGISTER_PWD];
    [[NSUserDefaults standardUserDefaults] synchronize];
    __block UIAlertController *alertVc;
    [[BQXMPPTool sharedXMPPTool] XMPPRegisterWithResult:^(ResultType type) {
        [BQActivityView hideActiviTy];
        if (type == XmppResultTypeRegisterSuccess) {
            alertVc = [UIAlertController alertControllerWithTitle:@"注册成功" message:@"正在跳转" preferredStyle:UIAlertControllerStyleAlert];
            [[NSUserDefaults standardUserDefaults] setObject:self.registerName.text forKey:USER_NAME];
            [[NSUserDefaults standardUserDefaults] setObject:self.registerpwd.text forKey:PASS_WORD];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self presentViewController:alertVc animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVc dismissViewControllerAnimated:YES completion:^{
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                });
            }];
        }else {
            alertVc = [UIAlertController alertControllerWithTitle:@"注册失败" message:@"请检查网络状态" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertVc animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVc dismissViewControllerAnimated:YES completion:nil];
                });
            }];
        }
    }];
}
#pragma mark - set方法

#pragma mark - get方
- (UITextField *)registerName {
    if (_registerName == nil) {
        UITextField *textFeild = [[UITextField alloc]initWithFrame:BQAdaptationFrame(0, 0, 200, 40)];
        textFeild.borderStyle = UITextBorderStyleRoundedRect;
        textFeild.placeholder = @"注册用户名";
        textFeild.center = CGPointMake(SCREEN_WIDTH / 2, 100);
        _registerName = textFeild;
    }
    return _registerName;
}
- (UITextField *)registerpwd {
    if (_registerpwd == nil) {
        UITextField *textFeild = [[UITextField alloc]initWithFrame:BQAdaptationFrame(0, 0, 200, 40)];
        textFeild.borderStyle = UITextBorderStyleRoundedRect;
        textFeild.placeholder = @"用户名密码";
        textFeild.center = CGPointMake(SCREEN_WIDTH / 2, CGRectGetMaxY(self.registerName.frame) + 60);
        _registerpwd = textFeild;
    }
    return _registerpwd;
}
-(UITextField *)registerpwdAgain {
    if (_registerpwdAgain == nil) {
        UITextField *textFeild = [[UITextField alloc]initWithFrame:BQAdaptationFrame(0, 0, 200, 40)];
        textFeild.borderStyle = UITextBorderStyleRoundedRect;
        textFeild.placeholder = @"再次输入密码";
        textFeild.center = CGPointMake(SCREEN_WIDTH / 2, CGRectGetMaxY(self.registerpwd.frame) + 60);
        _registerpwdAgain = textFeild;
    }
    return _registerpwdAgain;
}
@end
