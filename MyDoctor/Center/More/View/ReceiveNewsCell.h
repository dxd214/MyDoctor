//
//  ReceiveNewsCell.h
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-12-3.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiveNewsCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *receiveNewsLabel;
@property (strong, nonatomic) IBOutlet UISwitch *switchs;

- (IBAction)_switchAction:(id)sender;

@end
