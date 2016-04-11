//
//  LoginViewController.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-5.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginInputView.h"
#import "ReguserViewController.h"
#import "ForgotViewController.h"



@interface LoginViewController ()
{
    UIImageView *_downView;
}
@end

@implementation LoginViewController
{
    LoginInputView *_input;
}


- (id)initWithLoginSuccess:(SuccessLoginBlock)success;
{
    if ((self = [super initWithLoginSuccess:success]))
    {
        
    }
    return self;
}


- (void)back
{
    
    [_connection cancel];
    _connection = nil;
    _successLogin(self,NO);
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = CustomBlue;
   
 
    UIImage *p_logImage = [UIImage imageNamed:@"p_log.png"];
    CGSize bigSize = [NSObject adaptiveWithImage:p_logImage maxHeight:DeviceH maxWidth:DeviceW];
    UIImageView *downImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, DeviceH - bigSize.height, bigSize.width, bigSize.height)];
    downImgView.image = p_logImage;
    [self.view addSubview:downImgView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _input = [[LoginInputView alloc] initWithlogin:^()
                             {
                             
                             
                             }];
    [self.view addSubview:_input];
    
    
    UIImage *loginImg = [UIImage imageNamed:@"btn_log.png"];
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(CGRectGetMinX(_input.frame) + ScaleW(20), CGRectGetMaxY(_input.frame) + ScaleH(15), CGRectGetWidth(_input.frame) - ScaleW(40), (CGRectGetWidth(_input.frame) - ScaleW(40)) * loginImg.size.height / loginImg.size.width);
    [loginBtn setBackgroundImage:loginImg forState:UIControlStateNormal];
    [loginBtn setTitle:@"登录/LOGIN" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = Font(18);
    [loginBtn addTarget:self action:@selector(eventWithLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    
    UIImage *backImg = [UIImage imageNamed:@"back.png"];
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(15, 20 + (44 - backImg.size.height) / 2, 44, 44);
    [back setImage:backImg forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    
    
    
    CGSize registerSize = [NSObject getSizeWithText:@"注 册" font:Font(15) maxSize:CGSizeMake(MAXFLOAT,Font(15).lineHeight )];
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(CGRectGetMaxX(loginBtn.frame) - registerSize.width - 10, CGRectGetMaxY(loginBtn.frame) + ScaleH(10), registerSize.width + 20, registerSize.height + 20);
    registerBtn.titleLabel.font = Font(15);
    [registerBtn setTitle:@"注 册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(eventWithRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
}


- (void)eventWithLogin
{
    
    if (!_input.accountField.text.length) {
        [self.view makeToast:@"注册手机号码/请输入注册邮箱"];
        return;
    }
    
    NSInteger lenght = _input.pwdField.text.length;

    if (!lenght)
    {
        [self.view makeToast:@"输入密码有误"];
        return;
    }
    else if ( 6 - lenght > 0)
    {
        [self.view makeToast:@"输入密码有误"];
        return;
    }
    else if (lenght - 11 > 0)
    {
        [self.view makeToast:@"输入密码有误"];
        return;
    }

    
    [MBProgressHUD showMessag:@"登录中..." toView:self.view];

    NSMutableDictionary *params=[NSMutableDictionary new];   // 要传递的json数据是一个字典
    params[@"logintag"] = _input.accountField.text;
    params[@"password"] = _input.pwdField.text;
  
    _connection = [BaseModel POST:loginServlet parameter:params   class:[BaseModel class]
                          success:^(id data)
                   {
                       
                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                       [Infomation writeInfo:data[@"data"]];
                       _successLogin(self,YES);
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

- (void)eventWithRegister
{
    [self pushViewController:[[ReguserViewController alloc] initWithSuccess:^(id datas)
    {
        if ([datas count]) {
            [Infomation writeInfo:datas];
        }

        _successLogin(self,YES);
    }]];
}

- (void)eventWithForgot
{
    [self pushViewController:[ForgotViewController new]];
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
