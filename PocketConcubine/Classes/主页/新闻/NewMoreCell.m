//
//  NewDetailsCell.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-8.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "NewMoreCell.h"

@implementation NewMoreCell

- (void)drawRect:(CGRect)rect
{
    [self drawRectWithLine:rect start:CGPointMake(0, CGRectGetHeight(rect) -.3) end:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect) - .3) lineColor:CustomGray lineWidth:.3];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    {
        _headImageView = [UIImageView new];
        _title = [UILabel new];
        _title.textColor = CustomBlue;
        _title.font = FontBold(17);
        
        _abstracts = [UILabel new];
        _abstracts.numberOfLines = 0;
        _abstracts.textColor = CustomGray;
        _abstracts.font = Font(15);
        
        _createTime = [UILabel new];
        _createTime.textColor = CustomGray;
        _createTime.font = Font(15);
        _createTime.textAlignment = NSTextAlignmentRight;

        [self.contentView addSubview:_headImageView];
        [self.contentView addSubview:_title];
        [self.contentView addSubview:_abstracts];
        [self.contentView addSubview:_createTime];
   }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _headImageView.frame = CGRectMake(defaultInset.left + ScaleW(5), defaultInset.top * 2, ScaleH(80) * kTop2Scale, ScaleH(80));
    
    _title.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + ScaleW(5), CGRectGetMinY(_headImageView.frame), DeviceW - (CGRectGetMaxX(_headImageView.frame) + ScaleW(5) + defaultInset.right), _title.font.lineHeight);
    _abstracts.frame = CGRectMake(CGRectGetMinX(_title.frame), CGRectGetMaxY(_title.frame) + defaultInset.top, CGRectGetWidth(_title.frame), _abstracts.font.lineHeight * 2);
    _createTime.frame = CGRectMake(CGRectGetMinX(_title.frame), CGRectGetMaxY(_headImageView.frame) - _createTime.font.lineHeight, CGRectGetWidth(_title.frame), _createTime.font.lineHeight);
}

- (void)setDatas:(id)datas;
{
    
    NSString *topImg = datas[@"topimg"];
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:topImg] placeholderImage:[UIImage imageNamed:@"bk_1_1.png"]];
    

    NSString *title = [Base64 textFromBase64String:datas[@"newstitle"]];
    NSString *abstracts = [Base64 textFromBase64String:datas[@"abstracts"]];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[dateFormatter dateFromString:datas[@"pretime"]];
    NSString *createTime = [NSObject compareCurrentTimeToPastTime:date];
    
    _title.text = title;
    _abstracts.text = abstracts;
    _createTime.text = createTime;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
