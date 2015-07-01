//
//  HomeCell.m
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-11-29.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//

#import "HomeCell.h"
#import "HomeModel.h"
@implementation HomeCell

- (void)awakeFromNib {
    
}



- (void)layoutSubviews
{
    [super layoutSubviews];
//    self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ListBg"]];
    _userFaceImgView.image = [UIImage imageNamed:self.model.imgName];
    _titleLabel.text = self.model.title;
    _detailLabel.text = self.model.detail;
    _smallImgView.image = [UIImage imageNamed:@"ArrowIconGray@3x"];
}



@end
