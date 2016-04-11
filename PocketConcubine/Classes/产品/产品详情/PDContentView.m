
//
//  PDContentView.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-17.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "PDContentView.h"

@implementation PDContentView

- (void)drawRect:(CGRect)rect
{
    if (_datas)
    {
        [self drawWithChamferOfRectangle:CGRectMake(0, 0, CGRectGetWidth(rect), ScaleH(30)) inset:UIEdgeInsetsMake(0, 0, 0, 0) radius:0 lineWidth:.3 lineColor:CustomAlphaBlue  backgroundColor:CustomAlphaBlue];
    }
}



- (id)initWithFrame:(CGRect)frame finishOffset:(void(^)())finishOffset;
{
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor clearColor];
        _title = [UILabel new];
        _title.font = FontBold(15);
        _title.textColor = CustomDarkPurple;
        _title.backgroundColor = [UIColor clearColor];
        [self addSubview:_title];
        _finishOffset = finishOffset;

    }
    return self;
}

- (void)setDatas:(id)datas
{
    _datas = datas;
    _title.frame = CGRectMake(defaultInset.left + ScaleW(15), (ScaleH(30) - _title.font.lineHeight) / 2, CGRectGetWidth(self.frame) - ScaleW(30) - defaultInset.left - defaultInset.right, _title.font.lineHeight);
    _title.text = [[Base64 textFromBase64String:datas[@"protitle"]] stringByAppendingString:@" 代理"];
    [self setNeedsDisplay];
    _finishOffset();
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
