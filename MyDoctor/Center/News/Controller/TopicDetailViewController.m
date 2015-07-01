//
//  TopicDetailViewController.m
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-12-3.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//

#import "TopicDetailViewController.h"
#import "NewsCell.h"
#import "NewsInfoViewController.h"
#import "NewsModel.h"
@interface TopicDetailViewController ()

@end

@implementation TopicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _data = [NSMutableArray array];
    [self _initViews];
    [self _initNavItem];
    [self _loadData];
}
- (void)_initNavItem
{
    //左边按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0, 44, 44);
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
}
- (void)buttonAction:(UIButton *)button
{

    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)_initViews
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}
//加载数据
- (void)_loadData
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.topicId forKey:@"topicId"];
    [params setObject:@"1" forKey:@"page"];
    //详细信息请求
    [DataService requestAFWithUrl:JK_api_topic params:params reqestHeader:nil httpMethod:@"GET" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"result%@",result);
         // 把请求下来的数据解析成数据原型对象
         [self dataSave:result];
     } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"ERROR:%@",error);
         //        [self performSelector:@selector(loadNearByWeiboWithlong:lat:) withObject:nil afterDelay:2];
     }];
    
}
#pragma mark -处理数据，网络请求详细信息
/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil)
    {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

//处理数据，以及详细地图信息的数据请求
- (void)dataSave:(id)result
{
    // 把请求下来的数据解析成数据原型对象
    // 把请求下来的数据解析成数据原型对象
    NSArray *data = result[@"data"];
    for(NSDictionary *dic in data)
    {
        NewsModel *model = [[NewsModel alloc]initWithContentsOfDic:dic];
        [_data addObject:model];
    }
    [_tableView reloadData];
    
}

#pragma mark- UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"newsCell" ;
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"NewsCell"  owner:nil options:nil]lastObject];
        
    }
    cell.model = _data[indexPath.row];
    return cell;

    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NewsInfoViewController *newsInfoVC = [[NewsInfoViewController alloc]init];
    BaseNavViewController *baseNVC = [[BaseNavViewController alloc]initWithRootViewController:newsInfoVC];
    //将文章id给新闻页面
    newsInfoVC.infoId = [NSString stringWithFormat:@"%@",[_data[indexPath.row] iden]];
    [self presentViewController:baseNVC animated:YES completion:nil];

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
