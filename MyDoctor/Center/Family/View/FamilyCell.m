//
//  FamilyCell.m
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-12-6.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//

#import "FamilyCell.h"

@implementation FamilyCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(User *)model
{
    if (_model != model )
    {
        _model = model;
        if ([_model.sex isEqualToString:@"男"])
        {
            _faceImgView.image = [UIImage imageNamed:@"TitleIconMan"];
        }
        else
        {
            _faceImgView.image = [UIImage imageNamed:@"TitleIconWoman"];
        }
        _nameLabel.text = _model.name;
        _drugLabel.text = [NSString stringWithFormat:@"0种药品"];
    }
}
@end
