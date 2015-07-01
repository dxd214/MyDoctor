//
//  HeathViewController.m
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-11-29.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//项目简介
//项目难点
//心得体会，遇到的问题和解决方案
#import "HeathViewController.h"
#import "NewsCell.h"
#import "TopCell.h"
#import "TopModel.h"
#import "NewsModel.h"
#import "NewsInfoViewController.h"
#import "BaseNavViewController.h"
#import "TopicDetailViewController.h"
@interface HeathViewController ()

@end

@implementation HeathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _topData = [NSMutableArray array];
    _newsData = [NSMutableArray array];
    _myData = [NSMutableArray array];
    [self _initTopView];
    [self _initViews];
    [self _initTableView];
   
}
#pragma mark - UI设计
//自定义顶部视图
- (void)_initTopView
{
    // 1.创建标签栏
    _topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bar"]];
    // 2.开启点击事件
    _topView.userInteractionEnabled = YES;
    //3.添加选中图片
    _selectedImg = [[UIImageView alloc] initWithFrame:CGRectMake(7, 2, 51, 45)];
    _selectedImg.image = [UIImage imageNamed:@"selectTabbar_bg_all1"];
    _selectedImg.userInteractionEnabled = YES;
    [_topView addSubview:_selectedImg];
    
    // 4.创建标签按钮
    NSArray *titles = @[@"最新文章",@"健康专题",@"个人收藏"];
    for (int i = 0; i < titles.count; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(kScreenWidth / 3.0 * i, 0, kScreenWidth / 3.0, 45);
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        // 设置点击事件
        button.tag = i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:button];
        if (i == 0)
        {
            _selectedImg.center = CGPointMake(button.center.x, button.center.y + 2);
        }
    }
    
}

- (void)_initViews
{
    //创建显示在滚动视图上的子视图
    _ScrollView.showsVerticalScrollIndicator = NO;
    _ScrollView.pagingEnabled = YES;
    //设置代理方法
    _ScrollView.delegate = self;
    _ScrollView.contentSize = CGSizeMake(kScreenWidth*3, kScreenHeight-64-49-50);
    
    _view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight-64-49-50)];
    _view1.backgroundColor = [UIColor orangeColor];
    [_ScrollView addSubview:_view1];
    
    _view2 = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight-64-49-50)];
    _view2.backgroundColor = [UIColor redColor];
    [_ScrollView addSubview:_view2];
    
    _view3 = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth*2, 0, kScreenWidth, kScreenHeight-64-49-50)];
    _view3.backgroundColor = [UIColor greenColor];
    [_ScrollView addSubview:_view3];
    
}
- (void)buttonAction:(UIButton *)button
{
    //切换视图控制器
    CGPoint point = CGPointMake(kScreenWidth*button.tag, 0);
    [_ScrollView setContentOffset:point animated:YES];

    //添加动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.2];
    
    _selectedImg.center = button.center;
    
    [UIView commitAnimations];
}
#pragma mark - UIScrollView delegate
//视图停止以后调用
- (void)scrollViewDidEndDecelerating:(UIButton *)button
{
    int count = _ScrollView.contentOffset.x/kScreenWidth;
    button.tag = count;
    if (button.tag == 1)
    {
        [_newsTableView reloadData];
    }
    else if (button.tag == 2)
    {
        [_topTableView reloadData];
    }
    else
    {
        [_myTableView reloadData];
    }
}
#pragma mark - 表格UI
- (void)_initTableView
{
    _newsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-65-49-50) style:UITableViewStylePlain];
    _newsTableView.delegate = self;
    _newsTableView.dataSource = self;
    [_view1 addSubview:_newsTableView];
    [self _loadData:_newsTableView];
    
    _topTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-65-49-50) style:UITableViewStylePlain];
    _topTableView.delegate = self;
    _topTableView.dataSource = self;
    [_view2 addSubview:_topTableView];
    [self _loadData:_topTableView];
    
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-65-49-50) style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [_view3 addSubview:_myTableView];
    [self _loadCollectData];
    
}
#pragma mark -加载数据
//从plist文件加载个人收藏数据
- (void)_loadCollectData
{
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"Collect.plist" ofType:nil];
    NSArray *collectData = [NSArray arrayWithContentsOfFile:filePath];
    for(NSDictionary *dic in collectData)
    {
        CollectModel *model = [[CollectModel alloc]initWithContentsOfDic:dic];
        [_myData addObject:model];
    }
    [_myTableView reloadData];
   
    
}
//给最新新闻和话题新闻添加数据
- (void)_loadData:(UITableView *)tableView
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (tableView == _newsTableView)
    {
        [params setObject:@"1417573420226" forKey:@"last_time"];
    }
    else if (tableView == _topTableView)
    {
        [params setObject:@"1" forKey:@"page"];
    }
    
    NSString *urlString = tableView == _newsTableView?JK_api_info:JK_api_topic;
    
    //详细信息请求
    [DataService requestAFWithUrl:urlString params:params reqestHeader:nil httpMethod:@"GET" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         // 把请求下来的数据解析成数据原型对象
         // 把请求下来的数据解析成数据原型对象
         NSString *dataString = [result[@"data"] substringFromIndex:1];
         NSRange range = {0,dataString.length-1};
         NSString *subString3 = [dataString substringWithRange:range];
         //"{},{},{}"
         NSArray *array = [subString3 componentsSeparatedByString:@"},"];
         for (int i=0;i < array.count;i++)
         {
             NSString *str = array[i];
             if(i != array.count-1)
             {
                 str = [NSString stringWithFormat:@"%@}",str];
             }
             
             NSDictionary *dic = [self dictionaryWithJsonString:str];
             if(tableView == _newsTableView)
             {
                 NewsModel *model = [[NewsModel alloc]initWithContentsOfDic:dic];
                 [_newsData addObject:model];
             }
             else if(tableView == _topTableView)
             {
                 TopModel *model = [[TopModel alloc]initWithContentsOfDic:dic];
                 [_topData addObject:model];
             }
         }
         
         [tableView reloadData];


     } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"ERROR:%@",error);
     }];

}

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

