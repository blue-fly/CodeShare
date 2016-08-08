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

@interface AppDelegate ()<UIAlertViewDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //当我们把main.storyboard 关联去除掉，那么打开app会只展示一个黑色的window，没有控制器，我们需要手动创建一个
    
 
    //一般情况下，为了防止 appdelegate 方法里面需要添加的东西过多，显得程序混乱，我们都会将不同的模块封装起来
    [self setUpRootViewController];
    
    
    //Mob 初始化
    [self setUpMob];
    
    //封装检测新版本
    [self checkNewVersion];
    
    
    //3DTouch 都有哪些用
    //1.可以作为我们 app 的快捷键直接打开某个深层次的界面
    //2.可以作为预览新界面的样式
    //3.可以直接通过快捷操作，来实现不进入到某个控制器，却调用了它的一些方法
    //其实就相当于给我们的app增加了很多交互的方式
    [self setUpShortKeys];
    
    
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

//更新
- (void)checkNewVersion {
    
    //虽说 appStore 不允许应用检测更新，但是为了用户能够尽早的体验我们的新版本，这个工作还是要做。
    //1.不能在界面上直接展示
    //2.我们要保证在送审期间不能弹出新版本提示（由服务器控制）
    
    NSDictionary *paras =@{
                           @"service": @"Version.GetLatestVersion",
                           };
    [NetworkTool getDataWithParameters:paras completeBlock:^(BOOL success, id result) {
       
        if (success) {
            //取出最新的版本号
            NSInteger latestVersion = [[result objectForKey:@"version"] integerValue];
            //取出当前版本号
            //通过info.plist取当前版本
            NSInteger newVersion = [[[[NSBundle mainBundle] infoDictionary] objectForKey:kCFBundleVersionKey] integerValue];
            
            //对比，如果当前版本，比最新版本低，就弹出警示框
            if (newVersion < latestVersion) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"新版本" message:[result objectForKey:@"content"] delegate:self cancelButtonTitle:[[result objectForKey:@"isForce"] isEqualToString:@"1"]? @"取消":nil otherButtonTitles:@"去更新", nil];
                
                [alert show];
            }
        }
        
    }];
    
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //在这里跳转到appStore
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/app/id984365130"]];
    
    
}

//3D Touch
- (void)setUpShortKeys {
    
    UIApplicationShortcutItem *item1 = [[UIApplicationShortcutItem alloc] initWithType:@"type1" localizedTitle:@"按钮1" localizedSubtitle:@"我是小图标" icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeHome] userInfo:nil];
    
    UIApplicationShortcutItem *item2 = [[UIApplicationShortcutItem alloc] initWithType:@"type2" localizedTitle:@"按钮2" localizedSubtitle:@"我是小图标2" icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeSearch] userInfo:nil];
    
    
    //我们动态的在 app内部修改（添加）程序的快捷键
    [[UIApplication sharedApplication] setShortcutItems:@[item1,item2]];
    
    //如果使用这种方式，我们可以随时在app运行的时候，动态修改我们的快捷方式
    //还可以在info.plist文件中先指定几个快捷键（优先级最低），这样的话，我们的app从appStore一安装，不用运行，就可以使用快捷键
    
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

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    //当用户通过点击桌面上图标的快捷按钮进入到app会先调用这个方法，我们可以在这里做相应的处理
    NSString *type = shortcutItem.type;
    //type是可以标记某个item的方式之一
    
    if ([type isEqualToString:@"type2"]) {
        
        [(UITabBarController *)[self window].rootViewController setSelectedIndex:3];
    }
    
    
    //userInfo 可以在用户打开app时候，传值
    
}

@end
