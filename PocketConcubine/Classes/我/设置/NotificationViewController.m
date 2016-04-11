//
//  NotificationViewController.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-15.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "NotificationViewController.h"

@interface NotificationViewController ()
<UIWebViewDelegate>
{
    UIWebView *_webView;
    
}

@end

@implementation NotificationViewController

- (id)init
{
    if ((self = [super init]))
    {
        [self.navigationItem setNewTitle:@"推送设置"];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"back.png"];
    }
    return self;
}

- (void)back
{
    [self popViewController];
}



//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1 + [[UIApplication sharedApplication] enabledRemoteNotificationTypes]?1:0;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return ScaleH(20);
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if (section == 0)
//    {
//        return Font(17).lineHeight + 10;
//    }
//    else if (section == 1)
//    {
//        return Font(17).lineHeight + 10;
//
//    }
//    return 0;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    NSString *title = @"请在iPhone的“设置”-“通知”中进行修改";
//    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:title];
//    NSMutableParagraphStyle * style = [NSMutableParagraphStyle new];
//    //    style.headIndent = 50;//头部缩进，相当于左padding
//    //    style.tailIndent = -50;//相当于右padding
//    style.firstLineHeadIndent = ScaleW(15);//首行头缩进
//    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, title.length)];
//
//    UILabel *footer = [UILabel new];
//    footer.font = Font(15);
//    footer.textColor = CustomGray;
//    footer.attributedText = attrString;
//    return footer;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return ScaleH(60);
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *cellIdentifier = @"cellIdentifier";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.textLabel.font = Font(17);
//        cell.detailTextLabel.font = Font(15);
//        cell.detailTextLabel.textColor = CustomGray;
//    }
//    
//    if (indexPath.section == 0) {
//        if (indexPath.row == 0) {
//            cell.textLabel.text = @"新消息通知";
//            cell.detailTextLabel.text = ([[UIApplication sharedApplication] enabledRemoteNotificationTypes]?@"已开启":@"已关闭");
//        }
//    }
//    return cell;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
//    _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleWidth;
    [_webView loadRequest:[NSURLRequest requestWithURL:[self getPageUrl:@"ios.html"]]];
    [self.view addSubview:_webView];

}


-(NSURL *) getPageUrl:(NSString *)pagePath
{
    NSString * path = [[NSBundle mainBundle] bundlePath];
    path =  [path stringByAppendingFormat:@"/HTML/%@",pagePath];
    NSString *encodedPath = [path stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSString *urlStr = [NSString stringWithFormat:@"file://%@", encodedPath];
    NSURL *url = [NSURL URLWithString:urlStr];
    return url;
}


- (void)webViewDidStartLoad:(UIWebView *)webView;
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView;
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
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
