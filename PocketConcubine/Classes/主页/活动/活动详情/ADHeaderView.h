//
//  ADHeaderView.h
//  PocketConcubine
//
//  Created by 周文松 on 15-5-11.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ActivityType)
{
    kForeshow = 0,  ///
    kNew = 1 << 0,///最新活动
};



@class ADHeaderView;

@protocol ADHeaderViewDelegate <NSObject>
@optional
- (void)timeOut:(ADHeaderView *)cell;
@end


@interface ADHeaderView : UIView
{
    void(^_addActivity)();
}
- (id)initWithFrame:(CGRect)frame addActivity:(void(^)())addActivity;
@property (nonatomic, assign) id<ADHeaderViewDelegate>delegate;
@property (nonatomic, strong) id datas;
@property (nonatomic, strong) UIImageView *topImgView;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *text;
@property (nonatomic) NSDate *fireDate;
@property (nonatomic) NSTimer *timer;
@property (nonatomic, strong) UIButton *option;
- (void)setDatas:(id)datas type:(ActivityType)type;

@end
