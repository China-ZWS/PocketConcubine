//
//  ActingRecordViewController.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-15.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "ActingRecordViewController.h"

@interface ActingRecordViewController ()
{
     
}
@end

@implementation ActingRecordViewController

- (id)initWithViewControllers:(NSArray *)viewControllers
{
    if ((self = [super initWithViewControllers:viewControllers]))
    {
        [self.navigationItem setNewTitle:@"代理产品"];
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
