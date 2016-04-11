//
//  BaseClassViewController.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-21.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "BaseClassViewController.h"
#import "ClassDetailsViewController.h"
#import "ClassCell.h"

#import "CAlertView.h"
#import "QRcodeView.h"

@interface BaseClassViewController ()
<AbnormalViewDelegate>
@end

@implementation BaseClassViewController

- (void)dealloc
{
    [_header free];
    [_footer free];
}

- (id)init
{
    if ((self = [super init])) {
        _datas = [NSMutableArray array];
        _keywords = @"";
        _classesid = @"";
        _subclassesid = @"";

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
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
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
  
    [self pushViewController:[[ClassDetailsViewController alloc] initWithDatas:_datas[indexPath.row]]];
}

- (UIView *)createQRcode
{
    QRcodeView *view = [[QRcodeView alloc] initWithFrame:CGRectMake(0, 0, DeviceW * 3 / 5,  ScaleH(44) + DeviceW * 3 / 5 )];
    return view;
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
    
    [self refreshDatas:_keywords classesid:_classesid subclassesid:_subclassesid];
}

- (void)refreshDatas:(NSString *)keywords classesid:(NSString *)classesid subclassesid:(NSString *)subclassesid;
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"find"] = keywords;
    params[@"classesid"] = _classesid;
    params[@"subclassid"] = _subclassesid;
    params[@"page"] = [NSString stringWithFormat:@"%d",_currentPage];
    params[@"pageSize"] = @"10";
    
    _connection = [BaseModel POST:revideoServlet parameter:params   class:[BaseModel class]
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
