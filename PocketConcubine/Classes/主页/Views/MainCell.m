//
//  MainCell.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-4.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "MainCell.h"

@implementation MainCell

- (void)drawRect:(CGRect)rect
{
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    {
        _headImageView = [UIImageView new];
        _title = [UILabel new];
        _title.font = FontBold(15);
//        _title.backgroundColor = CustomGreen;

        _contentLb = [UILabel new];
        _contentLb.textColor = CustomGray;
        _contentLb.font = Font(13);
        
        
        [self.contentView addSubview:_headImageView];
        [self.contentView addSubview:_title];
        [self.contentView addSubview:_contentLb];
    }
    return self;
}

- (void)setDatas:(NSDictionary *)datas type:(MainCellType)type;
{
    
    
    switch (type)
    {
        case kNews:
        {
            _title.textColor = CustomBlue;
            NSString *imageStr = datas[@"newImg"];
            NSString *title = [Base64 textFromBase64String:datas[@"newTitle"]];
            NSString *content = [Base64 textFromBase64String:datas[@"newContent"]];
            _headImageView.frame = CGRectMake(defaultInset.left, (ScaleH(80) - ScaleH(60)) / 2, ScaleH(60) * kTop2Scale, ScaleH(60));
            [_headImageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"bk_3_2.png"]];
            NSLog(@"%f",kTop2Scale);
            _title.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + defaultInset.left, CGRectGetMidY(_headImageView.frame) - _title.font.lineHeight - ScaleH(3), DeviceW - (CGRectGetMaxX(_headImageView.frame) + defaultInset.left  + defaultInset.right + ScaleW(40)), _title.font.lineHeight);
            _title.text = title;
            _contentLb.frame = CGRectMake(CGRectGetMinX(_title.frame), CGRectGetMidY(_headImageView.frame) + ScaleH(3), CGRectGetWidth(_title.frame), _contentLb.font.lineHeight);
            _contentLb.text = content;
            
            UIButton *apply = [UIButton buttonWithType:UIButtonTypeCustom];
             apply.frame = CGRectMake(CGRectGetMaxX(_contentLb.frame) + defaultInset.left, (ScaleH(80) - ScaleH(40)) / 2, ScaleW(40), ScaleH(40));
            apply.backgroundColor = [UIColor clearColor];
            [apply setImage:[UIImage imageNamed:@"icon_broadcast.png"] forState:UIControlStateNormal];
            self.accessoryView = apply;
     
        }
            break;
        case kActivitys:
        {
            _title.textColor = CustomBlack;
            NSString *imageStr = datas[@"activityImg"];
            NSString *title = [Base64 textFromBase64String:datas[@"activityTitle"]];
            NSString *content = [Base64 textFromBase64String:datas[@"activityContent"]];

            
            _headImageView.frame = CGRectMake(defaultInset.left, (ScaleH(60) - ScaleH(50)) / 2, ScaleH(50), ScaleH(50));
            [_headImageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"bk_1_1.png"]];
//            _headImageView.layer.masksToBounds =YES;
//            _headImageView.layer.cornerRadius = 25;
            

            _title.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + defaultInset.left / 2, CGRectGetMidY(_headImageView.frame) - _title.font.lineHeight - ScaleH(3), DeviceW - (CGRectGetMaxX(_headImageView.frame) + defaultInset.left + defaultInset.right + ScaleW(60)), _title.font.lineHeight);
            _title.text = title;
            _contentLb.frame = CGRectMake(CGRectGetMinX(_title.frame), CGRectGetMidY(_headImageView.frame) + ScaleH(3), CGRectGetWidth(_title.frame), _contentLb.font.lineHeight);
           
            _contentLb.text = content;
            
            
            UIButton *apply = [UIButton buttonWithType:UIButtonTypeCustom];
            apply.frame = CGRectMake(CGRectGetMaxX(_contentLb.frame) + defaultInset.left, (ScaleH(60) - ScaleH(30)) / 2, ScaleW(60), ScaleH(30));
            [apply setTitle:@"报 名" forState:UIControlStateNormal];
            [apply setTitleColor:CustomBlue forState:UIControlStateNormal];
            [apply getCornerRadius:ScaleW(3) borderColor:CustomBlue borderWidth:1 masksToBounds:NO];
            apply.backgroundColor = [UIColor clearColor];
            apply.titleLabel.font = Font(13);
            self.accessoryView = apply;

        }
            break;
        default:
            break;
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
