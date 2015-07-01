//
//  NearByViewController.h
//  weibo
//
//  Created by zsm on 14-11-21.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>
@interface NearByViewController : BaseViewController<MKMapViewDelegate,CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIGestureRecognizerDelegate>
{
    MKMapView *_mapView;
    CLLocationManager *_locationManager;
    UITableView *_tableView;
    BOOL _isClose;
}
@property (nonatomic, strong) NSMutableArray *dataList;

@end
