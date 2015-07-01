//
//  KFViewController.m
//  AppKeFuDemo
//
//  Created by jack on 14-5-18.
//  Copyright (c) 2014年 appkefu.com. All rights reserved.
//

#import "KFViewController.h"
#import "TagsTableViewController.h"

#import "AppKeFuLib.h"


@interface KFViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong) NSString      *onlineStatus;
@property (nonatomic, strong) NSString      *onlineStatus2;

@end

@implementation KFViewController

@synthesize onlineStatus, onlineStatus2;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"微客服2";
    
    onlineStatus = NSLocalizedString(@"1.在线咨询售前", nil);
    onlineStatus2 = NSLocalizedString(@"2.在线咨询售后", nil);
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //监听登录状态
    [[NSNotificationCenter defaultCenter]
        addObserver:self selector:@selector(isConnected:) name:APPKEFU_LOGIN_SUCCEED_NOTIFICATION object:nil];
    
    //监听在线状态
    [[NSNotificationCenter defaultCenter]
        addObserver:self selector:@selector(notifyOnlineStatus:) name:APPKEFU_WORKGROUP_ONLINESTATUS object:nil];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:APPKEFU_LOGIN_SUCCEED_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:APPKEFU_WORKGROUP_ONLINESTATUS object:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.row == 0)
    {
        cell.textLabel.text = onlineStatus;
    }
    else if (indexPath.row == 1)
    {
        cell.textLabel.text = onlineStatus2;
    }
    else if(indexPath.row == 2)
    {
        cell.textLabel.text = @"3.设置用户标签";
    }
    else if (indexPath.row == 3)
    {
        cell.textLabel.text = @"4.清空聊天记录";
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        //第一种打开会话页面方式
        [[AppKeFuLib sharedInstance] pushChatViewController:self.navigationController
                                          withWorkgroupName:@"wgdemo"
                                 rightBarButtonItemCallback:nil
                                     showInputBarSwitchMenu:YES
                                                  withTitle:@"在线客服"
                                            withProductInfo:@"附加信息: 如商品信息,订单信息等"
                                 withLeftBarButtonItemColor:[UIColor whiteColor]
                                   hidesBottomBarWhenPushed:FALSE];
        
    }
    else if (indexPath.row == 1)
    {
        
        //第二种打开会话页面方式
        [[AppKeFuLib sharedInstance] presentChatViewController:self
                                          withWorkgroupName:@"wgdemo2"
                                 rightBarButtonItemCallback:nil
                                     showInputBarSwitchMenu:YES
                                                  withTitle:@"在线客服"
                                            withProductInfo:nil
                                    withLeftBarButtonItemColor:[UIColor redColor]
                                      hidesBottomBarWhenPushed:FALSE];
        
    }
    else if (indexPath.row == 2)
    {
        TagsTableViewController *tagVC = [[TagsTableViewController alloc] init];
        [self.navigationController pushViewController:tagVC animated:YES];
    }
    else if (indexPath.row == 3)
    {
        UIAlertView *alerview = [[UIAlertView alloc] initWithTitle:@"提示"
                                                           message:@"确定要清空聊天记录?" delegate:self
                                                 cancelButtonTitle:@"取消"
                                                 otherButtonTitles:@"确定", nil];
        [alerview show];
        
    }
}

#pragma mark Login Succeed Notification

//接收是否登录成功通知
- (void)isConnected:(NSNotification*)notification
{
    NSNumber *isConnected = [notification object];
    if ([isConnected boolValue])
    {
        //登录成功
        self.title = @"微客服2.0(登录成功)";
        
        //
        //查询工作组在线状态，需要将wgdemo替换为开发者自己的 “工作组名称”，请在官方管理后台申请，地址：http://appkefu.com/AppKeFu/admin
        [[AppKeFuLib sharedInstance] queryWorkgroupOnlineStatus:@"wgdemo"];
        [[AppKeFuLib sharedInstance] queryWorkgroupOnlineStatus:@"wgdemo2"];
    }
    else
    {
        //登录失败
        self.title = @"微客服2.0(登录失败)";
        
    }
}

#pragma mark OnlineStatus

//监听工作组在线状态
-(void)notifyOnlineStatus:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    
    //客服工作组名称
    NSString *workgroupName = [dict objectForKey:@"workgroupname"];
    
    //客服工作组在线状态
    NSString *status   = [dict objectForKey:@"status"];
    
    NSLog(@"%s workgroupName:%@, status:%@", __PRETTY_FUNCTION__, workgroupName, status);

    //
    if ([workgroupName isEqualToString:@"wgdemo"]) {
        
        //客服工作组在线
        if ([status isEqualToString:@"online"])
        {
            onlineStatus = NSLocalizedString(@"1.在线咨询售前(在线)", nil);
        }
        //客服工作组离线
        else
        {
            onlineStatus = NSLocalizedString(@"1.在线咨询售前(离线)", nil);
        }
        
    }
    //
    else if ([workgroupName isEqualToString:@"wgdemo2"]) {
    
        //客服工作组在线
        if ([status isEqualToString:@"online"])
        {
            onlineStatus2 = NSLocalizedString(@"2.在线咨询售后(在线)", nil);
        }
        //客服工作组离线
        else
        {
            onlineStatus2 = NSLocalizedString(@"2.在线咨询售后(离线)", nil);
        }
    }

    
    [self.tableView reloadData];
}

#pragma mark UIAlerviewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%s, %ld", __PRETTY_FUNCTION__, (unsigned long)buttonIndex);
    if (buttonIndex == 1) {
        
        //清空与客服工作组 "wgdemo" 的所有聊天记录
        [[AppKeFuLib sharedInstance] deleteMessagesWith:@"wgdemo"];
        [[AppKeFuLib sharedInstance] deleteMessagesWith:@"wgdemo2"];
        
    }
    
}

@end



