//
//  CDHeaderView.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-17.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "CDHeaderView.h"

static void *AVPlayerDemoPlaybackViewControllerRateObservationContext = &AVPlayerDemoPlaybackViewControllerRateObservationContext;
static void *AVPlayerDemoPlaybackViewControllerStatusObservationContext = &AVPlayerDemoPlaybackViewControllerStatusObservationContext;
static void *AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext = &AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext;


@interface CDHeaderView (Player)
@end

@implementation CDHeaderView (Player)

/* Called when the player item has played to its end time. */
- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    /* After the movie has played to its end time, seek back to time zero
     to play it again. */
    _seekToZeroBeforePlay = YES;
}

@end

@interface CDHeaderView ()
<PlayerToolViewDelegate>
{
    BOOL _isSeeking;
}
@end

@implementation CDHeaderView

- (void)dealloc
{
    [self playBack];
    
}

#pragma mark - 当视频还在加载中退出
- (void)playBack
{
    [self removePlayerTimeObserver];
    [_mPlayer removeObserver:self forKeyPath:@"rate"];
    [_mPlayer removeObserver:self forKeyPath:@"currentItem"];
    [_mPlayer.currentItem removeObserver:self forKeyPath:@"status"];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [_mPlayer pause];
    _mPlayer = nil;
}


- (id)initWithDatas:(id)datas;
{
    if ((self = [super initWithFrame:CGRectMake(0, 0, DeviceW, DeviceW * 9/16)])) {
        self.backgroundColor = [UIColor blackColor];
        [self layoutViews];
    }
    return self;
}


#pragma mark - 初始化UI
- (void)layoutViews
{
    _playerView = [[PlayerView alloc] initWithFrame:self.frame];
    _playerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self addSubview:_playerView];
    
    _tool = [[PlayerToolView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - ScaleH(30), DeviceW, ScaleH(30))];
    _tool.delegate = self;
    [self addSubview:_tool];
    
    
}





#pragma mark - 加载URL以及初始化播放器
- (void)setUrl:(NSURL *)url
{
   
    if (_url != url)
    {
        _url = url;
        
        /*
         Create an asset for inspection of a resource referenced by a given URL.
         Load the values for the asset key "playable".
         */
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:_url options:nil];
        
        NSArray *requestedKeys = @[@"playable"];
        
        /* Tells the asset to load the values of any of the specified keys that are not already loaded. */
        [asset loadValuesAsynchronouslyForKeys:requestedKeys completionHandler:
         ^{
             dispatch_async( dispatch_get_main_queue(),
                            ^{
                                NSError *error = nil;
//                                AVKeyValueStatus status = [asset statusOfValueForKey:@"playable" error:&error];
                                
                                [self prepareToPlayAsset:asset withKeys:requestedKeys];
  

//                                if (status == AVKeyValueStatusLoaded) //加载成功
//                                {
//                                    [self prepareToPlayAsset:asset withKeys:requestedKeys];
//                                }
//                                else if (status == AVKeyValueStatusFailed) //加载失败
//                                {
//                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"课程加载失败" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
//                                    [alert show];
//                                }
//                                else if (status == AVKeyValueStatusCancelled) // 关闭
//                                {
//                                    NSLog(@"关闭.");
//                                }

                                /* IMPORTANT: Must dispatch to main queue in order to operate on the AVPlayer and AVPlayerItem. */
                            });
         }];
    }
}

#pragma mark Prepare to play asset, URL

/*
 Invoked at the completion of the loading of the values for all keys on the asset that we require.
 Checks whether loading was successfull and whether the asset is playable.
 If so, sets up an AVPlayerItem and an AVPlayer to play the asset.
 */
