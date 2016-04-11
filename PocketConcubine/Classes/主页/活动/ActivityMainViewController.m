//
//  ActivityMainViewController.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-5.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "ActivityMainViewController.h"

@interface ActivityMainViewController ()

@end

@implementation ActivityMainViewController

- (id)initWithViewControllers:(NSArray *)viewControllers
{
    if ((self = [super initWithViewControllers:viewControllers]))
    {
        [self.navigationItem setNewTitle:@"直播课堂"];
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
    
    self.backgroudColor = [UIColor whiteColor];
    self.lineColor = CustomBlue;
    self.selectedTitleColor = CustomBlue;
    self.titleColor = CustomGray;
    
    
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
