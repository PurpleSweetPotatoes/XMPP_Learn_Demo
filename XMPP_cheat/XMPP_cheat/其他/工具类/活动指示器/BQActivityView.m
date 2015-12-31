//
//  BQActivityView.m
//  活动指示器
//
//  Created by baiqiang on 15/11/28.
//  Copyright © 2015年 baiqiang. All rights reserved.
//

#import "BQActivityView.h"

static BQActivityView *activiyView;

@interface BQActivityView ()
@property (nonatomic, strong) CAReplicatorLayer *reaplicator;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) CALayer *showlayer;
@property (nonatomic, strong) UILabel *label;
@end

static BQActivityView *activiyView = nil;

@implementation BQActivityView

+ (void)showActiviTy {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (activiyView == nil) {
            CGRect rect = [UIScreen mainScreen].bounds;
            activiyView = [[BQActivityView alloc] initWithFrame:rect];
            activiyView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
        }
    });
    activiyView.label.text = @"努力加载中....";
    [activiyView startAnimation];
    [[UIApplication sharedApplication].keyWindow addSubview:activiyView];
}

+ (void)hideActiviTy {
    activiyView.label.text = @"加载完成";
    [UIView animateWithDuration:0.25f animations:^{
        activiyView.alpha = 0;
    } completion:^(BOOL finished) {
        [activiyView removeFromSuperview];
        activiyView.alpha = 1;
    }];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.label];
        [self.contentView.layer addSublayer:self.reaplicator];
        [self addSubview:self.contentView];
    }
    return self;
}
- (void)startAnimation {
    //对layer进行动画设置
    CABasicAnimation *animaiton = [CABasicAnimation animation];
    //设置动画所关联的路径属性
    animaiton.keyPath = @"transform.scale";
    //设置动画起始和终结的动画值
    animaiton.fromValue = @(1);
    animaiton.toValue = @(0.1);
    //设置动画时间
    animaiton.duration = 1.0f;
    //设置动画次数
    animaiton.repeatCount = INT_MAX;
    //添加动画
    [_showlayer addAnimation:animaiton forKey:nil];
}
- (UIView *)contentView {
    if (_contentView == nil) {
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 110)];
        contentView.layer.cornerRadius = 10.0f;
        contentView.clipsToBounds = YES;
        contentView.center = self.center;
        contentView.backgroundColor = [UIColor grayColor];
        _contentView = contentView;
    }
    return _contentView;
}
- (UILabel *)label {
    if (_label == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.reaplicator.frame), CGRectGetWidth(self.contentView.frame), 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:16];
        _label = label;
    }
    return _label;
}
- (CAReplicatorLayer *)reaplicator{
    if (_reaplicator == nil) {
        //需要实例化的个数
        int numofInstance = 10;
        //动画时长
        CGFloat duration = 1.0f;
        //创建repelicator对象
        CAReplicatorLayer *repelicator = [CAReplicatorLayer layer];
        //设置其位置
        repelicator.bounds = CGRectMake(0, 0, 100, 70);
        repelicator.position = CGPointMake(self.contentView.bounds.size.width * 0.5, self.contentView.bounds.size.height * 0.4);
        //需要生成多少个相同实例
        repelicator.instanceCount = numofInstance;
        //代表实例生成的延时时间;
        repelicator.instanceDelay = duration / numofInstance;
        //设置每个实例的变换样式
        repelicator.instanceTransform = CATransform3DMakeRotation(M_PI * 2.0 / 10.0, 0, 0, 1);
        //创建repelicator对象的子图层，repelicator会利用此子图层进行高效复制。并绘制到自身图层上
        CALayer *layer = [CALayer layer];
        //设置子图层的大小位置
        layer.frame = CGRectMake(0, 0, 10, 10);
        //子图层的仿射变换是基于repelicator图层的锚点，因此这里将子图层的位置摆放到此锚点附近。
        CGPoint point = [repelicator convertPoint:repelicator.position fromLayer:self.layer];
        layer.position = CGPointMake(point.x, point.y - 20);
        //设置子图层的背景色
        layer.backgroundColor = [UIColor whiteColor].CGColor;
        //将子图层切圆
        layer.cornerRadius = 5;
        //为显示效果缩小layer比例
        layer.transform = CATransform3DMakeScale(0.01, 0.01, 1);
        _showlayer = layer;
        //将子图层添加到repelicator上
        [repelicator addSublayer:layer];
        _reaplicator = repelicator;
    }
    return _reaplicator;
}
@end
