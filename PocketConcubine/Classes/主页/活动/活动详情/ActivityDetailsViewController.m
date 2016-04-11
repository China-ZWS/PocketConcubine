//
//  ActivityDetailsViewController.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-11.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "ActivityDetailsViewController.h"
#import "MJRefresh.h"
#import "ADContentView.h"
#import "ADFooterView.h"

#import "ActivityRegisterViewController.h"

#import "NewDetailsViewController.h"
#import "ProductDetailsViewController.h"
#import "ClassDetailsViewController.h"
#import "DeputyViewController.h"

#import "QRcodeView.h"
#import "CAlertView.h"

@interface ActivityDetailsViewController ()
<MJRefreshBaseViewDelegate,AbnormalViewDelegate>
{
    NSDictionary *_datas;
    NSMutableDictionary *_dic;
    
    MJRefreshHeaderView *_header;
    ActivityType _type;
}

@property (nonatomic, strong) ADHeaderView *adHeaderView;
@property (nonatomic, strong) ADContentView *contentView;
@property (nonatomic, strong) ADFooterView *adFooterView;
@end

@implementation ActivityDetailsViewController

- (void)dealloc
{
    [_header free];
}

- (void)back
{
    [self popViewController];
}


- (id)initWithDatas:(id)datas type:(ActivityType)type;
{
    if ((self = [super init])) {
        _datas = datas;
        _type = type;
        [self.navigationItem setNewTitle:@"直播课堂"];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"back.png"];
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}

#pragma mark - 加载头
- (UIView *)adHeaderView
{
    if (!_adHeaderView)
    {
        ActivityDetailsViewController __weak*safeSelf = self;
        _adHeaderView = [[ADHeaderView alloc] initWithFrame:CGRectMake(0, 0, DeviceW, ScaleH(80)) addActivity:^()
                         {
                             [safeSelf eventWithAddActivity];
                         }];
    }
    return _adHeaderView;
}

#pragma mark -加载内容
- (UIView *)contentView
{
    if (!_contentView)
    {
        ActivityDetailsViewController __weak*safeSelf = self;
        _contentView = [[ADContentView  alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_adHeaderView.frame), DeviceW, ScaleH(30)) finishOffset:^()
                        {
                            [safeSelf adjustmentWithRect];
                        }];
    }
    return _contentView;
}

#pragma mark -加载热门推荐
- (UIView *)adFooterView
{
    
    if (!_adFooterView) {
        ActivityDetailsViewController __weak*safeSelf = self;
        _adFooterView = [[ADFooterView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_contentView.frame), DeviceW, ScaleH(30)) finishOffset:^()
                         {
                             [safeSelf adjustmentWithRect];
                         } selected:^(id data)
                         {
                             [safeSelf getDatas:data];
                         }];
    }
    return _adFooterView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _header = [MJRefreshHeaderView header];
    _header.scrollView = _scrollView ;
    _header.delegate = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_header beginRefreshing];
    });
    _scrollView.scrollHeaderView = self.adHeaderView;
    [_scrollView addSubview:self.contentView];
    _scrollView.scrollFooterView = self.adFooterView;
}


- (void)adjustmentWithRect
{
 
    CGRect footRect = _adFooterView.frame;
    footRect.origin.y = CGRectGetMaxY(_contentView.frame);
    _adFooterView.frame = footRect;
    
    if (CGRectGetMaxY(_adFooterView.frame) > CGRectGetHeight(self.view.frame)) {
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame), CGRectGetMaxY(_adFooterView.frame));
    }
    else
    {
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame), CGRectGetHeight(self.view.frame) + 1);
    }    
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
    [_adHeaderView setDatas:_dic type:_type];
    _contentView.datas = _dic;
    _adFooterView.datas = _dic;
}


- (void)refreshDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"activityid"] =  _datas[@"id"];
    params[@"userid"] =  [Infomation readInfo]?[Infomation readInfo][@"id"]:@"";
    _connection = [BaseModel POST:activityInfoServlet parameter:params class:[BaseModel class]
                          success:^(id data)
                   {
                       
                       _dic = [NSMutableDictionary dictionaryWithDictionary:data[@"data"]];
                       
                       
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
        {
            _datas = data;
            _type = kNew;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_header beginRefreshing];
            });
        };
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

#pragma mark - 参加活动
- (void)eventWithAddActivity
{
    [self pushViewController:[[ActivityRegisterViewController alloc] initWithDatas:_dic success:^()
                              {
                                  [self  refreshDatas];
                              }]];
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
