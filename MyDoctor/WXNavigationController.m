//
//  WXNavigationController.m
//  weibo
//
//  Created by zsm on 14-11-14.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "WXNavigationController.h"

@interface WXNavigationController ()
{
    UIPanGestureRecognizer *_pan;  // 手势
    float _animationTime;          // 手势的动画时间
    UIViewController *_topCtrl;     // 当前的控制器
    CGPoint _startPoint;           // 滑动手势开始位置
}
@property (nonatomic,strong) UIView *backgroundView;   //背景视图
@property (nonatomic,strong) UIImageView *backImageView;   //截图视图
@property (nonatomic,strong) UIView *alphaView;   //遮罩视图

@end

@implementation WXNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 1.创建收拾对象
    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self.view addGestureRecognizer:_pan];
    // 禁用手势
    [_pan setEnabled:NO];
    
    // 2.动画时间
    _animationTime = .35;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPan Action
- (void)panAction:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateBegan) {
        // 滑动开始
        // 1.记录位置
        _startPoint = [pan locationInView:self.view.window];
        
        // 2.记录当前现实的控制器
        _topCtrl = self.topViewController;
        
        // 3.重置pop动画视图的位置
        [self popSetAnimationView];
        
        // 4.让内容视图控制器返回到上一级控制器
        [super popViewControllerAnimated:NO];
        
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        // 滑动改变（根据滑动的位置改变视图的对应效果）
        // 1.获取当前手指位置
        CGPoint movePoint = [pan locationInView:self.view.window];
        [self moveViewPopWithX:movePoint.x - _startPoint.x];
        
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        // 滑动结束 （判断最终的滑动结果）
        CGPoint endPoint = [pan locationInView:self.view.window];
        [self panStateEndAnimationWithEndPoint:endPoint];

    }
}

// 滑动结束，手指离开屏幕时调用的方法
- (void)panStateEndAnimationWithEndPoint:(CGPoint)endPoint
{
    if (endPoint.x - _startPoint.x > 50) {
        // 满足条件继续执行pop动画
        
        // 计算动画时间
        _animationTime = .35 - (endPoint.x - _startPoint.x) / kScreenWidth * .35;
        [UIView animateWithDuration:_animationTime animations:^{
            [self moveViewPopWithX:kScreenWidth];
        } completion:^(BOOL finished) {
            _topCtrl = nil;
            // 恢复设置
            UIView *contextView = self.tabBarController == nil ? self.view : self.tabBarController.view;
            contextView.transform = CGAffineTransformIdentity;
            [_backImageView removeFromSuperview];
            [_backgroundView removeFromSuperview];
            [_alphaView removeFromSuperview];
            
            if (self.viewControllers.count == 1) {
                // 禁用手势
                [_pan setEnabled:NO];
            } else {
                // 开启
                [_pan setEnabled:YES];
            }
        }];
    } else if (endPoint.x - _startPoint.x > 0) {
        // 回到原始状态
        
        // 1.计算动画时间
        _animationTime = (endPoint.x - _startPoint.x) / kScreenWidth * .35;
        
        [UIView animateWithDuration:_animationTime animations:^{
            [self moveViewPopWithX:0];
        } completion:^(BOOL finished) {
            // 把内容视图控制器push到原始控制器
            [super pushViewController:_topCtrl animated:NO];
            _topCtrl = nil;
            // 恢复设置
            UIView *contextView = self.tabBarController == nil ? self.view : self.tabBarController.view;
            contextView.transform = CGAffineTransformIdentity;
            [_backImageView removeFromSuperview];
            [_backgroundView removeFromSuperview];
            [_alphaView removeFromSuperview];
            
            if (self.viewControllers.count == 1) {
                // 禁用手势
                [_pan setEnabled:NO];
            } else {
                // 开启
                [_pan setEnabled:YES];
            }
        }];
        
    } else {
        // 把内容视图控制器push到原始控制器
        [super pushViewController:_topCtrl animated:NO];
        // 恢复设置
        UIView *contextView = self.tabBarController == nil ? self.view : self.tabBarController.view;
        contextView.transform = CGAffineTransformIdentity;
        [_backImageView removeFromSuperview];
        [_backgroundView removeFromSuperview];
        [_alphaView removeFromSuperview];
        _topCtrl = nil;
        if (self.viewControllers.count == 1) {
            // 禁用手势
            [_pan setEnabled:NO];
        } else {
            // 开启
            [_pan setEnabled:YES];
        }

    }
}

#pragma mark - 重写导航控制器的push 和pop方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 1.创建动画视图
    [self pushSetAnimationView];
    
    // 2.把内容视图移动到屏幕的右边，设置透明度和缩放
    [self moveViewPushWithX:kScreenWidth];
    
    // 3.执行无动画导航
    [super pushViewController:viewController animated:NO];
    
    // 4.执行动画
    [UIView animateWithDuration:.35 animations:^{
        [self moveViewPushWithX:0];
    } completion:^(BOOL finished) {
        // 恢复设置
        _backImageView.transform = CGAffineTransformIdentity;
        [_backImageView removeFromSuperview];
        [_backgroundView removeFromSuperview];
        [_alphaView removeFromSuperview];
        
        if (self.viewControllers.count == 1) {
            // 禁用手势
            [_pan setEnabled:NO];
        } else {
            // 开启
            [_pan setEnabled:YES];
        }
    }];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    // 1.创建动画视图
    [self popSetAnimationView];
    
    // 2.把内容视图移动到屏幕的右边，设置透明度和缩放
    [self moveViewPopWithX:0];
    
    // 3.执行无动画导航
    UIViewController *viewCtrl = [super popViewControllerAnimated:NO];
    
    // 4.执行动画
    [UIView animateWithDuration:.35 animations:^{
        [self moveViewPopWithX:kScreenWidth];
    } completion:^(BOOL finished) {
        // 恢复设置
        UIView *contextView = self.tabBarController == nil ? self.view : self.tabBarController.view;
        contextView.transform = CGAffineTransformIdentity;
        [_backImageView removeFromSuperview];
        [_backgroundView removeFromSuperview];
        [_alphaView removeFromSuperview];
        
        if (self.viewControllers.count == 1) {
            // 禁用手势
            [_pan setEnabled:NO];
        } else {
            // 开启
            [_pan setEnabled:YES];
        }
    }];
    
    
    return viewCtrl;
}

