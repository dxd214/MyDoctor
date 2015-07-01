//
//  TopModel.h
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-11-28.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//

#import "BaseModel.h"

@interface TopModel : BaseModel
//{
//    "count": 20,
//    "page": 1,
//    "data": "[{\"position\":10,\"
//                  summary\":\"12月1日是世界艾滋病日，行动起来，向「零」艾滋迈进\",
//                  \"picPath\":\"http://drugs.dxy.cn/image/200/representative/2014/06/21/1403249994.jpg\",
//                      \"title\":\"【专题】AIDS 科普\",
//                  \"tag\":1,
//                  \"topicId\":2,
//                  \"modifyDate\":\"2014-12-01 16:31:25\",
//                  \"createDate\":\"2014-06-17 14:23:07\"},]",
//    "success": true
//}
//http://drugs.dxy.cn/api/topic?vs=8.1.1&ac=1d6c96d5-9a53-4fe1-9537-85a33de916f1&mc=a61c7ba72412368a4dfe65688c17189eb6c0b4b2&deviceName=iPhone5s&hardName=iPhone&topicId=2&page=1&vc=2.8.4
@property(nonatomic, strong) NSNumber *position;//所属类型
@property(nonatomic, strong) NSNumber *topicId;//id
@property(nonatomic, copy) NSString *title;//标题1
@property(nonatomic, copy) NSString *summary;//简介
@property(nonatomic, copy) NSString *picPath;//图片
@property(nonatomic, strong) NSNumber *tagId;//文章id
@property(nonatomic, copy) NSString *createDate;//发表时间
@property(nonatomic, copy) NSString *modifyDate;//浏览时间


@end