- (void)prepareToPlayAsset:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys
{
    if (_isPlayBack) {
        return;
    }
    /* Make sure that the value of each key has loaded successfully. */
    for (NSString *thisKey in requestedKeys)
    {
        NSError *error = nil;
        AVKeyValueStatus keyStatus = [asset statusOfValueForKey:thisKey error:&error];
        if (keyStatus == AVKeyValueStatusFailed)
        {
            [self assetFailedToPrepareForPlayback:error];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"课程加载失败" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        else if (keyStatus == AVKeyValueStatusCancelled) // 关闭
        {
            
            return;
        }
        /* If you are also implementing -[AVAsset cancelLoading], add your code here to bail out properly in the case of cancellation. */
    }
    
    /* Use the AVAsset playable property to detect whether the asset can be played. */
    if (!asset.playable)
    {
        /* Generate an error describing the failure. */
//        NSString *localizedDescription = NSLocalizedString(@"Item cannot be played", @"Item cannot be played description");
        NSString *localizedDescription = NSLocalizedString(@"视频播放失败", @"Item cannot be played description");

        NSString *localizedFailureReason = NSLocalizedString(@"地址错误", @"Item cannot be played failure reason");
        NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   localizedDescription, NSLocalizedDescriptionKey,
                                   localizedFailureReason, NSLocalizedFailureReasonErrorKey,
                                   nil];
        NSError *assetCannotBePlayedError = [NSError errorWithDomain:@"StitchedStreamPlayer" code:0 userInfo:errorDict];
        
        /* Display the error to the user. */
        [self assetFailedToPrepareForPlayback:assetCannotBePlayedError];
        
        return;
    }
    
    /* At this point we're ready to set up for playback of the asset. */
    
    /* Stop observing our prior AVPlayerItem, if we have one. */
    if (self.mPlayerItem)
    {
        /* Remove existing player item key value observers and notifications. */
        
        [self.mPlayerItem removeObserver:self forKeyPath:@"status"];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:AVPlayerItemDidPlayToEndTimeNotification
                                                      object:self.mPlayerItem];
    }
    
    /* Create a new instance of AVPlayerItem from the now successfully loaded AVAsset. */
    self.mPlayerItem = [AVPlayerItem playerItemWithAsset:asset];
    
    /* Observe the player item "status" key to determine when it is ready to play. */
    [self.mPlayerItem addObserver:self
                       forKeyPath:@"status"
                          options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                          context:AVPlayerDemoPlaybackViewControllerStatusObservationContext];
    
    /* When the player item has played to its end time we'll toggle
     the movie controller Pause button to be the Play button */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.mPlayerItem];
    
    _seekToZeroBeforePlay = NO;
    
    /* Create new player, if we don't already have one. */
    if (!_mPlayer)
    {
        /* Get a new AVPlayer initialized to play the specified player item. */
        [self setPlayer:[AVPlayer playerWithPlayerItem:self.mPlayerItem]];
        
        /* Observe the AVPlayer "currentItem" property to find out when any
         AVPlayer replaceCurrentItemWithPlayerItem: replacement will/did
         occur.*/
        [_mPlayer addObserver:self
                      forKeyPath:@"currentItem"
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext];
        
        /* Observe the AVPlayer "rate" property to update the scrubber control. */
        [_mPlayer addObserver:self
                      forKeyPath:@"rate"
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:AVPlayerDemoPlaybackViewControllerRateObservationContext];
    }
    
    /* Make our new AVPlayerItem the AVPlayer's current item. */
    if (_mPlayer.currentItem != self.mPlayerItem)
    {
        /* Replace the player item with a new player item. The item replacement occurs
         asynchronously; observe the currentItem property to find out when the
         replacement will/did occur
         
         If needed, configure player item here (example: adding outputs, setting text style rules,
         selecting media options) before associating it with a player
         */
        [_mPlayer replaceCurrentItemWithPlayerItem:self.mPlayerItem];
        
        [self syncPlayPauseButtons];
    }
    
    [_tool.scrubber setValue:0.0];
}


