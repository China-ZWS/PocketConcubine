//
//  WechatViewController.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-26.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "WechatViewController.h"



@interface WechatInputView : BaseInputView
@property (nonatomic, strong) BaseTextField *field;

@end

@implementation WechatInputView
- (id)initWithFrame:(CGRect)frame success:(void (^)())success
{
    if ((self = [super initWithFrame:frame success:success])) {
        [self layoutViews];
    }
    return self;
}



- (void)layoutViews
{
    [self addSubview:self.field];
}

- (BaseTextField *)field
{
    if (!_field)
    {
        _field = [[BaseTextField alloc] initWithFrame:CGRectMake(defaultInset.left, ScaleH(20), DeviceW - defaultInset.left * 2, ScaleH(45))];
        _field.placeholder = @"修改微信号";
        _field.delegate = self;
        _field.font = Font(15);
        _field.returnKeyType = UIReturnKeyNext;
        _field.text = [Base64 textFromBase64String:[Infomation readInfo][@"weixin"]];
        _field.keyboardType = UIKeyboardTypeNamePhonePad;
        [_field getCornerRadius:ScaleH(3) borderColor:CustomGray borderWidth:1 masksToBounds:YES];
    }
    return _field;
}


@end

@interface WechatViewController ()
{
    WechatInputView *_inputView;
}
@end

@implementation WechatViewController


- (id)init
{
    if ((self = [super init]))
    {
        [self.navigationItem setNewTitle:@"微信号修改"];
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
    WechatViewController __weak*safeSelf = self;
    _inputView = [[WechatInputView alloc] initWithFrame:CGRectMake(0, 0, DeviceW, ScaleH(20) + ScaleH(55)) success:^()
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

- (void)eventWithSignup
{
    [MBProgressHUD showMessag:@"修改中..." toView:self.view];
    
    NSMutableDictionary *params=[NSMutableDictionary new];   // 要传递的json数据是一个字典
    params[@"email"] = [Infomation readInfo][@"email"];
    params[@"weixin"] = [Base64 base64StringFromText:_inputView.field.text];
    params[@"address"] = [Infomation readInfo][@"address"];
    params[@"userid"] = [Infomation readInfo][@"id"];
    params[@"autograph"] = [Infomation readInfo][@"autograph"];
    
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
