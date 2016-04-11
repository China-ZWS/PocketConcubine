//
//  DataConfigManager.h
//  GrowingSupermarket
//
//  Created by 周文松 on 15-3-13.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//


@interface DataConfigManager : NSObject
+ (NSDictionary *)returnRoot;
+ (NSArray *)getMainConfigList;


/**
 *  @brief  获取设置列表本地数据
 *
 *  @return 返回设置列表本地数据
 */
+ (NSArray *)getSetConfigList;

+ (NSArray *)getMineList;

@end
