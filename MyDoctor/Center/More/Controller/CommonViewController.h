//
//  CommonViewController.h
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-12-2.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//

#import "BaseViewController.h"

@interface CommonViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@property (nonatomic,strong)NSArray *data;
@property (nonatomic, copy)NSString *urlDownload;
@end
