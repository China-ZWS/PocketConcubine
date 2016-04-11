//
//  ProductCell.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-16.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "ProductCell.h"
@implementation ProductCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        
        self.backgroundColor = [UIColor whiteColor];
        CGFloat titleHeight = FontBold(18).lineHeight; // 标题
        CGFloat contentHeigh = Font(15).lineHeight * 3; // 类容
        CGFloat inset = ScaleH(5);
        CGFloat allContentHeight = titleHeight + contentHeigh + inset;
        
        _headImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(defaultInset.left, defaultInset.top * 2, allContentHeight * kTop2Scale,  allContentHeight)];
        
        _title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headImageView.frame) + defaultInset.left, CGRectGetMinY(_headImageView.frame),DeviceW - CGRectGetMaxX(_headImageView.frame) - defaultInset.right - defaultInset.left, titleHeight)];
        _title.textColor = CustomBlue;
        _title.font = FontBold(18);
        _title.backgroundColor = [UIColor clearColor];
        
        _contentLb = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_title.frame), inset + CGRectGetMaxY(_title.frame), CGRectGetWidth(_title.frame), contentHeigh)];
        _contentLb.backgroundColor = [UIColor clearColor];
        _contentLb.textColor = CustomGray;
        _contentLb.font = Font(15);
        _contentLb.numberOfLines = 0;
        
        
        
        UIImage *image = [UIImage imageNamed:@"next.png"];
        _accView = [[UIImageView alloc] initWithFrame:CGRectMake(DeviceW - defaultInset.right - image.size.width, CGRectGetMinY(_textLb.frame) + (CGRectGetHeight(_textLb.frame) - image.size.height) / 2, image.size.width, image.size.height)];
        _accView.image = image;
        
        [self.contentView addSubview:_headImageView];
        [self.contentView addSubview:_title];
        [self.contentView addSubview:_contentLb];
        
    }
    return self;
}

- (void)setDatas:(id)datas
{
    NSString *imageStr = datas[@"backimg"];
    NSString *title = [Base64 textFromBase64String:datas[@"protitle"]];
    
    NSString *content = [Base64 textFromBase64String:datas[@"abstracts"]];
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"bk_3_2.png"]];
    _title.text = title;
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:content];
    NSMutableParagraphStyle * style = [NSMutableParagraphStyle new];
    //    style.headIndent = 50;//头部缩进，相当于左padding
    //    style.tailIndent = -50;//相当于右padding
    //    style.tailIndent = ScaleW(15);//首行头缩进
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, content.length)];
    _contentLb.attributedText = attrString;
    
    
    //    _contentLb.text = content;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end