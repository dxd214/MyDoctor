//
//  TopCell.m
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-12-3.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//

#import "TopCell.h"

@implementation TopCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(TopModel *)model
{
    if (_model != model)
    {
        _model = model;
        _topTitleLabel.text = _model.title;
        _topDetailLabel.text = _model.summary;
        [_topImgView sd_setImageWithURL:[NSURL URLWithString:_model.picPath]];
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    _topTitleLabel.text = _model.title;
    _topDetailLabel.text = _model.summary;
    [_topImgView sd_setImageWithURL:[NSURL URLWithString:_model.picPath]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
