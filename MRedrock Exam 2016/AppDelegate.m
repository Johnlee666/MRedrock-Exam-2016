//
//  AppDelegate.m
//  MRedrock Exam 2016
//
//  Created by 李展 on 16/5/14.
//  Copyright © 2016年 李展. All rights reserved.
//

#import "AppDelegate.h"
#import "LZListView.h"
#import "LZPlayerView.h"
#import "LZSearchView.h"
#import "LZRecordView.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
     UIViewController *view=[storyboard instantiateViewControllerWithIdentifier:@"a"];
    view.title = @"播放界面";
    UIViewController *view1=[storyboard instantiateViewControllerWithIdentifier:@"b"];
    view1.title = @"热歌榜";
    UIViewController *view2 = [storyboard instantiateViewControllerWithIdentifier:@"c"];
    view2.title = @"搜索界面";
    LZRecordView *view3 = [storyboard instantiateViewControllerWithIdentifier:@"d"];
    view3.title =@"播放列表";
    UITabBarController *bar = [[UITabBarController alloc]init];
    bar.viewControllers = @[view,view1,view2,view3];
    self.window.rootViewController=bar;
    self.window.backgroundColor = [UIColor whiteColor];
    // Override point for customization after application launch.
    return YES;
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
