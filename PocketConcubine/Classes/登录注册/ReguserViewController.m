//
//  ReguserViewController.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-24.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "ReguserViewController.h"
#import "ReguserInputView.h"

@interface ReguserViewController ()
{
    ReguserInputView *_inputView;
 
}
@end

@implementation ReguserViewController

- (id)initWithSuccess:(void(^)(id datas))success;
{
    if ((self = [super init])) {
        _success = success;
        [self.navigationItem setNewTitle:@"注 册"];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"back.png"];
        
    }
    return self;
}

- (void)back
{
    [self popViewController];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    ReguserViewController __weak*safeSelf = self;
    _inputView = [[ReguserInputView alloc] initWithFrame:CGRectMake(0, 0, DeviceW, ScaleH(20) + ScaleH(55) * 6) success:^()
                  {
                      [safeSelf eventWithSignup];
                  }];
//    _inputView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_inputView];
    
    UIButton *signUp = [UIButton buttonWithType:UIButtonTypeCustom];
    signUp.frame = CGRectMake(defaultInset.left, CGRectGetMaxY(_inputView.frame) + defaultInset.top, DeviceW - defaultInset.left * 2, ScaleH(50));
    signUp.backgroundColor = CustomBlue;
    signUp.titleLabel.font = Font(18);
    [signUp setTitle:@"注 册" forState:UIControlStateNormal];
    [signUp addTarget:self action:@selector(eventWithSignup) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signUp];
}

- (void)eventWithSignup
{
    [self.view endEditing:YES];
   
    
    if (![Base64 base64StringFromText:_inputView.nameField.text].length)
    {
        [self.view makeToast:@"请补全姓名!"];
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
   
    NSInteger lenght = _inputView.passwordField.text.length;
    if (!lenght) {
        [self.view makeToast:@"请补全密码!"];
        return;
    }
    else if ((6 - lenght) > 0)
    {
        [self.view makeToast:@"密码至少6位至11位"];
        return;
    }
    else if ((lenght - 11) > 0)
    {
        [self.view makeToast:@"密码至少6位至11位"];
        return;
    }
    
    
   
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
    
    
   
//    if (![Base64 base64StringFromText:_inputView.addressField.text])
//    {
//        [self.view makeToast:@"请补全所在地!"];
//        return;
//    }
    

    
    [MBProgressHUD showMessag:@"注册中..." toView:self.view];
    NSMutableDictionary *params=[NSMutableDictionary new];   // 要传递的json数据是一个字典
    params[@"username"] = [Base64 base64StringFromText:_inputView.nameField.text];
    params[@"password"] =  _inputView.passwordField.text;
    params[@"mobile"] =  _inputView.phoneNumField.text;;
    params[@"email"] = _inputView.mailField.text;
//    params[@"sex"] = _inputView.sexField.info;
    params[@"weixin"] = [Base64 base64StringFromText:_inputView.wechatField.text];

    _connection = [BaseModel POST:reguserServlet parameter:params   class:[BaseModel class]
                          success:^(id data)
                   {
                       _success(data[@"data"]);
                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                   }
                          failure:^(NSString *msg, NSString *state)
                   {
                    
                       [self.view makeToast:msg duration:.5 position:@"center"];
                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                   }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
