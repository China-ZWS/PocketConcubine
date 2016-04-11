//
//  newDetailsViewController.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-8.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "NewDetailsViewController.h"
#import "MJRefresh.h"
#import "NDHeaderView.h"
#import "NDContentView.h"
#import "NDFooterView.h"

#import "ProductDetailsViewController.h"
#import "ClassDetailsViewController.h"
#import "ActivityDetailsViewController.h"
#import "DeputyViewController.h"

#import "QRcodeView.h"
#import "CAlertView.h"

@interface NewDetailsViewController ()
<MJRefreshBaseViewDelegate, AbnormalViewDelegate>
{
    NSDictionary *_datas;
    NSDictionary *_dic;
    MJRefreshHeaderView *_header;
}
@property (nonatomic, strong) NDHeaderView *headerView;
@property (nonatomic, strong) NDContentView *contentView;
@property (nonatomic, strong) NDFooterView *footerView;
@end

@implementation NewDetailsViewController

- (void)dealloc
{
    [_header free];
}

- (void)back
{
    [self popViewController];
}


- (id)initWithDatas:(id)datas;
{
    if ((self = [super init])) {
        _datas = datas;
        [self.navigationItem setNewTitle:@"行业动态"];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"back.png"];
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}

#pragma mark 再加新闻标题与实践
- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[NDHeaderView alloc] initWithFrame:CGRectMake(0, 0, DeviceW, defaultInset.top + ScaleH(50))];
    }
    return _headerView;
}


- (UIView *)contentView
{
    if (!_contentView)
    {
        NewDetailsViewController __weak*safeSelf = self;
        _contentView = [[NDContentView  alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headerView.frame), DeviceW, 0) finishOffset:^()
                        {
                            [safeSelf adjustmentWithRect];
                        }];
    }
    return _contentView;
}

- (UIView *)footerView
{
    
    if (!_footerView) {
        NewDetailsViewController __weak*safeSelf = self;
        _footerView = [[NDFooterView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_contentView.frame), DeviceW, ScaleH(30)) finishOffset:^()
                         {
                             [safeSelf adjustmentWithRect];
                         } selected:^(id data)
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
    [_scrollView addSubview:self.contentView];
    _scrollView.scrollFooterView = self.footerView;
    

}

- (void)layoutViews
{
    _headerView.datas = _dic;
    _contentView.datas = _dic;
    _footerView.datas = _dic;
}


- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView;
{
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]])
    {
        [self refreshDatas];
    }
}

- (void)refreshDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"newsid"] =  _datas[@"id"];
   
    _connection = [BaseModel POST:newsInfoServlet parameter:params class:[BaseModel class]
                          success:^(id data)
                   {
                     
                       _dic = data[@"data"];
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
        {
            _datas = data;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_header beginRefreshing];
            });

        }
            break;
        case 2:
            [self pushViewController:[[ProductDetailsViewController alloc] initWithDatas:@{@"id":data[@"advertCode"]}]];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)abnormalReloadDatas
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_header beginRefreshing];
    });
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
