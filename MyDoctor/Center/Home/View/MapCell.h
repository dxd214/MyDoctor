//
//  MapCell.h
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-12-2.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapDetailModel.h"
@interface MapCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *callLabel;
@property (strong, nonatomic)MapDetailModel *model;


@end
