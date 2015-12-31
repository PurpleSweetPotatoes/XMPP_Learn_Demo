//
//  LoginViewController.m
//  XMPP_cheat
//
//  Created by baiqiang on 15/12/13.
//  Copyright © 2015年 baiqiang. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "AppDelegate.h"
#import <ReactiveCocoa.h>


@interface LoginViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITextField *userNameField;
@property (nonatomic, strong) UITextField *passWordField;

@end

@implementation LoginViewController

#pragma mark - 类方法

#pragma mark - 创建方法

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    [self registerNotification];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.userNameField.text = [[NSUserDefaults standardUserDefaults] objectForKey:USER_NAME];
    self.passWordField.text = [[NSUserDefaults standardUserDefaults] objectForKey:PASS_WORD];
    
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
#pragma mark - 实例方法
- (void)initData{
    
}

- (void)initUI{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.userNameField];
    [self.view addSubview:self.passWordField];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    loginBtn.frame = BQAdaptationFrame(0, 0, 70, 40);
    loginBtn.center = CGPointMake(SCREEN_WIDTH * 0.75, CGRectGetMaxY(self.passWordField.frame) + 70);
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginBtnClickedEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    //针对于self.userNameField.rac_textSignal 需要在编辑情况下才会有信号刺激
    RAC(loginBtn,enabled) = [RACSignal combineLatest:@[RACObserve(self.userNameField, text), RACObserve(self.passWordField, text)] reduce:^id(NSString *name, NSString *pwd) {
        return name.length > 0 && pwd.length > 0 ? @1 : @0;
    }];
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    registerBtn.frame = BQAdaptationFrame(0, 0, 70, 40);
    registerBtn.center = CGPointMake(SCREEN_WIDTH * 0.25, CGRectGetMaxY(self.passWordField.frame) + 70);
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerBtnClickedEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
}

- (void)registerNotification{
    
}

#pragma mark - 事件响应方法
- (void)loginBtnClickedEvent:(UIButton *)btn {
    [self.view endEditing:YES];
    NSUserDefaults *userDf = [NSUserDefaults standardUserDefaults];
    [userDf setObject:self.userNameField.text forKey:USER_NAME];
    [userDf setObject:self.passWordField.text forKey:PASS_WORD];
    [userDf synchronize];
    //开启活动指示器
    [BQActivityView showActiviTy];
    
    __weak typeof(self) weakSelf = self;
    //登录并获得结果
    [[BQXMPPTool sharedXMPPTool] XMPPLoginWithResult:^(ResultType type) {
        
        //关闭活动指示器
        [BQActivityView hideActiviTy];
        
        if (type == XmppResultTypeLoginSuccess) {
            //登录成功调用
            [weakSelf.navigationController.view removeFromSuperview];
            [weakSelf.navigationController removeFromParentViewController];
        }else{
            
            NSString *message = @"用户名或密码有误";
            if(type == XmppResultTypeConnectFail) {
                message = @"链接服务器失败";
            }
            //登录失败
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
            [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertVc animated:YES completion:nil];
        }
    }];
}

- (void)registerBtnClickedEvent:(UIButton *)btn {
    RegisterViewController *registerVc = [[RegisterViewController alloc] init];
    registerVc.title = @"注册";
    [self.navigationController pushViewController:registerVc animated:YES];
}
#pragma mark - Method

- (void)setTextFeild:(UITextField *)textFeild WithName:(NSString *)placeName{
    textFeild.autocorrectionType = UITextAutocorrectionTypeNo;
    textFeild.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textFeild.borderStyle = UITextBorderStyleRoundedRect;
    textFeild.placeholder = placeName;
}
#pragma mark - set方法

#pragma mark - get方法
- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:
                                      BQAdaptationFrame(0, 0, 100, 100)];
            imageView.center = CGPointMake(SCREEN_WIDTH / 2, BQAdaptationHeight() * 130);
            imageView.backgroundColor = [UIColor yellowColor];
            imageView.layer.cornerRadius = imageView.width / 2;
            imageView.clipsToBounds = YES;
            imageView;
        });
    }
    return _imageView;
}
- (UITextField *)userNameField {
    if (_userNameField == nil) {
        _userNameField = ({
            UITextField *textFeild = [[UITextField alloc] initWithFrame:BQAdaptationFrame(0, 0, 250, 40)];
            textFeild.center = CGPointMake(SCREEN_WIDTH / 2, CGRectGetMaxY(self.imageView.frame) + 70);
            textFeild.clearButtonMode = UITextFieldViewModeAlways;
            [self setTextFeild:textFeild WithName:@"请输入用户名"];
            textFeild;
        });
    }
    return _userNameField;
}
- (UITextField *)passWordField {
    if (_passWordField == nil) {
        _passWordField = ({
            UITextField *textFeild = [[UITextField alloc] initWithFrame:BQAdaptationFrame(0, 0, 250, 40)];
            textFeild.center = CGPointMake(SCREEN_WIDTH / 2, CGRectGetMaxY(self.userNameField.frame) + 40);
            textFeild.secureTextEntry = YES;
            [self setTextFeild:textFeild WithName:@"请输入密码"];
            textFeild;
        });
    }
    return _passWordField;
}
@end
