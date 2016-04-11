//
//  CPInputView.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-24.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "CPInputView.h"

@implementation CPInputView

- (id)initWithFrame:(CGRect)frame success:(void (^)())success
{
    if ((self = [super initWithFrame:frame success:success]))
    {
        [self layoutViews];
    }
    return self;
}

- (PJTextField *)opws
{
    if (!_opws)
    {
        _opws = [[PJTextField alloc] initWithFrame:CGRectMake(defaultInset.left,ScaleH(20), DeviceW - defaultInset.left * 2, ScaleH(45))];
        _opws.placeholder = @"旧密码";
        _opws.returnKeyType = UIReturnKeyNext;
        _opws.delegate = self;
        _opws.font = Font(15);
        _opws.font = Font(15);
    }
    return _opws;
}

- (PJTextField *)npws
{
    if (!_npws)
    {
        _npws = [[PJTextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(_opws.frame),CGRectGetMaxY(_opws.frame) + ScaleH(10), CGRectGetWidth(_opws.frame), ScaleH(45))];
        _npws.delegate = self;
        _npws.placeholder = @"新密码";
        _npws.returnKeyType = UIReturnKeyNext;
        [_npws setKeyboardType:UIKeyboardTypeDefault];
        _npws.font = Font(15);
    }
    return _npws;
}

- (PJTextField *)renpws
{
    if (!_renpws)
    {
        _renpws = [[PJTextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(_npws.frame),CGRectGetMaxY(_npws.frame) + ScaleH(10), CGRectGetWidth(_opws.frame), ScaleH(45))];
        _renpws.delegate = self;
        _renpws.placeholder = @"确定密码";
        _renpws.returnKeyType = UIReturnKeyGo;
        [_renpws setKeyboardType:UIKeyboardTypeDefault];
        _renpws.font = Font(15);
    }
    return _renpws;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    if ([textField isEqual:_opws])
    {
        [textField resignFirstResponder];
        [_npws becomeFirstResponder];
    }
    else if ([textField isEqual:_npws])
    {
        [textField resignFirstResponder];
        [_renpws becomeFirstResponder];
    }
    else if ([textField isEqual:_renpws])
    {
        [textField resignFirstResponder];
        _success();
    }
    return YES;
}

- (void)layoutViews
{
    [self addSubview:self.opws];
    [self addSubview:self.npws];
    [self addSubview:self.renpws];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
