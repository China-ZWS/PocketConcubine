//
//  ActivityInputView.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-14.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "ActivityInputView.h"

@implementation ActivityInputView



- (id)initWithFrame:(CGRect)frame success:(void (^)())success
{
    if ((self = [super initWithFrame:frame success:success])) {
        [self layoutViews];
    }
    
    return self;
}



- (void)layoutViews
{
//    [self addSubview:self.name];
//    [self addSubview:self.numOfpeople];
//    [self addSubview:self.phoneNum];
//    [self addSubview:self.mark];
    
    [self addSubview:self.nameField];
    [self addSubview:self.numOfpeopleField];
    [self addSubview:self.phoneNumField];
    [self addSubview:self.markField];
}


//- (UILabel *)name
//{
//    if (!_name) {
//        _name = [[UILabel alloc] initWithFrame:CGRectMake(ScaleX(5), ScaleY(20), DeviceW / 3.5, ScaleH(60))];
//        _name.font = FontBold(15);
//        _name.backgroundColor = [UIColor clearColor];
//        _name.textColor = CustomBlack;
//        _name.text = @"参加人姓名：";
//        _name.textAlignment = NSTextAlignmentRight;
//    }
//    return _name;
//}
//
//- (UILabel *)numOfpeople
//{
//    if (!_numOfpeople)
//    {
//        _numOfpeople = [[UILabel alloc] initWithFrame:CGRectMake(defaultInset.left, CGRectGetMaxY(_name.frame), DeviceW / 3.5, ScaleH(45))];
//        _numOfpeople.font = FontBold(15);
//        _numOfpeople.backgroundColor = [UIColor clearColor];
//        _numOfpeople.textColor = CustomBlack;
//        _numOfpeople.text = @"参加人数：";
//        _numOfpeople.textAlignment = NSTextAlignmentRight;
//    }
//    return _numOfpeople;
//}
//
//- (UILabel *)phoneNum
//{
//    if (!_phoneNum) {
//        _phoneNum = [[UILabel alloc] initWithFrame:CGRectMake(ScaleX(5), CGRectGetMaxY(_numOfpeople.frame), DeviceW / 3.5, ScaleH(45))];
//        _phoneNum.backgroundColor = [UIColor clearColor];
//        _phoneNum.font = FontBold(15);
//        _phoneNum.textColor = CustomBlack;
//        _phoneNum.text = @"联系电话：";
//        _phoneNum.textAlignment = NSTextAlignmentRight;
//    }
//    return _phoneNum;
//}
//
//- (UILabel *)mark
//{
//    if (!_mark) {
//        _mark = [[UILabel alloc] initWithFrame:CGRectMake(ScaleX(5), CGRectGetMaxY(_phoneNum.frame), DeviceW / 3.5, ScaleH(45))];
//        _mark.backgroundColor = [UIColor clearColor];
//        _mark.font = FontBold(15);
//        _mark.textColor = CustomBlack;
//        _mark.text = @"备注：";
//        _mark.textAlignment = NSTextAlignmentRight;
//    }
//    return _mark;
//}

- (PJTextField *)nameField
{
    if (!_nameField)
    {
        _nameField = [[PJTextField alloc] initWithFrame:CGRectMake(defaultInset.left, ScaleH(20), DeviceW -  defaultInset.left * 2, ScaleH(45))];
        _nameField.placeholder = @"姓名（必填）";
        _nameField.delegate = self;
        _nameField.font = Font(15);
        _nameField.returnKeyType = UIReturnKeyNext;
        _nameField.keyboardType = UIKeyboardTypeNamePhonePad;
    }
    return _nameField;
}

- (PJTextField *)numOfpeopleField
{
    if (!_numOfpeopleField)
    {
        _numOfpeopleField = [[PJTextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(_nameField.frame),CGRectGetMaxY(_nameField.frame) + defaultInset.top, CGRectGetWidth(_nameField.frame), ScaleH(45))];
        _numOfpeopleField.placeholder = @"人数（必填）";
        _numOfpeopleField.delegate = self;
        _numOfpeopleField.font = Font(15);
        _numOfpeopleField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _numOfpeopleField;
}

- (BaseTextField *)phoneNumField
{
    if (!_phoneNumField)
    {
        _phoneNumField = [[PJTextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(_numOfpeopleField.frame),CGRectGetMaxY(_numOfpeopleField.frame) + defaultInset.top, CGRectGetWidth(_numOfpeopleField.frame), ScaleH(50))];
        _phoneNumField.delegate = self;
        _phoneNumField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneNumField.placeholder = @"联系电话（必填）";
        _phoneNumField.font = Font(15);
    }
    return _phoneNumField;
}

- (PJTextView *)markField
{
    if (!_markField)
    {
        _markField = [[PJTextView  alloc] initWithFrame:CGRectMake(CGRectGetMinX(_phoneNumField.frame), CGRectGetMaxY(_phoneNumField.frame) + defaultInset.top * 2, CGRectGetWidth(_phoneNumField.frame), ScaleH(110))];
        _markField.font = Font(15);
        _markField.delegate = self;
        _markField.returnKeyType = UIReturnKeyGo;
        _markField.keyboardType = UIKeyboardTypeNamePhonePad;
    }
    return _markField;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    if ([textField isEqual:_nameField])
    {
        [textField resignFirstResponder];
        [_numOfpeopleField becomeFirstResponder];
    }
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
