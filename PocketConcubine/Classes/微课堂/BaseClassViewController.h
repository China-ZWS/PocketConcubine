//
//  BaseClassViewController.h
//  PocketConcubine
//
//  Created by 周文松 on 15-5-21.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "PJTableViewController.h"

@interface BaseClassViewController : PJTableViewController
<MJRefreshBaseViewDelegate>
{
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    NSInteger _currentPage;
    NSString  *_keywords;
    NSString *_classesid;
    NSString *_subclassesid;
    NSMutableArray *_datas;
}

- (void)refreshDatas:(NSString *)keywords classesid:(NSString *)classesid subclassesid:(NSString *)subclassesid;

@end
