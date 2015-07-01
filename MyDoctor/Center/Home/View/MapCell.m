//
//  MapCell.m
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-12-2.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//

#import "MapCell.h"
@implementation MapCell

- (void)awakeFromNib {
    
}
- (void)setModel:(MapDetailModel *)model
{
    if(_model != model)
    {
        _model = model;
    }

    _nameLabel.text = self.model.name;
    _addressLabel.text = self.model.formatted_address;
    if([self.model.formatted_phone_number isEqualToString:@""]||self.model.formatted_phone_number == nil)
    {
        _callLabel.text = @"暂无";
    }
    else
    {
        _callLabel.text = self.model.formatted_phone_number;
    }
}



@end
