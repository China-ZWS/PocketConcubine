//
//  BaseCollectionViewCell.h
//  GrowingSupermarket
//
//  Created by 周文松 on 15-3-23.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//


@interface BaseCollectionViewCell : UICollectionViewCell
{
    UIImageView *_imageView;
    UILabel *_title;
}
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *title;
@end
