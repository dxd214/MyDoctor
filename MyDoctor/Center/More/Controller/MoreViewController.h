//
//  MoreViewController.h
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-12-1.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//

#import "BaseViewController.h"

@interface MoreViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    long long sum;  //用于存放图片的缓存大小   单位：字节
}
@property (nonatomic, retain) UITableView *tableView;
@property(nonatomic, strong) NSArray *data;


@end
