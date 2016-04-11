

//
//  DataConfigManager.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-3-13.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "DataConfigManager.h"


@implementation DataConfigManager

+ (NSDictionary *)returnRoot
{
    NSString *path=[[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"];
    NSDictionary *root=[[NSDictionary alloc] initWithContentsOfFile:path];
    return root;
}

#pragma 得到本地tabbar 数据
+(NSArray *)getMainConfigList;
{
    
    NSDictionary * root = [self returnRoot];
    NSArray *data=[[NSArray alloc] initWithArray:[root objectForKey:@"MainTab"]];
    return data;
}

#pragma 得到本地设置数据
+ (NSArray *)getSetConfigList;
{
    NSDictionary * root = [self returnRoot];
    NSArray *data=[[NSArray alloc] initWithArray:[root objectForKey:@"Set"]];
    return data;
}

#define 得到我的数据
+ (NSArray *)getMineList;
{
    NSDictionary * root = [self returnRoot];
    NSArray *data=[[NSArray alloc] initWithArray:[root objectForKey:@"Mine"]];
    return data;

}






@end
