//
//  ForgotInputView.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-25.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "ForgotInputView.h"

@implementation ForgotInputView

- (id)initWithFrame:(CGRect)frame success:(void(^)())success;
{
    if ((self = [super initWithFrame:frame success:success]))
    {
        [self layoutViews];
    }
    return self;
}

- (PJTextField *)phoneNumField
{
    if (!_phoneNumField)
    {
        _phoneNumField = [[PJTextField alloc] initWithFrame:CGRectMake(defaultInset.left, ScaleH(20), DeviceW - defaultInset.left * 2, ScaleH(45))];
        _phoneNumField.placeholder = @"注册时所填的手机号码（必填）";
        _phoneNumField.delegate = self;
        _phoneNumField.font = Font(15);
        _phoneNumField.returnKeyType = UIReturnKeyNext;
        _phoneNumField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _phoneNumField;
}

- (PJTextField *)mailField
{
    if (!_mailField)
    {
        _mailField = [[PJTextField alloc] initWithFrame:CGRectMake(defaultInset.left, CGRectGetMaxY(_phoneNumField.frame) + ScaleH(10), DeviceW - defaultInset.left * 2, ScaleH(45))];
        _mailField.placeholder = @"注册时所填的邮箱（必填）";
        _mailField.delegate = self;
        _mailField.font = Font(15);
        _mailField.returnKeyType = UIReturnKeyNext;
        _mailField.keyboardType = UIKeyboardTypeEmailAddress;
    }
    return _mailField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    if ([textField isEqual:_phoneNumField])
    {
        [_phoneNumField resignFirstResponder];
        [_mailField becomeFirstResponder];
    }
    else if ([textField isEqual:_mailField])
    {
        [textField resignFirstResponder];
        _success();
    }
        
    return YES;
}



- (void)layoutViews
{
    [self addSubview:self.phoneNumField];
    [self addSubview:self.mailField];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
