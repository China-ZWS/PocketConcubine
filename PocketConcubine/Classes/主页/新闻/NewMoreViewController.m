//
//  NewDetailsViewController.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-4.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "NewMoreViewController.h"
#import "NewMoreCell.h"
#import "NewDetailsViewController.h"

@interface NewMoreViewController ()
<MJRefreshBaseViewDelegate, AbnormalViewDelegate>
{
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    NSInteger _currentPage;
    NSMutableArray *_datas;
    UIImageView *_headerView;
    UILabel *_headerTitle;
}
@end

@implementation NewMoreViewController

- (void)dealloc
{
    [_header free];
    [_footer free];
}

- (id)init
{
    if ((self = [super init]))
    {
        [self.navigationItem setNewTitle:@"行业动态"];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"back.png"];
        self.hidesBottomBarWhenPushed=YES;
        _datas = [NSMutableArray array];
    }
    return self;
}

- (void)back
{
    [self popViewController];
}

- (UIView *)createHeaderView
{
   
    if (!_headerView) {
        _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DeviceW, DeviceW/2)];
        _headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_headerView.frame) - ScaleH(40) , DeviceW , ScaleH(40))];
        [_headerView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)]];
        _headerView.userInteractionEnabled = YES;
        _headerTitle.backgroundColor = RGBA(10, 10, 10, .6);
        _headerTitle.font = FontBold(10);
        _headerTitle.textColor = [UIColor whiteColor];
        _headerTitle.textAlignment = NSTextAlignmentCenter;
        [_headerView addSubview:_headerTitle];
    }
    
    _headerTitle.text = _datas.count?[Base64 textFromBase64String:_datas[0][@"newstitle"]]:@"";
    [_headerView sd_setImageWithURL:[NSURL URLWithString:_datas.count?_datas[0][@"backimg"]:nil] placeholderImage:[UIImage imageNamed:@"bk_5_2.png"]];
    return _headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _header = [MJRefreshHeaderView header];
    _header.scrollView = _table;
    _header.delegate = self;
    
    
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = _table;
    _footer.delegate = self;
    
    
    _table.tableHeaderView = [self createHeaderView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_header beginRefreshing];
    });
    

    // Do any additional setup after loading the view.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!_datas.count) {
        return 0;
    }
    return _datas.count - 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScaleH(80) + (defaultInset.top + defaultInset.bottom) * 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    NewMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[NewMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.datas = _datas[indexPath.row + 1];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self pushViewController:[[NewDetailsViewController alloc] initWithDatas:_datas[indexPath.row + 1]]];
}

- (void)singleTap:(UIGestureRecognizer*)gestureRecognizer

{
    
    [self pushViewController:[[NewDetailsViewController alloc] initWithDatas:_datas[0]]];
    
}

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView;
{
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]])
    {
        _currentPage = 1;
    }
    else
    {
        _currentPage ++;
    }
    [self refreshDatas];
}

- (void)refreshDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = [NSString stringWithFormat:@"%d",_currentPage];
    params[@"pagesize"] = @"10";

    _connection = [BaseModel POST:newsServlet parameter:params   class:[BaseModel class]
                          success:^(id data)
                   {
                       
                       if (![data[@"data"] count])
                       {
                           _currentPage --;
                       }
                       else
                       {
                           if (_currentPage == 1) {
                               [_datas removeAllObjects];
                           }
                           [_datas addObjectsFromArray:data[@"data"]];
                           [self createHeaderView];
                           [self reloadTabData];
                       }
                       [_header endRefreshing];
                       [_footer endRefreshingWithoutIdle];
//
                       if (!_datas.count)
                       {
                           [AbnormalView setRect:_table.frame toView:_table abnormalType:NotDatas];
                           [AbnormalView setDelegate:self toView:_table];
                       }
                       else
                       {
                           [AbnormalView hideHUDForView:self.table];
                       }
                       
                       
                   }
                          failure:^(NSString *msg, NSString *state)
                   {
                       [self.view makeToast:msg];
                       [_header endRefreshing];
                       [_footer endRefreshingWithoutIdle];
                       if (_datas.count)
                       {
                           _currentPage --;
                       }
                       
                       
                       if ([state isEqualToString:kNetworkAnomaly])
                       {
                           if (!_datas.count)
                           {
                               [AbnormalView setRect:CGRectMake(0, CGRectGetHeight(_headerView.frame), CGRectGetWidth(_table.frame), CGRectGetHeight(_table.frame) - CGRectGetHeight(_headerView.frame)) toView:_table abnormalType:NotNetWork];
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
