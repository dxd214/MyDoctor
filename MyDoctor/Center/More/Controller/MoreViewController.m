//
//  MoreViewController.m
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-12-1.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//

#import "MoreViewController.h"
#import "LoginViewController.h"
#import "CommonViewController.h"
#import "ReceiveNewsCell.h"
#import "AboutMeViewController.h"
#import "ShareViewController.h"
//#import "KFViewController.h"
@interface MoreViewController ()

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self _initViews];
    [self loadData];

}

- (void)_initViews
{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-49-94) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    //表的头视图
    UIImageView *headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _tableView.width, 110)];
    headerView.backgroundColor = [UIColor lightGrayColor];
    headerView.userInteractionEnabled = YES;

    //头像按钮
    UIButton *userFaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    userFaceBtn.frame = CGRectMake((kScreenWidth-60)/2, 10, 60, 60);
    [userFaceBtn setImage:[UIImage imageNamed:@"BigIconMan"] forState:UIControlStateNormal];
    [userFaceBtn addTarget:self
                    action:@selector(buttonAction:)
          forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:userFaceBtn];
    //登陆标签
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(userFaceBtn.left+15, userFaceBtn.bottom+10, 50, 20)];
    label.text = @"登录";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:15];
    [headerView addSubview:label];
    _tableView.tableHeaderView = headerView;
    
    
}
//登陆
- (void)buttonAction:(UIButton *)button
{
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    BaseNavViewController *baseNav = [[BaseNavViewController alloc]initWithRootViewController:loginVC];
    [self presentViewController:baseNav animated:YES completion:nil];
//    [self.navigationController pushViewController:navVC animated:YES];

}
- (void)loadData
{
    //读取plist文件
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MoreList.plist" ofType:nil];
    _data = [[NSArray alloc] initWithContentsOfFile:plistPath];
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        ReceiveNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid_one"];
        if(cell == nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ReceiveNewsCell" owner:nil options:nil]lastObject];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.receiveNewsLabel.text = _data[indexPath.row];
        return cell;
    }
    else
    {
        static NSString *iden = @"CellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:iden] ;
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:14];

    }
    //显示的内容
    cell.textLabel.text = _data[indexPath.row];
    if (indexPath.row == 1)
    {
        cell.detailTextLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        //将字节转换成M
        float s = sum/(1024*1024.0);
        //添加显示缓存的label
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1fM",s];
    }
        return cell;
    }

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0)
    {
        //接收推送
        
    }
    else if (indexPath.row == 1)
    {
        //清除缓存
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否清除缓存？？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];

    }
    else if (indexPath.row == 2)
    {
        //用户反馈
        //应用推荐
//        KFViewController *kfVC = [[KFViewController alloc]init];
//        BaseNavViewController *baseNav = [[BaseNavViewController alloc]initWithRootViewController:kfVC];
//        [self presentViewController:baseNav animated:YES completion:nil];
        
    }
    else if (indexPath.row == 3)
    {
#warning 有问题
        //应用推荐
        CommonViewController *commonVC = [[CommonViewController alloc]init];
        BaseNavViewController *baseNav = [[BaseNavViewController alloc]initWithRootViewController:commonVC];
        [self presentViewController:baseNav animated:YES completion:nil];
//        [self.navigationController pushViewController:baseNav animated:YES];

    }
    else if (indexPath.row == 4)
    {
        //关于我们
        AboutMeViewController *aboutVC = [[AboutMeViewController alloc]init];
        BaseNavViewController *baseNav = [[BaseNavViewController alloc]initWithRootViewController:aboutVC];
        [self presentViewController:baseNav animated:YES completion:nil];
        
    }
    else if (indexPath.row == 5)
    {
        //使用帮助
        
        
    }
    else if (indexPath.row == 6)
    {
        //推荐给朋友
        ShareViewController *shareVC = [[ShareViewController alloc]init];
        BaseNavViewController *baseNav = [[BaseNavViewController alloc]initWithRootViewController:shareVC];
        [self presentViewController:baseNav animated:YES completion:nil];
        
    }
    
    
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1)
    {
        //清楚缓存
        [[SDImageCache sharedImageCache] clearDisk];
        
        //计算缓存大小
        [self refreshCaCheSize];
    }
    
}

//计算本地缓存
- (void)refreshCaCheSize
{
    
    //取得图片缓存的路径
    NSString *imagePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/ImageCache"];
    sum = 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取相应路径下所有文件的名字
    NSArray *fileName = [fileManager subpathsOfDirectoryAtPath:imagePath error:nil];
    
    for (NSString *str in fileName)
    {
        //获取图片的路径
        NSString *imgPath = [imagePath stringByAppendingPathComponent:str];
        //获取文件的属性字典
        NSDictionary *dic = [fileManager attributesOfItemAtPath:imgPath error:nil];
        
        long long size = [dic fileSize];
        
        sum += size;
        
    }
    //刷新视图
    [_tableView reloadData];
    
}



@end
