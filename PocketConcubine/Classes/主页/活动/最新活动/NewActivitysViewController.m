//
//  NewActivitysViewController.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-5.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "NewActivitysViewController.h"
#import "NewActivitysCell.h"
#import "ActivityDetailsViewController.h"

@interface NewActivitysViewController ()
<AbnormalViewDelegate>
@end

@implementation NewActivitysViewController


- (id)init
{
    if ((self = [super init])) {
        self.title = @"最新直播";
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
     
    
    // Do any additional setup after loading the view.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    NewActivitysCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[NewActivitysCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.datas = _datas[indexPath.row];
          
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self pushViewController:[[ActivityDetailsViewController alloc] initWithDatas:_datas[indexPath.row] type:kNew]];
}

- (void)refreshDatas
{
    [self.view endEditing:YES];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = @"2";
    
    _connection = [BaseModel POST:activityServlet parameter:params   class:[BaseModel class]
                          success:^(id data)
                   {
                       NSMutableArray *temps = data[@"data"][@"zxactivitys"];
                       _datas = temps;
                       [self reloadTabData];
                       [_header endRefreshing];
                       
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
//                       [self.view makeToast:msg];
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

- (void)abnormalReloadDatas
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_header beginRefreshing];
    });
}




@end
