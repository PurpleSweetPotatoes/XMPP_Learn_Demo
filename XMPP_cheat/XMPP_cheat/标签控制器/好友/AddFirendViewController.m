//
//  AddFirendViewController.m
//  XMPP_cheat
//
//  Created by baiqiang on 15/12/24.
//  Copyright © 2015年 baiqiang. All rights reserved.
//


#import "AddFirendViewController.h"
#import <ReactiveCocoa.h>

@interface AddFirendViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *AddBtn;

@end

@implementation AddFirendViewController

#pragma mark - 类方法

#pragma mark - 创建方法

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - 实例方法


- (void)initUI{
   @weakify(self)
    //创建信号关联
   [self.textField.rac_textSignal subscribeNext:^(NSString * text) {
       @strongify(self)
       self.AddBtn.enabled = text.length > 0 ? 1 : 0;
   }];
}

#pragma mark - 事件响应方法
- (IBAction)addBtnClickedEvent:(UIButton *)sender {
    /*  1.输入jid(NSString)
     2.判断是否存在此好友
     3.没有的话 添加(订阅)好友
     */
    //拼接实际的用户id(实际id由用户名加域名组成)
    NSString *strJid = [NSString stringWithFormat:@"%@@%@",self.textField.text,[BQXMPPTool sharedXMPPTool].hostName];
    XMPPJID *jid = [XMPPJID jidWithString:strJid];
    //判断是否存在此好友
    BOOL hasFirend = [[BQXMPPTool sharedXMPPTool].rosterStorage userExistsWithJID:jid xmppStream:[BQXMPPTool sharedXMPPTool].xmppStream];
    
    if (hasFirend == YES || [self.textField.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:USER_NAME]]) {
        //列表中若存在此好友给予提示
        NSString *message = hasFirend ? @"好友以存在" : @"不能添加自己";
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertVc animated:YES completion:nil];
    }else {
        //列表中不存在此好友则订阅该好友
        [[BQXMPPTool sharedXMPPTool].roster subscribePresenceToUser:jid];
    }
    
}


#pragma mark - Method

#pragma mark - set方法

#pragma mark - get方法




@end
