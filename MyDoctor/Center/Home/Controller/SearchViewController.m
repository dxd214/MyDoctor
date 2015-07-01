//
//  SearchViewController.m
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-12-1.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResultViewController.h"
@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad
{
    self.title = @"搜索";
    [super viewDidLoad];
    _data = [[NSMutableArray alloc]init];
    [self _initViews];
    [self loadData];
}
- (void)_initViews
{
    //搜索框
    _mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-20, 40)];
    _mySearchBar.backgroundColor = [UIColor clearColor];
    _mySearchBar.delegate = self;
    [_mySearchBar setPlaceholder:@"感冒、阿司匹林或aspl"];
    [_mySearchBar setShowsCancelButton:YES];
    [_mySearchBar becomeFirstResponder];
    _mySearchBar.backgroundImage = [UIImage imageNamed:@"SearchBg"];
    self.navigationItem.titleView = _mySearchBar;
    
    //表视图
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    //表的头视图
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    //选项卡
    NSArray *items = [NSArray arrayWithObjects:@"文章",@"药品", nil];
    UISegmentedControl *segmentCtrl = [[UISegmentedControl alloc]initWithItems:items];
    segmentCtrl.frame = CGRectMake(20, 10, kScreenWidth - 40, 30);
    segmentCtrl.selectedSegmentIndex = 0;
    [segmentCtrl addTarget:self action:@selector(segementAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:segmentCtrl];
    _tableView.tableHeaderView = headerView;
     
}

//分页控件
- (void)segementAction:(UISegmentedControl *)segemrntCtrl
{
    NSLog(@"分页控件");
}
#warning  Todo 每次点击搜索键，获取输入框的文字并添加到数组中，然后push到搜索结果页面
//加载数据
- (void)loadData
{
    //历史关键字
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"DefaultKeywords.plist" ofType:nil];
    _data = [NSArray arrayWithContentsOfFile:filePath];
    
}
#pragma UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        
    }
    cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
    cell.textLabel.text = _data[indexPath.row];
    if(indexPath.row == 0)
    {
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.tintColor = [UIColor lightGrayColor];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 40;
    }
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.将文字显示在搜索框
    _mySearchBar.text = _data[indexPath.row];
    //2.搜索
    
    
}

#pragma UISearchBarDelegate
//点击取消按钮
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [_mySearchBar resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
