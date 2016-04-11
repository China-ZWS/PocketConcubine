//
//  PDFooterView.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-17.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "PDFooterView.h"
@interface PDFooterCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *title;
@end

@implementation PDFooterCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.contentView addSubview:self.imageView];
        [self.imageView addSubview:self.title];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    }
    return _imageView;
}

- (UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_imageView.frame) - ScaleH(25) , CGRectGetWidth(_imageView.frame) , ScaleH(25))];
        _title.backgroundColor = RGBA(10, 10, 10, .6);
        _title.font = FontBold(15);
        _title.textColor = [UIColor whiteColor];
        _title.textAlignment = NSTextAlignmentCenter;
    }
    return _title;
}

@end


@implementation PDFooterView

- (void)drawRect:(CGRect)rect
{
    if (_datas)
    {
        [self drawWithChamferOfRectangle:CGRectMake(0, 0, CGRectGetWidth(rect), ScaleH(30)) inset:UIEdgeInsetsMake(0, 0, 0, 0) radius:0 lineWidth:.3 lineColor:CustomAlphaBlue  backgroundColor:CustomAlphaBlue];
    }
}

- (id)initWithFrame:(CGRect)frame finishOffset:(void(^)())finishOffset selected:(void(^)(id data))selected;
{
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor clearColor];
        _selected = selected;
        _finishOffset = finishOffset;
        [self layoutViews];
    }
    return self;
}

- (UICollectionViewFlowLayout *)segmentBarLayout
{
    UICollectionViewFlowLayout *segmentBarLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = (DeviceW - (defaultInset.left + defaultInset.right) * 2) / 2;
    CGFloat height = width / kTop3Scale;
    segmentBarLayout.itemSize = CGSizeMake(width,height);
    segmentBarLayout.sectionInset = UIEdgeInsetsMake( (defaultInset.left + defaultInset.right) / 4, (defaultInset.left + defaultInset.right) / 4, 0, (defaultInset.left + defaultInset.right) / 4);
    segmentBarLayout.minimumLineSpacing = (defaultInset.right + defaultInset.left) / 2 ;
    segmentBarLayout.minimumInteritemSpacing = 0;
    return segmentBarLayout;
}

- (void)setDatas:(id)datas
{    
    _datas = datas;
    
    CGFloat imageHeight = 0;
    NSArray *images = datas[@"recommends"];
    
    if (images.count)
    {
        CGRect rect = self.frame;
        rect.size.height = ScaleH(30);
        self.frame = rect;
        
        _title.frame = CGRectMake(defaultInset.left + ScaleW(15), (ScaleH(30) - _title.font.lineHeight) / 2, CGRectGetWidth(self.frame) - ScaleW(30) - defaultInset.left - defaultInset.right, _title.font.lineHeight);
        _title.text = @"热门推荐";
        
        CGFloat width = (DeviceW - (defaultInset.left + defaultInset.right) * 2) / 2;
        CGFloat height = width / kTop3Scale + (defaultInset.left + defaultInset.right) / 2;
        imageHeight = height * ceil((float)images.count/2) ;
        _collectionView.frame = CGRectMake(defaultInset.left, ScaleH(30) + defaultInset.top, DeviceW - defaultInset.left - defaultInset.right, imageHeight);
        [_collectionView reloadData];
        
        rect = self.frame;
        rect.size.height = CGRectGetHeight(self.frame) + imageHeight + defaultInset.top + defaultInset.bottom;
        self.frame = rect;
    }
    
    [self setNeedsDisplay];
}

- (void)layoutViews
{
    
    _title = [UILabel new];
    _title.font = FontBold(15);
    _title.textColor = CustomBlue;
    _title.backgroundColor = [UIColor clearColor];
    [self addSubview:_title];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[self segmentBarLayout]];
    _collectionView.userInteractionEnabled = YES;
    
    [_collectionView registerClass:[PDFooterCell class] forCellWithReuseIdentifier:@"cell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [self addSubview:_collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_datas[@"recommends"] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    PDFooterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    NSDictionary * datas = _datas[@"recommends"][indexPath.row];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:datas[@"advertImg"] ] placeholderImage:[UIImage imageNamed:@"userguide_avatar_icon.png"]];
    cell.title.text = [Base64 textFromBase64String:datas[@"advertTitle"]];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * datas = _datas[@"recommends"][indexPath.row];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:datas];
    dic[@"id"] = datas[@"advertCode"];
    _selected(dic);
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
