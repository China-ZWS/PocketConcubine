//
//  BaseProductViewController.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-23.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "BaseProductViewController.h"
#import "ProductDetailsViewController.h"
#import "ProductCell.h"

@interface BaseProductViewController ()
<AbnormalViewDelegate>
@end

@implementation BaseProductViewController

- (void)dealloc
{
    [_header free];
    [_footer free];
}

- (id)initWithTableViewStyle:(UITableViewStyle)style
{
    if ((self = [super initWithTableViewStyle:style])) {
        _datas = [NSMutableArray array];
        _keywords = @"";
        _classesid = @"";
        _subclassesid = @"";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.table.separatorColor = RGBA(230, 230, 230, 1);
    
    _header = [MJRefreshHeaderView header];
    _header.scrollView = _table;
    _header.delegate = self;
    
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = _table;
    _footer.delegate = self;
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_header beginRefreshing];
    });
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ScaleH(44);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return ScaleH(10);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor clearColor];
    
    NSDictionary *dic = _datas[section];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[dateFormatter dateFromString:dic[@"pretime"]];
    NSString *createTime = [NSObject compareCurrentTimeToPastTime:date];
    
    CGSize dateSize = [NSObject getSizeWithText:createTime font:Font(13) maxSize:CGSizeMake(200, ScaleH(13))];
    UILabel *dateLb = [[UILabel  alloc] initWithFrame:CGRectMake((DeviceW - dateSize.width - ScaleW(10)) / 2, ScaleH(44) - dateSize.height - ScaleW(5), dateSize.width + ScaleW(10), dateSize.height)];
    dateLb.text = createTime;
    dateLb.textAlignment = NSTextAlignmentCenter;
    dateLb.textColor = CustomGray;
    dateLb.font = Font(13);
    dateLb.backgroundColor = RGBA(220, 220, 220, 1);
    [headerView addSubview:dateLb];
    [dateLb getCornerRadius:ScaleH(3) borderColor:RGBA(220, 220, 220, 1) borderWidth:1 masksToBounds:YES];
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat titleHeight = FontBold(18).lineHeight; // 标题
    CGFloat contentHeigh = Font(15).lineHeight * 3; // 类容
    CGFloat inset = ScaleH(5);
    CGFloat allContentHeight = titleHeight + contentHeigh + inset;
    
    return allContentHeight + (defaultInset.top + defaultInset.bottom) * 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.datas = _datas[indexPath.section];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self pushViewController:[[ProductDetailsViewController alloc] initWithDatas:_datas[indexPath.row]]];
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
    params[@"find"] = _keywords;
    params[@"classesid"] = _classesid;
    params[@"subclassid"] = _subclassesid;
    params[@"page"] = [NSString stringWithFormat:@"%d",_currentPage];
    params[@"pageSize"] = @"10";
    
    _connection = [BaseModel POST:productServlet parameter:params   class:[BaseModel class]
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
