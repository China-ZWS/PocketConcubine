//
//  ProductSearchViewController.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-23.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "ProductSearchViewController.h"

@interface ProductSearchViewController ()

@end

@implementation ProductSearchViewController
- (id)initWithKeywords:(NSString *)keywords classesid:(NSString *)classesid subclassesid:(NSString *)subclassesid;
{
    if ((self = [super initWithTableViewStyle:UITableViewStyleGrouped]))
    {
//        _datas = [NSMutableArray array];
        _keywords = keywords;
        _classesid = classesid;
        _subclassesid = subclassesid;
        [self.navigationItem setNewTitle:@"微课堂筛选"];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"back.png"];
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}

- (void)back
{
    [self popViewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)refreshDatas:(NSString *)keywords classesid:(NSString *)classesid subclassesid:(NSString *)subclassesid
{
    
    [super refreshDatas:_keywords classesid:_classesid subclassesid:_subclassesid];
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
