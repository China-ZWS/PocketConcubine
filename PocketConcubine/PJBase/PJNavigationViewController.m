//
//  PJNavigationViewController.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-19.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "PJNavigationViewController.h"
#import "ClassDetailsViewController.h"
@interface PJNavigationViewController ()

@end

@implementation PJNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}

-(BOOL)shouldAutorotate
{
    return YES;
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