//
//  ActivityRegisterViewController.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-12.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "ActivityRegisterViewController.h"
#import "ActivityInputView.h"

@interface ActivityRegisterViewController ()
{
    NSMutableDictionary *_datas;
    ActivityInputView *_inputView;
}
@end

@implementation ActivityRegisterViewController

- (void)back
{
    [self popViewController];
}

- (id)initWithDatas:(id)datas success:(void(^)())success;
{
    if ((self = [super init]))
    {
        _datas = datas;
        _success = success;
        
        [self.navigationItem setNewTitle:@"直播课堂报名"];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"back.png"];
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    ActivityRegisterViewController __weak*safeSelf = self;
    _inputView = [[ActivityInputView alloc] initWithFrame:CGRectMake(0, 0, DeviceW, ScaleH(20) + ScaleH(55) * 3 + ScaleH(120)) success:^()
                  {
                      [safeSelf eventWithSignup];
                  }];
    [self.view addSubview:_inputView];
    
    UIButton *signUp = [UIButton buttonWithType:UIButtonTypeCustom];
    signUp.frame = CGRectMake(defaultInset.left, CGRectGetMaxY(_inputView.frame) + defaultInset.top, DeviceW - defaultInset.left * 2, ScaleH(45));
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
        [self gotoLogingWithSuccess:^(BOOL isSuccess)
         {
             
             if (isSuccess)
             {
                 [self.view makeToast:@"登录成功"];
             }
         }class:@"LoginViewController"];
        return;
    }
    if (![Base64 base64StringFromText:_inputView.nameField.text].length)
    {
        [self.view makeToast:@"请输入姓名!"];
        return;
    }
    if (![Base64 base64StringFromText:_inputView.numOfpeopleField.text])
    {
        [self.view makeToast:@"请输入参加人数!"];
        return;
    }
    if (![Base64 base64StringFromText:_inputView.phoneNumField.text])
    {
        [self.view makeToast:@"请输入联系电话!"];
        return;
    }
    
    [MBProgressHUD showMessag:Loding_text1 toView:self.view];
    NSMutableDictionary *params=[NSMutableDictionary new];   // 要传递的json数据是一个字典
    params[@"activityid"] = _datas[@"id"];
    params[@"userid"] =  [Infomation readInfo][@"id"];
    params[@"name"] = [Base64 base64StringFromText:_inputView.nameField.text];;
    params[@"count"] = _inputView.numOfpeopleField.text;
    params[@"mobile"] = _inputView.phoneNumField.text;
    params[@"content"] = [Base64 base64StringFromText:_inputView.markField.text];;
    
    _connection = [BaseModel POST:signUpServlet parameter:params   class:[BaseModel class]
                          success:^(id data)
                   {
                       _datas[@"flag"] = @"0";
                       _success(_datas);
                       [self.view makeToast:@"报名成功"];
                       
                       [self performSelector:@selector(back) withObject:nil afterDelay:.5];
                       
                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                   }
                          failure:^(NSString *msg, NSString *state)
                   {
                       [self.view makeToast:msg];
                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                   }];
}


- (void)didReceiveMemoryWarning
{
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
