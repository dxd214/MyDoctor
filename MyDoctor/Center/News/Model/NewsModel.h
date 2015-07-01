//
//  NewsModel.h
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-11-28.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//

#import "BaseModel.h"

@interface NewsModel : BaseModel
//{
//    "count": 308,
//    "data": "[{\"tag\":0,
//            \"bv\":\"\",
//            \"topicTag\":0,\
//            "id\":2073,\
//            "title\":\"看手机眼睛干涩？教你滴眼药水的正确方法\",
//            \"time\":\"2014-12-03 17:29:00\",
//            \"description\":\"晚上睡前经常看手机，眼睛干涩？为了缓解症状，该怎样滴眼药水？\",
//            \"topicId\":0,
//            \"thumb\":\"http://drugs.dxy.cn/image/200/representative/2014/12/03/1417600899204.jpg\",
//            \"cateId\":1,
//            \"cateName\":\"用药百科\",
//            \"code_type\":0,
//            \"top\":0},]",
//    "type": "list",
//    "success": true
//}
@property(nonatomic, strong) NSNumber *iden;//文章id
@property(nonatomic, copy) NSString *title;//标题
@property(nonatomic, copy) NSString *thumb;//图片
@property(nonatomic, copy) NSString *desc;//简介
@property(nonatomic, strong) NSNumber *topicId;//话题id
@property(nonatomic, strong) NSNumber *cateId;//栏目id
@property(nonatomic, copy) NSString *cateName;//栏目名称
@property(nonatomic, copy) NSString *time;//发表时间
@end
