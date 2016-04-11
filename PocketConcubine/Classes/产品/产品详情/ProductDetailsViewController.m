//
//  ProductDetailsViewController.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-17.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "ProductDetailsViewController.h"
#import "MJRefresh.h"
#import "PDHeaderView.h"
#import "PDContentView.h"
#import "PDFooterView.h"


#import "NewDetailsViewController.h"
#import "ProductDetailsViewController.h"
#import "ClassDetailsViewController.h"
#import "ActivityDetailsViewController.h"
#import "DeputyViewController.h"

#import "WXApi.h"
#import "CAlertView.h"
#import "QRcodeView.h"

@interface ProductDetailsViewController ()
<MJRefreshBaseViewDelegate,AbnormalViewDelegate, UIActionSheetDelegate>
{
    NSDictionary *_datas;
    MJRefreshHeaderView *_header;
    NSDictionary *_dic;

}
@property (nonatomic, strong) PDHeaderView *headerView;
@property (nonatomic, strong) PDContentView *contentView;
@property (nonatomic, strong) PDFooterView *footerView;
@property (nonatomic, strong) UIButton *status;

@end

@implementation ProductDetailsViewController

- (void)dealloc
{
    [_header free];
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

- (void)initRightItemView
{
    
    [self.navigationItem setRightItemView:[self getView]];
    
    
}


- (UIButton *)status
{
    if (!_status)
    {
        _status = [UIButton buttonWithType:UIButtonTypeCustom];
        _status.frame = CGRectMake(0, 0, DeviceW - ScaleW(40), 35);
        _status.backgroundColor = CustomlightPurple;
        [_status getShadowOffset:CGSizeMake(1, 1) shadowRadius:ScaleW(3) shadowColor:CustomlightPurple shadowOpacity:.6 cornerRadius:ScaleW(3) masksToBounds:NO];
        [_status setTitle:@"加载中..." forState:UIControlStateNormal];
        [_status addTarget:self action:@selector(eventWithStatus) forControlEvents:UIControlEventTouchUpInside];
        _status.enabled = NO;
    }
    
    return _status;
}



- (id)initWithDatas:(id)datas;
{
    if ((self = [super init])) {
        _datas = datas;
        [self.navigationItem setNewTitle:[Base64 textFromBase64String:datas[@"protitle"]]];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"back.png"];
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}

- (void)back
{
    [self popViewController];
}


- (void)loadView
{
    [super loadView];
//    NSMutableArray *tbitems = [NSMutableArray array];
//    UIBarButtonItem *sure = [[UIBarButtonItem alloc] initWithCustomView:self.status];
//    [tbitems addObject:sure];
//    [self setToolbarItems:tbitems];
}



- (UIView *)headerView
{
    if (!_headerView) {
        ProductDetailsViewController __weak*safeSelf = self;
        _headerView = [[PDHeaderView  alloc] initWithFrame:CGRectMake(0, 0, DeviceW, ScaleH(30)) finishOffset:^()
                        {
                            [safeSelf adjustmentWithRect];
                        }];
    }
    return _headerView;
}

- (UIView *)contentView
{
    if (!_contentView) {
        ProductDetailsViewController __weak*safeSelf = self;
        _contentView = [[PDContentView  alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headerView.frame), DeviceW, ScaleH(30)) finishOffset:^()
                        {
                            [safeSelf adjustmentWithRect];
                        }];
    }
    return _contentView;
}

- (UIView *)footerView
{
    if (!_footerView) {
        ProductDetailsViewController __weak*safeSelf = self;
        _footerView = [[PDFooterView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headerView.frame), DeviceW, ScaleH(30)) finishOffset:^()
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
    
//    CGRect contentRect = _contentView.frame;
//    contentRect.origin.y = CGRectGetMaxY(_headerView.frame);
//    _contentView.frame = contentRect;
    
    CGRect footRect = _footerView.frame;
    footRect.origin.y = CGRectGetMaxY(_headerView.frame);
    _footerView.frame = footRect;
    
    if (CGRectGetMaxY(_footerView.frame) > CGRectGetHeight(self.view.frame)) {
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame), CGRectGetMaxY(_footerView.frame));
    }
    else
    {
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame), CGRectGetHeight(self.view.frame) + 1);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _header = [MJRefreshHeaderView header];
    _header.scrollView = _scrollView ;
    _header.delegate = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_header beginRefreshing];
    });
    _scrollView.scrollHeaderView = self.headerView;
    _scrollView.scrollFooterView = self.footerView;
}


- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView;
{
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]])
    {
        [self refreshDatas];
    }
}

- (void)layoutViews
{
    _headerView.datas = _dic;
    _contentView.datas = _dic;
    _footerView.datas = _dic;
}


- (void)getDatas:(NSDictionary *)data
{
 
    if (!data.count) return;
    switch ([data[@"advertType"] integerValue]) {
        case 1:
            [self pushViewController:[[NewDetailsViewController alloc] initWithDatas:@{@"id":data[@"advertCode"]}]];
            break;
        case 2:
        {
            _datas = data;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_header beginRefreshing];
            });

        }
            break;
        case 3:
        {
            NSDictionary *dic = [Infomation readInfo];
            
            
            BOOL isOnline = [[MobClick getConfigParams:@"isOnline"] boolValue];
            
            if (isOnline) {
                BOOL hasVIP = ([dic[@"usertype"] integerValue] == 2)?1:0;
                if (!hasVIP) {
                    CAlertView *aler = [[CAlertView alloc] initWithView:[self createQRcode]];
                    [aler show];
                    return;
                }
            }
            [self pushViewController:[[ClassDetailsViewController alloc] initWithDatas:@{@"id":data[@"advertCode"]}]];

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

- (UIView *)createQRcode
{
    QRcodeView *view = [[QRcodeView alloc] initWithFrame:CGRectMake(0, 0, DeviceW * 3 / 5,  ScaleH(44) + DeviceW * 3 / 5 )];
    return view;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






- (void)abnormalReloadDatas
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_header beginRefreshing];
    });
}





#pragma mark - 详情接口
- (void)refreshDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] =  _datas[@"id"];
    params[@"userid"] =  [Infomation readInfo]?[Infomation readInfo][@"id"]:@"";
    _connection = [BaseModel POST:productInfoServlet parameter:params class:[BaseModel class]
                          success:^(id data)
                   {
                       _dic = data[@"data"];
                       
                       [self initRightItemView];

                       if (!_dic.count)
                       {
                           [AbnormalView setRect:_scrollView.frame toView:_scrollView abnormalType:NotDatas];
                           [AbnormalView setDelegate:self toView:_scrollView];
                       }
                       else
                       {
                           [AbnormalView hideHUDForView:_scrollView];
                           [self.navigationItem setNewTitle:[Base64 textFromBase64String:_dic[@"protitle"]]];
                           [self layoutViews];
                       }
                       
                       switch ([data[@"data"][@"status"] integerValue])
                       {
                           case 1:
                           {
                               [_status setTitle:@"申请代理" forState:UIControlStateNormal];
                               _status.enabled = YES;
                               _status.backgroundColor = CustomPink;
                               [_status getShadowOffset:CGSizeMake(1, 1) shadowRadius:ScaleW(3) shadowColor:CustomPink shadowOpacity:.6 cornerRadius:ScaleW(3) masksToBounds:NO];
                           }
                               break;
                           case 2:
                           {
                               [_status setTitle:@"审核中..." forState:UIControlStateNormal];
                               _status.enabled = NO;
                               _status.backgroundColor = CustomlightPurple;
                               [_status getShadowOffset:CGSizeMake(1, 1) shadowRadius:ScaleW(3) shadowColor:CustomlightPurple shadowOpacity:.6 cornerRadius:ScaleW(3) masksToBounds:NO];
                           }
                               break;
                           case 3:
                           {
                               [_status setTitle:@"产品已代理" forState:UIControlStateNormal];
                               _status.enabled = NO;
                               _status.backgroundColor = CustomlightPurple;
                               [_status getShadowOffset:CGSizeMake(1, 1) shadowRadius:ScaleW(3) shadowColor:CustomlightPurple shadowOpacity:.6 cornerRadius:ScaleW(3) masksToBounds:NO];
                           }
                               break;
                           default:
                               break;
                       }

                       
                       
                       [_header endRefreshing];
                   }
                          failure:^(NSString *msg, NSString *state)
                   {
                       [self.view makeToast:msg];
                       [_header endRefreshing];
                       
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
                               [AbnormalView setRect:_scrollView.frame toView:_scrollView abnormalType:kError];
                               [AbnormalView setDelegate:self toView:_scrollView];
                           }
                           else
                           {
                               [AbnormalView hideHUDForView:_scrollView];
                           }
                       }
                   }];
}


