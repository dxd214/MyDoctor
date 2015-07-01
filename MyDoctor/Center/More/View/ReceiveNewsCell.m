//
//  ReceiveNewsCell.m
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-12-3.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//

#import "ReceiveNewsCell.h"

@implementation ReceiveNewsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)_switchAction:(id)sender
{
    _switchs.isOn == !_switchs.isOn;
    if (_switchs.isOn == YES)
    {
        NSLog(@"打开推送");
    }
    else
    {
        NSLog(@"关闭推送");
    }
}
@end
