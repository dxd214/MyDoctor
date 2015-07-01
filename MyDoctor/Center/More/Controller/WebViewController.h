//
//  WebViewController.h
//  weibo
//
//  Created by zsm on 14-11-18.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD.h"

@interface WebViewController : BaseViewController<UIWebViewDelegate>
{
    UIWebView *_webView;
    MBProgressHUD *_hud;
}

@property (nonatomic,copy) NSString *urlString;
@end
