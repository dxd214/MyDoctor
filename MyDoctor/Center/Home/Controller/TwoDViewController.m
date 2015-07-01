//
//  TwoDViewController.m
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-12-1.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//

#import "TwoDViewController.h"


@interface TwoDViewController ()

@end

@implementation TwoDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //布局
    [self _initViews];
    //扫描二维码
    [self initTakeWork];

    
}
//布局
- (void)_initViews
{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 120, 60, 200)];
    UIView *downView = [[UIView alloc]initWithFrame:CGRectMake(0, 320, kScreenWidth, 120)];
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(260, 120, 60, 200)];
    
    topView.backgroundColor = [UIColor colorWithRed:.5 green:.5 blue:.5 alpha:.5];
    [self.view addSubview:topView];
    leftView.backgroundColor = [UIColor colorWithRed:.5 green:.5 blue:.5 alpha:.5];
    [self.view addSubview:leftView];
    downView.backgroundColor = [UIColor colorWithRed:.5 green:.5 blue:.5 alpha:.5];
    [self.view addSubview:downView];
    rightView.backgroundColor = [UIColor colorWithRed:.5 green:.5 blue:.5 alpha:.5];
    [self.view addSubview:rightView];
    
    [self performSelector:@selector(Action) withObject:self afterDelay:.35];

}
//扫描动画
- (void)Action
{
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(60, 120, 200, 1)];
    lineView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:lineView];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:2];
    [UIView setAnimationRepeatCount:999];
    [UIView setAnimationRepeatAutoreverses:YES];
    lineView.frame = CGRectMake(60, 320, 200, 1);
    
    
    [UIView commitAnimations];
}

//扫描二维码
- (void)initTakeWork
{
    
    ZBarReaderViewController *readerVC = [ZBarReaderViewController new];
    readerVC.readerDelegate = self;
    readerVC.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = readerVC.scanner;
    
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    [self presentViewController:readerVC animated:YES completion:nil];
    
}
//自动旋转屏幕
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
//扫描结束之后，自动读取并显示了条形码的图片和内容
- (void) imagePickerController: (UIImagePickerController*) readerPC
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    
    _imageview.image =
    [info objectForKey: UIImagePickerControllerOriginalImage];
    
    [readerPC dismissViewControllerAnimated:YES completion:nil];
    
    //判断是否包含 头'http:'
    NSString *regex = @"http+:[^\\s]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    //判断是否包含 头'ssid:'
    NSString *ssid = @"ssid+:[^\\s]*";;
    NSPredicate *ssidPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ssid];
    
    if ([predicate evaluateWithObject:symbol.data])
    {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                        message:@"用浏览器打开"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
        alert.tag=1;
        [alert show];
        
        
    }
    else if([ssidPre evaluateWithObject:symbol.data])
    {
        
        NSArray *arr = [symbol.data componentsSeparatedByString:@";"];
        
        NSArray * arrInfoFoot = [[arr objectAtIndex:1] componentsSeparatedByString:@":"];
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:symbol.data message:@"网址已经复制到剪贴板，即将在浏览器中打开" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:@"确定", nil];
        alert.delegate = self;
        alert.tag=2;
        [alert show];
        
        // 然后，可以使用如下代码来把一个字符串放置到剪贴板上：
        UIPasteboard *pasteboard=[UIPasteboard generalPasteboard];
        pasteboard.string = [arrInfoFoot objectAtIndex:1];
        
        
    }
}
#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    
}

@end
