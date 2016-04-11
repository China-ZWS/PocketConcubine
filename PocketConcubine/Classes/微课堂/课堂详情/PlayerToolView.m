//
//  PlayerToolView.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-17.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "PlayerToolView.h"

@implementation PlayerToolView
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = CustomAlphaBlue;
        [self layoutViews];

        
    }
    return self;
}


- (UIButton *)playBtn
{
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playBtn.frame = CGRectMake(ScaleW(20), 0, ScaleW(30), ScaleH(30));
        UIImage *image = [UIImage imageNamed:@"play.png"];
        UIImage *image_s = [UIImage imageNamed:@"pause"];
        [_playBtn setBackgroundImage:image forState:UIControlStateNormal];
        [_playBtn setBackgroundImage:image_s forState:UIControlStateSelected];
        [_playBtn addTarget:self action:@selector(eventWithPlay:) forControlEvents:UIControlEventTouchUpInside];
        _playBtn.selected = NO;
    }
    return _playBtn;
}

- (UIButton *)fillBtn
{
    if (!_fillBtn) {
        _fillBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _fillBtn.frame = CGRectMake(DeviceW - ScaleW(20) - ScaleW(20), (CGRectGetHeight(self.frame) - ScaleH(20)) / 2, ScaleW(20), ScaleH(20));
        UIImage *image = [UIImage imageNamed:@"small.png"];
        UIImage *image_s = [UIImage imageNamed:@"big"];
        [_fillBtn setBackgroundImage:image forState:UIControlStateNormal];
        [_fillBtn setBackgroundImage:image_s forState:UIControlStateSelected];
        [_fillBtn addTarget:self action:@selector(eventWithFill:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _fillBtn;
}

- (UILabel *)leftView
{
    if(!_leftView)
    {
        _leftView = [UILabel new];
        _leftView.frame = CGRectMake(CGRectGetMaxX(_playBtn.frame) + ScaleW(5), 0, ScaleW(50), ScaleH(30));
        _leftView.font = Font(13);
        _leftView.backgroundColor = [UIColor clearColor];
        _leftView.text = @"00:00";
        _leftView.textColor = [UIColor whiteColor];
        _leftView.textAlignment = NSTextAlignmentRight;
    }
    
    return _leftView;
}

- (UILabel *)rightView
{
    if (!_rightView) {
        _rightView = [UILabel new];
        _rightView.frame = CGRectMake(CGRectGetMinX(_fillBtn.frame) - ScaleW(5) - ScaleW(50), 0, ScaleW(50), ScaleW(30));
        _rightView.text = @"00:00";
        _rightView.textColor = [UIColor whiteColor];
        _rightView.backgroundColor = [UIColor clearColor];
        _rightView.textAlignment = NSTextAlignmentLeft;
    }
    return _rightView;
}

- (UISlider *)scrubber
{
    if (!_scrubber) {
        _scrubber = [UISlider new];
        [_scrubber setMinimumTrackImage:[UIImage imageNamed:@"progress_big_read.png"] forState:UIControlStateNormal];
        [_scrubber setMaximumTrackImage:[UIImage imageNamed:@"progress_big_unread.png"] forState:UIControlStateNormal];
        [_scrubber setThumbImage:[UIImage imageNamed:@"progress.png"] forState:UIControlStateNormal];
        _scrubber.frame = CGRectMake(CGRectGetMaxX(_leftView.frame) + ScaleW(5), (ScaleH(30) - 10) / 2, DeviceW - (CGRectGetMaxX(_leftView.frame) + ScaleW(5)) * 2, 10);        _rightView.font = Font(13);
        _scrubber.backgroundColor = [UIColor clearColor];
        [_scrubber addTarget:self action:@selector(beginDragging) forControlEvents:UIControlEventTouchDown];
        [_scrubber addTarget:self action:@selector(dragging) forControlEvents:UIControlEventValueChanged];
        [_scrubber addTarget:self action:@selector(endDraging) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scrubber;
}



- (void)layoutViews
{
    
    [self addSubview:self.playBtn];
    [self addSubview:self.fillBtn];
    
    [self addSubview:self.leftView];
    [self addSubview:self.rightView];

    [self addSubview:self.scrubber];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];

}

- (void)eventWithPlay:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected) {
        if ([_delegate respondsToSelector:@selector(play)] && [_delegate conformsToProtocol:@protocol(PlayerToolViewDelegate)]) {
            [_delegate play];
        }
    }
    else
    {
        if ([_delegate respondsToSelector:@selector(pause)] && [_delegate conformsToProtocol:@protocol(PlayerToolViewDelegate)]) {
            [_delegate pause];
        }
    }

}

- (void)eventWithFill:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected) {
        if ([_delegate respondsToSelector:@selector(play)] && [_delegate conformsToProtocol:@protocol(PlayerToolViewDelegate)]) {
            [_delegate big];
        }
    }
    else
    {
        if ([_delegate respondsToSelector:@selector(pause)] && [_delegate conformsToProtocol:@protocol(PlayerToolViewDelegate)]) {
            [_delegate small];
        }
    }

}

