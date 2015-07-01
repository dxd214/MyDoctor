//
//  NewsInfoViewController.h
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-12-3.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//

#import "BaseViewController.h"
#import "CollectModel.h"
@interface NewsInfoViewController : BaseViewController<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIWebView *_webView;    //网页视图
    UITableView *_tableView;
    BOOL _isClose;
}
@property(nonatomic,assign)NSInteger fontSize;//字体大小
@property(nonatomic,copy)NSString *html;
@property(nonatomic,copy)NSString *infoId;
@property(nonatomic,strong)NSArray *data;//分享列表数据
@property(nonatomic,strong)NSMutableArray *collectData;//分享列表数据
@property(nonatomic,strong)NSMutableArray *collectIdData;//分享列表数据
@property(nonatomic,strong)NSArray *images;//分享图片
@property(nonatomic,strong)CollectModel *model;

@property(nonatomic, copy) NSString *title;//标题
@property(nonatomic, copy) NSString *thumb;//图片
@property(nonatomic,copy)  NSString *content;//网页内容


@end
