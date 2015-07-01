//
//  NewsModel.m
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-11-28.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel

- (id)initWithContentsOfDic:(NSDictionary *)dic
{
    self = [super initWithContentsOfDic:dic];
    if (self)
    {
        self.iden = dic[@"id"];
        self.desc = dic[@"description"];
    }
    
    return self;
}
@end
