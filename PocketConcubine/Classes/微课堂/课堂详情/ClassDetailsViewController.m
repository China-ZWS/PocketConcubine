//
//  ClassDetailsViewController.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-17.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//
#import "MJRefresh.h"
#import "ClassDetailsViewController.h"
#import "CDHeaderView.h"
#import "CDContentView.h"
#import "CDFooterView.h"
#import "AppDelegate.h"


#import "NewDetailsViewController.h"
#import "ProductDetailsViewController.h"
#import "ClassDetailsViewController.h"
#import "ActivityDetailsViewController.h"
#import "DeputyViewController.h"


@interface ClassDetailsViewController ()
<AbnormalViewDelegate, UIActionSheetDelegate>
{
    NSDictionary *_datas;
    NSDictionary *_dic;
    BOOL _isLandscape;
    
}
@property (nonatomic, strong) CDHeaderView *headerView;
@property (nonatomic, strong) CDContentView *contentView;
@property (nonatomic, strong) CDFooterView *footerView;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *great;
@end

@implementation ClassDetailsViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIView *)getView
{
    UIImage *shareImg = [UIImage imageNamed:@"share.png"];
    UIImage *collectionImg = [UIImage imageNamed:@"icon_great.png"];
    UIImage *collection_hImg = [UIImage imageNamed:@"icon_collect.png"];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, shareImg.size.width + collectionImg.size.width + 15, shareImg.size.height)];
    
    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collectBtn.frame = CGRectMake(0, 0, collectionImg.size.width, collectionImg.size.height);
    [collectBtn setBackgroundImage:collectionImg forState:UIControlStateNormal];
    [collectBtn setBackgroundImage:collection_hImg forState:UIControlStateSelected];
    [collectBtn addTarget:self action:@selector(eventWithCollect:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:collectBtn];
    if ([_dic[@"flag"] integerValue] == 0)
    {
        collectBtn.selected = NO;
    }
    else if ([_dic[@"flag"] integerValue] == 1)
    {
        collectBtn.selected = YES;
    }

    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(15 + CGRectGetWidth(collectBtn.frame), 0, shareImg.size.width, shareImg.size.height);
    [shareBtn addTarget:self action:@selector(eventWithShare) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setBackgroundImage:shareImg forState:UIControlStateNormal];
    [view addSubview:shareBtn];

    return view;
}


- (id)initWithDatas:(id)datas;
{
    if ((self = [super init])) {
        _datas = datas;
        
        [self.navigationItem setNewTitle:@"课堂详情"];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"back.png"];
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}

- (UIButton *)backBtn
{
    if (!_backBtn) {
        UIImage *backImg = [UIImage imageNamed:@"back.png"];
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(20, 20, backImg.size.width, backImg.size.height);
        [_backBtn setBackgroundImage:backImg forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.hidden = YES;
    }
    return _backBtn;
}

- (UIButton *)great
{
    if (_great)
    {
        _great = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _great;
}

- (void)back
{
    if (_isLandscape)
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
        return;
    }
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.allowRotation = NO;
    _headerView.isPlayBack = YES;
    [self popViewController];
}

- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[CDHeaderView alloc] initWithDatas:nil];
    }
    return _headerView;
}

- (UIView *)contentView
{
    if (!_contentView) {
        ClassDetailsViewController __weak*safeSelf = self;
        _contentView = [[CDContentView  alloc] initWithFrame:CGRectMake(0, 0, DeviceW, ScaleH(30)) finishOffset:^
                        {
                            [safeSelf adjustmentWithRect];
                        }];
    }
    return _contentView;
}

- (UIView *)footerView
{
    if (!_footerView) {
        ClassDetailsViewController __weak*safeSelf = self;
        _footerView = [[CDFooterView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_contentView.frame), DeviceW, ScaleH(30)) finishOffset:^()
                         {
                             [safeSelf adjustmentWithRect];
                         }
                       selected:^(id data)
                       {
                           [safeSelf getDatas:data];

                       }];

    }
    return _footerView;
}


- (void)adjustmentWithRect
{
    
    CGRect footRect = _footerView.frame;
    footRect.origin.y = CGRectGetMaxY(_contentView.frame);
    _footerView.frame = footRect;
    
    if (CGRectGetMaxY(_footerView.frame) > CGRectGetHeight(_scrollView.frame)) {
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame), CGRectGetMaxY(_footerView.frame));
    }
    else
    {
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame) + 1);
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.headerView];
    [_headerView addSubview:self.backBtn];
    [_headerView addSubview:self.great];
  
    _scrollView.frame = CGRectMake(0, CGRectGetMaxY(_headerView.frame), DeviceW, CGRectGetHeight(self.view.frame) - CGRectGetMaxY(_headerView.frame));
    
    [_scrollView addSubview:self.contentView];
    _scrollView.scrollFooterView = self.footerView;
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.allowRotation = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)statusBarOrientationChange:(NSNotification *)notification

{
        
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft) // home键靠右
    {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        [self setNavigationBarHidden:YES];
        _headerView.frame = CGRectMake(0, 0, DeviceW, DeviceH);
        _headerView.tool.frame = CGRectMake(0, CGRectGetHeight(_headerView.frame) - ScaleH(120), DeviceW, ScaleH(120));
        _isLandscape = YES;
        _backBtn.hidden = NO;
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        [self setNavigationBarHidden:NO];
        _headerView.frame = CGRectMake(0, 0, DeviceW, DeviceW * 9/16);
        _headerView.tool.frame = CGRectMake(0, CGRectGetHeight(_headerView.frame) - ScaleH(30), DeviceW, ScaleH(30));
        _isLandscape = NO;
        _backBtn.hidden = YES;
    }
    
}
    




