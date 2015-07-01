//
//  BaseNavViewController.m
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-11-29.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//

#import "BaseNavViewController.h"
#import "MainTabBarController.h"

@interface BaseNavViewController ()

@end

@implementation BaseNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.delegate = self;
    // 取消导航栏半透明的效果
    self.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationBar.translucent = NO;
    // 设置导航栏图片
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"TopBar.png"] forBarMetrics:UIBarMetricsDefault];
    
    


}

//隐藏tabBar
#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count == 1) {
        MainTabBarController *mainTBC = (MainTabBarController *)self.tabBarController;
        mainTBC.tabBarView.hidden = NO;
    } else if (self.viewControllers.count == 2) {
        MainTabBarController *mainTBC = (MainTabBarController *)self.tabBarController;
        mainTBC.tabBarView.hidden = YES;
    }
}






@end
