
//
//  QRcodeView.m
//  PocketConcubine
//
//  Created by 周文松 on 15/8/5.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "QRcodeView.h"

@implementation QRcodeView
- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat minX, minY, maxX, maxY;
    CGContextSetStrokeColorWithColor(context, RGBA(210, 210, 210, 1).CGColor);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, .3);
    
    
    minX = CGRectGetMinX(rect) + 10;
    minY = CGRectGetMinY(rect) + 10;
    maxX = CGRectGetMaxX(rect) - 10;
    maxY = CGRectGetMaxY(rect) - 10;
    UIBezierPath *            path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(minX, minY, maxX - minX, maxY - minY) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(3, 3)];
    [path stroke];
    [path fill];
    [path closePath];
    
    
    [self drawRectWithLine:rect start:CGPointMake(ScaleW(5) + 10, ScaleH(44) + 10) end:CGPointMake(CGRectGetWidth(rect) - ScaleW(5) - 10, ScaleH(44) + 10) lineColor:CustomGray lineWidth:.3];
    
    NSString *text = @"扫描二维码支付";
    CGSize size = [NSObject getSizeWithText:text font:FontBold(17) maxSize:CGSizeMake(MAXFLOAT, FontBold(17).lineHeight)];
    [self drawTextWithText:text rect:CGRectMake((CGRectGetWidth(rect) - size.width) / 2, 10 + (ScaleH(44) - size.height) / 2, size.width, size.height) color:CustomBlack font:FontBold(17)];
    
    UIImage *weima = [UIImage imageNamed:@"weima.png"];
    [weima drawInRect:CGRectMake(20, 20 + ScaleH(44), CGRectGetWidth(rect) - 40, CGRectGetWidth(rect) - 40)];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
