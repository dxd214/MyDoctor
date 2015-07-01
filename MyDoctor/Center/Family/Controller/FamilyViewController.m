//
//  FamilyViewController.m
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-11-29.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//

#import "FamilyViewController.h"
#import "AddInfoViewController.h"
#import "FamilyCell.h"
#import "User.h"
#import "BaseNavViewController.h"

@interface FamilyViewController ()

@end

@implementation FamilyViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self _loadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _data = [NSMutableArray array];
    [self _initViews];
    [self _loadData];
    self.view.backgroundColor = [UIColor redColor];
}
- (void)_loadData
{
    // 查询
    CoreDataDBHelper *dbHelper = [CoreDataDBHelper shareCoreDataDBHelper];
    
    NSArray *array = [dbHelper selectDataWithModelName:@"User" predicateString:nil sort:nil ascending:NO];
    for(User *user in array)
    {
        [_data addObject:user];
    }
    [_tableView reloadData];
}


- (void)_initViews
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-49) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}

#pragma mark- UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if(section == 0)
    {
        return _data.count+1;
    }
    else
        return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        static NSString *iden = @"familyCell" ;
        FamilyCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if(cell == nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"FamilyCell"  owner:nil options:nil]lastObject];
            
        }
        //第一组
        if (indexPath.section == 0)
        {
            if(indexPath.row == _data.count)
            {
                cell.nameLabel.text = @"新增成员";
                cell.faceImgView.image = [UIImage imageNamed:@"TitleIconAdd@3x"];
                cell.drugLabel.text = @"";
            }
            else
            {
                cell.model = _data[indexPath.row];
            }
        }
        else
        {
            //第二组
            if(indexPath.row == 0)
            {
                cell.nameLabel.text = @"家庭常备药品";
                cell.faceImgView.image = [UIImage imageNamed:@"TitleIconAdd"];
                cell.drugLabel.text = @"31种药品";
            }
            else if(indexPath.row == 1)
            {
                cell.nameLabel.text = @"疫苗管理";
                cell.faceImgView.image = [UIImage imageNamed:@"MustIconGray.png"];
                cell.drugLabel.text = @"儿童疫苗接种时间表";
            }
        }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //点击单元格时间
    if(indexPath.section ==0)
    {
        if(indexPath.row == _data.count)
        {
            //添加
            AddInfoViewController *addVC = [[AddInfoViewController alloc]init];
            BaseNavViewController *navVC = [[BaseNavViewController alloc]initWithRootViewController:addVC];
            [self presentViewController:navVC animated:YES completion:nil];
        }
        else
        {
            _cellName = [_data[indexPath.row] name];
            //删除
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"删除用户？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            //显示提示框
            [alertView show];
            
        }

    }
}
#pragma mark -UIAlertView delaget

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSLog(@"点击取消了");
    }else if (buttonIndex == 1)
    {
        
        CoreDataDBHelper *dbHelper = [CoreDataDBHelper shareCoreDataDBHelper];
        NSString *predicateString = [NSString stringWithFormat:@"self.name = '%@'",_cellName];
        BOOL result =  [dbHelper deleteDataWithModelName:@"User" predicateString:predicateString];
        NSLog(@"%@",result == YES?@"删除成功":@"失败");
        [self _loadData];
        
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    if(section == 0)
    {
        label.text = @"成员";
    }
    else
    {
        label.text = @"疫苗";
    }
    return label;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
