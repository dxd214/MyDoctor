//
//  CommentCell.m
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-12-2.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [_appImgView sd_setImageWithURL:[NSURL URLWithString:self.model.iconPath]];
    _nameLabel.text = self.model.name;
    _descLabel.text = self.model.desc;

}
@end
