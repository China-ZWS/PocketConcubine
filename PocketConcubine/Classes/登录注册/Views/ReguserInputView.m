//
//  ReguserInputView.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-24.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "ReguserInputView.h"
#import "AddressPickerView.h"

@protocol SexViewDelegate <NSObject>

- (void)set:(NSString *)type;

@end

@interface SexView : UIView
{
    UIButton *_manBtn;
    UIButton *_womanBtn;
}
@property (nonatomic, weak) id <SexViewDelegate> delegate;
@end

@implementation SexView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        
//        self.backgroundColor = [UIColor redColor];
        self.userInteractionEnabled = YES;
        [self layoutViews];
    }
    return self;
}


- (void)layoutViews
{
    _manBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _manBtn.frame = CGRectMake(0, 0, ScaleW(44), ScaleH(44));
    [_manBtn setImage:[UIImage imageNamed:@"icon_register_unCheck.png"] forState:UIControlStateNormal];
    [_manBtn setImage:[UIImage imageNamed:@"icon_register_Check.png"] forState:UIControlStateSelected];
    _manBtn.titleLabel.font = Font(15);
    [_manBtn setTitleColor:CustomGray forState:UIControlStateNormal];
    [_manBtn setTitle:@"男" forState:UIControlStateNormal];
    [_manBtn addTarget:self action:@selector(eventWithMan) forControlEvents:UIControlEventTouchUpInside];
    

    
    _womanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _womanBtn.frame = CGRectMake(CGRectGetWidth(self.frame) - ScaleW(44), 0, ScaleW(44), ScaleH(44));
    [_womanBtn setTitleColor:CustomGray forState:UIControlStateNormal];
    [_womanBtn setImage:[UIImage imageNamed:@"icon_register_unCheck.png"] forState:UIControlStateNormal];
    [_womanBtn setTitle:@"女" forState:UIControlStateNormal];
    _womanBtn.titleLabel.font = Font(15);
    [_womanBtn addTarget:self action:@selector(eventWithWoman) forControlEvents:UIControlEventTouchUpInside];
    [_womanBtn setImage:[UIImage imageNamed:@"icon_register_Check.png"] forState:UIControlStateSelected];
    
    
    [self addSubview:_manBtn];
    [self addSubview:_womanBtn];
    
    
    
}

- (void)eventWithMan
{
    if (_manBtn.selected) {
        return;
    }
    _manBtn.selected = !_manBtn.selected;
    _womanBtn.selected = !_manBtn.selected;
    
    if (_manBtn.selected) {
        [_delegate set:@"0"];
    }

 }

- (void)eventWithWoman
{
    if (_womanBtn.selected) {
        return;
    }
    _womanBtn.selected = !_womanBtn.selected;
    _manBtn.selected = !_womanBtn.selected;
    
    if (_womanBtn.selected) {
        [_delegate set:@"1"];
    }
}



@end

@interface ReguserInputView ()
<SexViewDelegate>
@end

@implementation ReguserInputView

- (id)initWithFrame:(CGRect)frame success:(void(^)())success;
{
    if ((self = [super initWithFrame:frame success:success]))
    {
        [self layoutViews];
    }
    return self;
}




- (void)layoutViews
{
    
    
    [self addSubview:self.nameField];
    [self addSubview:self.passwordField];
    [self addSubview:self.rePasswordField];
//    [self addSubview:self.idCaredField];
//    [self addSubview:self.sexField];
    [self addSubview:self.phoneNumField];
    [self addSubview:self.mailField];
    [self addSubview:self.wechatField];

}

- (PJTextField *)nameField
{
    if (!_nameField)
    {
        _nameField = [[PJTextField alloc] initWithFrame:CGRectMake(defaultInset.left, ScaleY(20), DeviceW - defaultInset.left * 2, ScaleH(45))];
        _nameField.placeholder = @"用户名（必填）";
        _nameField.delegate = self;
        _nameField.font = Font(17);
        _nameField.returnKeyType = UIReturnKeyNext;
        _nameField.keyboardType = UIKeyboardTypeNamePhonePad;
    }
    return _nameField;
}

- (PJTextField *)passwordField
{
    if (!_passwordField)
    {
        _passwordField = [[PJTextField alloc] initWithFrame:CGRectMake(defaultInset.left, CGRectGetMaxY(_nameField.frame) + ScaleH(10), DeviceW -  defaultInset.left * 2, ScaleH(45))];
        _passwordField.placeholder = @"登录密码（必填，6-11位）";
        _passwordField.delegate = self;
        _passwordField.font = Font(17);
        _passwordField.returnKeyType = UIReturnKeyNext;
        _passwordField.keyboardType = UIKeyboardTypeNamePhonePad;
    }
    return _passwordField;
}

- (PJTextField *)rePasswordField
{
    if (!_rePasswordField) {
        _rePasswordField = [[PJTextField alloc] initWithFrame:CGRectMake(defaultInset.left, CGRectGetMaxY(_passwordField.frame) + ScaleH(10), DeviceW - defaultInset.left * 2, ScaleH(45))];
        _rePasswordField.placeholder = @"确认密码（必填）";
        _rePasswordField.delegate = self;
        _rePasswordField.font = Font(17);
        _rePasswordField.returnKeyType = UIReturnKeyNext;
        _rePasswordField.keyboardType = UIKeyboardTypeNamePhonePad;
    }
    return _rePasswordField;
}


