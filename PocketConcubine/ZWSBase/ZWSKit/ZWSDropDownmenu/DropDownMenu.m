//
//  DropDownMenu.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-3-25.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "DropDownMenu.h"

@interface DropDownMenu ()
{
    UIView *_backgroundView;
    CGPoint _origin;
    NSInteger _numOfMenu;
}
@end

@implementation DropDownMenu


- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        CGSize screensize = [UIScreen mainScreen].bounds.size;
        _origin = frame.origin;
        [self layoutBackgroundView];
        
    }
    return self;
}


- (void)setDataSource:(id<DropDownMenuDataSource>)dataSource
{

}

- (void)setDelegate:(id<DropDownMenuDelegate>)delegate
{
    
}

#pragma mark - init support
- (CALayer *)createBgLayerWithColor:(UIColor *)color andPosition:(CGPoint)position {
    CALayer *layer = [CALayer layer];
    
    layer.position = position;
    layer.bounds = CGRectMake(0, 0, CGRectGetWidth(self.frame)/_numOfMenu, CGRectGetHeight(self.frame) - 1);
    layer.backgroundColor = color.CGColor;
    
    return layer;
}

- (CAShapeLayer *)createIndicatorWithColor:(UIColor *)color andPosition:(CGPoint)point {
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(8, 0)];
    [path addLineToPoint:CGPointMake(4, 5)];
    [path closePath];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.fillColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    
    CGPathRelease(bound);
    
    layer.position = point;
    
    return layer;
}

#pragma mark - 背景
- (void)layoutBackgroundView
{
    _backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _backgroundView.backgroundColor = [UIColor grayColor];
    _backgroundView.opaque = NO;
    UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
    [_backgroundView addGestureRecognizer:gesture];
}

- (void)backgroundTapped:(UITapGestureRecognizer *)paramSender
{
    
}
//#pragma mark - init method
//- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height {
//    CGSize screenSize = [UIScreen mainScreen].bounds.size;
//    self = [self initWithFrame:CGRectMake(origin.x, origin.y, screenSize.width, height)];
//    if ((self = super ini)) {
//        <#statements#>
//    }
//    if (self) {
//    }
//    return self;
//}
//

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
