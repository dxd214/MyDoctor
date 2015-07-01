//
//  LoginViewController.m
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-11-29.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    self.title = @"账号登陆";
    [super viewDidLoad];
    [self _initNavItem];
}
- (void)_initNavItem
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, 44, 44);
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}
- (void)buttonAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self popoverPresentationController];
}



@end
