//
//  AgentViewController.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-25.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "SetAgentViewController.h"
#import "SetAgentInputView.h"
@interface SetAgentViewController ()
{
    SetAgentInputView *_inputView;
    UIButton *_signUp;
}
@end

@implementation SetAgentViewController

- (id)init{
    if ((self = [super init]))
    {
        [self.navigationItem setNewTitle:@"代理商"];
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
    SetAgentViewController __weak*safeSelf = self;
    _inputView = [[SetAgentInputView alloc] initWithFrame:CGRectMake(0, 0, DeviceW, ScaleH(20) + ScaleH(60) * 3 + ScaleH(120)) success:^()
                  {
                      [safeSelf eventWithSignup];
                  }];
    [self.view addSubview:_inputView];
    
    _signUp = [UIButton buttonWithType:UIButtonTypeCustom];
    _signUp.frame = CGRectMake(ScaleW(20), CGRectGetMaxY(_inputView.frame) + ScaleH(15), DeviceW - ScaleW(40), ScaleH(50));
    _signUp.backgroundColor = CustomlightPurple;
    _signUp.titleLabel.font = Font(18);
    [_signUp addTarget:self action:@selector(eventWithSignup) forControlEvents:UIControlEventTouchUpInside];
    [_signUp getShadowOffset:CGSizeMake(1, 1) shadowRadius:ScaleW(3) shadowColor:CustomPink shadowOpacity:.6 cornerRadius:ScaleW(3) masksToBounds:NO];
    _signUp.hidden = YES;
    [_signUp setTitle:@"加载中..." forState:UIControlStateNormal];
    [self.view addSubview:_signUp];
}

- (void)eventWithSignup
{
    
    if (!_inputView.nameField.text.length)
    {
        [self.view makeToast:@"请补全姓名!"];
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

    if (!_inputView.addressField.text.length)
    {
        [self.view makeToast:@"请补全所在地!"];
        return;
    }

    [MBProgressHUD showMessag:@"提交中..." toView:self.view];
    
    NSMutableDictionary *params=[NSMutableDictionary new];   // 要传递的json数据是一个字典
    params[@"userid"] =  [Infomation readInfo]?[Infomation readInfo][@"id"]:@"";
    params[@"parentname"] = [Base64 base64StringFromText:_inputView.nameField.text];
    params[@"mobile"] = _inputView.phoneNumField.text;
    params[@"area"] = [Base64 base64StringFromText:_inputView.addressField.text];
    params[@"backup"] = [Base64 base64StringFromText:_inputView.markField.text];

    _connection = [BaseModel POST:submitagentServlet parameter:params   class:[BaseModel class]
                          success:^(id data)
                   {
                       [_signUp setTitle:@"审核中..." forState:UIControlStateNormal];
                       _signUp.enabled = NO;
                       _inputView.edit = NO;
                       _signUp.backgroundColor = CustomlightPurple;
                       [_signUp getShadowOffset:CGSizeMake(1, 1) shadowRadius:ScaleW(3) shadowColor:CustomlightPurple shadowOpacity:.6 cornerRadius:ScaleW(3) masksToBounds:NO];
                       
                       
                       [self.view makeToast:@"申请成功" duration:.5 position:@"center"];
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

- (void)viewWillAppear:(BOOL)animated
{
    [MBProgressHUD showMessag:Loding_text1 toView:self.view];
    
    NSMutableDictionary *params=[NSMutableDictionary new];   // 要传递的json数据是一个字典
    params[@"userid"] =  [Infomation readInfo]?[Infomation readInfo][@"id"]:@"";
    
    _connection = [BaseModel POST:checkAgentServlet parameter:params   class:[BaseModel class]
                          success:^(id data)
                   {
                       _inputView.nameField.text = [Base64 textFromBase64String:data[@"data"][@"parentname"]];
                       _inputView.phoneNumField.text = data[@"data"][@"mobile"];
                       _inputView.addressField.text = [Base64 textFromBase64String:data[@"data"][@"area"]];
                       _inputView.markField.text = [Base64 textFromBase64String:data[@"data"][@"backup"]];
                       _signUp.hidden = NO;
                       switch ([data[@"data"][@"status"] integerValue])
                       {
                           case 1:
                           {
                               [_signUp setTitle:@"申请代理商" forState:UIControlStateNormal];
                               _signUp.enabled = YES;
                               _signUp.backgroundColor = CustomPink;
                               [_signUp getShadowOffset:CGSizeMake(1, 1) shadowRadius:ScaleW(3) shadowColor:CustomPink shadowOpacity:.6 cornerRadius:ScaleW(3) masksToBounds:NO];
                            }
                               break;
                           case 2:
                           {
                               [_signUp setTitle:@"审核中" forState:UIControlStateNormal];
                               _signUp.enabled = NO;
                               _inputView.edit = NO;
                               _signUp.backgroundColor = CustomlightPurple;
                               [_signUp getShadowOffset:CGSizeMake(1, 1) shadowRadius:ScaleW(3) shadowColor:CustomlightPurple shadowOpacity:.6 cornerRadius:ScaleW(3) masksToBounds:NO];
                           }
                               break;
                           case 3:
                           {
                               [_signUp setTitle:@"已成为代理商" forState:UIControlStateNormal];
                               _signUp.enabled = NO;
                               _inputView.edit = NO;
                               _signUp.backgroundColor = CustomlightPurple;
                               [_signUp getShadowOffset:CGSizeMake(1, 1) shadowRadius:ScaleW(3) shadowColor:CustomlightPurple shadowOpacity:.6 cornerRadius:ScaleW(3) masksToBounds:NO];
                           }
                               break;
                           default:
                               break;
                       }
                    
                       [MBProgressHUD hideHUDForView:self.view animated:YES];
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