- (void)observeValueForKeyPath:(NSString*) path ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{
    
    if (_isPlayBack) {
        [self playBack];
        return;
    }

    /* AVPlayerItem "status" property value observer. */
    if (context == AVPlayerDemoPlaybackViewControllerStatusObservationContext)
    {
        [self syncPlayPauseButtons];
        
        AVPlayerItemStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        switch (status)
        {
                /* Indicates that the status of the player is not yet known because
                 it has not tried to load new media resources for playback */
            case AVPlayerItemStatusUnknown:
            {
                [self removePlayerTimeObserver];
                [self syncScrubber];
                [self disableScrubber];
                [self disablePlayerButtons];
            }
                break;
                
            case AVPlayerItemStatusReadyToPlay:
            {
                
                
                [_mPlayer play];

                /* Once the AVPlayerItem becomes ready to play, i.e.
                 [playerItem status] == AVPlayerItemStatusReadyToPlay,
                 its duration can be fetched from the item. */
                
                [self initScrubberTimer];
                [self enableScrubber];
                [self enablePlayerButtons];
            }
                break;
                
            case AVPlayerItemStatusFailed:
            {
                AVPlayerItem *playerItem = (AVPlayerItem *)object;
                [self assetFailedToPrepareForPlayback:playerItem.error];
            }
                break;
        }
    }
    /* AVPlayer "rate" property value observer. */
    else if (context == AVPlayerDemoPlaybackViewControllerRateObservationContext)
    {
        [self syncPlayPauseButtons];
    }
    /* AVPlayer "currentItem" property observer.
     Called when the AVPlayer replaceCurrentItemWithPlayerItem:
     replacement will/did occur. */
    else if (context == AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext)
    {
        AVPlayerItem *newPlayerItem = [change objectForKey:NSKeyValueChangeNewKey];
        
        /* Is the new player item null? */
        if (newPlayerItem == (id)[NSNull null])
        {
            [self disablePlayerButtons];
            [self disableScrubber];
        }
        else /* Replacement of player currentItem has occurred */
        {
            /* Set the AVPlayer for which the player layer displays visual output. */
            [_playerView setPlayer:_mPlayer];
            [_playerView setVideoFillMode:AVLayerVideoGravityResizeAspect];

            [self syncPlayPauseButtons];
        }
    }
    else
    {
        [super observeValueForKeyPath:path ofObject:object change:change context:context];
    }
}




-(void)assetFailedToPrepareForPlayback:(NSError *)error
{
    [self removePlayerTimeObserver];
    [self syncScrubber];
    [self disableScrubber];
    [self disablePlayerButtons];
    /* Display the error. */
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
                                                        message:[error localizedFailureReason]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

/* Cancels the previously registered time observer. */
-(void)removePlayerTimeObserver
{
    if (_mTimeObserver)
    {
        [_mPlayer removeTimeObserver:_mTimeObserver];
        _mTimeObserver = nil;
    }
}


/* Set the scrubber based on the player current time. */
- (void)syncScrubber
{
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration))
    {
        _tool.scrubber.minimumValue = 0.0;
        return;
    }
    
    double duration = CMTimeGetSeconds(playerDuration);
    //获取当前时间
    CMTime currentTime = _mPlayer.currentItem.currentTime;
    //转成秒数
    CGFloat currentPlayTime = (CGFloat)currentTime.value/currentTime.timescale;
    _tool.leftView.text = [self convertMovieTimeToText:currentPlayTime];
    if (isfinite(duration))
    {
        float minValue = [_tool.scrubber minimumValue];
        float maxValue = [_tool.scrubber maximumValue];
        double time = CMTimeGetSeconds([_mPlayer currentTime]);
        
        [_tool.scrubber setValue:(maxValue - minValue) * time / duration + minValue];
    }
}


/* Requests invocation of a given block during media playback to update the movie scrubber control. */
-(void)initScrubberTimer
{
    double interval = .1f;
    
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration))
    {
        return;
    }
    double duration = CMTimeGetSeconds(playerDuration);
    if (isfinite(duration))
    {
        CGFloat width = CGRectGetWidth([_tool.scrubber bounds]);
        interval = 0.5f * duration / width;
        CMTime totalTime = _mPlayerItem.duration;
        _tool.rightView.text = [NSString stringWithFormat:@"%@",[self convertMovieTimeToText:(CGFloat)totalTime.value/totalTime.timescale]];
    }
    
    /* Update the scrubber during normal playback. */
    __weak CDHeaderView *weakSelf = self;
    _mTimeObserver = [_mPlayer addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(interval, NSEC_PER_SEC)
                                                               queue:NULL /* If you pass NULL, the main queue is used. */
                                                          usingBlock:^(CMTime time)
                     {
                         [weakSelf syncScrubber];
                     }];
}



/* ---------------------------------------------------------
 **  Get the duration for a AVPlayerItem.
 ** ------------------------------------------------------- */

