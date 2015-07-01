//
//  CommonViewController.m
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-12-2.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//

#import "CommonViewController.h"
#import "CommentCell.h"
#import "CommentModel.h"
#import "WebViewController.h"
@interface CommonViewController ()

@end

@implementation CommonViewController

- (void)viewDidLoad {
    self.title = @"应用推荐";
    [super viewDidLoad];
    [self _initNavItem];
    [self _initViews];
    [self _loadData];
}
- (void)_initNavItem
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, 44, 44);
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}
- (void)buttonAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
    //    [self popoverPresentationController];
}

- (void)_initViews
{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    
    [self.view addSubview:_tableView];
    
}
- (void)_loadData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"type"];
    [params setObject:@"2" forKey:@"productType"];
    
    // 请求数据
    [DataService requestAFWithUrl:JK_api_recommend params:params reqestHeader:nil httpMethod:@"GET" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        // 获取微博数组
        NSArray *array = [result objectForKey:@"data"];
        NSMutableArray *models = [NSMutableArray array];
        for (NSDictionary *dic in array)
        {
            CommentModel *model = [[CommentModel alloc]initWithContentsOfDic:dic];
            //保存下载链接
            self.urlDownload = model.downloadUrl;
            [models addObject:model];
        }
        self.data = models;
        [_tableView reloadData];
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
    }];

}
#pragma mark- UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"commentCell" ;
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if(cell == nil)
    {
        //在nib文件中给cell添加id
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CommentCell" owner:nil options:nil]lastObject];
    }
    cell.model = _data[indexPath.row];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //点击单元格事件
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"您确定下载软件吗？"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    
    //显示提示框
    [alertView show];
}
#pragma mark -UIAlertView delaget

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSLog(@"点击取消了");
    }
    else if (buttonIndex == 1)
    {

        NSLog(@"点击确定了");
        //下载页面
        WebViewController *webVC = [[WebViewController alloc]init];
        BaseNavViewController *baseNav = [[BaseNavViewController alloc]initWithRootViewController:webVC];
        webVC.urlString = self.urlDownload;
        [self.navigationController pushViewController:baseNav animated:YES];
//        [self presentViewController:baseNav animated:YES completion:nil];
        
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

@end
