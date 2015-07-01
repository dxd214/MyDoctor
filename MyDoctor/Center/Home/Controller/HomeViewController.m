//
//  HomeViewController.m
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-11-29.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeCell.h"
#import "HomeModel.h"
#import "SearchViewController.h"
#import "BaseNavViewController.h"
#import "NearByViewController.h"
//#import "ZBarViewController.h"
@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad
{

    [super viewDidLoad];
    _data = [NSMutableArray array];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"HomeSelBg.png"]];
    [self _initViews];

    [self loadData];
    
}

- (void)_initViews
{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-49) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    //表的头视图
    UIImageView *headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _tableView.width, 80)];
    headerView.backgroundColor = [UIColor grayColor];
    headerView.userInteractionEnabled = YES;
    headerView.image = [UIImage imageNamed:@"IndexLogoBg"];
   
    //搜索图片按钮
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake((kScreenWidth-240)/2, 20, 240, 40);

#warning mark-这里的图片大小有问题
    UIImage *image = [UIImage imageNamed:@"SearchBgIndex"];
    image = [image stretchableImageWithLeftCapWidth:150 topCapHeight:3];
    [searchBtn setImage:image forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:searchBtn];

    _tableView.tableHeaderView = headerView;
    
}
- (void)buttonAction{
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    BaseNavViewController *navVC = [[BaseNavViewController alloc]initWithRootViewController:searchVC];
    [self presentViewController:navVC animated:YES completion:nil];
}
- (void)loadData
{
    //获取数据
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"HomeItem.plist" ofType:nil];
    _array = [NSArray arrayWithContentsOfFile:filePath];
    for (int i = 0;i<_array.count;i++)
    {
        NSArray *array2D = _array[i];
        NSMutableArray *dataIn = [NSMutableArray array];
        for(NSDictionary *dic in array2D)
        {
            HomeModel *model = [[HomeModel alloc]init];
            model.imgName = dic[@"imgName"];
            model.title = dic[@"title"];
            model.detail = dic[@"detail"];
            [dataIn addObject:model];
        }
        [_data addObject:dataIn];
    }

    [_tableView reloadData];

}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _array.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array2D = _array[section];
    return array2D.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"homeCell";
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"HomeCell" owner:nil options:nil]lastObject];
    }
    HomeModel *model = _data[indexPath.section][indexPath.row];
    cell.model = model;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            //对症找药
        }
        else if (indexPath.row == 1)
        {
            //虚假药品曝光
        }
        else
        {
            //附近药店
            // 创建附近微博视图控制器
            NearByViewController *nearbyVC = [[NearByViewController alloc] init];
            [self.navigationController pushViewController:nearbyVC animated:YES];

        }
    }
    else
    {
        if(indexPath.row == 0)
        {
            //扫一扫
//            ZBarViewController *readerVC = [[ZBarViewController alloc]init];
//            BaseNavViewController *navVC = [[BaseNavViewController alloc]initWithRootViewController:readerVC];
//            [self.navigationController pushViewController:navVC animated:YES];
        }
        else
        {
            //服药提醒
            
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

@end
