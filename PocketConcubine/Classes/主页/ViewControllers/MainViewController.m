//
//  MainViewController.m
//  PocketConcubine
//
//  Created by 周文松 on 15-4-28.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "MainViewController.h"
#import "MJRefreshHeaderView.h"
#import "BannerView.h"
#import "MainCell.h"

#import "NewMoreViewController.h" //新闻更多
#import "NewDetailsViewController.h" //新闻详情

#import "ActivityMainViewController.h" //活动
#import "EventsViewController.h"  //互动预告
#import "NewActivitysViewController.h" //最新活动
#import "ActivityDetailsViewController.h" //活动详情


#import "DeputyViewController.h"
#import "ProductDetailsViewController.h"
#import "ClassDetailsViewController.h"

#import "QRcodeView.h"
#import "CAlertView.h"

@interface MainViewController ()
<MJRefreshBaseViewDelegate, AbnormalViewDelegate>
{
    MJRefreshHeaderView *_header;
    BannerView *_bannerView;
    NSDictionary *_datas;
}
@end

@implementation MainViewController

- (id)init
{
    if ((self = [super init]))
    {
        [self.navigationItem setNewTitle:@"赢销商学院"];
    }
    return self;
}

- (UIView *)createHeaderView
{
    if (!_bannerView)
    {
        MainViewController __weak*safeSelf = self;
        _bannerView = [[BannerView alloc] initWithSelect:^(id data)
                       {
                           [safeSelf pushViewWithDatas:data];
                       }];
    }
    _bannerView.isStop = YES;
    return _bannerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _header = [MJRefreshHeaderView header];
    _header.scrollView = _table;
    _header.delegate = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _table.tableHeaderView = [self createHeaderView];
 
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_header beginRefreshing];
        
    });
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _datas.count?_datas.count - 1:0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ScaleH(30);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton *header = [UIButton new];
    header.backgroundColor = CustomAlphaBlue;
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(defaultInset.right, (ScaleH(30) - ScaleH(25)) / 2, DeviceW - defaultInset.right - defaultInset.right, ScaleH(25))];
    title.font = FontBold(15);
    title.textColor = CustomBlue;
    switch (section) {
        case 0:
            title.text = @"行业动态:";
            break;
        case 1:
            title.text = @"直播课堂:";
            break;
        default:
            break;
    }
    
    UIImage *image = [UIImage imageNamed:@"icon_small-purple.png"];
    UIImageView *nextView = [[UIImageView alloc] initWithFrame:CGRectMake(DeviceW - defaultInset.right - image.size.width, (ScaleH(30) - image.size.height) / 2, image.size.width, image.size.height)];
    nextView.userInteractionEnabled = YES;
    nextView.image = image;
    [header addSubview:title];
    [header addSubview:nextView];
    [header addTarget:self action:@selector(eventWithHeader:) forControlEvents:UIControlEventTouchUpInside];
    header.tag = section;
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return [_datas[@"news"] count];
    }
    else
    {
        return [_datas[@"activitys"] count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return ScaleH(80);
    }
    else if (indexPath.section == 1)
    {
        return ScaleH(60);
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    MainCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[MainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    switch (indexPath.section) {
        case 0:
            [cell setDatas:_datas[@"news"][indexPath.row] type:kNews];
            break;
        case 1:
            [cell setDatas:_datas[@"activitys"][indexPath.row] type:kActivitys];
            break;

        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        NSString *idStr = _datas[@"news"][indexPath.row][@"newCode"];
        [self pushViewController:[[NewDetailsViewController alloc] initWithDatas:@{@"id":idStr}]];
    }
    else
    {
        NSString *idStr = _datas[@"activitys"][indexPath.row][@"activityCode"];
        [self pushViewController:[[ActivityDetailsViewController alloc] initWithDatas:@{@"id":idStr} type:kNew]];
    }
}

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView;
{
    [self.view endEditing:YES];
    _connection = [BaseModel POST:firstPageServlet parameter:nil   class:[BaseModel class]
                          success:^(id data)
                   {
                       _datas = data[@"data"];
                       _bannerView.isStop = YES;
                       _bannerView.data = _datas[@"adverts"];
                       
                       if (!_datas.count)
                       {
                           [AbnormalView setRect:_table.frame toView:_table abnormalType:NotDatas];
                           [AbnormalView setDelegate:self toView:_table];
                       }
                       else
                       {
                           [AbnormalView hideHUDForView:self.table];
                           [self reloadTabData];
                       }

                       [_header endRefreshing];
                   }
                          failure:^(NSString *msg, NSString *state)
                   {
                       [_header endRefreshing];
                       if ([state isEqualToString:kNetworkAnomaly])
                       {
                           if (!_datas.count)
                           {
                               [AbnormalView setRect:_table.frame toView:_table abnormalType:NotNetWork];
                               [AbnormalView setDelegate:self toView:_table];
                           }
                           else
                           {
                               [AbnormalView hideHUDForView:self.table];
                           }
                           
                       }
                       else
                       {
                           if (!_datas.count)
                           {
                               [AbnormalView setRect:_table.frame toView:_table abnormalType:kError];
                               [AbnormalView setDelegate:self toView:_table];
                           }
                           else
                           {
                               [AbnormalView hideHUDForView:self.table];
                           }
                           
                       }

                   }];
}

- (void)refreshWithViews
{
    
}

- (void)eventWithHeader:(UIButton *)button
{
    switch (button.tag) {
        case 0:
            [self pushViewController:[NewMoreViewController new]];
            break;
        case 1:
        {
            NSArray *viewControllers = @[[EventsViewController new], [NewActivitysViewController new]];
            ActivityMainViewController *controller = [[ActivityMainViewController alloc] initWithViewControllers:viewControllers];
            [self pushViewController:controller];

        }
            break;
        default:
            break;
    }
}

- (void)pushViewWithDatas:(NSDictionary *)data
{
 
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

- (void)viewWillAppear:(BOOL)animated
{
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
