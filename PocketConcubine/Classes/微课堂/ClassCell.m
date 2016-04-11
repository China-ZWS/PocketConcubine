
//
//  ClassCell.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-16.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "ClassCell.h"

@implementation ClassCell

- (void)drawRect:(CGRect)rect
{
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    {
        _headImageView = [UIImageView new];
        _title = [UILabel new];
        _title.textColor = CustomBlack;
        _title.numberOfLines = 2;
        _title.font = FontBold(17);
        _num = [UIButton buttonWithType:UIButtonTypeCustom];
        _num.titleLabel.font = Font(15);
        [_num setTitleColor:CustomGray forState:UIControlStateNormal];

        _date = [UIButton buttonWithType:UIButtonTypeCustom];
        _date.titleLabel.font = Font(15);
        [_date setTitleColor:CustomGray forState:UIControlStateNormal];

        [self.contentView addSubview:_headImageView];
        [self.contentView addSubview:_title];
        [self.contentView addSubview:_num];
        [self.contentView addSubview:_date];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    

}

- (void)setDatas:(id)datas
{
    NSString *imageStr = datas[@"backimg"];
    NSString *title = [Base64 textFromBase64String:datas[@"protitle"]];
    NSString *sum = datas[@"sum"];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[dateFormatter dateFromString:datas[@"pretime"]];
    NSString *createTime = [NSObject compareCurrentTimeToPastTime:date];
    CGSize dateSize = [NSObject getSizeWithText:createTime font:_date.titleLabel.font maxSize:CGSizeMake(200, _date.titleLabel.font.lineHeight)];
    
    
    
    _headImageView.frame = CGRectMake(defaultInset.left + ScaleW(5), defaultInset.top * 2, ScaleH(80) * kTop2Scale, ScaleH(80));
    
    CGSize titleSize = [NSObject getSizeWithText:title font:_title.font maxSize:CGSizeMake( DeviceW - (CGRectGetMaxX(_headImageView.frame) + ScaleW(5) + defaultInset.right), _title.font.lineHeight * 2)];
    _title.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + ScaleW(5), CGRectGetMinY(_headImageView.frame), titleSize.width, titleSize.height);

    [_headImageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"bk_3_2.png"]];
   
    _title.text = title;
    
    UIImage *numImg = [UIImage imageNamed:@"icon_people.png"];
    UIImage *dateImg = [UIImage imageNamed:@"icon_time.png"];
    _num.frame = CGRectMake(CGRectGetMinX(_title.frame), CGRectGetMaxY(_headImageView.frame) - ScaleH(35) + (ScaleH(35) - numImg.size.height) / 2 , ScaleW(50), ScaleH(35));
    _num.backgroundColor = [UIColor clearColor];
    [_num setImage:numImg forState:UIControlStateNormal];
    [_num setTitle:sum forState:UIControlStateNormal];
    _num.imageEdgeInsets = UIEdgeInsetsMake(0,0,0,2.5);
    _num.titleEdgeInsets = UIEdgeInsetsMake(0,2.5,0,0);

    
    _date.frame = CGRectMake(CGRectGetMaxX(_title.frame) - (dateImg.size.width + ScaleW(5) + dateSize.width + ScaleW(10)), CGRectGetMinY(_num.frame), dateImg.size.width + ScaleW(5) + dateSize.width + ScaleW(10), CGRectGetHeight(_num.frame));
    [_date setImage:dateImg forState:UIControlStateNormal];
    [_date setTitle:createTime forState:UIControlStateNormal];
    _date.imageEdgeInsets = UIEdgeInsetsMake(0,0,0,2.5);
    _date.titleEdgeInsets = UIEdgeInsetsMake(0,2.5,0,0);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


//    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:title];
//    NSMutableParagraphStyle * style = [NSMutableParagraphStyle new];
////    style.headIndent = 50;//头部缩进，相当于左padding
////    style.tailIndent = -50;//相当于右padding
//    style.firstLineHeadIndent = ScaleW(15);//首行头缩进
//    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, title.length)];
//    _title.attributedText = attrString;


@end
