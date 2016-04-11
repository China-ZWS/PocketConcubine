//
//  LoginInputView.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-8.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "LoginInputView.h"
#define loginAndInputWithInsetHeight ScaleH(70)
#define inputHeight ScaleH(110)
@implementation LoginInputView

- (void)drawRect:(CGRect)rect
{
    NSString *text = @"赢销商学院";
    CGSize textSize = [NSObject getSizeWithText:text font:FontBold(22) maxSize:CGSizeMake(200,30)];
    
    [self drawTextWithText:text rect:CGRectMake((CGRectGetWidth(rect) - textSize.width) / 2, (loginAndInputWithInsetHeight - textSize.height) / 2, textSize.width, textSize.height) color:[UIColor whiteColor] font:FontBold(22)];
    
    [self drawWithChamferOfRectangle:CGRectMake(0, loginAndInputWithInsetHeight, CGRectGetWidth(rect), inputHeight) inset:UIEdgeInsetsZero radius:ScaleH(5) lineWidth:1 lineColor:CustomGray  backgroundColor:[UIColor whiteColor]];
    
    [self drawRectWithLine:rect start:CGPointMake(0, loginAndInputWithInsetHeight + inputHeight / 2 - .5) end:CGPointMake(CGRectGetWidth(rect) , loginAndInputWithInsetHeight + inputHeight / 2 - .5) lineColor:CustomGray lineWidth:1];
}

- (id)initWithlogin:(void(^)())login;
{
    if ((self = [super initWithFrame:CGRectMake(ScaleX(20), ScaleY(30), DeviceW - ScaleX(20) * 2, inputHeight + loginAndInputWithInsetHeight)])) {
        self.backgroundColor = [UIColor clearColor];
        _login = login;
        [self layoutViews];
    }
    return self;
    
}

- (void)layoutViews
{
    
    CGFloat const fieldHight = ScaleH(50);
    CGFloat const fieldWidht = CGRectGetWidth(self.frame)  - ScaleW(20);
    _accountField = [[BaseTextField alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - fieldWidht) / 2, loginAndInputWithInsetHeight + (inputHeight / 2 - fieldHight) / 2, fieldWidht, fieldHight)];
    _accountField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_users.png"]];
    _accountField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"NAME 邮箱/手机号" attributes:@{NSForegroundColorAttributeName:CustomGray}];
    _accountField.keyboardType = UIKeyboardTypeNumberPad;
    _accountField.delegate = self;
    _accountField.textColor = [UIColor blackColor];
    _accountField.font = Font(15);
    _accountField.text = @"18569530609";
    
    [self addSubview:_accountField];
    
    _pwdField = [[BaseTextField alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - fieldWidht) / 2, loginAndInputWithInsetHeight + inputHeight / 2 + (inputHeight / 2 - fieldHight) / 2, fieldWidht, fieldHight)];
    _pwdField.delegate = self;
    _pwdField.textColor = [UIColor blackColor];
    _pwdField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_password.png"]];
    _pwdField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"PAWSSWORD 密码" attributes:@{NSForegroundColorAttributeName:CustomGray}];
    _pwdField.font = Font(15);
    _pwdField.secureTextEntry = YES;
    _pwdField.returnKeyType = UIReturnKeyGo;
    [_pwdField setKeyboardType:UIKeyboardTypeDefault];
    _pwdField.text = @"222222";
    [self addSubview:_pwdField];
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [textField resignFirstResponder];
    if ([textField isEqual:_accountField])
    {
        [_pwdField becomeFirstResponder];
    }
    else
    {
        _login();
    }
    return YES;
}// called whe

//- (void)didMoveToWindow
//{
//
//}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
