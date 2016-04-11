//
//  EventsCell.h
//  PocketConcubine
//
//  Created by 周文松 on 15-5-5.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "PublicActivityListCell.h"

@class EventsCell;

@protocol EventsCellDelegate <NSObject>
@optional
- (void)timeOut:(EventsCell *)cell;
@end


@interface EventsCell : PublicActivityListCell
{
}
@property (nonatomic, assign) id<EventsCellDelegate>delegate;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSDate *fireDate;
@end