//- (PJTextField *)idCaredField
//{
//    if (!_idCaredField) {
//        _idCaredField = [[PJTextField alloc] initWithFrame:CGRectMake(defaultInset.left, CGRectGetMaxY(_rePasswordField.frame) + ScaleH(10), DeviceW - defaultInset.left * 2, ScaleH(45))];
//        _idCaredField.placeholder = @"身份证（必填）";
//        _idCaredField.delegate = self;
//        _idCaredField.font = Font(17);
//        _idCaredField.returnKeyType = UIReturnKeyNext;
//        _idCaredField.keyboardType = UIKeyboardTypePhonePad;
//    }
//    return _idCaredField;
//}
//
//
//- (PJTextField *)sexField
//{
//    if (!_sexField)
//    {
//        _sexField = [[PJTextField alloc] initWithFrame:CGRectMake(defaultInset.left, CGRectGetMaxY(_idCaredField.frame) + ScaleH(10), DeviceW - defaultInset.left * 2, ScaleH(45))];
//        _sexField.enabled = NO;
//        _sexField.placeholder = @"性别";
//        _sexField.delegate = self;
//        _sexField.font = Font(17);
//        _sexField.returnKeyType = UIReturnKeyNext;
//        _sexField.keyboardType = UIKeyboardTypeNamePhonePad;
//        SexView *sexView = [[SexView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_sexField.frame) - ScaleW(100), CGRectGetMinY(_sexField.frame) + (ScaleH(45) - ScaleH(44)) / 2, ScaleW(100), ScaleH(44))];
//        sexView.delegate = self;
//        [self addSubview:sexView];
////        _sexField.rightView = sexView;
////        _sexField.rightViewMode=UITextFieldViewModeAlways;
//    }
//    return _sexField;
//}

- (PJTextField *)phoneNumField
{
    if (!_phoneNumField)
    {
        _phoneNumField = [[PJTextField alloc] initWithFrame:CGRectMake(defaultInset.left, CGRectGetMaxY(_rePasswordField.frame) + ScaleH(10), DeviceW -  defaultInset.left * 2, ScaleH(45))];
        _phoneNumField.placeholder = @"手机号码（必填）";
        _phoneNumField.delegate = self;
        _phoneNumField.font = Font(17);
        _phoneNumField.returnKeyType = UIReturnKeyNext;
        _phoneNumField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _phoneNumField;
}

- (PJTextField *)mailField
{
    if (!_mailField)
    {
        _mailField = [[PJTextField alloc] initWithFrame:CGRectMake(defaultInset.left, CGRectGetMaxY(_phoneNumField.frame) + ScaleH(10), DeviceW -  defaultInset.left * 2, ScaleH(45))];
        _mailField.placeholder = @"邮箱（必填）";
        _mailField.delegate = self;
        _mailField.font = Font(17);
        _mailField.returnKeyType = UIReturnKeyNext;
        _mailField.keyboardType = UIKeyboardTypeEmailAddress;
    }
    return _mailField;
}


- (PJTextField *)wechatField
{
    if (!_wechatField)
    {
        _wechatField = [[PJTextField alloc] initWithFrame:CGRectMake(defaultInset.left, CGRectGetMaxY(_mailField.frame) + ScaleH(10), DeviceW -  defaultInset.left * 2, ScaleH(45))];
        _wechatField.placeholder = @"微信号码（必填）";
        _wechatField.delegate = self;
        _wechatField.font = Font(17);
        _wechatField.returnKeyType = UIReturnKeyNext;
        _wechatField.keyboardType = UIKeyboardTypeNamePhonePad;
    }
    return _wechatField;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    
    [textField resignFirstResponder];
    if ([textField isEqual:_nameField])
    {
        [_passwordField becomeFirstResponder];
    }
    else if ([textField isEqual:_passwordField])
    {
        [_rePasswordField becomeFirstResponder];
    }
    else if ([textField isEqual:_rePasswordField])
    {
    }
    else if ([textField isEqual:_phoneNumField])
    {
        [_mailField becomeFirstResponder];
    }
    else if ([textField isEqual:_mailField])
    {
        [_wechatField becomeFirstResponder];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [super textFieldDidBeginEditing:textField];
    
//    if ([textField isEqual:_sexField])
//    {
//        textField.inputView = [[SexPickerView alloc] initWithSex:^(NSString * sex)
//        {
//            _sexField.text = sex;
//            [self textFieldShouldReturn:_sexField];
//        }target:self];
//    }
//    else
    
//    if ([textField isEqual:_addressField])
//    {
//        textField.inputView=[[AddressPickerView alloc] initWithAddress:^(NSString *address)
//                             {
//                                 _addressField.text = address;
//                             }target:self];
//        textField.inputAccessoryView = nil;
//    }
}


//- (void)set:(NSString *)type
//{
//    _sexField.info = type;
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
