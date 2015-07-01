//
//  NewsInfoViewController.m
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-12-3.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//

#import "NewsInfoViewController.h"
#import "ShareCell.h"
@interface NewsInfoViewController ()

@end

@implementation NewsInfoViewController

- (void)viewDidLoad {
    self.hidesBottomBarWhenPushed = YES;
    self.title = @"健康百科";
    [super viewDidLoad];
    _data = [NSArray array];
    _collectData = [NSMutableArray array];
    _collectIdData = [NSMutableArray array];
    _fontSize = 14;
    //创建视图
    [self _initNavItem];
    [self _initView];
    //加载数据
    [self _loadData];
    [self _loadTableViewData];
}
#pragma mark - UI设计
- (void)_initNavItem
{
    //左边按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.tag = 101;
    backButton.frame=CGRectMake(0, 0, 44, 44);
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
#warning 有问题，字体不能改变，不能收藏
    //右边按钮
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 44)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightView];
    //字体大小
    UIButton *fontButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fontButton.tag = 102;
    [fontButton setImage:[UIImage imageNamed:@"DrugIconText.png"] forState:UIControlStateNormal];
    [fontButton setImage:[UIImage imageNamed:@"DrugIconText2"] forState:UIControlStateHighlighted];
    fontButton.frame=CGRectMake(0, 0, 44, 44);
    [fontButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:fontButton];
    //分享
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.tag = 103;
    [shareButton setImage:[UIImage imageNamed:@"DrugIconText.png"] forState:UIControlStateNormal];
    [shareButton setImage:[UIImage imageNamed:@"DrugIconText2"] forState:UIControlStateHighlighted];
    shareButton.frame=CGRectMake(50, 0, 44, 44);
    [shareButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:shareButton];
    
    //收藏
    UIButton *collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    collectButton.tag = 104;
    [collectButton setImage:[UIImage imageNamed:@"DrugIcon04.png"] forState:UIControlStateNormal];
    [collectButton setImage:[UIImage imageNamed:@"DrugIcon04Sel.png"]forState:UIControlStateSelected];
    collectButton.frame=CGRectMake(100, 0, 44, 44);
    [collectButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:collectButton];
}
- (void)buttonAction:(UIButton *)button
{
    if(button.tag == 101)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    if(button.tag == 102)
    {
        //调整字体
        if(_fontSize < 20)
        {
            _fontSize +=2;
        }
        else
        {
            _fontSize = 14;
        }
        [self _loadData];
    }
    if(button.tag == 103)
    {
        _isClose = !_isClose;
        if(_isClose == YES)
        {
            [UIView animateWithDuration:.35 animations:^{
                _tableView.left = kScreenWidth;
                
            } completion:nil];
        }
        else
        {
            [UIView animateWithDuration:.35 animations:^{
                _tableView.left = kScreenWidth-200;
                
            } completion:nil];
        }

    }
    if(button.tag == 104)
    {
        [self collectButtonAction:button];
    }
}
#pragma mark - 保存数据到本地文件
//添加收藏，并将数据保存到本地【在显示页面从本地读取数据】
- (void)collectButtonAction:(UIButton *)button
{
    //添加到收藏列表
    //将文章的id和内容保存到本地plist文件
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Collect.plist" ofType:nil];
    NSArray *plistData = [[NSArray alloc] initWithContentsOfFile:plistPath];
    [_collectData addObjectsFromArray:plistData];
    //读取plist
    if(button.selected == NO)
    {
        [_collectIdData addObject:self.infoId];
        
        //添加一项内容
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:self.infoId forKey:@"infoId"];
        [dic setObject:self.title forKey:@"title"];
//        [dic setObject:self.thumb forKey:@"thumb"];
        [dic setObject:self.content forKey:@"content"];
        [_collectData addObject:dic];
        
        //获取应用程序沙盒的Documents目录
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *plistPath1 = [paths objectAtIndex:0];
        
        //得到完整的文件名
        NSString *filename=[plistPath1 stringByAppendingPathComponent:@"Collect.plist"];
        //输入写入
        [_collectData writeToFile:filename atomically:YES];
        NSLog(@"收藏成功");
        button.selected = !button.selected;
        
    }
    else
    {
        NSLog(@"您已经收藏");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"确定取消收藏吗？"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
        
        
        //显示提示框
        [alertView show];
        button.selected = !button.selected;
    }

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
    
        NSLog(@"取消收藏");
        [_collectIdData removeObject:self.infoId];
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Collect.plist" ofType:nil];
        NSArray *plistData = [[NSArray alloc] initWithContentsOfFile:plistPath];
        for(NSMutableDictionary *dic in plistData)
        {
            if([self.infoId isEqualToString:dic[@"infoId"]])
            {
                [dic removeAllObjects];
            }
            else
            {
                NSLog(@"没找到");
            }
        }
            //获取应用程序沙盒的Documents目录
            NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            NSString *plistPath1 = [paths objectAtIndex:0];
            
            //得到完整的文件名
            NSString *filename=[plistPath1 stringByAppendingPathComponent:@"Collect.plist"];
            //输入写入
            [_collectData writeToFile:filename atomically:YES];
            NSLog(@"收藏成功");

        
    }
    
}

//创建视图
- (void)_initView {
    
    //创建网页视图
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    //缩放网页以适合屏幕大小显示
    _webView.scalesPageToFit = YES;
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth, 0, 200, kScreenHeight-64) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor blackColor];
    _tableView.alpha = .8;
    _isClose = YES;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
}
#pragma mark -处理数据，网络请求详细信息
/*
 //获取数据 @"%d%@%d%d%d%d%@"
 font: 14dpx FZLTHJW--GB1-0; //方正兰亭字体
 //背景图片url(WriteIcon.png) no-repeat left center;
 // 行间距margin: 1.5em 0em 0em -.55em;
 */
//处理数据，以及详细地图信息的数据请求

//加载数据
- (void)_loadData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.infoId forKey:@"infoId"];
    //详细信息请求
    [DataService requestAFWithUrl:JK_api_info params:params reqestHeader:nil httpMethod:@"GET" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         //加载html数据
         self.content = result[@"data"];
         NSURL *baseURL = [NSBundle mainBundle].resourceURL;
         //显示网页
         [_webView loadHTMLString:self.content baseURL:baseURL];

     } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"ERROR:%@",error);
     }];
    
}
//分享数据
- (void)_loadTableViewData
{
    _data = @[@"微信好友",@"朋友圈",@"新浪微博",@"QQ空间"];
    _images = @[@"ShareWeixin.png",@"ShareFriend.png",@"ShareWeibo.png",@"ShareQzone.png"];
}
#pragma mark- UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"shareCell" ;
    ShareCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ShareCell"  owner:nil options:nil]lastObject];
        
    }
    cell.shareLabel.text = _data[indexPath.row];
    cell.shareImgView.image = [UIImage imageNamed:_images[indexPath.row]];
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //点击单元格时间
}
#pragma webViewDelegate
//代码如下：
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *strSize=[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.fontSize='%ldpx';var pArray = document.getElementsByTagName('p');for(var i=0; i<pArray.length;i++){var spanArray = document.getElementsByTagName('span');pArray[i].style.fontSize='%ldpx';for(var j=0; j<spanArray.length;j++){spanArray[j].style.fontSize='%ldpx';}}",_fontSize,_fontSize,_fontSize];
    [webView stringByEvaluatingJavaScriptFromString:strSize];
}



@end
