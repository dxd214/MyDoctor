//
//  TopModel.m
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-11-28.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//

#import "TopModel.h"

@implementation TopModel
- (id)initWithContentsOfDic:(NSDictionary *)dic
{
    self = [super initWithContentsOfDic:dic];
    if (self)
    {
        self.tagId = dic[@"tag"];
    }
    
    return self;
}
@end
