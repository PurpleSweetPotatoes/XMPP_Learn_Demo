//
//  EditView.m
//  XMPP_cheat
//
//  Created by baiqiang on 15/12/19.
//  Copyright © 2015年 baiqiang. All rights reserved.
//

#import "EditView.h"

typedef void (^CallbackBlock)(NSString *text);
@interface EditView()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, copy) CallbackBlock callback;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *myTextField;
@end

@implementation EditView

+ (void)showEditViewWithTitle:(NSString *)title text:(NSString *)text UsingBlock:(void (^)(NSString *text))successBlock {
    EditView *eView = [[EditView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 0.7, 120)];
    eView.center = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.5);
    eView.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
    eView.callback = successBlock;
    eView.titleLabel.text = title;
    eView.myTextField.text = text;
    [[UIApplication sharedApplication].keyWindow addSubview:eView.backView];
    [[UIApplication sharedApplication].keyWindow addSubview:eView];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        self.layer.cornerRadius = 10;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)initUI {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:20];
    self.titleLabel = label;
    [self addSubview:label];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(self.width * 0.1, CGRectGetMaxY(label.frame) + 10, self.width * 0.8, 30)];
    textField.backgroundColor = [UIColor whiteColor];
    self.myTextField = textField;
    [self addSubview:textField];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, CGRectGetMaxY(textField.frame) + 10, self.width * 0.5, self.height - CGRectGetMaxY(textField.frame) - 10);
    [self customBtn:backBtn title:@"back"];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(self.width * 0.5, CGRectGetMaxY(textField.frame) + 10, self.width * 0.5, self.height - CGRectGetMaxY(textField.frame) - 10);
    [self customBtn:sureBtn title:@"sure"];
}



- (void)btnClickedEvent:(UIButton *)btn {
    if ([btn.currentTitle isEqualToString:@"sure"] && self.callback != nil) {
        self.callback(self.myTextField.text);
    }
    [self hideEditView];
}

- (void)hideEditView {
    [self.backView removeFromSuperview];
    [self removeFromSuperview];
}

- (void)customBtn:(UIButton *)btn title:(NSString *)title {
    [btn addTarget:self action:@selector(btnClickedEvent:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];

    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:btn];
}

- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _backView.backgroundColor = [UIColor colorWithRed:0.795 green:0.786 blue:0.794 alpha:0.300];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideEditView)];
        [_backView addGestureRecognizer:tap];
    }
    return _backView;
}
@end
