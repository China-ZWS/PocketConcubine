//
//  ReguserInputView.h
//  PocketConcubine
//
//  Created by 周文松 on 15-5-24.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "BaseInputView.h"
#import "PJTextField.h"
@interface ReguserInputView : BaseInputView


@property (nonatomic, strong) PJTextField *nameField;
@property (nonatomic, strong) PJTextField *passwordField;
@property (nonatomic, strong) PJTextField *rePasswordField;
//@property (nonatomic, strong) PJTextField *idCaredField;
//@property (nonatomic, strong) PJTextField *sexField;
@property (nonatomic, strong) PJTextField *phoneNumField;
@property (nonatomic, strong) PJTextField *mailField;
@property (nonatomic, strong) PJTextField *wechatField;
//@property (nonatomic, strong) PJTextField *addressField;

@end
