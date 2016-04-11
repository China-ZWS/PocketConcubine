//
//  ClassViewController.m
//  PocketConcubine
//
//  Created by 周文松 on 15-4-28.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "ClassViewController.h"
#import "ClassFilterViewController.h"
#import "ClassCell.h"
#import "ClassSearchViewController.h"


@interface ClassViewController ()
<UISearchDisplayDelegate,UISearchBarDelegate>
{
    UISearchDisplayController *_barCtr;
}
@end

@implementation ClassViewController

- (id)init
{
    if ((self = [super init]))
    {
        [self.navigationItem setNewTitle:@"微课堂"];
        [self.navigationItem setRightItemWithTarget:self title:nil action:@selector(right) image:@"icon_menu.png"];
     }
    return self;
}



- (void)right
{
    [self pushViewController:[ClassFilterViewController new]];
}

- (UIView *)addHeader
{
    UISearchBar *bar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, DeviceW, 44)];
    bar.delegate = self;
    bar.placeholder = @"搜索";
    bar.tintColor = [UIColor whiteColor];
    //初始化搜索控制器
    _barCtr =[[UISearchDisplayController alloc] initWithSearchBar:bar contentsController:self];
    _barCtr.delegate = self;
    //自带一个表格
    _barCtr.searchBar.barTintColor = CustomBlue;
    _barCtr.searchResultsDataSource = self;
    _barCtr.searchResultsDelegate = self;
    return bar;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _table.tableHeaderView = [self addHeader];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.table) {
        return [super numberOfSectionsInTableView:tableView];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.table) {
        return [super tableView:tableView numberOfRowsInSection:section];
    }else
    {
        // 谓词搜索
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@",searchDisplayController.searchBar.text];
//        filterData =  [[NSArray alloc] initWithArray:[_datas filteredArrayUsingPredicate:predicate]];
        return 5;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.table)
    {
       return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    else
    {
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.table) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    else
    {
        static NSString *cellIdentifier = @"searchIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
//        cell.textLabel.text = [NSString stringWithFormat:@"这是第几行%d",indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _table)
    {
        
        
        
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    else
    {
        
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
{
    
    [self pushViewController:[[ClassSearchViewController alloc] initWithKeywords:searchBar.text classesid:_classesid subclassesid:_subclassesid]];
    [_barCtr setActive:NO animated:YES];
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
