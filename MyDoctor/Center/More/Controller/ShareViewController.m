//
//  ShareViewController.m
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-12-4.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//

#import "ShareViewController.h"
#import "ShareCell.h"
@interface ShareViewController ()

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _data = [NSArray array];
    _images = [NSArray array];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
