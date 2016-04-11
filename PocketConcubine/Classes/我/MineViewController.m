//
//  MineViewController.m
//  PocketConcubine
//
//  Created by 周文松 on 15-4-28.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "MineViewController.h"
#import "MainTabBar.h"
#import "CollectionViewController.h"
#import "CollectionClassesViewController.h"
#import "CollectionProductViewController.h"

#import "RecordViewController.h"
#import "HaveproductsViewController.h"

#import "SetAgentViewController.h"

#import "NewDetailsViewController.h"
#import "ProductDetailsViewController.h"
#import "ClassDetailsViewController.h"
#import "ActivityDetailsViewController.h"
#import "DeputyViewController.h"

@interface MineCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) id datas;
@end

@implementation MineCell

- (void)drawRect:(CGRect)rect
{
    
    [self drawRectWithLine:rect start:CGPointMake(0, 0) end:CGPointMake(CGRectGetWidth(rect), 0) lineColor:CustomGray lineWidth:.3];
    [self drawRectWithLine:rect start:CGPointMake(0, 0) end:CGPointMake(0, CGRectGetHeight(rect)) lineColor:CustomGray lineWidth:.3];
    [self drawRectWithLine:rect start:CGPointMake(0, CGRectGetHeight(rect)) end:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect)) lineColor:CustomGray lineWidth:.3];
    [self drawRectWithLine:rect start:CGPointMake(CGRectGetWidth(rect), 0) end:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect)) lineColor:CustomGray lineWidth:.3];

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.title];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [UIImageView new];
    }
    return _imageView;
}

- (UILabel *)title
{
    if (!_title) {
        _title = [UILabel new];
        _title.font = FontBold(15);
        _title.textColor = CustomBlack;
        _title.textAlignment = NSTextAlignmentCenter;
    }
    return _title;
}

- (void)setDatas:(id)datas
{
    UIImage *image = [UIImage imageNamed:datas[@"image"]];
    NSString *title = datas[@"title"];

    _imageView.frame = CGRectMake((CGRectGetWidth(self.frame) - image.size.width) / 2, (CGRectGetHeight(self.frame) - image.size.height - _title.font.lineHeight) / 2, image.size.width, image.size.height);
    _imageView.image = image;
    
    _title.frame = CGRectMake(0, CGRectGetMaxY(_imageView.frame), CGRectGetWidth(self.frame), _title.font.lineHeight);
    _title.text = title;
}


@end

#import "MJRefresh.h"

@interface MineViewController ()
<UICollectionViewDataSource, UICollectionViewDelegate, MJRefreshBaseViewDelegate>
{
    UICollectionView *_collectionView;
    NSArray *_datas;
    NSDictionary *_dic;
    MJRefreshHeaderView *_header;
}
@property (nonatomic, strong) UIImageView *headerView;

@end

@implementation MineViewController

- (void)dealloc
{
    [_header free];
}

- (id)init
{
    if ((self = [super init]))
    {
        [self.navigationItem setNewTitle:@"我"];
        _datas = [DataConfigManager getMineList];
    }
    return self;
}

- (UICollectionViewFlowLayout *)segmentBarLayout
{
    UICollectionViewFlowLayout *segmentBarLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = DeviceW / 3;
    segmentBarLayout.itemSize = CGSizeMake(width,width);
//    segmentBarLayout.sectionInset = UIEdgeInsetsMake(0, (defaultInset.left + defaultInset.right) / 4, 0, (defaultInset.left + defaultInset.right) / 4);
    segmentBarLayout.minimumLineSpacing = 0;
    segmentBarLayout.minimumInteritemSpacing = 0;
    return segmentBarLayout;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:[self segmentBarLayout]];
    _collectionView.userInteractionEnabled = YES;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_collectionView registerClass:[MineCell class] forCellWithReuseIdentifier:@"cell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_collectionView];
    
    
    _header = [MJRefreshHeaderView header];
    _header.scrollView = _collectionView;
    _header.delegate = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_header beginRefreshing];
    });

}



- (void)eventWithExit
{
    [Infomation deleteInfo];
    [(MainTabBar *)self.tabBarController setSelected:0];
    NSNotificationPost(RefreshWithViews, nil, nil);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, DeviceW / kTop3Scale);
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    footerView.backgroundColor = [UIColor clearColor];
    [footerView addSubview:self.headerView];
    return footerView;
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    
    MineCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.datas = _datas[indexPath.row];
    
     return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Class class = NSClassFromString(_datas[indexPath.row][@"class"]);
    if ([class isSubclassOfClass:[CollectionViewController class]])
    {
        NSArray *viewControllers = @[[CollectionClassesViewController new], [CollectionProductViewController new]];
        CollectionViewController *viewController = [[CollectionViewController alloc]initWithViewControllers:viewControllers];
        [self pushViewController:viewController];

    }
 //    else if ([class isSubclassOfClass:[SetAgentViewController class]])
//    {
//        
//    }
    else
    {
        id viewController = [class new];
        
        [self pushViewController:viewController];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 登录成功的回调刷新数据
- (void)refreshWithViews
{

}


- (UIImageView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DeviceW, DeviceW / kTop3Scale)];
        _headerView.userInteractionEnabled = YES;
        [_headerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)]];
    }
    [_headerView sd_setImageWithURL:[NSURL URLWithString:_dic[@"advertImg"]] placeholderImage:[UIImage imageNamed:@"bk_5_2.png"]];
    return _headerView;
}


- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView;
{
    _connection = [BaseModel POST:myPageServlet parameter:nil class:[BaseModel class]
                          success:^(id data)
                   {
                       _dic = data[@"data"];
                       [self headerView];
                       [_header endRefreshing];
                   }
                          failure:^(NSString *msg, NSString *state)
                   {
                       [self.view makeToast:@"msg"];
                       [_header endRefreshing];
                   }];
}

- (void)singleTap:(UIGestureRecognizer*)gestureRecognizer
{
    if (!_dic.count) return;
    switch ([_dic[@"advertType"] integerValue]) {
        case 1:
            [self pushViewController:[[NewDetailsViewController alloc] initWithDatas:@{@"id":_dic[@"advertCode"]}]];
            break;
        case 2:
            [self pushViewController:[[ProductDetailsViewController alloc] initWithDatas:@{@"id":_dic[@"advertCode"]}]];
            break;
        case 3:
            [self pushViewController:[[ClassDetailsViewController alloc] initWithDatas:@{@"id":_dic[@"advertCode"]}]];
            break;
        case 4:
            [self pushViewController:[[ActivityDetailsViewController alloc] initWithDatas:@{@"id":_dic[@"advertCode"]} type:kNew]];
            break;
        case 5:
            [self pushViewController:[DeputyViewController new]];
            break;
        default:
            break;
    }

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
