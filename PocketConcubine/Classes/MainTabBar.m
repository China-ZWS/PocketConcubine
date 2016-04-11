//
//  MainTabBar.m
//  PocketConcubine
//
//  Created by 周文松 on 15-4-28.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "MainTabBar.h"
#import "MainViewController.h"
#import "ClassViewController.h"
#import "ProductViewController.h"
#import "MineViewController.h"
#import "PJNavigationBar.h"
#import "PJNavigationViewController.h"


@interface MainTabBar ()
<UITabBarControllerDelegate>
{
    NSArray *_tabConfigList;
    NSInteger _currentIndex;
}
@end

@implementation MainTabBar

- (void)dealloc
{
    NSLog(@"dealloc = %@", [self class]);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.delegate = self;
    }
    return self;
}


#pragma mark - 设备bar背景颜色
- (UIImage *)createTabBarBk
{
    UIImage *image = [UIImage imageNamed:@"tabBar_back"];
    CGFloat top = 3; // 顶端盖高度
    CGFloat bottom = 1 ; // 底端盖高度
    CGFloat left = 1; // 左端盖宽度
    CGFloat right = 1; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    image = [image resizableImageWithCapInsets:insets ];
    
    return image;
}

- (NSArray *)createTabItemArr
{
    _tabConfigList = [DataConfigManager getMainConfigList];
    NSMutableArray *item = [NSMutableArray array];
    for (int i = 0; i < _tabConfigList.count; i ++)
    {
        switch (i) {
            case 0:
            {
                MainViewController *item0 = [[MainViewController alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithNavigationBarClass:[PJNavigationBar class] toolbarClass:nil];
                nav.viewControllers = @[item0];
                [item addObject:nav];
                
            }
                break;
            case 1:
            {
                
                ClassViewController *item1 = [[ClassViewController alloc] init];
                PJNavigationViewController *nav = [[PJNavigationViewController alloc] initWithNavigationBarClass:[PJNavigationBar class] toolbarClass:nil];
                nav.viewControllers = @[item1];
                [item addObject:nav];

            }
                break;
            case 2:
            {
                ProductViewController *item2 = [[ProductViewController alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithNavigationBarClass:[PJNavigationBar class] toolbarClass:nil];
                nav.viewControllers = @[item2];
                [item addObject:nav];
                
            }
                break;
            case 3:
            {
                MineViewController *item3 = [[MineViewController alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithNavigationBarClass:[PJNavigationBar class] toolbarClass:nil];
                nav.viewControllers = @[item3];
                [item addObject:nav];
                
            }
                break;
              default:
                break;
        }
        
    }
    return item;

}


- (void)createTabItemBk:(NSInteger)items;
{
    
    for (int i = 0; i < items; i ++)
    {
        NSDictionary *dict = [_tabConfigList objectAtIndex:i];
        [[self.tabBar.items objectAtIndex:i] setFinishedSelectedImage:[[UIImage imageNamed:[dict objectForKey:@"highlightedImage"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]  withFinishedUnselectedImage:[[UIImage imageNamed:[dict objectForKey:@"image"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]];
        
        [(UITabBarItem *)[self.tabBar.items objectAtIndex:i] setTitle:[dict objectForKey:@"title"]];
        [[self.tabBar.items objectAtIndex:i] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:CustomGray,NSForegroundColorAttributeName,FontBold(12),NSFontAttributeName,nil] forState:UIControlStateNormal];
//
        [(UITabBarItem *)[self.tabBar.items objectAtIndex:i] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:CustomBlue,NSForegroundColorAttributeName,FontBold(12),NSFontAttributeName,nil] forState:UIControlStateSelected];
        
        /* You may specify the font, text color, text shadow color, and text shadow offset for the title in the text attributes dictionary, using the keys found in UIStringDrawing.h. */
        //        - (void)setTitleTextAttributes:(NSDictionary *)attributes forState:(UIControlState)state NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
        //        其中作为attributes的字典参数，要获取有哪些可以的话可以参照下面这句。
        //        [self.tabBarItem setTitleTextAttributes:@{ UITextAttributeTextColor : [UIColor whiteColor] } forState:UIControlStateNormal];
//                [NSValue valueWithCGSize:CGSizeMake(0.5, .5)] , UITextAttributeTextShadowOffset ,kUIColorFromRGB(0xFFFFFF) ,UITextAttributeTextShadowColor ,
        //        这里是修改颜色的，你可以用UITextAttributeFont来修改字体。
//        [(UITabBarItem *)[self.tabBar.items objectAtIndex:i] setImageInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
//
//        [(UITabBarItem *)[self.tabBar.items objectAtIndex:i] setTitlePositionAdjustment:UIOffsetMake(0, - 3)];

    }
//    self.tabBar.selectionIndicatorImage = [[NSObject drawrWithImage:CGSizeMake(CGRectGetWidth(self.tabBar.frame) / _tabConfigList.count, CGRectGetHeight(self.tabBar.frame)) backgroundColor:RGBA(23, 103, 223, 1)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabBar setBackgroundImage:[self createTabBarBk] ];    /*设置Bar的背景颜色*/
    self.viewControllers = [self createTabItemArr];     /*设置Bar的items*/
    [self createTabItemBk:self.viewControllers.count];     /*设置Bar的item的背景及Title*/
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;
{
    
    UINavigationController *nav = (UINavigationController *)viewController;
    
    if ([nav.viewControllers[0] isKindOfClass:[MineViewController class]])
    {
        BaseViewController *controller = (BaseViewController *)nav.viewControllers[0];
        if (![Infomation readInfo])
        {
            
            [controller gotoLogingWithSuccess:^(BOOL isSuccess)
             {
                 
                 if (isSuccess)
                 {
                     [self.view makeToast:@"登录成功"];
                     _currentIndex = self.selectedIndex;
                     NSNotificationPost(RefreshWithViews, nil, nil);
                 }
                 else
                 {
                     self.selectedIndex = _currentIndex;
                 }
             }
                                        class:@"LoginViewController"];
        }
    }
    else
    {
        _currentIndex = self.selectedIndex;
    }
    
}

- (void)setSelected:(NSInteger)index;
{
    _currentIndex = 0;
    self.selectedIndex = index;
    
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
