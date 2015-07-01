//
//  Common.h
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-11-28.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//

#ifndef MyDoctor_Common_h
#define MyDoctor_Common_h

// 获取设备屏幕的物理尺寸
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

// 当前SDK版本
#define kVersion [[UIDevice currentDevice].systemVersion floatValue]


// ios数据接口地址
#define base_Url @"http://drugs.dxy.cn"
#define JK_search_place @"people/api/search-place"//附近医院【&location=39.924805%2C116.197485&radius=1000】
#define JK_api_recommend @"api/recommend"//应用推荐

#define JK_search_detail @"people/api/search-place-detail"//详细医院信息【&reference=UIOUOI】

#define JK_api_info      @"api/info"//最新文章【last_time=1417573420226】
//#define JK_api_info      @"api/info"//最新文章详细2073、、专题文章详细2065、搜索文章详细1591  【infoId=2073】
#define JK_api_topic     @"api/topic"//健康专题【page=1】
//#define JK_api_topic     @"api/topic"//专题的详细【topicId=2&page=1】

#define JK_api_search_info  @"api/search-info" //搜索


//------------安卓接口----------
#define baseAndroidUrl @"http://dxy.com/app/i/columns"
#define JK_article_list     @"article/list" //最新文章【page_index=1&items_per_page=10&order=publishTime】
//专题的详细【page_index=1&items_per_page=10&order=publishTime&special_id=20】
#define JK_special_list     @"special/list"//健康专题【page_index=1&items_per_page=10】
#define JK_article_single  @"article/single"  //最新的详细文章，专题的详细文章【id=2050】

//显示欢迎页面
#define KShowGuide  @"showGuide"



/*
http://drugs.dxy.cn/api/info?vs=8.1.1&ac=1d6c96d5-9a53-4fe1-9537-85a33de916f1&deviceName=iPhone5s&mc=a61c7ba72412368a4dfe65688c17189eb6c0b4b2&hardName=iPhone&vc=2.8.4&last_time=1417573420226最新资讯
http://drugs.dxy.cn/api/topic?vs=8.1.1&ac=1d6c96d5-9a53-4fe1-9537-85a33de916f1&deviceName=iPhone5s&mc=a61c7ba72412368a4dfe65688c17189eb6c0b4b2&hardName=iPhone&page=1&vc=2.8.4 健康专题
http://drugs.dxy.cn/api/info?vs=8.1.1&ac=1d6c96d5-9a53-4fe1-9537-85a33de916f1&infoId=2073&deviceName=iPhone5s&mc=a61c7ba72412368a4dfe65688c17189eb6c0b4b2&hardName=iPhone&vc=2.8.4资讯的详细
http://drugs.dxy.cn/api/topic?vs=8.1.1&ac=1d6c96d5-9a53-4fe1-9537-85a33de916f1&mc=a61c7ba72412368a4dfe65688c17189eb6c0b4b2&deviceName=iPhone5s&hardName=iPhone&topicId=2&page=1&vc=2.8.4专题的详细
http://drugs.dxy.cn/api/info?vs=8.1.1&ac=1d6c96d5-9a53-4fe1-9537-85a33de916f1&infoId=2065&deviceName=iPhone5s&mc=a61c7ba72412368a4dfe65688c17189eb6c0b4b2&hardName=iPhone&vc=2.8.4专题的文章

http://drugs.dxy.cn/api/search-info 搜索点击
//保健品，抱歉，没有找到相关的保健品

http://drugs.dxy.cn/api/info?vs=8.1.1&ac=1d6c96d5-9a53-4fe1-9537-85a33de916f1&infoId=1591&deviceName=iPhone5s&mc=a61c7ba72412368a4dfe65688c17189eb6c0b4b2&hardName=iPhone&vc=2.8.4  搜索，相关科普的文章

http://drugs.dxy.cn/people/api/search-place?vs=8.1.1&sensor=false&ac=1d6c96d5-9a53-4fe1-9537-85a33de916f1&deviceName=iPhone5s&mc=a61c7ba72412368a4dfe65688c17189eb6c0b4b2&types=pharmacy&hardName=iPhone&location=39.924805%2C116.197485&radius=1000&vc=2.8.4   地图
http://drugs.dxy.cn/people/api/search-place-detail?vs=8.1.1&sensor=false&ac=1d6c96d5-9a53-4fe1-9537-85a33de916f1&deviceName=iPhone5s&mc=a61c7ba72412368a4dfe65688c17189eb6c0b4b2&reference=CoQBfQAAAFARYywF698fDrbj9xjs0YAWZt6fSypZRqjrjLXziezLxW203aJl938tJLtepzXKZTxjPbOtk6xbHECkDXYWFof3aWOuZJwhW0f5ecr-cbvELjVNYdz538XTy2b8jiSAzXUjVPGVFEP-R-dNA88ZDC3RzDN19xVqRTcsD0wfgr6sEhCo0q2MUU4qCgjlggMe1SmjGhTiyK2CmEk6662K_Tywap1OYB_lTg&hardName=iPhone&language=zh-CN&vc=2.8.4

地图表格，点击之后请求网络并加载数据
*/

//-------------安卓---------------
/*
http://dxy.com/app/i/columns/article/list?page_index=1&items_per_page=10&order=publishTime //最新文章
http://dxy.com/app/i/columns/special/list?page_index=1&items_per_page=10   //健康专题
http://dxy.com/app/i/columns/article/single?id=2050 //最新的详细
http://dxy.com/app/i/columns/article/list?page_index=1&items_per_page=10&order=publishTime&special_id=20专题的详细列表
http://dxy.com/app/i/columns/article/single?id=2045 //专题的详细文章

//地图用的百度地图的接口
*/


#endif


