//
//  NearHospatialModel.m
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-12-2.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//

#import "NearHospatialModel.h"

@implementation NearHospatialModel
- (id)initWithContentsOfDic:(NSDictionary *)dic
{
    self = [super initWithContentsOfDic:dic];
    if (self)
    {
        self.iden = dic[@"id"];
    }
    
    return self;
}

@end