// 创建POP时候动画的视图
- (void)popSetAnimationView
{
    // 1.获取当前设备的截图
    UIImage *captureImage = [self capture];
    
    // 2.视图的大小
    float version = [[UIDevice currentDevice].systemVersion floatValue];
    CGRect frame = CGRectMake(0, 0, kScreenWidth, version >= 7.0 ? kScreenHeight : kScreenHeight - 20);
    
    // 3.创建背景视图
    if (_backgroundView == nil) {
        _backgroundView = [[UIView alloc] initWithFrame:frame];
        _backgroundView.backgroundColor = [UIColor blackColor];
    }
    // 添加到截图视图之前
    UIView *contextView = self.tabBarController == nil ? self.view : self.tabBarController.view;
    [contextView.superview insertSubview:_backgroundView belowSubview:contextView];
    
    // 4.遮罩视图
    if (_alphaView == nil) {
        _alphaView = [[UIView alloc] initWithFrame:frame];
        _alphaView.backgroundColor = [UIColor blackColor];
        _alphaView.alpha = .1;
    }
    [contextView.superview insertSubview:_alphaView aboveSubview:contextView];
    
    // 5.创建截图视图
    if (_backImageView == nil) {
        _backImageView = [[UIImageView alloc] initWithFrame:frame];
    }
    _backImageView.left = 0;
    // 设置图片并添加
    _backImageView.image = captureImage;
    [contextView.superview insertSubview:_backImageView aboveSubview:_alphaView];
}

// 创建PUSH时候的动画视图
- (void)pushSetAnimationView
{
    // 1.获取当前设备的截图
    UIImage *captureImage = [self capture];
    
    // 2.视图的大小
    float version = [[UIDevice currentDevice].systemVersion floatValue];
    CGRect frame = CGRectMake(0, 0, kScreenWidth, version >= 7.0 ? kScreenHeight : kScreenHeight - 20);
    
    // 3.创建背景视图
    if (_backgroundView == nil) {
        _backgroundView = [[UIView alloc] initWithFrame:frame];
        _backgroundView.backgroundColor = [UIColor blackColor];
    }
    // 添加到截图视图之前
    UIView *contextView = self.tabBarController == nil ? self.view : self.tabBarController.view;
    [contextView.superview insertSubview:_backgroundView belowSubview:contextView];
    
    // 4.创建截图视图
    if (_backImageView == nil) {
        _backImageView = [[UIImageView alloc] initWithFrame:frame];
    }
    _backImageView.left = 0;
    // 设置图片并添加
    _backImageView.image = captureImage;
    [contextView.superview insertSubview:_backImageView belowSubview:contextView];
    
    // 5.遮罩视图
    if (_alphaView == nil) {
        _alphaView = [[UIView alloc] initWithFrame:frame];
        _alphaView.backgroundColor = [UIColor blackColor];
        _alphaView.alpha = .1;
    }
    [contextView.superview insertSubview:_alphaView belowSubview:contextView];
    
    
}

// 获取当前设备的截图
- (UIImage *)capture
{
    // 获取需要截取的视图
    UIView *view = self.tabBarController == nil ? self.view : self.tabBarController.view;
    if (view == nil) {
        return nil;
    }
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}

#pragma mark - 导航效果设置
- (void)moveViewPushWithX:(float)x
{
    // 容错 0 < x < kScreenWidth
    x = MIN(x, kScreenWidth);
    x = MAX(x, 0);
    
    // 定义视图的缩放比例
    float scale = (x / kScreenWidth) * .1 + .9;
    _backImageView.transform = CGAffineTransformMakeScale(scale, scale);
    
    // 定义遮罩视图的透明度
    float alpha = .5 - (x / kScreenWidth) * .5;
    _alphaView.alpha = alpha;
    
    // 当前内容视图移动到最右边
    UIView *contextView = self.tabBarController == nil ? self.view : self.tabBarController.view;
    contextView.left = x;
}

- (void)moveViewPopWithX:(float)x
{
    // 容错 0 < x < kScreenWidth
    x = MIN(x, kScreenWidth);
    x = MAX(x, 0);
    
    // 定义视图的缩放比例
    float scale = (x / kScreenWidth) * .1 + .9;
    UIView *contextView = self.tabBarController == nil ? self.view : self.tabBarController.view;
    contextView.transform = CGAffineTransformMakeScale(scale, scale);
    
    // 定义遮罩视图的透明度
    float alpha = .5 - (x / kScreenWidth) * .5;
    _alphaView.alpha = alpha;
    
    // 当前内容视图移动到最右边
    _backImageView.left = x;
}
@end