#pragma mark- UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView ==_newsTableView)
    {
        return _newsData.count;
    }
    else if(tableView == _topTableView)
    {
        return _topData.count;
    }
    else
    {
        return _myData.count;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _newsTableView)
    {
        static NSString *iden = @"newsCell" ;
        NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if(cell == nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"NewsCell" owner:nil options:nil]lastObject];
        }
        cell.model = _newsData[indexPath.row];
        return cell;
    }
    else if(tableView == _topTableView)
    {
        static NSString *iden = @"topCell" ;
        TopCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if(cell == nil)
        {

            cell = [[[NSBundle mainBundle]loadNibNamed:@"TopCell"  owner:nil options:nil]lastObject];
            
        }
        cell.model = _topData[indexPath.row];
        return cell;

    }
    else
    {
        static NSString *iden = @"newsCell" ;
        NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if(cell == nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"NewsCell" owner:nil options:nil]lastObject];
        }
        cell.model = _myData[indexPath.row];
        return cell;
    }

    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //点击单元格时间
    if (tableView == _newsTableView)
    {
        NewsInfoViewController *newsInfoVC = [[NewsInfoViewController alloc]init];
        BaseNavViewController *baseNVC = [[BaseNavViewController alloc]initWithRootViewController:newsInfoVC];
        //将文章id给新闻页面
        newsInfoVC.infoId = [NSString stringWithFormat:@"%@",[_newsData[indexPath.row] iden]];
        [self presentViewController:baseNVC animated:YES completion:nil];

    }
    else if(tableView == _topTableView)
    {
        TopicDetailViewController *topInfoVC = [[TopicDetailViewController alloc]init];
        BaseNavViewController *baseNVC = [[BaseNavViewController alloc]initWithRootViewController:topInfoVC];
        //将话题id给话题页面
        topInfoVC.topicId = [NSString stringWithFormat:@"%@",[_topData[indexPath.row] topicId]];
//        [self.navigationController pushViewController:baseNVC animated:YES];
        [self presentViewController:baseNVC animated:YES completion:nil];
    }
    else
    {
        NewsInfoViewController *newsInfoVC = [[NewsInfoViewController alloc]init];
        BaseNavViewController *baseNVC = [[BaseNavViewController alloc]initWithRootViewController:newsInfoVC];
        //将文章id给新闻页面
        newsInfoVC.infoId = [NSString stringWithFormat:@"%@",[_myData[indexPath.row] iden]];
        [self presentViewController:baseNVC animated:YES completion:nil];

    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _topTableView)
    {
        return 112;
    }
    else
        return 80;
}



@end
