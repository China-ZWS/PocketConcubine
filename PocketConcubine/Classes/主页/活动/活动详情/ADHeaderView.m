//
//  ADHeaderView.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-11.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "ADHeaderView.h"

@implementation ADHeaderView

- (void)drawRect:(CGRect)rect
{
    if ([_datas count])
    {
        [self drawRectWithLine:rect start:CGPointMake(0, CGRectGetHeight(rect) - 1) end:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect) - 1) lineColor:CustomGray lineWidth:.5];
    }
}

- (id)initWithFrame:(CGRect)frame addActivity:(void(^)())addActivity;
{
    if ((self = [super initWithFrame:frame]))
    {
        _addActivity = addActivity;
        self.backgroundColor = [UIColor clearColor];
        _topImgView = [[UIImageView alloc] initWithFrame:CGRectMake(defaultInset.left, (CGRectGetHeight(frame) - ScaleH(60)) / 2, ScaleW(60), ScaleH(60))];
//        _topImgView.layer.masksToBounds =YES;
//        _topImgView.layer.cornerRadius = 30;
        [self addSubview:_topImgView];
        
        _title = [UILabel new];
        _title.font = FontBold(15);
        _title.textColor = CustomBlack;
        
        _text  = [UILabel new];
        _text.font = Font(13);
        _text.textColor = CustomBlue;
        
        _option = [UIButton buttonWithType:UIButtonTypeCustom];
        [_option addTarget:self action:@selector(eventWithOption:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:_title];
        [self addSubview:_text];
        [self addSubview:_option];
    }
    return self;
}

- (void)setDatas:(id)datas type:(ActivityType)type
{
    _datas = datas;
    NSString *topImg = datas[@"backimg"];
    [_topImgView sd_setImageWithURL:[NSURL URLWithString:topImg] placeholderImage:[UIImage imageNamed:@"bk_1_1.png"]];
    
    
    if (type == kForeshow)
    {
        NSString *begintime = datas[@"begintime"];
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        _fireDate=[dateFormatter dateFromString:begintime];
        
        
        begintime = [NSObject compareFutureTimeToCurrentTime:_fireDate];
        
        
        NSString *activitytitle = [Base64 textFromBase64String:datas[@"activitytitle"]];
        _title.frame = CGRectMake(CGRectGetMaxX(_topImgView.frame) + defaultInset.left, CGRectGetMidY(_topImgView.frame) - ScaleW(3) - _title.font.lineHeight, DeviceW - CGRectGetMaxX(_topImgView.frame) - defaultInset.left - defaultInset.right, _title.font.lineHeight);
        _title.text = activitytitle;
        
        
        _text.frame = CGRectMake(CGRectGetMinX(_title.frame), CGRectGetMidY(_topImgView.frame) + ScaleH(3), CGRectGetWidth(_title.frame), _text.font.lineHeight);
        if (begintime) {
            _text.text = [NSString stringWithFormat:@"%@ 准时开始报名",begintime];
        }
        else
        {
            if (!_timer) {
                _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:_timer forMode:UITrackingRunLoopMode];
            }
        }
        _option.hidden = YES;
        _option.frame = CGRectZero;
    }
    else
    {
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

        NSDate *date = [dateFormatter dateFromString:datas[@"endtime"]];
        
        
        NSString *endtime = [NSObject compareCurrentTimeToPastTime:date];
        NSString *activitytitle = [Base64 textFromBase64String:datas[@"activitytitle"]];
       
        _title.frame = CGRectMake(CGRectGetMaxX(_topImgView.frame) + defaultInset.left, CGRectGetMidY(_topImgView.frame) - ScaleW(3) - _title.font.lineHeight, DeviceW - CGRectGetMaxX(_topImgView.frame) - defaultInset.left - defaultInset.right - ScaleH(30), _title.font.lineHeight);
        _title.text = activitytitle;
        
        _text.frame = CGRectMake(CGRectGetMinX(_title.frame), CGRectGetMidY(_topImgView.frame) + ScaleH(3), CGRectGetWidth(_title.frame), _text.font.lineHeight);
        _text.text = [NSString stringWithFormat:@"截止日期：%@",endtime];
      
        _option.frame = CGRectMake(DeviceW - defaultInset.left - ScaleH(50), (ScaleH(80) - ScaleH(30)) / 2, ScaleW(50), ScaleH(30));
        _option.hidden = NO;
        if ([datas[@"flag"] integerValue])
        {
            [_option getCornerRadius:ScaleW(3) borderColor:CustomBlue borderWidth:1 masksToBounds:NO];
            _option.userInteractionEnabled = NO;
            [_option setTitle:@"已报名" forState:UIControlStateNormal];
            [_option setTitleColor:CustomBlue forState:UIControlStateNormal];
            _option.titleLabel.font = Font(13);
        }
        else
        {
            _option.userInteractionEnabled = YES;
            [_option getCornerRadius:ScaleW(3) borderColor:CustomBlue borderWidth:1 masksToBounds:NO];
            [_option setTitleColor:CustomBlue forState:UIControlStateNormal];
            [_option setTitle:@"报名" forState:UIControlStateNormal];
            _option.titleLabel.font = Font(13);
        }
    }
    
    [self setNeedsDisplay];
}

- (void)timerFireMethod:(NSTimer *)timer
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *today = [NSDate date];//当前时间
    NSDate *compareDate = [_fireDate earlierDate:today];
    if (![compareDate isEqualToDate:today])
    {
        if ([_delegate conformsToProtocol:@protocol(ADHeaderViewDelegate)] &&
            [_delegate respondsToSelector:@selector(timeOut:)])
        {
            [_delegate  timeOut:self];
        }
    }
    
    
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *d = [calendar components:unitFlags fromDate:today toDate:_fireDate options:0];//计算时间差
    
    _text.text = [NSString stringWithFormat:@"%d小时%d分%d秒 后开始报名",[d hour], [d minute], [d second]];//倒计时显示
}

- (void)eventWithOption:(UIButton *)button
{
    _addActivity();
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
