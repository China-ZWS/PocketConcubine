//
//  PDContentView.h
//  PocketConcubine
//
//  Created by 周文松 on 15-5-17.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDContentView : UIView
{
    void(^_finishOffset)();
}
@property (nonatomic,strong) UILabel *title;
@property (nonatomic, strong) id datas;
- (id)initWithFrame:(CGRect)frame finishOffset:(void(^)())finishOffset;

@end
