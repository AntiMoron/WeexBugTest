//
//  WXNavigatorModule.m
//  btciOS
//
//  Created by AntiMoron on 2018/7/23.
//  Copyright © 2018年 AntiMoron. All rights reserved.
//

#import "BTCNavigatorModule.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "WeexViewController.h"

@implementation BTCNavigatorModule

WX_EXPORT_METHOD(@selector(push:))
WX_EXPORT_METHOD(@selector(pop))

-(UITabBarController*) currentTabViewController {
    AppDelegate* appdel = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UIWindow* window = appdel.window;
    if([window.rootViewController isKindOfClass:UITabBarController.class]) {
        return (UITabBarController*)window.rootViewController;
    }
    return nil;
}

-(void) push:(NSDictionary*)option {
    if(!option) { return ; }
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString* finalUrl = option[@"url"];
        BOOL animated = [option[@"animated"] boolValue];
        NSString* title = option[@"title"];
        // 添加鲁棒性
        if([title isKindOfClass:NSNull.class]) {
            title = nil;
        }
        // 是否要带上navigation Controller包装
        BOOL nativeHaveNavigator = [option[@"nativeHaveNavigator"] boolValue];
        WeexViewController* vc = [[WeexViewController alloc] initWithURLString:finalUrl];
        vc.currentHash = finalUrl;
        vc.title = title;
        UITabBarController* tabBarController = self.currentTabViewController;
        NSArray<UIViewController*>* viewControllers = tabBarController.viewControllers;
        UIViewController* currentVC = nil;
        if(tabBarController.selectedIndex < viewControllers.count) {
            currentVC = viewControllers[tabBarController.selectedIndex];
        }
        if(currentVC.presentedViewController) {
            currentVC = currentVC.presentedViewController;
        }
        UINavigationController* navController = (UINavigationController*)currentVC;
        vc.hidesBottomBarWhenPushed = YES;
        vc.showNavBack = nativeHaveNavigator;
        for(NSInteger i = 0; i < navController.viewControllers.count; i++) {
            UIViewController* aVc = navController.viewControllers[i];
            if([aVc isKindOfClass:WeexViewController.class] && [((WeexViewController*)aVc).currentHash isEqualToString:finalUrl]) {
                [navController popToViewController:aVc animated:animated];
                return ;
            }
        }
        [navController pushViewController:vc animated:animated];
    });
}

-(void) pop {
    UITabBarController* tabBarController = self.currentTabViewController;
    NSArray<UIViewController*>* viewControllers = tabBarController.viewControllers;
    UIViewController* currentVC = nil;
    if(tabBarController.selectedIndex < viewControllers.count) {
        currentVC = viewControllers[tabBarController.selectedIndex];
    }
    if(currentVC.presentedViewController) {
        currentVC = currentVC.presentedViewController;
    }
    UINavigationController* navController = (UINavigationController*)currentVC;
    if(![navController isKindOfClass:UINavigationController.class]) {
        navController = navController.navigationController;
    }
    if(!navController) {
        [currentVC dismissViewControllerAnimated:YES completion:nil];
    } else {
        [navController popViewControllerAnimated:YES];
    }
}

@end
