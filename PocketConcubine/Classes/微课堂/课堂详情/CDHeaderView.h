//
//  CDHeaderView.h
//  PocketConcubine
//
//  Created by 周文松 on 15-5-17.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "PlayerView.h"
#import "PlayerToolView.h"

@interface CDHeaderView : UIView

{
    id _mTimeObserver;
    BOOL _seekToZeroBeforePlay;
    PlayerView *_playerView;
    UIButton *_playBtn;
    float _mRestoreAfterScrubbingRate;

}
@property (nonatomic, strong) NSURL *url;
@property (nonatomic) BOOL isPlayBack;

@property (readwrite, strong, setter=setPlayer:, getter=player) AVPlayer* mPlayer;
@property (strong) AVPlayerItem* mPlayerItem;
@property (nonatomic, strong)PlayerToolView *tool;

- (id)initWithDatas:(id)datas;
- (void)playBack;

@end
