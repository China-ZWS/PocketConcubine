//
//  PDHeaderView.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-17.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "PDHeaderView.h"

@implementation PDHeaderView

- (void)drawRect:(CGRect)rect
{
    if (_datas)
    {
        [self drawWithChamferOfRectangle:CGRectMake(0, 0, CGRectGetWidth(rect), ScaleH(30)) inset:UIEdgeInsetsMake(0, 0, 0, 0) radius:0 lineWidth:.3 lineColor:CustomAlphaBlue  backgroundColor:CustomAlphaBlue];
    }
}

- (id)initWithFrame:(CGRect)frame finishOffset:(void(^)())finishOffset;
{
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor clearColor];
        _title = [UILabel new];
        _title.font = FontBold(15);
        _title.textColor = CustomBlue;
        _title.backgroundColor = [UIColor clearColor];
        [self addSubview:_title];
        
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
    _datas = datas;
    _title.frame = CGRectMake(defaultInset.left + ScaleW(15), (ScaleH(30) - _title.font.lineHeight) / 2, CGRectGetWidth(self.frame) - ScaleW(30) - defaultInset.left - defaultInset.right, _title.font.lineHeight);
    _title.text = @"简 介";
    [_webView loadHTMLString:[Base64 textFromBase64String:datas[@"procontent"]] baseURL:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    _webView.hidden = NO;
    
    CGRect rect = _webView.frame;
    rect.origin = CGPointMake(defaultInset.left,  ScaleW(30) - defaultInset.top);
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
    [self setNeedsDisplay];
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
