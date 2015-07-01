//
//  CommentModel.h
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-12-2.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//
/*
 {
 "data": [{
 "position": 3,
 "iconPath": "http://drugs.dxy.cn/image/middle/representative/2013/12/24/1387832431.png",
 "desc": "收录上万种药品说明书，为临床医生提供便捷的药物查询工具。",
 "name": "用药助手",
 "downloadUrl": "https://itunes.apple.com/cn/app/id540999305"
 },
 */
#import "BaseModel.h"

@interface CommentModel : BaseModel
@property(nonatomic, strong) NSNumber *position;//位置
@property(nonatomic, copy) NSString *iconPath;//图标地址
@property(nonatomic, copy) NSString *name;//应用名称
@property(nonatomic, copy) NSString *desc;//简介
@property(nonatomic, copy) NSString *downloadUrl;//下载地址

             
@end
/*
//附近医院
http://drugs.dxy.cn/people/api/search-place?vs=8.1&sensor=false&ac=1d6c96d5-9a53-4fe1-9537-85a33de916f1&deviceName=iPhone&mc=0e862fd0c52bc344a55455280d318c133f7847ae&types=pharmacy&hardName=iPhone&location=39.922632%2C116.199081&radius=1000&vc=2.8.4
//详细地址
http://drugs.dxy.cn/people/api/search-place-detail?vs=8.1&sensor=false&ac=1d6c96d5-9a53-4fe1-9537-85a33de916f1&deviceName=iPhone&mc=0e862fd0c52bc344a55455280d318c133f7847ae&reference=CpQBhAAAAK1J7GYUDpDLaRlYq5SamUo4OJAZ9CnMwxGQfCZEjpxV8ETYrIxoH9DgD3y1Wzx8BhvJL_IMAOPluwlyAukyb7Zouf4dQfMmDt95N9QhsTro3F-yHr7TN2mHKe-iEBb-0YPHq8yF3rPsgTnlO11IKwJD0HNwIf-JE-yPhdrJHrCn4z8z_AHyLNYiOuLAmzdP4RIQueWWASEaO4JbHht2Vn-eeRoU3RKKEojfTotIBG6fkgTCjtnxufI&hardName=iPhone&language=zh-CN&vc=2.8.4
//话题
http://drugs.dxy.cn/api/topic?vs=8.1&ac=1d6c96d5-9a53-4fe1-9537-85a33de916f1&deviceName=iPhone&mc=0e862fd0c52bc344a55455280d318c133f7847ae&hardName=iPhone&page=1&vc=2.8.4
 //话题列表
http://drugs.dxy.cn/api/topic?vs=8.1&ac=1d6c96d5-9a53-4fe1-9537-85a33de916f1&mc=0e862fd0c52bc344a55455280d318c133f7847ae&deviceName=iPhone&hardName=iPhone&topicId=2&page=1&vc=2.8.4

http://drugs.dxy.cn/api/info?vs=8.1&ac=1d6c96d5-9a53-4fe1-9537-85a33de916f1&infoId=2066&deviceName=iPhone&mc=0e862fd0c52bc344a55455280d318c133f7847ae&hardName=iPhone&vc=2.8.4
*/