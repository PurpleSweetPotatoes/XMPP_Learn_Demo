//
//  BaseViewController.m
//  XMPP_cheat
//
//  Created by baiqiang on 15/12/13.
//  Copyright © 2015年 baiqiang. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
//    self.view.backgroundColor = [UIColor whiteColor];

    CGFloat red = (arc4random() % 256) / 256.0;
    CGFloat green = (arc4random() % 256) / 256.0;
    CGFloat blue = (arc4random() % 256) / 256.0;
    self.view.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];

    
}
- (void)initDataSource {
    
}
- (void)initUI {
    
}
- (void)registerNotification {
    
}


@end
