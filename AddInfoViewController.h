//
//  AddInfoViewController.h
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-12-6.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//

#import "BaseViewController.h"

@interface AddInfoViewController : BaseViewController<UIPickerViewDelegate,UIPickerViewDataSource>


@property (strong, nonatomic) IBOutlet UITextField *textName;
@property (strong, nonatomic) IBOutlet UIView *motherView;

@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UIView *pickView;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic,copy)NSString *birthday;
@end
