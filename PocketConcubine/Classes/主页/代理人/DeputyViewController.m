//
//  DeputyViewController.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-27.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "DeputyViewController.h"
#import "MJRefresh.h"

@interface DeputyCell : UICollectionViewCell
@property (nonatomic) id datas;
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *date;
@property (nonatomic, strong) UILabel *abstracts;
@end

@implementation DeputyCell



- (void)drawRect:(CGRect)rect
{

    [self drawWithChamferOfRectangle:rect inset:UIEdgeInsetsZero radius:ScaleH(3) lineWidth:.3 lineColor:CustomlightPink    backgroundColor:[UIColor whiteColor]];
    [self drawRectWithLine:rect start:CGPointMake(ScaleW(5), CGRectGetMaxY(_date.frame) + ScaleW(5)) end:CGPointMake(CGRectGetWidth(rect) - ScaleW(5), CGRectGetMaxY(_date.frame) + ScaleW(5)) lineColor:CustomlightPink lineWidth:.3];
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
       
        _topImageView = [UIImageView new];
        _name = [UILabel new];
        _name.font = FontBold(15);
        
        _date = [UILabel new];
        _date.font = Font(10);
        _date.textColor = CustomDarkPurple;
        _abstracts = [UILabel new];
        _abstracts.textColor = CustomlightPurple;
        _abstracts.font = Font(13);
        _abstracts.numberOfLines = 2;
        
        [self.contentView addSubview:_topImageView];
        [self.contentView addSubview:_name];
        [self.contentView addSubview:_date];
        [self.contentView addSubview:_abstracts];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _topImageView.frame = CGRectMake(ScaleW(5), ScaleW(5), CGRectGetWidth(self.frame) - ScaleW(5) * 2, (CGRectGetWidth(self.frame) - ScaleW(5) * 2) * 1.2);
    _name.frame = CGRectMake(ScaleW(5), CGRectGetMaxY(_topImageView.frame) + ScaleW(5), CGRectGetWidth(self.frame) - ScaleW(5) * 2, _name.font.lineHeight);
    _date.frame = CGRectMake(ScaleW(5), CGRectGetMaxY(_name.frame) + ScaleW(2), CGRectGetWidth(self.frame) - ScaleW(5) * 2, _date.font.lineHeight);
    _abstracts.frame = CGRectMake(ScaleW(5) * 2, CGRectGetMaxY(_date.frame) + ScaleW(5), CGRectGetWidth(self.frame) - ScaleW(5) * 2, CGRectGetHeight(self.frame) - CGRectGetMaxY(_date.frame));
}

- (void)setDatas:(id)datas
{
   
    
    [_topImageView  sd_setImageWithURL:[NSURL URLWithString:datas[@"topimg"]] placeholderImage:[UIImage imageNamed:@"bk_3_2.png"]];
    
    NSString *name = [NSString stringWithFormat:@"姓名:%@",[Base64 textFromBase64String:datas[@"username"]]];
    NSMutableAttributedString *nameAttr = [[NSMutableAttributedString alloc] initWithString:name];
    [nameAttr addAttribute:NSForegroundColorAttributeName value:CustomDarkPurple range:NSMakeRange(0,[@"姓名:" length])];
    [nameAttr addAttribute:NSForegroundColorAttributeName value:CustomPink range:NSMakeRange([@"姓名:" length],[[Base64 textFromBase64String:datas[@"username"]]length])];
    _name.attributedText = nameAttr;

    NSString *date = [NSString stringWithFormat:@"入行时间:%@",[datas[@"date"] componentsSeparatedByString:@" "][0]];
    _date.text = date;
    _abstracts.text = [Base64 textFromBase64String:datas[@"autograph"]];
}


@end

@interface DeputyViewController ()
<UICollectionViewDelegate, UICollectionViewDataSource, MJRefreshBaseViewDelegate>
{
    UICollectionView *_collectionView;
    MJRefreshHeaderView *_header;
    NSArray *_datas;
}
@end

@implementation DeputyViewController

- (void)dealloc
{
    [_header free];
}

