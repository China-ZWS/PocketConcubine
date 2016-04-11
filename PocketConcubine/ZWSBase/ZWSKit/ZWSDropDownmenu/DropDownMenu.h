//
//  DropDownMenu.h
//  GrowingSupermarket
//
//  Created by 周文松 on 15-3-25.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DropDownMenuDelegate;


@protocol DropDownMenuDataSource;

@interface DropDownMenu : UIView

@property (nonatomic) id<DropDownMenuDelegate>delegate;
@property (nonatomic) id<DropDownMenuDataSource>dataSource;
@end

@protocol DropDownMenuDelegate <NSObject>

@end

@protocol DropDownMenuDataSource <NSObject>

@end