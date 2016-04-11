//
//  PublicActivityListCell.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-5.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "PublicActivityListCell.h"

@implementation PublicActivityListCell

- (void)drawRect:(CGRect)rect
{
    [self drawRectWithLine:rect start:CGPointMake(0, CGRectGetHeight(rect) -.3) end:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect) - .3) lineColor:CustomGray lineWidth:.3];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScaleX(10), (ScaleH(70) - ScaleH(60)) / 2, ScaleW(60), ScaleH(60))];
       
        _title = [UILabel new];
        _title.font = FontBold(15);
        _title.textColor = CustomBlack;
        
        _textLb  = [UILabel new];
        _textLb.font = Font(13);
        _textLb.textColor = CustomGray;
        
        [self.contentView addSubview:_headImageView];
        [self.contentView addSubview:_title];
        [self.contentView addSubview:_textLb];
    }
    return self;
}


- (id)init
{
    if ((self = [super init])) {
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScaleX(10), (ScaleH(70) - ScaleH(60)) / 2, ScaleW(60), ScaleH(60))];
        
        _title = [UILabel new];
        _title.font = FontBold(15);
        _title.textColor = CustomBlue;
        
        _textLb  = [UILabel new];
        _textLb.font = Font(13);
        _textLb.textColor = CustomGray;
        
        [self.contentView addSubview:_headImageView];
        [self.contentView addSubview:_title];
        [self.contentView addSubview:_textLb];

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
