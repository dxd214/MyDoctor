//
//  NewsCell.m
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-12-3.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//

#import "NewsCell.h"

@implementation NewsCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setModel:(NewsModel *)model
{
    if (_model != model)
    {
        _model = model;
        _newsTitleLabel.text = _model.title;
        [_newsImgView sd_setImageWithURL:[NSURL URLWithString:_model.thumb]];
    }
}
- (void)setCollectModel:(CollectModel *)collectModel
{
    if (_collectModel != collectModel)
    {
        _collectModel = collectModel;
        _newsTitleLabel.text = _collectModel.title;
        [_newsImgView sd_setImageWithURL:[NSURL URLWithString:_collectModel.thumb]];
    }
}


//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    _newsTitleLabel.text = _model.title;
//    [_newsImgView sd_setImageWithURL:[NSURL URLWithString:_model.thumb]];
//}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
