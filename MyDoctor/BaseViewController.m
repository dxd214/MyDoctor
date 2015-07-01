//
//  BaseViewController.m
//  weibo
//
//  Created by zsm on 14-11-11.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self appDelegete];
}

- (AppDelegate *)appDelegete
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

@end
