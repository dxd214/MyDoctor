//
//  TopCell.h
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-12-3.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopModel.h"
@interface TopCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *topTitleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *topImgView;
@property (strong, nonatomic) IBOutlet UILabel *topDetailLabel;


@property(nonatomic,strong)TopModel *model;
@end