- (CMTime)playerItemDuration
{
    AVPlayerItem *playerItem = [_mPlayer currentItem];
    if (playerItem.status == AVPlayerItemStatusReadyToPlay)
    {
        return([playerItem duration]);
    }
    
    return(kCMTimeInvalid);
}



-(void)enableScrubber
{
    _tool.scrubber.enabled = YES;
}

-(void)disableScrubber
{
    _tool.scrubber.enabled = NO;
}


-(void)enablePlayerButtons
{
    _tool.playBtn.enabled = YES;
}

-(void)disablePlayerButtons
{
    _tool.playBtn.enabled = YES;
}

#pragma mark - 更新当前播放按钮状态
- (void)syncPlayPauseButtons
{
    if ([self isPlaying])
    {
        _tool.playBtn.selected = YES;
    }
    else
    {
        _tool.playBtn.selected = NO;
        
    }
}

#pragma mark - 判断当前播放的状态
- (BOOL)isPlaying
{
    return _mRestoreAfterScrubbingRate != 0.f || [_mPlayer rate] != 0.f;
}



-(NSString*)convertMovieTimeToText:(CGFloat)time{
    int m = (int)(time/60);
    int s = (int) ((time/60 - m)*60);
    return [NSString stringWithFormat:@"%02d:%02d ",m,s];
}

#pragma mark - CDHeaderViewDelegate -
#pragma mark -开始
- (void)play
{
    [_mPlayer play];
}

#pragma mark - 暂停
- (void)pause
{
    [_mPlayer pause];
    
}

- (void)big
{
    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    [UIView animateWithDuration:duration animations:^{
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            SEL selector = NSSelectorFromString(@"setOrientation:");
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:[UIDevice currentDevice]];
            int val = UIInterfaceOrientationLandscapeRight;
            [invocation setArgument:&val atIndex:2];
            [invocation invoke];
        }
    }];
}

- (void)small
{
    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    [UIView animateWithDuration:duration animations:^{
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            SEL selector = NSSelectorFromString(@"setOrientation:");
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:[UIDevice currentDevice]];
            int val = UIInterfaceOrientationPortrait;
            [invocation setArgument:&val atIndex:2];
            [invocation invoke];
        }
    }];

}



- (void)beginDragging
{
    _mRestoreAfterScrubbingRate = [self.mPlayer rate];
    [self.mPlayer setRate:0.f];
    
    /* Remove previous timer. */
    [self removePlayerTimeObserver];
}

- (void)dragging
{
    if (!_isSeeking)
    {
        _isSeeking = YES;
        
        CMTime playerDuration = [self playerItemDuration];
        if (CMTIME_IS_INVALID(playerDuration)) {
            return;
        }
        
        double duration = CMTimeGetSeconds(playerDuration);
        if (isfinite(duration))
        {
            float minValue = [_tool.scrubber minimumValue];
            float maxValue = [_tool.scrubber maximumValue];
            float value = [_tool.scrubber value];
            
            double time = duration * (value - minValue) / (maxValue - minValue);
            _tool.leftView.text = [self convertMovieTimeToText:time];

            [self.mPlayer seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC) completionHandler:^(BOOL finished) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    _isSeeking = NO;
                });
            }];
        }
    }

}

- (void)endDraging
{
    if (!_mTimeObserver)
    {
        CMTime playerDuration = [self playerItemDuration];
        if (CMTIME_IS_INVALID(playerDuration))
        {
            return;
        }
        
        double duration = CMTimeGetSeconds(playerDuration);
        if (isfinite(duration))
        {
            CGFloat width = CGRectGetWidth([_tool.scrubber bounds]);
            double tolerance = 0.5f * duration / width;
            
            __weak CDHeaderView *weakSelf = self;
            _mTimeObserver = [self.mPlayer addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(tolerance, NSEC_PER_SEC) queue:NULL usingBlock:
                             ^(CMTime time)
                             {
                                 [weakSelf syncScrubber];
                             }];
        }
    }
    
    if (_mRestoreAfterScrubbingRate)
    {
        [self.mPlayer setRate:_mRestoreAfterScrubbingRate];
        _mRestoreAfterScrubbingRate = 0.f;
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
