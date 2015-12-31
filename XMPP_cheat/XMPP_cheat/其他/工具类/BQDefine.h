//
//  BQDefine.h
//  runtimeDemo
//
//  Created by baiqiang on 15/12/2.
//  Copyright © 2015年 baiqiang. All rights reserved.
//

#ifndef BQDefine_h
#define BQDefine_h


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define IPHONE6_WIDTH 375
#define IPHONE6_HEIGHT 667

#define HAS_NAVIGATIONBAR_HEIGHT (SCREEN_HEIGHT - CGRectGetMaxY(self.navigationController.navigationBar.frame))

#define HAS_TABBAR_HEIGHT (SCREEN_HEIGHT - self.tabBarController.tabBar.bounds.size.height)

#define HAS_TABBAR_AND_NAVIGATIONBAR_HEIGHT (SCREEN_HEIGHT - self.tabBarController.tabBar.bounds.size.height - CGRectGetMaxY(self.navigationController.navigationBar.frame))

#endif /* BQDefine_h */