- (id)init
{
    if ((self = [super init]))
    {
        [self.navigationItem setNewTitle:@"代理人"];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"back.png"];
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}

- (void)back
{
    [self popViewController];
}

- (UICollectionViewFlowLayout *)segmentBarLayout
{
//    _topImageView.frame = CGRectMake(ScaleW(5), ScaleW(5), CGRectGetWidth(self.frame) - ScaleW(5) * 2, (CGRectGetWidth(self.frame) - ScaleW(5) * 2) * 1.2);
//    _name.frame = CGRectMake(ScaleW(5), CGRectGetMaxY(_topImageView.frame), CGRectGetWidth(self.frame) - ScaleW(5) * 2, _name.font.lineHeight + 5);
//    _date.frame = CGRectMake(ScaleW(5), CGRectGetMaxY(_name.frame), CGRectGetWidth(self.frame) - ScaleW(5) * 2, _date.font.lineHeight + 5);
//    _abstracts.frame = CGRectMake(ScaleW(5) * 2, CGRectGetMaxY(_date.frame), CGRectGetWidth(self.frame) - ScaleW(5) * 2, CGRectGetHeight(self.frame) - CGRectGetMaxY(_date.frame));

    UICollectionViewFlowLayout *segmentBarLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = (DeviceW - ScaleW(40)) / 3;
    CGFloat insetHeight = ScaleW(5);
    CGFloat imageHeight = (width - insetHeight * 2) * 1.2;
    CGFloat nameHeight = Font(15).lineHeight;
    CGFloat dateHeight = Font(10).lineHeight;
    CGFloat abstractsHeight = Font(13).lineHeight * 2;
    CGFloat height = insetHeight * 4 + imageHeight + nameHeight + dateHeight + abstractsHeight + ScaleW(2);
    
    segmentBarLayout.itemSize = CGSizeMake(width,height);
        segmentBarLayout.sectionInset = UIEdgeInsetsMake(ScaleW(10), ScaleW(10), 0, ScaleW(10));
    segmentBarLayout.minimumLineSpacing = ScaleW(10);
    segmentBarLayout.minimumInteritemSpacing = 0;
    return segmentBarLayout;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:[self segmentBarLayout]];
    _collectionView.userInteractionEnabled = YES;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_collectionView registerClass:[DeputyCell class] forCellWithReuseIdentifier:@"cell"];
    _collectionView.delegate = self;
    _collectionView.alwaysBounceVertical  = YES;
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
    
    
    DeputyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.datas = _datas[indexPath.row];
    
    return cell;
}


- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView;
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    _connection = [BaseModel POST:fineUserServlet parameter:params class:[BaseModel class]
                          success:^(id data)
                   {
                       
                       _datas = data[@"data"][@"users"];
//                       _dic = [NSMutableDictionary dictionaryWithDictionary:data[@"data"]];
//                       
//                       
                       if (!_datas.count)
                       {
                           [AbnormalView setRect:_collectionView.frame toView:_collectionView abnormalType:NotDatas];
                           [AbnormalView setDelegate:self toView:_collectionView];
                       }
                       else
                       {
                           [AbnormalView hideHUDForView:_collectionView];
                           [_collectionView reloadData];
                       }
                       [_header endRefreshing];
                   }
                          failure:^(NSString *msg, NSString *state)
                   {
                       [self.view makeToast:msg];
                       [_header endRefreshing];
                       
                       if ([state isEqualToString:kNetworkAnomaly])
                       {
                           if (!_datas.count)
                           {
                               [AbnormalView setRect:_collectionView.bounds toView:_collectionView abnormalType:NotNetWork];
                               [AbnormalView setDelegate:self toView:_collectionView];
                           }
                           else
                           {
                               [AbnormalView hideHUDForView:_collectionView];
                           }
                       }
                       else
                       {
                           if (!_datas.count)
                           {
                               [AbnormalView setRect:_collectionView.frame toView:_collectionView abnormalType:kError];
                               [AbnormalView setDelegate:self toView:_collectionView];
                           }
                           else
                           {
                               [AbnormalView hideHUDForView:_collectionView];
                           }
                       }
                   }];
//}

    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
