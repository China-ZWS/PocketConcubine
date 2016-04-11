//
//  ForgotViewController.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-25.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "ForgotViewController.h"
#import "ForgotInputView.h"

@interface ForgotViewController ()
{
    ForgotInputView *_inputView;
}
@end

@implementation ForgotViewController

- (id)init
{
    if ((self = [super init]))
    {
        [self.navigationItem setNewTitle:@"找回密码"];
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
    
    ForgotViewController __weak*safeSelf = self;
    _inputView = [[ForgotInputView alloc] initWithFrame:CGRectMake(0, 0, DeviceW, ScaleH(20) + ScaleH(55) * 2) success:^()
                  {
                      [safeSelf eventWithSignup];
                  }];
    [self.view addSubview:_inputView];
//    _inputView.backgroundColor = [UIColor redColor];

    UIButton *signUp = [UIButton buttonWithType:UIButtonTypeCustom];
    signUp.frame = CGRectMake(defaultInset.left, CGRectGetMaxY(_inputView.frame) + defaultInset.top, DeviceW - defaultInset.left * 2, ScaleH(45));
    signUp.backgroundColor = CustomBlue;
    signUp.titleLabel.font = Font(18);
    [signUp setTitle:@"提 交" forState:UIControlStateNormal];
    [signUp addTarget:self action:@selector(eventWithSignup) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signUp];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)eventWithSignup
{
    [self.view endEditing:YES];

    if (!_inputView.phoneNumField.text.length)
    {
        [self.view makeToast:@"请补全手机号码!"];
        return;
    }
    else if (![NSObject isMobileNumber:_inputView.phoneNumField.text])
    {
        [self.view makeToast:@"请输入正确的手机号码!"];
        return;
    }
    
    if (!_inputView.mailField.text.length)
    {
        [self.view makeToast:@"请补全邮箱地址!"];
        return;
    }
    else if (![NSObject isValidateEmail:_inputView.mailField.text])
    {
        [self.view makeToast:@"请输入正确的邮箱!"];
        return;
    }

    [MBProgressHUD showMessag:Loding_text1 toView:self.view];

    
    NSMutableDictionary *params=[NSMutableDictionary new];   // 要传递的json数据是一个字典
    params[@"mobile"] = _inputView.phoneNumField.text;
    params[@"email"] = _inputView.mailField.text;
    
    _connection = [BaseModel POST:forgetServlet parameter:params   class:[BaseModel class]
                          success:^(id data)
                   {
                       [self.view makeToast:@"请去邮箱查收"];
                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                   }
                          failure:^(NSString *msg, NSString *state)
                   {
                       [self.view makeToast:msg];
                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                   }];
    

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
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
