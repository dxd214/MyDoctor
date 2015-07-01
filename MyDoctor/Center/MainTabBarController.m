//
//  MainTabBarController.m
//  weibo
//
//  Created by zsm on 14-11-11.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "MainTabBarController.h"


@interface MainTabBarController ()

@end

@implementation MainTabBarController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // 1.自定义标签栏
    [self _initTabBarView];
    

}

// 1.自定义标签栏
- (void)_initTabBarView
{
    float top = kVersion >= 7.0 ? (kScreenHeight - 49) : kScreenHeight - 49 - 20;
    // 1.创建标签栏
    _tabBarView = [[UIImageView alloc]initWithFrame:CGRectMake(0, top, kScreenWidth, 49)];
    _tabBarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bar"]];
    // 3.开启点击事件
    _tabBarView.userInteractionEnabled = YES;
    [self.view addSubview:_tabBarView];
    
    
    // 4.创建标签按钮
    NSArray *imageNames = @[@"Icon01.png",@"Icon02.png",@"Icon03.png",@"Icon04.png"];
    NSArray *selectImgNames = @[@"Icon01Sel@2x.png",@"Icon02Sel@2x.png",@"Icon03Sel@2x.png",@"Icon04Sel@2x.pnKg"];
    NSArray *titles = @[@"首页",@"健康科普",@"家人健康",@"更多"];
    for (int i = 0; i < imageNames.count; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(kScreenWidth / 4.0 * i, 0, kScreenWidth / 4.0, 40);
        [button setImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:selectImgNames[i]] forState:UIControlStateSelected];
        // 设置点击事件
        button.tag = i;
        [button addTarget:self action:@selector(tabBarItemAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(button.left, button.bottom, button.width, 6)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:10];
        titleLabel.textColor = [UIColor lightGrayColor];
        titleLabel.text = titles[i];
        [_tabBarView addSubview:titleLabel];
        [_tabBarView addSubview:button];
        
    }
    
}

#pragma mark - tabBarItem Action
- (void)tabBarItemAction:(UIButton *)button
{
    self.selectedIndex = button.tag;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}


@end
