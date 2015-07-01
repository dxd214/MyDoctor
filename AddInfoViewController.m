//
//  AddInfoViewController.m
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-12-6.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//

#import "AddInfoViewController.h"
#import "User.h"
#define currentMonth [currentMonthString integerValue]
@interface AddInfoViewController ()
{
    NSMutableArray *yearArray;
    NSArray *monthArray;
    NSMutableArray *DaysArray;
    
    NSString *currentMonthString;
    
    int selectedYearRow;
    int selectedMonthRow;
    int selectedDayRow;
    
    BOOL firstTimeLoad;

}
@end

@implementation AddInfoViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUser];
    [self loadData];
    [self _initNavItem];
}
- (void)_initNavItem
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, 44, 44);
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}
- (void)buttonAction
{
    [self dismissViewControllerAnimated:YES completion:nil];

}


- (void)loadData
{
    firstTimeLoad = YES;
    self.pickerView.hidden = YES;
    
    NSDate *date = [NSDate date];
    
    // Get Current Year
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    
    NSString *currentyearString = [NSString stringWithFormat:@"%@",
                                   [formatter stringFromDate:date]];
    
    
    // Get Current  Month
    
    [formatter setDateFormat:@"MM"];
    
    currentMonthString = [NSString stringWithFormat:@"%ld",[[formatter stringFromDate:date]integerValue]];
    
    
    // Get Current  Date
    
    [formatter setDateFormat:@"dd"];
    NSString *currentDateString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    
    // PickerView -  Years data
    
    yearArray = [[NSMutableArray alloc]init];
    
    
    for (int i = 1970; i <= 2050 ; i++)
    {
        [yearArray addObject:[NSString stringWithFormat:@"%d",i]];
        
    }
    
    
    // PickerView -  Months data
    
    
    monthArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    
    
    // PickerView -  days data
    
    DaysArray = [[NSMutableArray alloc]init];
    
    for (int i = 1; i <= 31; i++)
    {
        [DaysArray addObject:[NSString stringWithFormat:@"%d",i]];
        
    }
    
    
    // PickerView - Default Selection as per current Date
    
    [self.pickerView selectRow:[yearArray indexOfObject:currentyearString] inComponent:0 animated:YES];
    
    [self.pickerView selectRow:[monthArray indexOfObject:currentMonthString] inComponent:1 animated:YES];
    
    [self.pickerView selectRow:[DaysArray indexOfObject:currentDateString] inComponent:2 animated:YES];
    
    
}

- (void)createUser
{
    
    for(int i = 1;i<8;i++)
    {
        UIButton *button = (UIButton *)[self.view viewWithTag:100+i];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
}
- (void)buttonAction:(UIButton *)button
{
    CoreDataDBHelper *dbHelper = [CoreDataDBHelper shareCoreDataDBHelper];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    [dic setObject:self.textName.text forKey:@"name"];
    if (button.tag == 101)
    {
        [dic setObject:@"男" forKey:@"sex"];
        [dic setObject:@"否" forKey:@"mother"];
        button.selected = YES;
        [button setImage:[UIImage imageNamed:@"RadioButton-Selected"] forState:UIControlStateSelected];

    }
    else if (button.tag == 102)
    {
        [dic setObject:@"女" forKey:@"sex"];
        button.selected = YES;
        [button setImage:[UIImage imageNamed:@"RadioButton-Selected"] forState:UIControlStateSelected];
        _motherView.hidden = NO;
    }
    else if (button.tag == 103)
    {
        [dic setObject:@"是" forKey:@"mother"];
    }
    else if (button.tag == 104)
    {
        _pickView.hidden = NO;
    }
    else  if (button.tag == 105)
    {
        // 把学生对象设置到文件中
        BOOL result = [dbHelper insertDataWithModelName:@"User" setAttributWithDic:dic];
        NSLog(@"%@",result == YES?@"添加成功":@"添加失败");
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    else if (button.tag == 106)
    {
//        _pickView.hidden = YES;
//        //生日
//        [dic setObject:self.birthday forKey:@"birthday"];
//        [button setTitle:self.birthday forState:UIControlStateNormal];

    }
    else
    {//隐藏日期选择器
        _pickView.hidden = YES;
        [button setTitle:@"" forState:UIControlStateNormal];
    }
    
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return [yearArray count];
        
    }
    else if (component == 1)
    {
        return [monthArray count];
    }
    else
    { // day
        
        if (firstTimeLoad)
        {
            if (currentMonth == 1 || currentMonth == 3 || currentMonth == 5 || currentMonth == 7 || currentMonth == 8 || currentMonth == 10 || currentMonth == 12)
            {
                return 31;
            }
            else if (currentMonth == 2)
            {
                int yearint = [[yearArray objectAtIndex:selectedYearRow]intValue ];
                
                if(((yearint %4==0)&&(yearint %100!=0))||(yearint %400==0)){
                    
                    return 29;
                }
                else
                {
                    return 28; // or return 29
                }
                
            }
            else
            {
                return 30;
            }
            
        }
        else
        {
            if (selectedMonthRow == 0 || selectedMonthRow == 2 || selectedMonthRow == 4 || selectedMonthRow == 6 || selectedMonthRow == 7 || selectedMonthRow == 9 || selectedMonthRow == 11)
            {
                return 31;
            }
            else if (selectedMonthRow == 1)
            {
                int yearint = [[yearArray objectAtIndex:selectedYearRow]intValue ];
                
                if(((yearint %4==0)&&(yearint %100!=0))||(yearint %400==0)){
                    return 29;
                }
                else
                {
                    return 28; // or return 29
                }
            }
            else
            {
                return 30;
            }
            
        }
    }
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view
{
    
    // Custom View created for each component
    UILabel *pickerLabel = (UILabel *)view;
    
    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, 50, 60);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:15.0f]];
    }
    if (component == 0)
    {
        pickerLabel.text =  [yearArray objectAtIndex:row]; // Year
    }
    else if (component == 1)
    {
        pickerLabel.text =  [monthArray objectAtIndex:row];  // Month
    }
    else
    {
        pickerLabel.text =  [DaysArray objectAtIndex:row]; // Date
        
    }
    
    return pickerLabel;
    
}


#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    _birthday = [NSString stringWithFormat:@"%@年%@月%@日 ",[yearArray objectAtIndex:[self.pickerView selectedRowInComponent:0]],[monthArray objectAtIndex:[self.pickerView selectedRowInComponent:1]],[DaysArray objectAtIndex:[self.pickerView selectedRowInComponent:2]]];
    return _birthday;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        selectedYearRow = row;
        [self.pickerView reloadAllComponents];
    }
    else if (component == 1)
    {
        selectedMonthRow = row;
        [self.pickerView reloadAllComponents];
    }
    else
    {
        selectedDayRow = row;
        [self.pickerView reloadAllComponents];
        
    }
}

@end
