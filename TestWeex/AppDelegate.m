//
//  AppDelegate.m
//  TestWeex
//
//  Created by AntiMoron on 2018/10/3.
//  Copyright © 2018年 AntiMoron. All rights reserved.
//

#import "AppDelegate.h"
#import <WeexSDK/WeexSDK.h>
#import "WeexImageHandler.h"
#import "ViewController.h"
#import <WeexSDK/WeexSDK.h>
#import "BTCNavigatorModule.h"
#import "WeexViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [WXAppConfiguration setAppGroup:@"BTC"];
    [WXAppConfiguration setAppName:@"BTC"];
    [WXAppConfiguration setAppVersion:@"1.0.0"];
    
    //init sdk environment
    [WXSDKEngine initSDKEnvironment];
    
    
    //register the implementation of protocol, optional
    [WXSDKEngine registerHandler:[[WeexImageHandler alloc] init] withProtocol:@protocol(WXImgLoaderProtocol)];
    WeexViewController* wvc = [[WeexViewController alloc] initWithURLString:@"http://192.168.0.101:8082/dist/index.js"];
    self.window.rootViewController = [[ViewController alloc] initWithRootViewController:wvc];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
