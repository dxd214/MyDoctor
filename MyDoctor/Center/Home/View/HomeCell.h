//
//  HomeCell.h
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-11-29.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeModel;
@interface HomeCell : UITableViewCell
{
    IBOutlet UIImageView *_userFaceImgView;
    IBOutlet UILabel *_titleLabel;
    IBOutlet UILabel *_detailLabel;
    IBOutlet UIImageView *_smallImgView;
    
}
@property (nonatomic, strong)HomeModel *model;
@end
