//
//  LoginInputView.h
//  PocketConcubine
//
//  Created by 周文松 on 15-5-8.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginInputView : UIView
<BaseTextFieldDelegate>
{
    void(^_login)();
}
@property (nonatomic, strong)BaseTextField *accountField;
@property (nonatomic, strong)BaseTextField *pwdField;


- (id)initWithlogin:(void(^)())login;

@end
