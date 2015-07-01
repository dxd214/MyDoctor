//
//  NearHospatialModel.h
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-12-2.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//
/*
result": [{
"id": "ccf005ca8c44b85c8bcfbc5a9ff01fb0624ed1d0",
"vicinity": "北京市石景山区西黄村",
"location": "{\"lng\":116.203472,\"lat\":39.927866}",
"name": "北京首钢总医院",
"reference": "CoQBdwAAAN5iurD3DCY4F_WgZLf4thjT8-68RVXaAMYJJ17OPg2XAscTfgjgBNRCkRpnrKRWI-p51g9VqQdij1rKW9HSUIAElI-htpMQKHRkDcpF20fnV1JrnnFaTv3TqmMMzjcx-ufbP-mlBkFJ1V445NWbYzUIpdnNBjQkXCsizqOG27MfEhDYJfu2meMXQWD_vcmuMBIZGhQrewJN1GTbAZCrmMYFe-XR6PQ92w"
},
 */
#import "BaseModel.h"

@interface NearHospatialModel : BaseModel

@property(nonatomic, strong) NSNumber *iden;//id
@property(nonatomic, copy) NSString *vicinity;//地址
@property(nonatomic, copy) NSString *location;//经纬度
@property(nonatomic, copy) NSString *name;//医院名称
@property(nonatomic, copy) NSString *reference;//参考


@end
