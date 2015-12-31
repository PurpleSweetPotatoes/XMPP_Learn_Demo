//
//  BQFootImageView.m
//  QQ聊天界面
//
//  Created by rimi on 15/6/23.
//  Copyright (c) 2015年 baiqiang. All rights reserved.
//

#import "BQFootImageView.h"
#import <AVFoundation/AVFoundation.h>

@interface BQFootImageView()
{
    NSString *_recorderPath;
}
@property (nonatomic, strong) UIButton *voiceButton;
@property (nonatomic, strong) UIButton *faceButton;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UILabel *soundLabel;
@property (nonatomic, strong) AVAudioRecorder *recorder;

@end
@implementation BQFootImageView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self addSubview:self.voiceButton];
        [self addSubview:self.textField];
        [self addSubview:self.faceButton];
        [self addSubview:self.addButton];
        [self addSubview:self.soundLabel];
        [self recorder];
        self.soundLabel.hidden = !self.voiceButton.selected;
        
    }
    return self;
}

- (UIButton *)voiceButton{
    if (_voiceButton == nil) {
        _voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_voiceButton setImage:[UIImage imageNamed:@"ToolViewInputText"] forState:UIControlStateNormal];
        [_voiceButton setImage:[UIImage imageNamed:@"chat_bottom_voice_nor"] forState:UIControlStateSelected];
        [_voiceButton addTarget:self action:@selector(clickButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        _voiceButton.frame = CGRectMake(0 , 0, 44, 44);
    }
    return _voiceButton;
}
- (UIButton *)addButton{
    if (_addButton == nil) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setImage:[UIImage imageNamed:@"chat_bottom_up_nor"]     forState:UIControlStateNormal];
        [_addButton setImage:[UIImage imageNamed:@"chat_bottom_up_press"] forState:UIControlStateHighlighted];
        [_addButton addTarget:self action:@selector(clickButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        _addButton.frame = CGRectMake(SCREEN_WIDTH - 44, 0, 44, 44);
    }
    return _addButton;
}
- (UIButton *)faceButton{
    if (_faceButton == nil) {
        _faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_faceButton setImage:[UIImage imageNamed:@"chat_bottom_smile_nor"]     forState:UIControlStateNormal];
        [_faceButton setImage:[UIImage imageNamed:@"chat_bottom_smile_press"] forState:UIControlStateHighlighted];
        [_faceButton addTarget:self action:@selector(clickButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        _faceButton.frame = CGRectMake(SCREEN_WIDTH - 88, 0, 44, 44);
    }
    return _faceButton;
}
- (void)clickButtonEvent:(UIButton *)button{
    if (button == self.voiceButton) {
        button.selected = !button.selected;
        self.soundLabel.hidden = !self.voiceButton.selected;
        self.textField.hidden = !self.soundLabel.hidden;
        return;
    }
    if ([self.delegate respondsToSelector:@selector(footImageViewclickedBtnCallBackWithButton:)]) {
        [self.delegate footImageViewclickedBtnCallBackWithButton:button];
    }
}
- (void)longGesEvent:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self.recorder record];
        self.soundLabel.backgroundColor = [UIColor grayColor];
    }else if (sender.state == UIGestureRecognizerStateEnded) {
        [self.recorder stop];
        self.soundLabel.backgroundColor = self.backgroundColor;
        if ([self.delegate respondsToSelector:@selector(footImageViewrecorderEndWithUrl:)]) {
            [self.delegate footImageViewrecorderEndWithUrl:_recorderPath];
        }
    }
}
- (UITextField *)textField{
    if (_textField == nil) {
        _textField = [[UITextField alloc] init];
        _textField.frame = CGRectMake(44, 5, CGRectGetWidth(self.frame) - 132, 34);
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.returnKeyType = UIReturnKeySend;
    }
    return _textField;
}

- (UILabel *)soundLabel {
    if (_soundLabel == nil) {
        _soundLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, 5, CGRectGetWidth(self.frame) - 132, 34)];
        _soundLabel.text = @"长按录音";
        _soundLabel.backgroundColor = [UIColor grayColor];
        _soundLabel.textAlignment = NSTextAlignmentCenter;
        _soundLabel.userInteractionEnabled = YES;
        _soundLabel.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
        _soundLabel.layer.cornerRadius = 5;
        _soundLabel.layer.borderWidth = 1;
        _soundLabel.layer.borderColor = [UIColor colorWithWhite:0.702 alpha:1.000].CGColor;
        _soundLabel.clipsToBounds = YES;
        UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGesEvent:)];
        longGes.minimumPressDuration = 0.2;
        [_soundLabel addGestureRecognizer:longGes];
    }
    return _soundLabel;
}
- (AVAudioRecorder *)recorder {
    if (_recorder == nil) {
        NSString *home = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [home stringByAppendingPathComponent:@"recorder.caf"];
        BQLog(@"path = %@",path);
        _recorderPath = path;
        NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
        //设置录音格式
        [dicM setObject:@(kAudioFormatMPEG4AAC) forKey:AVFormatIDKey];
        //设置录音采样率，8000是电话采样率，对于一般录音已经够了
        [dicM setObject:@(8000) forKey:AVSampleRateKey];
        //设置通道,这里采用单声道
        [dicM setObject:@(1) forKey:AVNumberOfChannelsKey];
        //每个采样点位数,分为8、16、24、32
        [dicM setObject:@(8) forKey:AVLinearPCMBitDepthKey];
        //是否使用浮点数采样
        [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
        NSError *recodeErr;
        _recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:path] settings:dicM error:&recodeErr];
        if (recodeErr) {
            BQLog(@"recodeErr = %@",recodeErr.localizedDescription);
        }
        if ([_recorder prepareToRecord]) {
            BQLog(@"准备录音");
        };
    }
    return _recorder;
}
@end