- (void)layoutViews
{
    _headerView.url = [NSURL URLWithString:_dic[@"resvideo"]];
    _contentView.datas = _dic;
    _footerView.datas = _dic;
}


- (void)setUpDatas
{
    [self refreshDatas];
}


- (void)refreshDatas
{
    [MBProgressHUD showMessag:Loding_text1 toView:self.view];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] =  _datas[@"id"];
    params[@"userid"] =  [Infomation readInfo]?[Infomation readInfo][@"id"]:@"";

    _connection = [BaseModel POST:revideoInfoServlet parameter:params class:[BaseModel class]
                          success:^(id data)
                   {
                       
                       
                       _dic = data[@"data"];
                       
                       [self initCollect];
                       
                       if (!_dic.count)
                       {
                           [AbnormalView setRect:_scrollView.frame toView:_scrollView abnormalType:NotDatas];
                           [AbnormalView setDelegate:self toView:_scrollView];
                       }
                       else
                       {
                           [AbnormalView hideHUDForView:_scrollView];
                           [self layoutViews];
                       }
                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                   }
                          failure:^(NSString *msg, NSString *state)
                   {
                       [self.view makeToast:msg];
                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                       
                       if ([state isEqualToString:kNetworkAnomaly])
                       {
                           if (!_dic.count)
                           {
                               [AbnormalView setRect:_scrollView.bounds toView:_scrollView abnormalType:NotNetWork];
                               [AbnormalView setDelegate:self toView:_scrollView];
                           }
                           else
                           {
                               [AbnormalView hideHUDForView:_scrollView];
                           }
                       }
                       else
                       {
                           if (!_dic.count)
                           {
                               [AbnormalView setRect:_scrollView.frame toView:_scrollView abnormalType:NotDatas];
                               [AbnormalView setDelegate:self toView:_scrollView];
                           }
                           else
                           {
                               [AbnormalView hideHUDForView:_scrollView];
                           }
                       }
                   }];
}


- (void)getDatas:(NSDictionary *)data
{
    if (!data.count) return;
    switch ([data[@"advertType"] integerValue]) {
        case 1:
            [self pushViewController:[[NewDetailsViewController alloc] initWithDatas:@{@"id":data[@"advertCode"]}]];
            break;
        case 2:
            [self pushViewController:[[ProductDetailsViewController alloc] initWithDatas:@{@"id":data[@"advertCode"]}]];
            break;
        case 3:
        {
            
            _datas = data;
            [self setUpDatas];
        }
            break;
        case 4:
            [self pushViewController:[[ActivityDetailsViewController alloc] initWithDatas:@{@"id":data[@"advertCode"]} type:kNew]];
            break;
        case 5:
            [self pushViewController:[DeputyViewController new]];
            break;
        default:
            break;
    }

  
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)eventWithCollect:(UIButton *)button
{
    
    if (![Infomation readInfo])
    {
        
        [self gotoLogingWithSuccess:^(BOOL isSuccess)
         {
             
             if (isSuccess)
             {
                 [self.view makeToast:@"登录成功"];
                 NSNotificationPost(RefreshWithViews, nil, nil);
             }
             else
             {
             }
         }
                              class:@"LoginViewController"];
        
        return;
    }

    if (button.selected)
    {
        [self.view makeToast:@"已收藏"];
        return;
    }
    button.selected = !button.selected;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = @"2";
    params[@"id"] =  _dic[@"id"];
    params[@"userid"] =  [Infomation readInfo]?[Infomation readInfo][@"id"]:@"";
    
  _connection = [BaseModel POST:submitcollectServlet parameter:params class:[BaseModel class]
                          success:^(id data)
                   {
                       [self.view makeToast:@"收藏成功"];

                                          }
                          failure:^(NSString *msg, NSString *state)
                   {
                       [self.view makeToast:msg];
                   }];
}

- (void)initCollect
{
    [self.navigationItem setRightItemView:[self getView]];
}


- (void)eventWithShare
{
    
    if (![Infomation readInfo])
    {
        
        [self gotoLogingWithSuccess:^(BOOL isSuccess)
         {
             
             if (isSuccess)
             {
                 [self.view makeToast:@"登录成功"];
                 NSNotificationPost(RefreshWithViews, nil, nil);
             }
             else
             {
             }
         }
                                    class:@"LoginViewController"];
        
        return;
    }

    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"微信好友" otherButtonTitles:@"微信朋友圈", nil];
    [sheet showInView:self.view.window];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (actionSheet.destructiveButtonIndex == buttonIndex)
    {
        
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = [Base64 textFromBase64String:_dic[@"restitle"]];
        message.description = @"微信";
        [message setThumbImage:[UIImage imageNamed:@"shareThumbImage.png"]];
        
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = [NSString stringWithFormat:@"http://121.199.55.224:8080/beauty/resvideo/share?id=%@",_dic[@"id"]];
        
        message.mediaObject = ext;
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneSession;
        
        [WXApi sendReq:req];
        
    }
    else if (actionSheet.firstOtherButtonIndex == buttonIndex)
    {
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = [Base64 textFromBase64String:_dic[@"restitle"]];
        message.description = @"微信";
        [message setThumbImage:[UIImage imageNamed:@"shareThumbImage.png"]];
        
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = [NSString stringWithFormat:@"http://121.199.55.224:8080/beauty/resvideo/share?id=%@",_dic[@"id"]];
        
        message.mediaObject = ext;
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneTimeline;
        
        [WXApi sendReq:req];
        
    }
    
}



- (void)abnormalReloadDatas
{
    [self refreshDatas];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
