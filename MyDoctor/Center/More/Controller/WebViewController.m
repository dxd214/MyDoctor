//
//  WebViewController.m
//  weibo
//
//  Created by zsm on 14-11-18.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    self.title = @"下载应用";
    [super viewDidLoad];

    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 1.创建webView视图
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    _webView.hidden = YES;
    _webView.delegate = self;

    // 自适应链接网页
    [_webView setScalesPageToFit:YES];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    _webView.hidden = YES;
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"正在加载...";
    _hud.dimBackground = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    _webView.hidden = NO;
    _hud.labelText = @"加载完成";
    [_hud hide:YES afterDelay:1];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}
@end
