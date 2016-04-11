//
//  EventsCell.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-5.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "EventsCell.h"

@implementation EventsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {

    }
    return self;
}



- (void)setDatas:(id)datas
{
    NSString *topImg = datas[@"topimg"];
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:topImg] placeholderImage:[UIImage imageNamed:@"bg_event.png"]];
  
    
    NSString *abstracts = [Base64 textFromBase64String:datas[@"abstracts"]];

    
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    _fireDate=[dateFormatter dateFromString:datas[@"begintime"]];
    
    NSString *begintime = [NSObject compareFutureTimeToCurrentTime:_fireDate];

    
    
    
    NSString *activitytitle = [Base64 textFromBase64String:datas[@"activitytitle"]];
    _title.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + ScaleW(10), CGRectGetMidY(_headImageView.frame) - ScaleW(3) - _title.font.lineHeight, DeviceW - CGRectGetMaxX(_headImageView.frame) + ScaleW(10), _title.font.lineHeight);
    _title.text = activitytitle;
    

    _textLb.frame = CGRectMake(CGRectGetMinX(_title.frame), CGRectGetMidY(_headImageView.frame) + ScaleH(3), CGRectGetWidth(_title.frame), _textLb.font.lineHeight);
    if (begintime) {
        _textLb.text = [NSString stringWithFormat:@"%@ 准时开始报名",begintime];
    }
    else
    {
        if (!_timer) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:UITrackingRunLoopMode];
        }
    }
    

}

- (void)timerFireMethod:(NSTimer *)timer
{
    if (!self.window)return;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *today = [NSDate date];//当前时间
    NSDate *compareDate = [_fireDate earlierDate:today];
    if (![compareDate isEqualToDate:today])
    {
        if ([_delegate conformsToProtocol:@protocol(EventsCellDelegate)] &&
            [_delegate respondsToSelector:@selector(timeOut:)])
        {
            [_delegate  timeOut:self];
        }
    }

    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *d = [calendar components:unitFlags fromDate:today toDate:_fireDate options:0];//计算时间差
   
    _textLb.text = [NSString stringWithFormat:@"%d小时%d分%d秒",[d hour], [d minute], [d second]];//倒计时显示
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
