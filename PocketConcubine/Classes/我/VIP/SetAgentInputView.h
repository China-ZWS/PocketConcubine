//
//  AgentInputView.h
//  PocketConcubine
//
//  Created by 周文松 on 15-5-25.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "BaseInputView.h"

@interface SetAgentInputView : BaseInputView
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *phoneNum;
@property (nonatomic, strong) UILabel *address;
@property (nonatomic, strong) UILabel *mark;

@property (nonatomic, strong) BaseTextField *nameField;
@property (nonatomic, strong) BaseTextField *phoneNumField;
@property (nonatomic, strong) BaseTextField *addressField;
@property (nonatomic, strong) BaseTextView *markField;
@property (nonatomic) BOOL edit;
@end
