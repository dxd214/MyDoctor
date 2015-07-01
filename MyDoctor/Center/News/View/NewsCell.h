//
//  NewsCell.h
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-12-3.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"
#import "CollectModel.h"
@interface NewsCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *newsImgView;
@property (strong, nonatomic) IBOutlet UILabel *newsTitleLabel;

@property(nonatomic,strong)NewsModel *model;
@property(nonatomic,strong)CollectModel *collectModel;
@end
