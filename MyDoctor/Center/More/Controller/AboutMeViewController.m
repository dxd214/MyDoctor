//
//  AboutMeViewController.m
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-12-3.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//

#import "AboutMeViewController.h"
#import "AboutMeModel.h"
@interface AboutMeViewController ()

@end

@implementation AboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _data = [NSMutableArray array];
    [self _initNavItem];
    [self _initViews];
    [self _loadData];
    // Do any additional setup after loading the view.
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
    [self.view addSubview:_tableView];
    
    //表的头视图
    UIImageView *headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _tableView.width, 100)];
    headerView.userInteractionEnabled = YES;
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 100, 30)];
    nameLabel.font = [UIFont boldSystemFontOfSize:17];
    nameLabel.text = @"丁香医生";
    [headerView addSubview:nameLabel];
    
    UILabel *versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 40, 250, 20)];
    versionLabel.text = @"软件版本：2.8.7（2014-11-24）";
    versionLabel.font = [UIFont systemFontOfSize:12];
    [headerView addSubview:versionLabel];

    UILabel *appLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 60, 100, 20)];
    appLabel.text = @"软件授权：丁香园";
    appLabel.font = [UIFont systemFontOfSize:12];
    [headerView addSubview:appLabel];
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-70, 20, 57, 57)];
    imgView.image = [UIImage imageNamed:@"Icon"];
    [headerView addSubview:imgView];

    
    _tableView.tableHeaderView = headerView;
    

    
}
- (void)_loadData
{
    //获取数据
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"AboutMe.plist" ofType:nil];
    NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
    for(NSDictionary *dic in array)
    {
        AboutMeModel *model = [[AboutMeModel alloc]init];
        model.title = dic[@"title"];
        model.detail = dic[@"detail"];
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
    static NSString *iden = @"aboutCell" ;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:iden];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [_data[indexPath.row] title];
    cell.detailTextLabel.textAlignment = UITextAlignmentLeft;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.textColor = [UIColor greenColor];
    cell.detailTextLabel.text = [_data[indexPath.row] detail];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //点击单元格时间
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
