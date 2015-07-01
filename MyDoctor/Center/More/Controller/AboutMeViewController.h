//
//  AboutMeViewController.h
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-12-3.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//

#import "BaseViewController.h"

@interface AboutMeViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
{
}
@property (nonatomic, retain) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *data;
@end
