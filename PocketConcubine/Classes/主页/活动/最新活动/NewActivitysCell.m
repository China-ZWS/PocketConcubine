//
//  NewActivitysCell.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-5.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "NewActivitysCell.h"

@implementation NewActivitysCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    {
        _option = [UIButton buttonWithType:UIButtonTypeCustom];
        _option.frame = CGRectMake(DeviceW - ScaleW(50), (ScaleH(70) - ScaleH(30)) / 2, ScaleW(50), ScaleH(30));
        [_option setTitle:@"报 名" forState:UIControlStateNormal];
        [_option addTarget:self action:@selector(eventWithOption:) forControlEvents:UIControlEventTouchUpInside];
        [_option setTitleColor:CustomBlue forState:UIControlStateNormal];
        [_option getCornerRadius:ScaleW(3) borderColor:CustomBlue borderWidth:1 masksToBounds:NO];
        _option.backgroundColor = [UIColor clearColor];
        _option.titleLabel.font = Font(13);
        self.accessoryView = _option;
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
    NSString *endTime = datas[@"endtime"];
    NSDate *date = [dateFormatter dateFromString:endTime];
    
    NSString *begintime = [NSObject compareCurrentTimeToPastTime:date];
    
    
    
    NSString *activitytitle = [Base64 textFromBase64String:datas[@"activitytitle"]];
    _title.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + ScaleW(10), CGRectGetMidY(_headImageView.frame) - ScaleW(3) - _title.font.lineHeight, DeviceW - CGRectGetMaxX(_headImageView.frame) - ScaleW(80), _title.font.lineHeight);
    _title.text = activitytitle;
    
    
    _textLb.frame = CGRectMake(CGRectGetMinX(_title.frame), CGRectGetMidY(_headImageView.frame) + ScaleH(3), CGRectGetWidth(_title.frame), _textLb.font.lineHeight);
    _textLb.text = [NSString stringWithFormat:@"截止日期：%@",begintime];    
}

- (void)eventWithOption:(UIButton *)button
{
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
