//
//  AppDelegate.m
//  BitcoinTheNightMan
//
//  Created by Albert on 13-11-28.
//  Copyright (c) 2013年 Albert. All rights reserved.
//

#import "AppDelegate.h"
#import "DemoViewController.h"
#import <AVOSCloud/AVOSCloud.h>

#import "ALBitcoinSDK.h"
//#import "ALFMDBHelper.h"

//avos
#define AVOS_APP_ID @"c02tr4xhsafzf8bxiior2mwqkfvrjxu4ivmr0kbs9h0hdxjy"
#define AVOS_APP_KEY @"4rtyzu1aol8xk3l6fo944brmyeh1lcgb7j8ohugi7swexcw5"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    [ALBitcoinSDK registerLKSDK];
    
    [AVOSCloud setApplicationId:AVOS_APP_ID clientKey:AVOS_APP_KEY];
    [AVOSCloud useAVCloudCN];
    
//    [[ALFMDBHelper shareDBHelper] setApplicationDataBaseName:@"coin"];
    
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    AVACL *defaultACL = [AVACL ACL];
    [defaultACL setPublicWriteAccess:YES];
    [defaultACL setPublicReadAccess:YES];
    [AVACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    //PUSH进入程序
    if (application.applicationIconBadgeNumber != 0)
    {
        application.applicationIconBadgeNumber = 0;
        //存储在当前安装deviceToken解析并保存它
        [[AVInstallation currentInstallation] saveInBackground];
    }
    
    [self handlePush:launchOptions];
    
    
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    self.window.rootViewController = [[[DemoViewController alloc] initWithNibName:@"DemoViewController" bundle:nil] autorelease];
//    NSLog(@"%lf",[@"0.0.01" doubleValue]);
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)printLog:(NSString*)log
{
    NSLog(@"%@",log); //用于xcode日志输出
}

//当一个应用程序打开了从一个通知
- (void)handlePush:(NSDictionary *)launchOptions
{
    
    // Extract the notification data
    NSDictionary *notificationPayload = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    
    // Create a pointer to the Photo object
    NSLog(@"notificationPayload = %@",notificationPayload);
    
    
    // 判断：如果应用程序的启动是因为一个推送通知
    if (notificationPayload)
    {
        UIAlertView *aV = [[UIAlertView alloc] initWithTitle:@"您有一个新的提醒" message:[NSString stringWithFormat:@"%@",launchOptions] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [aV show];
        [aV release];
        NSLog(@"应用程序的启动是因为一个推送通知!!!");
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current Installation and save it to Parse.
    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

//通知来时应用程序已经打开了
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    NSLog(@"receviedPushOfUserInfo = %@", userInfo);
    if (application.applicationState == UIApplicationStateActive)
    {
//        if (customBar==nil)
//        {
//            customBar = [[CustomStatueBar alloc] initWithFrame:CGRectMake(320-120, 0, 120, 20)];
//            customBar.tapdelegate = self;
//        }
//        
//        [customBar showStatusMessage:@"您收到一条新消息！"];
        
        // The application was already running.
        //        UIAlertView *aV = [[UIAlertView alloc] initWithTitle:@"您收到一条新消息" message:[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        //        [aV show];
        //        [aV release];
    }
    else
    {
        // The application was just brought from the background to the foreground,
        // so we consider the app as having been "opened by a push notification."
        [AVAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
}



//清理bage
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
    //    if (currentInstallation.badge != 0)
    //    {
    //        currentInstallation.badge = [ViewData defaultManager].unReadNumber;
    //        [currentInstallation saveEventually];
    //    }
    // ...
}
@end
