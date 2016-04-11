
//
//  GuideViewController.m
//  PocketConcubine
//
//  Created by 周文松 on 15/8/1.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "GuideViewController.h"

@interface GuideViewController ()
{
//    UIScrollView *_scrollView;
}

@end

@implementation GuideViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:scrollView.frame];
    imgView.image = [UIImage imageNamed:@"750-1334_s.png"];
    imgView.userInteractionEnabled = YES;
    [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)]];
    [scrollView addSubview:imgView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((DeviceW - ScaleW(60)) / 2, DeviceH - ScaleH(100), ScaleW(60), ScaleH(30));
    [button setTitle:@"启 动" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button getCornerRadius:ScaleW(3) borderColor:[UIColor whiteColor] borderWidth:1 masksToBounds:NO];
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.font = Font(13);
    [scrollView addSubview:button];
    button.enabled = NO;
    [self.view addSubview:scrollView];
}

- (void)singleTap
{
    [_delegate changeViewController];
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
