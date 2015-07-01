//
//  NearByViewController.m
//  weibo
//
//  Created by zsm on 14-11-21.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "NearByViewController.h"
#import "Annotation.h"
#import "NearHospatialModel.h"
#import "MapCell.h"
#import "MapDetailModel.h"

@interface NearByViewController ()
{
    UIView *_balckView;
    NSString *_tel;
}
@end

@implementation NearByViewController

- (void)viewDidLoad {
    self.title = @"附近药店";
    self.hidesBottomBarWhenPushed = YES;
    [super viewDidLoad];
        //大数组存放所有的数据
    _dataList = [NSMutableArray array];
    [self _initViews];
    
    // 获取当前位置
    [self myLocationManager];
}
- (void)_initViews
{
    // 创建地图
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    [self.view addSubview:_mapView];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 25, 25);
    [rightBtn setImage:[UIImage imageNamed:@"PositionIcon"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    //遮蔽视图
    _balckView = [[UIView alloc]initWithFrame:self.view.bounds];
    _balckView.backgroundColor = [UIColor blackColor];
    _balckView.alpha = .3;
    _balckView.hidden = YES;

    //添加点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    tap.delegate = self;
    [_balckView addGestureRecognizer:tap];
    [self.view addSubview:_balckView];
    //表格
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth, 0, 250, kScreenHeight-64) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _isClose = YES;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}
- (void)tapAction
{
    [UIView animateWithDuration:.35 animations:^{
        _tableView.left = kScreenWidth;
        _balckView.hidden = YES;
    } completion:nil];
}
//显示隐藏医院列表
- (void)buttonAction:(UIButton *)button
{
    _isClose = !_isClose;
    if(_isClose == YES)
    {
        [UIView animateWithDuration:.35 animations:^{
            _tableView.left = kScreenWidth;
             _balckView.hidden = YES;
        } completion:nil];
    }
    else
    {
        [UIView animateWithDuration:.35 animations:^{
        _tableView.left = kScreenWidth-200;
        _balckView.hidden = NO;
        } completion:nil];
    }
    
}
// 获取当前位置
- (void)myLocationManager
{
    _locationManager = [[CLLocationManager alloc] init];
    if (kVersion >= 8.0)
    {
        // 8.0里面必须设置的放大
        // 请求如许使用定位服务
        [_locationManager requestAlwaysAuthorization];
    }
    
    // 设置请求信息的精确度
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    _locationManager.delegate = self;
    // 开始定位
    [_locationManager startUpdatingLocation];
}

#pragma mark - 根据经纬度，请求网络
// 获取经纬度，开始请求网络
- (void)loadNearByWeiboWithlong:(NSString *)lon lat:(NSString *)lat
{
    // 在地图上显示自己的位置
    MKUserLocation *userLocation = [[MKUserLocation alloc] init];
    userLocation.coordinate = CLLocationCoordinate2DMake([lat doubleValue], [lon doubleValue]);
    [_mapView addAnnotation:userLocation];
  
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *location = [NSString stringWithFormat:@"%@%%2C%@",lat,lon];
    [params setObject:location forKey:@"location"];
    [params setObject:@"1000" forKey:@"radius"];

    //请求标注视图数据
    [DataService requestAFWithUrl:JK_search_place params:params reqestHeader:nil httpMethod:@"GET" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"请求成功");
        // 把请求下来的数据解析成数据原型对象
         [self dataSave:result];
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"请求错误，正在重新请求中....");
        [self performSelector:@selector(loadNearByWeiboWithlong:lat:) withObject:nil afterDelay:2];
    }];
    
    
}
#pragma mark -处理数据，网络请求详细信息
//处理数据，以及详细地图信息的数据请求
- (void)dataSave:(id)result
{
    // 把请求下来的数据解析成数据原型对象
    NSArray *results = result[@"result"];
    if(results.count == 0)
    {
        NSLog(@"附近1000米没有医院");
        return;
    }
    for (NSDictionary *subDic in results)
    {
        //创建model
        NearHospatialModel *nearModel = [[NearHospatialModel alloc] initWithContentsOfDic:subDic];

        // 创建标注视图的数据原型类
        Annotation *nearAnnotation = [[Annotation alloc] init];
        nearAnnotation.title = nearModel.name;
        nearAnnotation.subtitle = nearModel.vicinity;
        nearAnnotation.model = nearModel;
        nearAnnotation.reference = nearModel.reference;
        [_mapView addAnnotation:nearAnnotation];
    }
    

}
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // 停止定位服务
    [manager stopUpdatingLocation];
    
    // 获取当前请求下来的位置
    CLLocation *location = [locations lastObject];
    // 设置地图中心点位置
    CLLocationCoordinate2D coordinate2D = location.coordinate;
    MKCoordinateSpan span = {.05,.05};
    MKCoordinateRegion region = {coordinate2D,span};
    [_mapView setRegion:region];
    
    // 获取经纬度，开始请求网络
    [self loadNearByWeiboWithlong:[NSString stringWithFormat:@"%f",location.coordinate.longitude] lat:[NSString stringWithFormat:@"%f",location.coordinate.latitude]];
}