- (void)beginDragging
{
    if ([_delegate respondsToSelector:@selector(beginDragging)] && [_delegate conformsToProtocol:@protocol(PlayerToolViewDelegate)]) {
        [_delegate beginDragging];
    }

}

- (void)dragging
{
    if ([_delegate respondsToSelector:@selector(beginDragging)] && [_delegate conformsToProtocol:@protocol(PlayerToolViewDelegate)]) {
        [_delegate dragging];
    }

}

- (void)endDraging
{
    if ([_delegate respondsToSelector:@selector(beginDragging)] && [_delegate conformsToProtocol:@protocol(PlayerToolViewDelegate)]) {
        [_delegate endDraging];
    }
}


- (void)statusBarOrientationChange:(NSNotification *)notification

{
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft) // home键靠右
    {

        _fillBtn.selected = YES;
        _playBtn.frame = CGRectMake(ScaleW(35), (ScaleH(120) - ScaleH(60)) / 2, ScaleW(60), ScaleH(60));
        _fillBtn.frame = CGRectMake(DeviceW - ScaleW(35) - ScaleW(60), (ScaleH(120) - ScaleH(50)) / 2, ScaleW(50), ScaleH(50));
        _leftView.frame = CGRectMake(CGRectGetMaxX(_playBtn.frame) + ScaleW(5), (ScaleH(120) - ScaleH(60)) / 2, ScaleW(100), ScaleH(60));
        _rightView.frame = CGRectMake(CGRectGetMinX(_fillBtn.frame) - ScaleW(5) - ScaleW(100), (ScaleH(120) - ScaleH(60)) / 2, ScaleW(100), ScaleW(60));
        _scrubber.frame = CGRectMake(CGRectGetMaxX(_leftView.frame) + ScaleW(5), (ScaleH(120) - 10) / 2, DeviceW - (CGRectGetMaxX(_leftView.frame) + ScaleW(5)) * 2, 10);

    }
    else if (orientation == UIDeviceOrientationPortrait)
    {
        
        _fillBtn.selected = NO;
        _playBtn.frame = CGRectMake(ScaleW(20), 0, ScaleW(30), ScaleH(30));
        _fillBtn.frame = CGRectMake(DeviceW - ScaleW(20) - ScaleW(20), (ScaleH(30) - ScaleH(20)) / 2, ScaleW(20), ScaleH(20));
        _leftView.frame = CGRectMake(CGRectGetMaxX(_playBtn.frame) + ScaleW(5), 0, ScaleW(50), ScaleH(30));
        _rightView.frame = CGRectMake(CGRectGetMinX(_fillBtn.frame) - ScaleW(5) - ScaleW(50), 0, ScaleW(50), ScaleW(30));
        _scrubber.frame = CGRectMake(CGRectGetMaxX(_leftView.frame) + ScaleW(5), (ScaleH(30) - 10) / 2, DeviceW - (CGRectGetMaxX(_leftView.frame) + ScaleW(5)) * 2, 10);
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
