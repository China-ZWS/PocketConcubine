//
//  ChangePasswordViewController.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-24.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "CPInputView.h"

@interface ChangePasswordViewController ()
{
    CPInputView *_inputView;
}
@end

@implementation ChangePasswordViewController

- (id)init
{
    if ((self = [super init]))
    {
        [self.navigationItem setNewTitle:@"修改密码"];
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

    ChangePasswordViewController __weak*safeSelf = self;
    _inputView = [[CPInputView alloc] initWithFrame:CGRectMake(0, 0, DeviceW, ScaleH(20) + ScaleH(55) * 3) success:^()
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
    
    [self.view endEditing:YES];
    if (![Infomation readInfo])
    {
        [self.view makeToast:@"请先登录!"];
        return;
    }
    
    NSInteger oldlenght = _inputView.opws.text.length;

    if (!oldlenght)
    {
        [self.view makeToast:@"请输入旧密码"];
        return;
    }
    else if (6 - oldlenght > 0)
    {
        [self.view makeToast:@"输入密码有误"];
        return;
    }
    else if (oldlenght - 11 > 0)
    {
        [self.view makeToast:@"输入密码有误"];
        return;
    }
    
    
    NSInteger newlenght = _inputView.npws.text.length;

    if (!newlenght)
    {
        [self.view makeToast:@"请输入新密码"];
        return;
    }
    else if ( 6 - newlenght > 0)
    {
        [self.view makeToast:@"密码至少6位至11位"];
        return;
    }
    else if (newlenght - 11 > 0)
    {
        [self.view makeToast:@"密码至少6位至11位"];
        return;
    }
    
    
    
    NSInteger renewlenght = _inputView.renpws.text.length;

    if (!renewlenght)
    {
        [self.view makeToast:@"请再次确认修改密码!"];
        return;
    }
    else if (![_inputView.renpws.text isEqualToString:_inputView.npws.text])
    {
        [self.view makeToast:@"2次密码输入不一致"];
        return;
    }
    
    [MBProgressHUD showMessag:@"密码修改中..." toView:self.view];
    NSMutableDictionary *params=[NSMutableDictionary new];   // 要传递的json数据是一个字典
    params[@"userid"] =  [Infomation readInfo]?[Infomation readInfo][@"id"]:@"";
    params[@"oldpassword"] = _inputView.opws.text;
    params[@"newpassword"] = _inputView.npws.text;

    _connection = [BaseModel POST:changepwdServlet parameter:params   class:[BaseModel class]
                          success:^(id data)
                   {
                       [self.view makeToast:@"修改成功"];
                       
                       [self performSelector:@selector(back) withObject:nil afterDelay:.5];
                       
                       [MBProgressHUD hideHUDForView:self.view animated:YES];
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
