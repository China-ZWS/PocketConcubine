//
//  ClassFilterViewController.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-15.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "ClassFilterViewController.h"
#import "PJTableView.h"
#import "PJCell.h"
#import "ClassSearchViewController.h"

@interface ClassFilterCell :PJCell

@end

@implementation ClassFilterCell



@end

@interface ClassFilterViewController ()
<UITableViewDataSource, UITableViewDelegate, AbnormalViewDelegate>
{
    NSArray *_datas;
    PJTableView *_subClassesTab;
    PJTableView *_classesTab;
    NSInteger _classesIndex;
    NSString *_classesid;
    NSString *_subclassesid;
}
@end

@implementation ClassFilterViewController



- (id)init
{
    if ((self = [super init]))
    {
        self.hidesBottomBarWhenPushed=YES;
        [self.navigationItem setNewTitle:@"产品分类"];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"back.png"];
    }
    return self;
}

- (void)back
{
    [self popViewController];
}

- (UIButton *)setBtn
{
    UIButton *sure = [UIButton buttonWithType:UIButtonTypeCustom];
    sure.frame = CGRectMake(0, 0, DeviceW - defaultInset.left * 3, 35);
    sure.backgroundColor = CustomBlue;
    [sure setTitle:@"确 定" forState:UIControlStateNormal];
    [sure addTarget:self action:@selector(eventWithSure) forControlEvents:UIControlEventTouchUpInside];
    return sure;
}

- (void)loadView
{
    [super loadView];
    NSMutableArray *tbitems = [NSMutableArray array];
    UIBarButtonItem *sure = [[UIBarButtonItem alloc] initWithCustomView:[self setBtn]];
    [tbitems addObject:sure];
    [self setToolbarItems:tbitems];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _classesTab = [[PJTableView alloc] initWithFrame:CGRectMake(0, 0, DeviceW / 2, DeviceH) style:UITableViewStyleGrouped];
    _classesTab.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [_classesTab setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    _classesTab.separatorColor = CustomGray;
    _classesTab.delegate = self;
    _classesTab.dataSource = self;
    [self.view addSubview:_classesTab];
    
    NSInteger selectedIndex = 0;
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    [_classesTab selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
 
    if ([_classesTab.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        
        [_classesTab.delegate tableView:_classesTab didSelectRowAtIndexPath:selectedIndexPath];
        
    }
    
    _subClassesTab = [[PJTableView alloc] initWithFrame:CGRectMake(DeviceW / 2, 0, DeviceW / 2, DeviceH) style:UITableViewStyleGrouped];
    _subClassesTab.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [_subClassesTab setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    _subClassesTab.delegate = self;
    _subClassesTab.separatorColor = CustomGray;
    _subClassesTab.dataSource = self;
    [self.view addSubview:_subClassesTab];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _classesTab)
    {
        return _datas.count;
    }
    else
    {
        return [_datas[_classesIndex][@"subclasses"] count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.font = Font(15);
        cell.backgroundColor = [UIColor whiteColor];
        if (tableView == _classesTab) {
            UIView *aView = [[UIView alloc] initWithFrame:cell.contentView.frame];
            aView.backgroundColor = CustomAlphaBlue;
            cell.selectedBackgroundView = aView;   //设置选中后cell的背景颜色
        }
    }
    if (tableView == _classesTab) {
        cell.textLabel.text = [Base64 textFromBase64String:_datas[indexPath.row][@"cname"]];
        if ([_datas[indexPath.row][@"subclasses"] count]) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else
    {
        if (_classesid.length) {
            cell.backgroundColor = CustomAlphaBlue;
        }
        cell.textLabel.text = [Base64 textFromBase64String:_datas[_classesIndex][@"subclasses"][indexPath.row][@"subname"]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _classesTab)
    {
        if ([_classesid isEqualToString:_datas[indexPath.row][@"classid"] ]) {
            return;
        }
        _classesIndex = indexPath.row;
        _classesid = _datas[indexPath.row][@"classid"];
        _subclassesid = @"";
        [_subClassesTab reloadData];
    }
    else
    {
        if ([_subclassesid isEqualToString:_datas[_classesIndex][@"subclasses"][indexPath.row][@"subclassid"] ]) {
            return;
        }
        if (!_classesid.length) {
            _classesid = _datas[0][@"classid"];
            NSInteger selectedIndex = 0;
            NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
            [_classesTab selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        _subclassesid = _datas[_classesIndex][@"subclasses"][indexPath.row][@"subclassid"];
        [self eventWithSure];
    }
}



- (void)setUpDatas
{
    [MBProgressHUD showMessag:Loding_text1 toView:self.view];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = @"2";
    _connection = [BaseModel POST:classesServlet parameter:params   class:[BaseModel class]
                          success:^(id data)
                   {
                       
                       _datas = data[@"data"][@"classes"];
                       
                       [self reloadTabData];
                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                       
                       if (!_datas.count)
                       {
                           [AbnormalView setRect:CGRectMake(0, 49, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 49) toView:self.view abnormalType:NotDatas];
                           [AbnormalView setDelegate:self toView:self.view];
                       }
                       else
                       {
                           [AbnormalView hideHUDForView:self.view];
                       }
                   }
                          failure:^(NSString *msg, NSString *state)
                   {
                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                       if ([state isEqualToString:kNetworkAnomaly])
                       {
                           if (!_datas.count)
                           {
                               [AbnormalView setRect:CGRectMake(0, 49, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 49) toView:self.view abnormalType:NotNetWork];
                               [AbnormalView setDelegate:self toView:self.view];
                           }
                           else
                           {
                               [AbnormalView hideHUDForView:self.view];
                           }
                       }
                       else
                       {
                           if (!_datas.count)
                           {
                               [AbnormalView setRect:CGRectMake(0,  49, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 49) toView:self.view abnormalType:kError];
                               [AbnormalView setDelegate:self toView:self.view];                           }
                           else
                           {
                               [AbnormalView hideHUDForView:self.view];
                           }
                           
                       }
                       
                   }];

}

- (void)reloadTabData
{
    [_classesTab reloadData];
    [_subClassesTab reloadData];
}

- (void)eventWithSure
{
    
    if (_subclassesid.length || _classesid.length)
    {
        [self pushViewController:[[ClassSearchViewController alloc] initWithKeywords:@"" classesid:_classesid subclassesid:_subclassesid]];
    }
    else
    {
        [self.view makeToast:@"请选择分类" duration:.5 position:@"center"];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController  setToolbarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController  setToolbarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)abnormalReloadDatas
{
    [self setUpDatas];
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
