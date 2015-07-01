//
//  HeathViewController.h
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-11-29.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//

#import "BaseViewController.h"

@interface HeathViewController : BaseViewController<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIView *_view1;//新闻视图
    UITableView *_newsTableView;
    UIView *_view2;//话题视图
    UITableView *_topTableView;
    UIView *_view3;//个人收藏
    UITableView *_myTableView;
    IBOutlet UIView *_topView;
    UIImageView *_selectedImg;
    IBOutlet UIScrollView *_ScrollView;
}
@property(nonatomic,strong)NSMutableArray *newsData;
@property(nonatomic,strong)NSMutableArray *topData;
@property(nonatomic,strong)NSMutableArray *myData;

@property(nonatomic,copy)NSString *infoId;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *thumb;
@property(nonatomic,copy)NSString *content;
@end
