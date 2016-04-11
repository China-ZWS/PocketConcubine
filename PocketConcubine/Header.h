//
//  Header.h
//  PocketConcubine
//
//  Created by 周文松 on 15-4-28.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#ifndef PocketConcubine_Header_h
#define PocketConcubine_Header_h


#endif

#define RGBA(r,g,b,a)	[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a] //RGB颜色
/**
 *  @brief  与蓝色导航条一样的颜色
 */
#define CustomBlue RGBA(43, 189, 188, 1) //与蓝色导航条一样的颜色
#define CustomGreen RGBA(137,177,50,1) //绿色下载
#define CustomGray RGBA(160, 160, 160, 1) // 灰色
#define CustomBlack RGBA(110, 110, 110, 1) //自定义黑色
#define CustomDarkPurple RGBA(68, 60, 114, 1) // 紫色
#define CustomlightPurple RGBA(179,171,211,1) // 淡紫色
#define CustomAlphaBlue RGBA(43,189,188,.2) //透明紫色
#define CustomPurple RGBA(75, 55, 103, 1)


#define CustomPink RGBA(186, 59, 119, 1) //粉红
#define CustomlightPink RGBA(192,148,219,1) //淡粉红
#define Loding_text1 @"正在拉取数据"

#define kTop3Scale 2
#define kTop2Scale 1.5

//#define kTop3Scale (640.0 / 320.0)
//#define kTop2Scale (232.0 / 140.0)


#define kUserDefaults [NSUserDefaults standardUserDefaults]

//判断wifi
#define kSettingIsAllowWIFI  @"kSettingAllowWIFI"
//获取是否wifi
#define kISWIFI ([[NSUserDefaults standardUserDefaults] boolForKey:kSettingIsAllowWIFI])


#define NSNotificationAdd(Server,Sel,Name,Object) [[NSNotificationCenter defaultCenter] addObserver:Server selector:@selector(Sel) name:Name object:Object]
#define NSNotificationPost(name,Object,info) [[NSNotificationCenter defaultCenter] postNotificationName:name object:Object userInfo:info]

#define RefreshWithViews @"refreshWithViews"

#define Tool [ToolSingleton getInstance]
