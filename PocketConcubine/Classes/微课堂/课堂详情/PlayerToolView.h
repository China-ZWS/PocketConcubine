//
//  PlayerToolView.h
//  PocketConcubine
//
//  Created by 周文松 on 15-5-17.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlayerToolViewDelegate <NSObject>

@optional
- (void)play;
- (void)pause;
- (void)big;
- (void)small;
- (void)beginDragging;
- (void)dragging;
- (void)endDraging;
@end

@interface PlayerToolView : UIView
@property (nonatomic, assign) id<PlayerToolViewDelegate>delegate;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UISlider *scrubber;
@property (nonatomic, strong) UIButton *fillBtn;
@property (nonatomic, strong) UILabel *leftView;
@property (nonatomic, strong) UILabel *rightView;
@end
