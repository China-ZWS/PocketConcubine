//
//  EventsViewController.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-5.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "EventsViewController.h"
#import "EventsCell.h"
#import "ActivityDetailsViewController.h"

@interface EventsViewController ()
<EventsCellDelegate, AbnormalViewDelegate>
{
    NSMutableArray *_times;
    NSTimer *_timer;
}
@end

@implementation EventsViewController

- (id)init
{
    if ((self = [super init])) {
        _times = [NSMutableArray array];
        self.title = @"直播预告";
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
//    不可取的方法，内存消耗严重，给每个Cell上Timer更可取
//    if (!_timer) {
//        _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
//        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:UITrackingRunLoopMode];
//    }
//
    // Do any additional setup after loading the view.
}

/*
- (void)timerFireMethod:(NSTimer *)timer
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    
    for (int i = 0; i < _times.count; i ++)
    {
        NSDictionary *dic = _times[i];
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        NSDate *fireDate=[dateFormatter dateFromString:dic[@"begintime"]];
        NSDate *today = [NSDate date];当前时间
        NSDate *compareDate = [fireDate earlierDate:today];
        if (![compareDate isEqualToDate:today])
        {
            [_times removeObjectAtIndex:i];
            [_datas removeObjectAtIndex:i];
            [_table deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
            i --;
                        [self reloadTabData];
            continue;
        }
 
        unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        
        NSDateComponents *d = [calendar components:unitFlags fromDate:today toDate:fireDate options:0];//计算时间差
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        EventsCell *cell = (EventsCell *)[_table cellForRowAtIndexPath:indexPath];
        cell.textLb.text = [NSString stringWithFormat:@"%d小时%d分%d秒", [d hour], [d minute], [d second]];//倒计时显示
    }
}
*/


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"icellIdentifier";
    EventsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[EventsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.delegate = self;
    }
    
    cell.datas = _datas[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self pushViewController:[[ActivityDetailsViewController alloc] initWithDatas:_datas[indexPath.row] type:kForeshow]];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventsCell * eventsCell = (EventsCell *)cell;
    [eventsCell.timer invalidate];
    eventsCell.timer = nil;
}


- (void)timeOut:(EventsCell *)cell
{
    
    NSIndexPath *indexPath = [_table indexPathForCell:cell];
    
//    [_times removeObjectAtIndex:indexPath.row];
    [_datas removeObjectAtIndex:indexPath.row];
    
   
    [_table beginUpdates];
    [_table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [_table endUpdates];
    
    
}



- (void)refreshDatas
{
    [self.view endEditing:YES];
    
    [self clearWifhTimer];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = @"1";
    
    _connection = [BaseModel POST:activityServlet parameter:params   class:[BaseModel class]
                          success:^(id data)
                   {
                       NSMutableArray *temps = [NSMutableArray arrayWithArray:data[@"data"][@"ygactivitys"]];
                                             
                       _datas = temps;
                       
                       
                       for (int i = 0; i < _datas.count; i ++)
                       {
                           
                           NSDate *now = [NSDate date];
                           NSDate *date = [now dateByAddingTimeInterval:i*3];
                           NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
                           [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                           NSString *dateString = [dateFormatter stringFromDate:date];
                           [_times addObject:@{@"begintime":dateString,@"activitytitle":@"6LefOOS9jeWls+aYn+WtpiA05q2l5omT6YCg5YGP5YiG5Y235Y+R"}];
                       }
                       
                       
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

- (void)clearWifhTimer
{
    NSArray *cells = _table.visibleCells;
    for (EventsCell *cell in cells)
    {
        if (cell.timer) {
            [cell.timer invalidate];
            cell.timer = nil;
        }
     }
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
