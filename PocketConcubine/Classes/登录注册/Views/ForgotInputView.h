//
//  ForgotInputView.h
//  PocketConcubine
//
//  Created by 周文松 on 15-5-25.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "BaseInputView.h"
#import "PJTextField.h"

@interface ForgotInputView : BaseInputView

@property (nonatomic, strong) PJTextField *phoneNumField;
@property (nonatomic, strong) PJTextField *mailField;
@end