#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    // 判断当前标注是否是自己的位置
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    static NSString *iden = @"an";
    MKPinAnnotationView *annotationView  =(MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:iden];
    
    if (annotationView == nil)
    {
        annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:iden];
        //显示详细内容
        annotationView.canShowCallout = YES;
        
        //设置颜色
        annotationView.pinColor = MKPinAnnotationColorRed;
        
        //设置动画
        annotationView.animatesDrop = YES;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoDark];
        [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        annotationView.rightCalloutAccessoryView = button;

    }
    // 重新的给定数据
    annotationView.annotation = annotation;
    //根据标注视图获取对应的tableView数据
    [self loadTableData:annotation];
    return annotationView;

}

/*
 标注视图，获取数据，保存到NearHospatialModel中
 一个标注视图，一个reference
 表格视图，根据reference请求数据，保存到MapDetailModel中
 显示单元格
 */
//根据标注视图获得reference并发送网络请求
- (void)loadTableData:(Annotation *)annotation
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:annotation.reference forKey:@"reference"];
    //详细信息请求
    [DataService requestAFWithUrl:JK_search_detail params:params reqestHeader:nil httpMethod:@"GET" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"请求成功");
         
         MapDetailModel *mapModel = [[MapDetailModel alloc]  initWithContentsOfDic:result[@"result"]];
         //将数据给单元格数组存储
         [self.dataList addObject:mapModel];
         [_tableView reloadData];
         
     } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"请求失败");
         //2s之后重新加载
         [self performSelector:@selector(loadNearByWeiboWithlong:lat:) withObject:nil afterDelay:2];
     }];
    
}

- (void)buttonAction
{
    NSLog(@"点击了地图了");
}
#pragma mark- MKMapViewDelegate

//点击左右测视图
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    NSLog(@"点击左右视图");
}

//点击表示视图
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    NSLog(@"点击标注视图");
}

//获取上一次的点击标注视图
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    NSLog(@"didDeselectAnnotationView");
}

//用户的位置已经更新
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    NSLog(@"已经更新用户位置信息");
}

#pragma mark -UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.dataList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"MapCell";
    MapCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MapCell" owner:nil options:nil]lastObject];
    }
    cell.model = _dataList[indexPath.row];

    return cell;
}
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   _tel = [_dataList[indexPath.row] formatted_phone_number];
    if (![_tel isEqualToString:@""])
    {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"拨打电话"
                                                           delegate:self
                                                  cancelButtonTitle:@"取 消"
                                             destructiveButtonTitle:_tel
                                                  otherButtonTitles:nil, nil];
        [sheet showInView:self.view];
    }
    
}
#pragma mark - UIActionSheetDelegate
//拨打电话
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    NSString *tel = [NSString stringWithFormat:@"tel://%@",[actionSheet buttonTitleAtIndex:0]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
 
}

@end
