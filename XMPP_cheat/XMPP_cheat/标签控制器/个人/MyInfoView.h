//
//  MyInfoView.h
//  XMPP_cheat
//
//  Created by baiqiang on 15/12/19.
//  Copyright © 2015年 baiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyInfoView : UIView

/**
 *  用户头像
 */
@property (nonatomic, strong, readonly) UIImageView *imageView;

/**
 *  用户名字
 */
@property (nonatomic, strong, readonly) UILabel *nameLabel;

@end
