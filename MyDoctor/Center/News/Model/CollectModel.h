//
//  CollectModel.h
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-12-5.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//

#import "BaseModel.h"

@interface CollectModel : BaseModel
@property(nonatomic, copy) NSString *title;//标题
@property(nonatomic, copy) NSString *thumb;//图片
@property(nonatomic,copy)  NSString *content;//网页内容
@property(nonatomic,copy)  NSString *infoId;
@end
