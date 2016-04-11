//
//  PublicActivityListViewController.h
//  PocketConcubine
//
//  Created by 周文松 on 15-5-5.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "PJTableViewController.h"

@interface PublicActivityListViewController : PJTableViewController
<MJRefreshBaseViewDelegate>
{
    MJRefreshHeaderView *_header;
    NSMutableArray *_datas;
}
@end
