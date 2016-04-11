//
//  PJTextView.m
//  PocketConcubine
//
//  Created by 周文松 on 15/8/3.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "PJTextView.h"

@implementation PJTextView
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat minX, minY, maxX, maxY;
    CGContextSetStrokeColorWithColor(context, RGBA(210, 210, 210, 1).CGColor);
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextSetLineWidth(context, .3);
    
    
    minX = CGRectGetMinX(rect) + 1;
    minY = CGRectGetMinY(rect) + 1;
    maxX = CGRectGetMaxX(rect) - 1;
    maxY = CGRectGetMaxY(rect) - 1;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(minX, minY, maxX - minX, maxY - minY)];
    [path stroke];
    [path fill];
    [path closePath];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
