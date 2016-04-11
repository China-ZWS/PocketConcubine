//
//  NDHeaderView.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-11.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "NDHeaderView.h"

@implementation NDHeaderView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        self.backgroundColor = [UIColor clearColor];
        
        _title = [[UILabel alloc] initWithFrame:CGRectMake(0, defaultInset.top, DeviceW, ScaleW(30))];
        _title.font = FontBold(18);
        _title.textColor = CustomBlack;
        _title.textAlignment = NSTextAlignmentCenter;
        _title.backgroundColor = [UIColor clearColor];
        
        _text  = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_title.frame), DeviceW, ScaleH(20))];
        _text.backgroundColor = [UIColor clearColor];
        _text.font = Font(13);
        _text.textColor = CustomGray;
        _text.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_title];
        [self addSubview:_text];
    }
    return self;
}

- (void)setDatas:(id)datas
{
    NSString *newTitle = [Base64 textFromBase64String:datas[@"newstitle"]];
    NSString *pretime = datas[@"pretime"];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    pretime = [NSObject compareCurrentTimeToPastTime:[dateFormatter dateFromString:pretime]];
    NSString *pubName = [Base64 textFromBase64String:datas[@"pubname"]];
    _title.text = newTitle;
    _text.text = [pubName stringByAppendingString:pretime];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
