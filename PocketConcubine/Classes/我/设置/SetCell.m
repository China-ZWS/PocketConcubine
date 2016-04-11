
//
//  SetCell.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-15.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "SetCell.h"

@implementation SetCell
- (void)drawRect:(CGRect)rect
{
//    [self drawRectWithLine:rect start:CGPointMake(0, CGRectGetHeight(rect) - .3) end:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect) - .3) lineColor:CustomGray lineWidth:.3];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        self.textLabel.font = Font(15);
//        self.detailTextLabel.font = Font(13);
//        self.detailTextLabel.textColor = CustomGray;
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    
//    for (UIView *subview in self.contentView.superview.subviews) {
//       
//        if ([NSStringFromClass(subview.class) hasSuffix:@"SeparatorView"]) {
//            subview.hidden = NO;
//        }
//    }
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
