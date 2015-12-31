//
//  BQFootImageView.h
//  QQ聊天界面
//
//  Created by rimi on 15/6/23.
//  Copyright (c) 2015年 baiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FootViewBtnType) {
    FootViewBtnTypeBrow = 100,
    FootViewBtnTypeFile
};

@protocol BQFootImageViewDelegate <NSObject>

- (void)footImageViewclickedBtnCallBackWithButton:(UIButton *)btn;
- (void)footImageViewrecorderEndWithUrl:(NSString *)file;

@end

@interface BQFootImageView : UIImageView
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, weak) id<BQFootImageViewDelegate> delegate;
@end
