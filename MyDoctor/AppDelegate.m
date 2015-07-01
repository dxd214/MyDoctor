//
//  AppDelegate.m
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-11-28.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//

#import "AppDelegate.h"
#import "GuideViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

/*
 此appkey为演示所用，请确保应用在上线之前，到http://appkefu.com/AppKeFu/admin/index.php，申请自己的appkey
 */
#define APP_KEY @"0e93289b0a4160a6b9b5f0e4787fe3f7"


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {


    //设置首次使用欢迎页面
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    BOOL showGuide = [userDefaults boolForKey:KShowGuide];
    
    if (showGuide == NO)
    {
        self.window.rootViewController = [[GuideViewController alloc] init];
        [userDefaults setBool:YES forKey:KShowGuide];
        //同步数据
        [userDefaults synchronize];
    }
    
    //步骤一：初始化操作
//    [[AppKeFuLib sharedInstance] loginWithAppkey:APP_KEY];
    //注册离线消息推送
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    }
    return YES;
}
#pragma mark 离线消息推送
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    //同步deviceToken便于离线消息推送, 同时必须在管理后台上传 .pem文件才能生效
//    [[AppKeFuLib sharedInstance] uploadDeviceToken:deviceToken];
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"收到推送消息。%@", userInfo);
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"注册推送失败，原因：%@",error);
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    //苹果官方规定除特定应用类型，如：音乐、VOIP类可以在后台运行，其他类型应用均不得在后台运行，所以在程序退到后台要执行logout登出，
    //离线消息通过服务器推送可接收到
    //在程序切换到前台时，执行重新登录，见applicationWillEnterForeground函数中
    //步骤四：
//    [[AppKeFuLib sharedInstance] logout];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    //步骤五：切换到前台重新登录
//    [[AppKeFuLib sharedInstance] loginWithAppkey:APP_KEY];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
@end
