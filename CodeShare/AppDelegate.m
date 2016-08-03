//
//  AppDelegate.m
//  CodeShare
//
//  Created by 段登志 on 16/8/2.
//  Copyright © 2016年 ddz. All rights reserved.
//

#import "AppDelegate.h"
#import "CSViewController.h"
#import <SMS_SDK/SMSSDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //当我们把main.storyboard 关联去除掉，那么打开app会只展示一个黑色的window，没有控制器，我们需要手动创建一个
    
 
    //一般情况下，为了防止 appdelegate 方法里面需要添加的东西过多，显得程序混乱，我们都会将不同的模块封装起来
    [self setUpRootViewController];
    
    
    //Mob 初始化
    [self setUpMob];
    
    return YES;
}


- (void)setUpRootViewController {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[CSViewController alloc] init];
    
    [self.window makeKeyAndVisible];
}


- (void)setUpMob {
    [SMSSDK registerApp:MobApp withSecret:MobSecret];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
