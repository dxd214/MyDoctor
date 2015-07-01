//
//  MapDetailModel.h
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-12-2.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//
/*
 {
 "result": {
 "id": "aea93634b24cdfb2df280c9ec634320fd3ab8694",
 "vicinity": "石景山区阜石路166号",
 "name": "北京嘉信泽洋口腔诊所",
 "formatted_address": "中国北京市石景山区阜石路166号",
 "formatted_phone_number": "010 8890 9890"
 },
 "html_attribution": "[]",
 "success": true
 }
 */
#import "BaseModel.h"

@interface MapDetailModel : BaseModel
@property(nonatomic, copy) NSString *iden;//id
@property(nonatomic, copy) NSString *vicinity;//地址
@property(nonatomic, copy) NSString *name;//医院名称
@property(nonatomic, copy) NSString *formatted_address;//邮编地址
@property(nonatomic, copy) NSString *formatted_phone_number;//电话


@end
