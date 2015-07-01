//
//  SearchViewController.h
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-12-1.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//

#import "BaseViewController.h"

@interface SearchViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    NSArray *_data;
    UISearchBar *_mySearchBar;
    UITableView *_tableView;
}


@end
