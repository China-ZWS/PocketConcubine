//
//  ActivityInputView.h
//  PocketConcubine
//
//  Created by 周文松 on 15-5-14.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PJTextField.h"
#import "PJTextView.h"
@interface ActivityInputView : BaseInputView


//@property (nonatomic, strong) UILabel *name;
//@property (nonatomic, strong) UILabel *numOfpeople;
//@property (nonatomic, strong) UILabel *phoneNum;
//@property (nonatomic, strong) UILabel *mark;

@property (nonatomic, strong) PJTextField *nameField;
@property (nonatomic, strong) PJTextField *numOfpeopleField;
@property (nonatomic, strong) PJTextField *phoneNumField;
@property (nonatomic, strong) PJTextView *markField;


@end