#pragma mark - 收藏接口
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

    
    if (button.selected) {
        [self.view makeToast:@"已收藏"];
        return;
    }
    button.selected = !button.selected;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = @"1";
    params[@"id"] =  _dic[@"id"];
    params[@"userid"] =  [Infomation readInfo]?[Infomation readInfo][@"id"]:@"";
    
    _connection = [BaseModel POST:submitcollectServlet parameter:params class:[BaseModel class]
                          success:^(id data)
                   {
                       [self.view makeToast:@"收藏成功"];

                       
                   }
                          failure:^(NSString *msg, NSString *state)
                   {
                       [self.view makeToast:msg duration:.5 position:@"center"];
                   }];
    
}

#pragma mark - 申请代理
- (void)eventWithStatus
{
 
    if (![Infomation readInfo])
    {
        
        [self gotoLogingWithSuccess:^(BOOL isSuccess)
         {
             
             if (isSuccess)
             {
                 [self.view makeToast:@"登录成功" duration:.5 position:@"center"];
             }
         }class:@"LoginViewController"];
        return;
    }
    [MBProgressHUD showMessag:Loding_text1 toView:self.view];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"productid"] =  _datas[@"id"];
    params[@"userid"] =  [Infomation readInfo]?[Infomation readInfo][@"id"]:@"";
    
    _connection = [BaseModel POST:agentproductServlet parameter:params class:[BaseModel class]
                          success:^(id data)
                   {
                      

                       [_status setTitle:@"审核中..." forState:UIControlStateNormal];
                       _status.enabled = NO;
                       _status.backgroundColor = CustomlightPurple;
                       [_status getShadowOffset:CGSizeMake(1, 1) shadowRadius:ScaleW(3) shadowColor:CustomlightPurple shadowOpacity:.6 cornerRadius:ScaleW(3) masksToBounds:NO];
                      
                       [self.view makeToast:@"申请成功" duration:.5 position:@"center"];
                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                       
                   }
                          failure:^(NSString *msg, NSString *state)
                   {
               
                       [MBProgressHUD hideHUDForView:self.view animated:YES];

                       [self.view makeToast:msg duration:.5 position:@"center"];
                  
                   
                   }];
    
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
        message.title = [Base64 textFromBase64String:_dic[@"protitle"]];
//        message.description = @"微信";
        [message setThumbImage:[UIImage imageNamed:@"shareThumbImage.png"]];
        
        WXWebpageObject *ext = [WXWebpageObject object];

        ext.webpageUrl = [NSString stringWithFormat:@"http://121.199.55.224:8080/beauty/news/share?id=%@",_dic[@"id"]];
        
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
        message.title = [Base64 textFromBase64String:_dic[@"protitle"]];
//        message.description = @"微信";
        NSLog(@"%@",_dic);
        [message setThumbImage:[UIImage imageNamed:@"shareThumbImage.png"]];
        
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = [NSString stringWithFormat:@"http://121.199.55.224:8080/beauty/news/share?id=%@",_dic[@"id"]];
        
        message.mediaObject = ext;
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneTimeline;
        
        [WXApi sendReq:req];
        
    }
    
}


//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self.navigationController  setToolbarHidden:NO animated:YES];
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//
//    [self.navigationController  setToolbarHidden:YES animated:YES];
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
