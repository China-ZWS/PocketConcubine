//
//  PJTableViewController.h
//  GrowingSupermarket
//
//  Created by 周文松 on 15-3-18.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "BaseTableViewController.h"
#import "MJRefresh.h"
@interface PJTableViewController : BaseTableViewController
- (id)initWithTableViewStyle:(UITableViewStyle)style;

- (UIView *)addHeader;
- (UIView *)addFooter;

@end
