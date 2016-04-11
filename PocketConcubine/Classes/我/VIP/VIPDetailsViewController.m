//
//  AgentDetailsViewController.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-27.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "VIPDetailsViewController.h"
#import "PJTextField.h"

@interface VIPDetailsViewController ()
<BaseTextFieldDelegate>
{
    PJTextField *_field;
}
@property (nonatomic, strong) UIView *VipView;
@property (nonatomic, strong) UIView *registerVipView;

@property (nonatomic) BOOL hasVIP;
@end

@implementation VIPDetailsViewController

- (id)init
{
    if ((self = [super init]))
    {
        [self.navigationItem setNewTitle:@"VIP"];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"back.png"];
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}


- (void)back
{
    [self popViewController];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initDetails];
    [self initRegisterVip];
    NSDictionary *dic = [Infomation readInfo];
    
    BOOL hasVIP = ([dic[@"usertype"] integerValue] == 1)?0:1;
    self.hasVIP = hasVIP;
    

}

- (UIView *)VipView
{
    if (!_VipView) {
        UIImage *img = [UIImage imageNamed:@"vip.png"];
        CGSize imgSize = [NSObject adaptiveWithImage:img maxHeight:ScaleH(130) maxWidth:ScaleW(130)];
        
        NSString *title = @"恭喜你成为VIP";
        CGSize titleSize = [NSObject getSizeWithText:title font:Font(15) maxSize:CGSizeMake(DeviceW, Font(15).lineHeight)];
        
        CGFloat inset = 5;
        CGFloat allHeight = imgSize.height + inset + titleSize.height;
        
        
        _VipView = [[UIView alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(self.view.frame) - 200 - allHeight) / 2, DeviceW,allHeight)];
        
        UIImageView *vipImgView = [[UIImageView alloc] initWithFrame:CGRectMake((DeviceW - imgSize.width) / 2, 0, imgSize.width, imgSize.height)];
        vipImgView.image = img;
        
        UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(vipImgView.frame) + inset, DeviceW, titleSize.height)];
        titleLb.font = Font(15);
        titleLb.textAlignment = NSTextAlignmentCenter;
        titleLb.text = title;
        titleLb.textColor = RGBA(248, 149, 29, 1);
        [_VipView addSubview:vipImgView];
        [_VipView addSubview:titleLb];
    }
    return _VipView;
}

- (UIView *)registerVipView
{
    if (!_registerVipView) {
        _registerVipView = [[UIView alloc] initWithFrame:self.view.frame];
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(ScaleW(15), ScaleH(20), DeviceW - ScaleW(30), FontBold(17).lineHeight)];
        title.font = FontBold(17);
        title.text = @"请输入密码串,拿到VIP资格";
        title.textColor = CustomBlack;
        [_registerVipView addSubview:title];
        
        _field = [[PJTextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(title.frame), CGRectGetMaxY(title.frame) + defaultInset.bottom * 2, CGRectGetWidth(title.frame), ScaleH(45))];
        _field.placeholder = @"密码串";
        _field.delegate = self;
        _field.font = Font(17);
        _field.returnKeyType = UIReturnKeyNext;
        _field.keyboardType = UIKeyboardTypeNamePhonePad;
        [_registerVipView addSubview:_field];
        
        UIButton *signUp = [UIButton buttonWithType:UIButtonTypeCustom];
        signUp.frame = CGRectMake(CGRectGetMinX(_field.frame), CGRectGetMaxY(_field.frame) + defaultInset.bottom * 2, CGRectGetWidth(_field.frame), ScaleH(50));
        signUp.backgroundColor = CustomBlue;
        signUp.titleLabel.font = Font(18);
        [signUp setTitle:@"确 认" forState:UIControlStateNormal];
        [signUp addTarget:self action:@selector(eventWithSignup) forControlEvents:UIControlEventTouchUpInside];
        [_registerVipView addSubview:signUp];
        
    }
    return _registerVipView;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)initDetails
{
    [self.view addSubview:self.VipView];
}

- (void)initRegisterVip
{
    [self.view addSubview:self.registerVipView];
}

- (void)setHasVIP:(BOOL)hasVIP
{
    if (hasVIP)
    {
        _VipView.hidden = NO;
        _registerVipView.hidden = YES;
    }
    else
    {
        _VipView.hidden = YES;
        _registerVipView.hidden = NO;

    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)eventWithSignup
{
    [MBProgressHUD showMessag:@"提交中..." toView:self.view];
    [self.view endEditing:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"number"] =  _field.text;
    params[@"userid"] = [Infomation readInfo][@"id"];
    
    _connection = [BaseModel POST:userBandServlet parameter:params   class:[BaseModel class]
                          success:^(id data)
                   {
                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                       self.hasVIP = YES;
                       NSMutableDictionary *dic = [NSMutableDictionary  dictionaryWithDictionary:[Infomation readInfo]];
                       dic[@"usertype"] = @"2";
                       [Infomation writeInfo:dic];
                   }
                          failure:^(NSString *msg, NSString *state)
                   {
                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                       [self.view makeToast:msg];
                       
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
