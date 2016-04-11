//
//  IHTextBaseTextField.m
//  XFDesigners
//
//  Created by yaoyongping on 12-12-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IHTextBaseTextField.h"

@implementation IHTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [self setClearButtonMode:UITextFieldViewModeWhileEditing];
        UIView *v=[[UIView alloc] init];
        CGRect rect=v.frame;
        rect.size.height=20;
        [v setFrame:rect];
        
        UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(10, 0, 100, 20)];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [btn setImage:[UIImage imageNamed:@"jianpan"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"jianpan_action"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(hideKeyBoard:) forControlEvents:UIControlEventTouchUpInside];
        [v addSubview:btn];
        
        [self setInputAccessoryView:v];
        
        
        
        [self setLeftViewMode:UITextFieldViewModeAlways];
    }
    return self;
}
 -(void)hideKeyBoard:(id)sender{
    [self resignFirstResponder];
}

-(void)dealloc{
    NSLog(@"IHTextField dealloc");
}



/**
 *  @brief  控制清除按钮的位置
 *
 *  @param bounds 范围
 *
 *  @return 返回的范围
 */
/*
-(CGRect)clearButtonRectForBounds:(CGRect)bounds
{
    return CGRectMake( bounds.size.width - 30, (bounds.size.height - 18 ) / 2 - 2, 18, 18);
}
*/


/**
 *  @brief  控制placeHolder的位置，左右缩20
 *
 *  @param bounds 范围
 *
 *  @return 返回的范围
 */
-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(CGRectGetMaxX(self.leftView.frame) + 10, bounds.origin.y, bounds.size.width - (CGRectGetMaxX(self.leftView.frame) + 10), bounds.size.height);//更好理解些
    return inset;

}

/**
 *  @brief  控制显示文本的位置
 *
 *  @param bounds 范围
 *
 *  @return 返回的范围
 */
-(CGRect)textRectForBounds:(CGRect)bounds
{
    //return CGRectInset(bounds, 50, 0);
    CGRect inset = CGRectMake(CGRectGetMaxX(self.leftView.frame) + 10, bounds.origin.y , bounds.size.width - (CGRectGetMaxX(self.leftView.frame) + 10) - 30, bounds.size.height);//更好理解些
    
    return inset;
    
}


/**
 *  @brief  控制编辑文本的位置
 *
 *  @param bounds 范围
 *
 *  @return 返回的范围
 */
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    
    CGRect inset = CGRectMake(CGRectGetMaxX(self.leftView.frame) + 10, bounds.origin.y, bounds.size.width - (CGRectGetMaxX(self.leftView.frame) + 10) - 30, bounds.size.height);
    return inset;
}

/**
 *  @brief  控制左视图位置
 *
 *  @param bounds 范围
 *
 *  @return 返回的范围
 */
/*
- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x + 5, bounds.origin.y, self.leftView.frame.size.width, self.leftView.frame.size.height);
    return inset;
}
 */

//控制placeHolder的颜色、字体
//- (void)drawPlaceholderInRect:(CGRect)rect
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1].CGColor);
//    
//    [[self placeholder] drawInRect:rect withFont:[UIFont systemFontOfSize:16]];
//}
//



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end

