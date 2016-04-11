//
//  AgentInputView.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-25.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "SetAgentInputView.h"
#import "AddressPickerView.h"

@implementation SetAgentInputView

- (id)initWithFrame:(CGRect)frame success:(void(^)())success;
{
    if ((self = [super initWithFrame:frame success:success]))
    {
        [self layoutViews];
    }
    return self;
}

- (UILabel *)name
{
    if (!_name) {
        _name = [[UILabel alloc] initWithFrame:CGRectMake(0, ScaleY(20), DeviceW / 3, ScaleH(60))];
        _name.font = FontBold(15);
        _name.backgroundColor = [UIColor clearColor];
        _name.textColor = CustomBlack;
        _name.text = @"上级代理商名字：";
        _name.numberOfLines = 0;
        _name.textAlignment = NSTextAlignmentRight;
    }
    return _name;
}

- (UILabel *)phoneNum
{
    if (!_phoneNum) {
        _phoneNum = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_name.frame), DeviceW / 3, ScaleH(60))];
        _phoneNum.font = FontBold(15);
        _phoneNum.backgroundColor = [UIColor clearColor];
        _phoneNum.textColor = CustomBlack;
        _phoneNum.numberOfLines = 0;
        _phoneNum.text = @"上级代理商电话：";
        _phoneNum.textAlignment = NSTextAlignmentRight;
    }
    return _phoneNum;
}


- (UILabel *)address
{
    if (!_address) {
        _address = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_phoneNum.frame), DeviceW / 3, ScaleH(60))];
        _address.font = FontBold(15);
        _address.numberOfLines = 0;
        _address.backgroundColor = [UIColor clearColor];
        _address.textColor = CustomBlack;
        _address.text = @"所在地：";
        _address.textAlignment = NSTextAlignmentRight;
    }
    return _address;
}


- (UILabel *)mark
{
    if (!_mark) {
        _mark = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_address.frame), DeviceW / 3, ScaleH(60))];
        _mark.backgroundColor = [UIColor clearColor];
        _mark.font = FontBold(15);
        _mark.textColor = CustomBlack;
        _mark.text = @"备注：";
        _mark.textAlignment = NSTextAlignmentRight;
    }
    return _mark;
}



- (void)layoutViews
{
    [self addSubview:self.name];
    [self addSubview:self.phoneNum];
    [self addSubview:self.address];
    [self addSubview:self.mark];
    
    [self addSubview:self.nameField];
    [self addSubview:self.phoneNumField];
    [self addSubview:self.addressField];
    [self addSubview:self.markField];
}

- (BaseTextField *)nameField
{
    if (!_nameField)
    {
        _nameField = [[BaseTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_name.frame), CGRectGetMinY(_name.frame) + (ScaleH(60) - ScaleH(50)) / 2, DeviceW -  DeviceW / 3 - ScaleW(15) * 2, ScaleH(50))];
        _nameField.placeholder = @"姓名（必填）";
        _nameField.delegate = self;
        _nameField.font = Font(15);
        _nameField.returnKeyType = UIReturnKeyNext;
        _nameField.keyboardType = UIKeyboardTypeNamePhonePad;
        [_nameField getCornerRadius:ScaleH(3) borderColor:CustomGray borderWidth:1 masksToBounds:YES];
    }
    return _nameField;
}

- (BaseTextField *)phoneNumField
{
    if (!_phoneNumField)
    {
        _phoneNumField = [[BaseTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_phoneNum.frame), CGRectGetMinY(_phoneNum.frame) + (ScaleH(60) - ScaleH(50)) / 2, DeviceW -  DeviceW / 3 - ScaleW(15) * 2, ScaleH(50))];
        _phoneNumField.placeholder = @"联系方式（必填）";
        _phoneNumField.delegate = self;
        _phoneNumField.font = Font(15);
        _phoneNumField.returnKeyType = UIReturnKeyNext;
        _phoneNumField.keyboardType = UIKeyboardTypeNumberPad;
        [_phoneNumField getCornerRadius:ScaleH(3) borderColor:CustomGray borderWidth:1 masksToBounds:YES];
    }
    return _phoneNumField;
}

- (BaseTextField *)addressField
{
    if (!_addressField)
    {
        _addressField = [[BaseTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_address.frame), CGRectGetMinY(_address.frame) + (ScaleH(60) - ScaleH(50)) / 2, DeviceW -  DeviceW / 3 - ScaleW(15) * 2, ScaleH(50))];
        _addressField.placeholder = @"省份-城市（必填）";
        _addressField.delegate = self;
        _addressField.font = Font(15);
        _addressField.returnKeyType = UIReturnKeyDone;
        _addressField.keyboardType = UIKeyboardTypeNamePhonePad;
        [_addressField getCornerRadius:ScaleH(3) borderColor:CustomGray borderWidth:1 masksToBounds:YES];
    }
    return _addressField;
}

- (BaseTextView *)markField
{
    if (!_markField)
    {
        _markField = [[BaseTextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_mark.frame), CGRectGetMinY(_mark.frame) + (ScaleH(60) - ScaleH(50)) / 2, DeviceW -  DeviceW / 3 - ScaleW(15) * 2, ScaleH(120))];
        _markField.font = Font(15);
        _markField.delegate = self;
        _markField.returnKeyType = UIReturnKeyGo;
        _markField.keyboardType = UIKeyboardTypeNamePhonePad;
        [_markField getCornerRadius:ScaleH(3) borderColor:CustomGray borderWidth:1 masksToBounds:YES];
    }
    return _markField;
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    if ([textField isEqual:_nameField])
    {
        [_nameField resignFirstResponder];
        [_phoneNumField becomeFirstResponder];
    }
    else if ([textField isEqual:_phoneNumField])
    {
        [textField resignFirstResponder];
        [_addressField becomeFirstResponder];
    }
    
    return YES;
}



- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [super textFieldDidBeginEditing:textField];
    
    if ([textField isEqual:_addressField])
    {
        textField.inputView=[[AddressPickerView alloc] initWithAddress:^(NSString *address)
                             {
                                 _addressField.text = address;
                             }target:self];
        textField.inputAccessoryView = nil;
    }
}

- (void)setEdit:(BOOL)edit
{
    if (!edit)
    {
        _nameField.enabled = NO;
        _phoneNumField.enabled = NO;
        _addressField.enabled = NO;
        _markField.userInteractionEnabled = NO;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
