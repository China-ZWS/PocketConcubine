

//
//  StartViewController.m
//  PocketConcubine
//
//  Created by 周文松 on 15/8/1.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "StartViewController.h"
#import "GuideViewController.h"
#import "MainTabBar.h"

@interface StartViewController ()
<GuideViewControllerDelegate>
{
    UIViewController *_currentView;
    NSArray *_arrays;
}
@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _arrays = [self createArrays];
    
    [self initWithController];
    // Do any additional setup after loading the view.
}

- (void)initWithController
{
    //判断是不是第一次启动应用

    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
    {
        UIViewController *newController = self.childViewControllers[1];

        [self transitionFromViewController:_currentView toViewController:newController duration:0 options:UIViewAnimationOptionTransitionNone animations:^{
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            [self.view addSubview:newController.view];
            [self.view bringSubviewToFront:newController.view];
            
        }  completion:^(BOOL finished) {
            _currentView = newController;
        }];

    }
    else
    {
        NSLog(@"不是第一次启动");
        UIViewController *newController = self.childViewControllers[0];
        [self.view addSubview:_currentView.view];
        [self.view bringSubviewToFront:newController.view];
    }
    
}

- (void)changeViewController
{
    UIViewController *newController = self.childViewControllers[0];
    NSLog(@"周文松");
    [self transitionFromViewController:_currentView toViewController:newController duration:1.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [self.view bringSubviewToFront:newController.view];
        
    }  completion:^(BOOL finished) {
        _currentView = newController;
    }];
    

}



- (NSArray *)createArrays
{
    NSMutableArray *controllers=[NSMutableArray array];
    
    for (int i = 0 ; i < 2; i ++)
    {
        UIViewController *controller;
        switch (i) {
            case 0:
            {
                controller=[MainTabBar new];
//                [self.view addSubview:controller.view];
                [controllers addObject:controller];
                [self addChildViewController:controller];
                _currentView = controller;
            }
                break;
            case 1:
            {
                controller = [GuideViewController new];
                GuideViewController *ctr = (GuideViewController *)controller;
                ctr.delegate = self;
                [controllers addObject:controller];
                [self addChildViewController:controller];
            }
                break;
                
            default:
                break;
        }
        
    }
    
    return controllers;
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
