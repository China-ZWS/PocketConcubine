//
//  ProfileViewController.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-26.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileInputView : BaseInputView
@property (nonatomic, strong) BaseTextView *profile;

@end

@implementation ProfileInputView

- (id)initWithFrame:(CGRect)frame success:(void (^)())success
{
    if ((self = [super initWithFrame:frame success:success]))
    {
        [self layoutViews];
    }
    
    return self;
}

- (void)layoutViews
{
    [self addSubview:self.profile];
}

- (BaseTextView *)profile
{
    if (!_profile)
    {
        _profile = [[BaseTextView alloc] initWithFrame:CGRectMake(defaultInset.left, ScaleH(20), DeviceW - defaultInset.left * 2, ScaleH(120))];
        _profile.font = Font(15);
        _profile.delegate = self;
        _profile.returnKeyType = UIReturnKeyGo;
        _profile.text = [Base64 textFromBase64String:[Infomation readInfo][@"autograph"]];
        _profile.keyboardType = UIKeyboardTypeNamePhonePad;
        [_profile getCornerRadius:ScaleH(3) borderColor:CustomGray borderWidth:1 masksToBounds:YES];
    }
    return _profile;
}


@end




@interface ProfileViewController ()
{
    ProfileInputView *_inputView;
}
@end

@implementation ProfileViewController

- (id)init
{
    if ((self = [super init]))
    {
        [self.navigationItem setNewTitle:@"个人简介修改"];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"back.png"];
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}

- (void)back
{
    [self popViewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    ProfileViewController __weak*safeSelf = self;
    _inputView = [[ProfileInputView alloc] initWithFrame:CGRectMake(0, 0, DeviceW, ScaleH(20) + ScaleH(130)) success:^()
                  {
                      [safeSelf eventWithSignup];
                  }];
    [self.view addSubview:_inputView];
    UIButton *signUp = [UIButton buttonWithType:UIButtonTypeCustom];
    signUp.frame = CGRectMake(defaultInset.left, CGRectGetMaxY(_inputView.frame) + defaultInset.top, DeviceW - defaultInset.left * 2, ScaleH(50));
    signUp.backgroundColor = CustomBlue;
    signUp.titleLabel.font = Font(18);
    [signUp setTitle:@"提 交" forState:UIControlStateNormal];
    [signUp addTarget:self action:@selector(eventWithSignup) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signUp];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)eventWithSignup
{
    [MBProgressHUD showMessag:@"修改中..." toView:self.view];
    
    
    NSMutableDictionary *params=[NSMutableDictionary new];   // 要传递的json数据是一个字典
    params[@"email"] = [Infomation readInfo][@"email"];
    params[@"weixin"] = [Infomation readInfo][@"weixin"];
    params[@"address"] = [Infomation readInfo][@"address"];
    params[@"userid"] = [Infomation readInfo][@"id"];
    params[@"autograph"] = [Base64 base64StringFromText:_inputView.profile.text];

    _connection = [BaseModel POST:updateuserServlet parameter:params   class:[BaseModel class]
                          success:^(id data)
                   {
                       [self.view makeToast:@"修改成功"];
                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                       
                       
                       NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[Infomation readInfo]];
                       [dic addEntriesFromDictionary:params];
                       [Infomation writeInfo:dic];
                       NSNotificationPost(RefreshWithViews, nil, nil);

                       [self performSelector:@selector(back) withObject:nil afterDelay:.5];
                       
                   }
                          failure:^(NSString *msg, NSString *state)
                   {
                       [self.view makeToast:msg];
                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                   }];
    
    

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
