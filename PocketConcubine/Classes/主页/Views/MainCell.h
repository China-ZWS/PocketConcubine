//
//  MainCell.h
//  PocketConcubine
//
//  Created by 周文松 on 15-5-4.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "PJCell.h"
typedef NS_ENUM(NSInteger, MainCellType)
{
    kNews = 0,//新闻
    kActivitys = 1 << 0//活动
};

@interface MainCell : PJCell
{
    MainCellType _type;
}
- (void)setDatas:(NSDictionary *)datas type:(MainCellType)type;
@end
