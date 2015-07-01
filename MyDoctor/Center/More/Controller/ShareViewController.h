//
//  ShareViewController.h
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-12-4.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//

#import "BaseViewController.h"

@interface ShareViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
}
@property(nonatomic,strong)NSArray *data;
@property(nonatomic,strong)NSArray *images;
@end
