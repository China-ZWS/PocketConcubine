//
//  CDContentView.h
//  PocketConcubine
//
//  Created by 周文松 on 15-5-17.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDContentView : UIView
<UIWebViewDelegate>
{
    void(^_finishOffset)();
}
- (id)initWithFrame:(CGRect)frame finishOffset:(void(^)())finishOffset;

@property (nonatomic,strong) UILabel *title;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) id datas;

@end
