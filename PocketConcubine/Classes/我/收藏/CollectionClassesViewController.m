//
//  CollectionClassesViewController.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-24.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "CollectionClassesViewController.h"
#import "ClassCell.h"
#import "ClassDetailsViewController.h"

@interface CollectionClassesViewController ()
<MJRefreshBaseViewDelegate,AbnormalViewDelegate>
{
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    NSInteger _currentPage;
    NSMutableArray *_datas;
}
@end

@implementation CollectionClassesViewController

- (void)dealloc
{
    [_header free];
    [_footer free];
}

- (id)init
{
    if ((self = [super init])) {
        self.title = @"微课堂";
        _datas = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _header = [MJRefreshHeaderView header];
    _header.scrollView = _table;
    _header.delegate = self;
    
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = _table;
    _footer.delegate = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_header beginRefreshing];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScaleH(80) + (defaultInset.top + defaultInset.bottom) * 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    ClassCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ClassCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    cell.datas = _datas[indexPath.row];
//    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"ic_play_0%d.png",indexPath.row % 4]];
//    
//    cell.accView.frame = CGRectMake(DeviceW/2 - ((indexPath.row % 2)?(image.size.width * 3 / 2):(image.size.width / - 2)), (CGRectGetHeight(cell.headImageView.frame) - ScaleH(30) - image.size.height) / 2, image.size.width, image.size.height);
//    cell.accView.image = image;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self pushViewController:[[ClassDetailsViewController alloc] initWithDatas:_datas[indexPath.row]]];
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
    params[@"userid"] =  [Infomation readInfo]?[Infomation readInfo][@"id"]:@"";
    params[@"type"] = @"2";
//    params[@"page"] = [NSString stringWithFormat:@"%d",_currentPage];
//    params[@"pageSize"] = @"10";
    
    _connection = [BaseModel POST:usercollectServlet parameter:params   class:[BaseModel class]
                          success:^(id data)
                   {
                       
                       NSMutableArray *temps = data[@"data"];
                       
                       if (!temps.count)
                       {
                           _currentPage --;
                       }
                       else
                       {
                           if (_currentPage == 1) {
                               [_datas removeAllObjects];
                           }
                           [_datas addObjectsFromArray:temps];
                           [self reloadTabData];
                       }
                       [_header endRefreshing];
                       [_footer endRefreshingWithoutIdle];
                       
                       if (!_datas.count)
                       {
                           [AbnormalView setRect:_table.frame toView:_table abnormalType:NotDatas title:@"亲，赶快去收藏吧!"];
                           [AbnormalView setDelegate:self toView:_table];
                       }
                       else
                       {
                           [AbnormalView hideHUDForView:self.table];
                       }
                       
                       
                   }
                          failure:^(NSString *msg, NSString *state)
                   {
//                       [self.view makeToast:msg];
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

- (void)abnormalReloadDatas;
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_header beginRefreshing];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
