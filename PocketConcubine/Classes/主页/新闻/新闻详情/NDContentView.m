//
//  NDContentView.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-11.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "NDContentView.h"

@implementation NDContentView

- (id)initWithFrame:(CGRect)frame finishOffset:(void(^)())finishOffset;
{
    if ((self = [super initWithFrame:frame]))
    {
        self.backgroundColor = [UIColor clearColor];

        
        _webView = [UIWebView new];
        _webView.delegate = self;
        _webView.backgroundColor = [UIColor clearColor];
        _webView.opaque = NO;
        _webView.scrollView.scrollEnabled = NO;
        _webView.hidden = YES;
        [self addSubview:_webView];
        _finishOffset = finishOffset;
    }
    return self;
}

- (void)setDatas:(id)datas
{
    NSString *newscontent = [Base64 textFromBase64String:datas[@"newscontent"]];
    [_webView loadHTMLString:newscontent baseURL:nil];

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    _webView.hidden = NO;
    
    CGRect rect = _webView.frame;
    rect.origin = CGPointMake(defaultInset.left, defaultInset.top);
    rect.size = CGSizeMake(DeviceW - defaultInset.left - defaultInset.right, 1);
    _webView.frame = rect;
    
    //字体大小
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%f%%'",ScaleW(105)]];
    //字体颜色
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'gray'"];
    
    CGFloat totalHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight"] floatValue];
    
    rect.size.height = totalHeight;
    _webView.frame = rect;
    
    
    CGRect selfRect = self.frame;
    selfRect.size.height = CGRectGetMaxY(_webView.frame) + defaultInset.bottom ;
    self.frame = selfRect;
    
    _finishOffset();
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
