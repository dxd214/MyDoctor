//
//  HomeViewController.h
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-11-29.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//

#import "BaseViewController.h"
@interface HomeViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSArray *_array;
    UISearchBar *mySearchBar;
}

@property(nonatomic,strong)NSMutableArray *data;
@end
