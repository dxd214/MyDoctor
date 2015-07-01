//
//  WeiboAnnotation.m
//  weibo
//
//  Created by zsm on 14-11-21.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "Annotation.h"

@implementation Annotation : NSObject
- (void)setModel:(NearHospatialModel *)model
{
    if (_model != model) {
        _model = model;
        
        if ([_model.location isKindOfClass:[NSString class]])
        {
            //        "{\"lng\":116.203472,\"lat\":39.927866}"
            // 获取经纬度
            NSRange range1 = {7,10};  //1.表示截取的位置下标，6:截取的长度
            NSString *latStr = [_model.location substringWithRange:range1];
            NSRange range2 = {24,9};  //1.表示截取的位置下标，6:截取的长度
            NSString *lngStr = [_model.location substringWithRange:range2];
            double lat = [latStr doubleValue];
            double lon = [lngStr doubleValue];
            _coordinate = CLLocationCoordinate2DMake(lon, lat);
        }
    }
    
}

@end
