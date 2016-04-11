//
//  GuideViewController.h
//  PocketConcubine
//
//  Created by 周文松 on 15/8/1.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import <UIKit/UIKit.h> 

@protocol GuideViewControllerDelegate <NSObject>

- (void)changeViewController;

@end
@interface GuideViewController : UIViewController
@property (nonatomic, weak) id<GuideViewControllerDelegate>delegate;
@end
