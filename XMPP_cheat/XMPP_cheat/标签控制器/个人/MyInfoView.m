//
//  MyInfoView.m
//  XMPP_cheat
//
//  Created by baiqiang on 15/12/19.
//  Copyright © 2015年 baiqiang. All rights reserved.
//

#import "MyInfoView.h"

@implementation MyInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)initUI {
    [self createImageView];
    [self showUserName];
    
    UILabel *otherLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width * 0.4, 30)];
    otherLabel.textAlignment = NSTextAlignmentRight;
    otherLabel.text = @"个人信息 >";
    otherLabel.textColor = [UIColor grayColor];
    otherLabel.font = [UIFont systemFontOfSize:17];
    otherLabel.center = CGPointMake(self.width * 0.75, self.height * 0.5);
    [self addSubview:otherLabel];
}

- (void)createImageView {
    CGFloat imageH = self.height - 20;
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageH, imageH)];
    _imageView.layer.cornerRadius = imageH * 0.5;
    _imageView.clipsToBounds = YES;
    _imageView.center = CGPointMake(imageH * 0.5 + 10, self.height * 0.5);
    _imageView.backgroundColor = [UIColor redColor];
    [self addSubview:_imageView];
}
- (void)showUserName {
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imageView.frame) + 10, self.height * 0.5 - 15, self.width * 0.5, 30)];
    _nameLabel.font = [UIFont systemFontOfSize:20];
    [self addSubview:_nameLabel];
}
@end
