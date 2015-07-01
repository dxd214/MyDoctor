//
//  FamilyCell.h
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-12-6.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
@interface FamilyCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *faceImgView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *drugLabel;
@property (nonatomic, strong) User*model;
@end
