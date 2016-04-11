//
//  PDFooterView.h
//  PocketConcubine
//
//  Created by 周文松 on 15-5-17.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFooterView : UIView
<UICollectionViewDataSource, UICollectionViewDelegate>
{
    UICollectionView *_collectionView;
    NSDictionary*_datas;
    UILabel *_title;
    void (^_selected)(id data);
    void (^_finishOffset)();
}
- (id)initWithFrame:(CGRect)frame finishOffset:(void(^)())finishOffset selected:(void(^)(id data))selected;
@property (nonatomic, strong) id datas;


@end
