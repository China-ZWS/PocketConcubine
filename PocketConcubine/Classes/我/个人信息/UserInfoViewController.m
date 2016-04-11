//
//  UserInfoViewController.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-15.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserInfoCell.h"
#import "ProfileViewController.h"
#import "MailViewController.h"
#import "WechatViewController.h"
#import "AddressViewController.h"
#import "BasePhotoPickerManager.h"

@interface UserInfoViewController ()
<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
}
@end

@implementation UserInfoViewController

- (id)init
{
    if ((self = [super initWithTableViewStyle:UITableViewStyleGrouped]))
    {
        [self.navigationItem setNewTitle:@"个人信息"];
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
    
    _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 2;
    }
    else
    {
        return 4;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ScaleH(20);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return ScaleH(10);
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return ScaleH(100);
        }
    }
    return ScaleH(60);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell)
    {
        cell = [[UserInfoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.font = Font(15);
        cell.detailTextLabel.font = Font(13);
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;

    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            cell.textLabel.text = @"头 像";
            UIImageView *userTopimg = [[UIImageView alloc] initWithFrame:CGRectMake(DeviceW - ScaleH(120), (ScaleH(100) - ScaleH(80)) / 2, ScaleH(80), ScaleH(80))];
            [userTopimg sd_setImageWithURL:[NSURL URLWithString:[Infomation readInfo][@"topimg"]] placeholderImage:[UIImage imageNamed:@"userTop.png"]];
            userTopimg.layer.masksToBounds =YES;
            userTopimg.layer.cornerRadius = ScaleH(40);
            [cell.contentView addSubview:userTopimg];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else
        {
            cell.textLabel.text = @"个人简介";
            cell.detailTextLabel.text = [Base64 textFromBase64String:[Infomation readInfo][@"autograph"]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
      
        }
    }
    else
    {
        switch (indexPath.row) {
            case 0:
            {
                cell.textLabel.text = @"姓 名";
                cell.detailTextLabel.text = [Base64 textFromBase64String:[Infomation readInfo][@"username"]];
            }
                break;
//            case 1:
//            {
//                cell.textLabel.text = @"性 别";
//                NSString *sex = nil;
//                if ([[Infomation readInfo][@"sex"] integerValue] == 0)
//                {
//                    sex = @"男";
//                }
//                else if ([[Infomation readInfo][@"sex"] integerValue] == 1)
//                {
//                    sex = @"女";
//                }
//
//                cell.detailTextLabel.text = sex;
//            }
//                break;
//            case 2:
//            {
//                cell.textLabel.text = @"身份证号码";
//                cell.detailTextLabel.text = [Infomation readInfo][@"certificate"];
//            }
                break;
            case 1:
            {
                cell.textLabel.text = @"邮 箱";
                cell.detailTextLabel.text = [Infomation readInfo][@"email"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
            }
                break;
            case 2:
            {
                cell.textLabel.text = @"手机号码";
                cell.detailTextLabel.text = [Infomation readInfo][@"mobile"];

            }
                break;
            case 3:
            {
                cell.textLabel.text = @"微 信";
                cell.detailTextLabel.text = [Base64 textFromBase64String:[Infomation readInfo][@"weixin"]];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
//            case 6:
//            {
//                cell.textLabel.text = @"所在地";
//                cell.detailTextLabel.text = [Base64 textFromBase64String:[Infomation readInfo][@"address"]];
//                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            }
//                break;
   
            default:
                break;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            
            [[BasePhotoPickerManager shared] showActionSheetInView:self.view fromController:self completion:^(UIImage *img)
             {
                 
                 NSMutableDictionary *params = [NSMutableDictionary dictionary];
                 params[@"code"] = @"1";
                 //    params[@"account"] = @"";
                 
                 NSMutableDictionary *param = [NSMutableDictionary dictionary];
                 param[@"userid"] = [Infomation readInfo][@"id"];
                 params[@"param"] = [param JSONString];
                 
                 
                 [ZWSRequest postRequestWithURL:[serverUrl stringByAppendingString:updateuserImgServlet] postParems:params images:@[img] picFileName:@"image" success:^(id datas)
                  {
                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                      NSString *topimg = datas[@"data"];
                      NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[Infomation readInfo]];
                      dic[@"topimg"] = topimg;
                      [Infomation writeInfo:dic];
                      [self.view makeToast:@"上传头像成功"];
                      [self reloadTabData];
                  }
                                        failure:^(NSString *msg)
                  {
                      
                      [self.view makeToast:msg];
                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                  }
                  ];

             }
             cancelBlock:^()
             
            {
                [self.view makeToast:@"取消"];
                
            }];

            
//            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
//            [sheet showInView:self.view.window];

        }
        else
        {
            [self pushViewController:[ProfileViewController new]];
        }
    }
    else
    {
        switch (indexPath.row)
        {
            case 3:
            {
                [self pushViewController:[MailViewController new]];
            }
                break;
            case 5:
            {
                [self pushViewController:[WechatViewController new]];

            }
                break;
            case 6:
            {
                [self pushViewController:[AddressViewController new]];

            }
                break;
                
            default:
                break;
        }

    }
}




- (void)refreshWithViews
{
    [self reloadTabData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)eventWithSignup
{
    
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
