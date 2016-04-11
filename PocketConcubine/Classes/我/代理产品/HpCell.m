//
//  HpCell.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-26.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "HpCell.h"

@implementation HpCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    {
        self.textLabel.font = FontBold(15);
        self.textLabel.textColor = CustomDarkPurple;
        self.detailTextLabel.font = Font(13);
       
        _textLb = [UILabel new];
        _textLb.font = Font(13);
        _textLb.textColor = CustomGray;
        [self.contentView addSubview:_textLb];
  }
    return self;
}

- (void)layoutSubviews
{
    
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(10, (ScaleH(70) - ScaleH(60)) / 2, ScaleW(60), ScaleH(60));
    //    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.origin.x =  ScaleW(60) + 20;
    textLabelFrame.origin.y = CGRectGetMidY(self.imageView.frame) - self.textLabel.font.lineHeight - ScaleH(3);
    self.textLabel.frame = textLabelFrame;
    
    _textLb.frame = CGRectMake(ScaleW(60) + 20, CGRectGetMidY(self.imageView.frame) + ScaleH(3), 100, _textLb.font.lineHeight);
    
    
    [self setSeparatorInset:UIEdgeInsetsMake(0, ScaleW(60) + 20, 0, 0)];
}

- (void)setDatas:(id)datas
{
    NSString *topImg = datas[@"topimg"];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topImg] placeholderImage:[UIImage imageNamed:@"bk_1_1.png"]];
    
    
    
    NSString *title = [Base64 textFromBase64String:datas[@"name"]];
    NSString *date = [datas[@"date"] componentsSeparatedByString:@" "][0];
    NSString *status = datas[@"status"];
    
    self.textLabel.text = title;
    self.textLb.text = date;
    
    switch ([status integerValue]) {
        case 0:
            self.detailTextLabel.text = @"审核被拒";
            self.detailTextLabel.textColor = [UIColor redColor];
            break;
        case 1:
            self.detailTextLabel.text = @"审核通过";
            self.detailTextLabel.textColor = CustomlightPurple;
            break;
        case 2:
            self.detailTextLabel.text = @"待审核";
            self.detailTextLabel.textColor = CustomPink;
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
