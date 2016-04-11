//
//  SetViewController.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-15.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "SetViewController.h"
#import "MainTabBar.h"
#import "SetCell.h"
#import "SDImageCache.h"

@interface SetViewController ()
{
    NSArray *_datas;
}
@end

@implementation SetViewController

- (id)init
{
    if ((self = [super initWithTableViewStyle:UITableViewStyleGrouped]))
    {
        [self.navigationItem setNewTitle:@"我的设置"];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"back.png"];
        self.hidesBottomBarWhenPushed=YES;
        _datas = [DataConfigManager getSetConfigList];
    }
    return self;
}

- (void)back
{
    [self popViewController];
}

- (UIView *)getFootView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceW, ScaleH(55))];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(defaultInset.left, ScaleH(10), CGRectGetWidth(self.table.frame) - defaultInset.left * 2, ScaleH(50));
    button.backgroundColor = CustomBlue;
    button.titleLabel.font = Font(18);
    [button setTitle:@"退 出" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(eventWithExit) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    return view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_table registerClass:[SetCell class] forCellReuseIdentifier:@"cellIdentifier"];
    _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _table.tableFooterView = [self getFootView];

//    [_table setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _datas.count ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_datas[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ScaleH(20);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return ScaleH(10);
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScaleH(60);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    SetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    if (!cell) {
        cell = [[SetCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *datas = _datas[indexPath.section][indexPath.row];
    cell.textLabel.text = datas[@"title"];
    if (indexPath.section != 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    

    
       if (indexPath.section == 2) {
        if (indexPath.row == 1) {
            NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@","];
            NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
            NSString *oldVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
            oldVersion = [@"V " stringByAppendingString:[oldVersion stringByTrimmingCharactersInSet:set]];
//            CGSize size = [NSObject getSizeWithText:oldVersion font:Font(15) maxSize:CGSizeMake(MAXFLOAT, Font(15).lineHeight)];
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScaleW(50), 50)];
            title.backgroundColor = [UIColor clearColor];
            title.font = Font(15);
            title.textColor = CustomGray;
            title.text = oldVersion;
            cell.accessoryView = title;
        }
        else if (indexPath.row == 0)
        {
            
            NSString *text = [NSString stringWithFormat:@"占用：%.2f M",(CGFloat)[[SDImageCache sharedImageCache] getSize] / (1024 * 1024)];
//            CGSize size = [NSObject getSizeWithText:text font:Font(15) maxSize:CGSizeMake(MAXFLOAT, Font(15).lineHeight)];
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScaleW(120), 50)];
            title.backgroundColor = [UIColor clearColor];
            title.font = Font(15);
            title.textColor = CustomGray;
            title.text = text;
            cell.accessoryView = title;
        }
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [[SDImageCache sharedImageCache] clearDisk];
            [[SDImageCache sharedImageCache] clearMemory];
            
            [self.view makeToast:@"清除成功" duration:.5 position:@"center"];
            [self reloadTabData];
            return;
        }
    }
    NSDictionary *datas = _datas[indexPath.section][indexPath.row];
    Class class = NSClassFromString(datas[@"class"]);
    id viewController = [class new];
    [self pushViewController:viewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 退出
- (void)eventWithExit
{
    [Infomation deleteInfo];
    [(MainTabBar *)self.tabBarController setSelected:0];
    NSNotificationPost(RefreshWithViews, nil, nil);
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
