//
//  HomeModel.h
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-11-29.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeModel : NSObject
//[{
//    "aliasName": "乙肝疫苗",
//    "id": 1,
//    "months": 0,
//    "effect": "预防乙型病毒肝炎（乙肝）",
//    "injectionNumber": "第1剂/共3剂",
//    "name": "乙肝疫苗",
//    "feeType": 3,
//    "sameNameRelationIds": "",
//    "mutexRelationIds": "",
//    "recommendType": 1
//}

@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *detail;
@property (nonatomic, copy)NSString *imgName;
@end
