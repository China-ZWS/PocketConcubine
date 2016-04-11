//
//  AdressPickerView.h
//  PocketConcubine
//
//  Created by 周文松 on 15-5-25.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressPickerView : UIView
{
}
- (id)initWithAddress:(void(^)(NSString *address))address target:(id)target;

@end
