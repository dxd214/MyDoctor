//
//  GuideViewController.m
//  01 WXMovie
//
//  Created by lyb on 14-8-25.
//  Copyright (c) 2014年 imac. All rights reserved.
//

#import "GuideViewController.h"
#import "MainTabbarController.h"

@interface GuideViewController ()

@end

@implementation GuideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _initWelcome];
}
- (void)_initWelcome
{
    //隐藏状态栏
    //iOS6
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    //将图片存放到数组中
    NSArray *guideImages = @[@"Iphone01.jpg",
                             @"Iphone02.jpg",
                             @"Iphone03.jpg",
                             @"Iphone04.jpg"
                             ];
    
    //创建滚动视图
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //隐藏滚动条
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    //设置显示内容的尺寸
    scrollView.contentSize = CGSizeMake(kScreenWidth*guideImages.count, kScreenHeight);
    //设置分页效果
    scrollView.pagingEnabled = YES;
    [self.view addSubview:scrollView];
    
    for (int i=0; i<guideImages.count; i++)
    {
        NSString *imgName1 = guideImages[i];
        //视图背景图片
        UIImageView *guideImg = [[UIImageView alloc] initWithFrame:CGRectMake(i*kScreenWidth, 0, kScreenWidth, kScreenHeight)];
        guideImg.image = [UIImage imageNamed:imgName1];
        [scrollView addSubview:guideImg];
        
    }

}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{

//    scrollView.contentOffset.x    x方向的偏移量
//    scrollView.contentSize.width  显示内容的宽度
//    scrollView.width
    NSLog(@"scrollView.width：%f",scrollView.width);
    NSLog(@"scrollView.contentSize.width: %f",scrollView.contentSize.width);
    
    //滑动到最后的时候
//    scrollView.contentOffset.x - (scrollView.contentSize.width-scrollView.width) = 0;
    
    CGFloat sub = scrollView.contentOffset.x - (scrollView.contentSize.width-scrollView.width);
    
    if (sub > 30)
    {
        
        //显示状态栏
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        // 加载故事版里面的控制器
        UIViewController *mainCtrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateInitialViewController];
        //取得当前的主window
//        [UIApplication sharedApplication].keyWindow
        /*
         如果视图view直接或者间接的显示window上，则可以通过self.view.window取得window对象
         */
        self.view.window.rootViewController = mainCtrl;
        
        mainCtrl.view.transform = CGAffineTransformMakeScale(.5, .5);
        
        //放大动画
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.5];
        
        mainCtrl.view.transform = CGAffineTransformIdentity;
        //关闭动画
        [UIView commitAnimations];
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
