//
//  WeexViewController.h
//  btciOS
//
//  Created by AntiMoron on 2018/5/30.
//  Copyright © 2018年 AntiMoron. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  页面控制
 */
@interface WeexViewController : UIViewController
/**
 *  当前页面的Hash.
 */
@property(nonatomic, copy) NSString* currentHash;
/**
 *  是否展示回退按钮
 */
@property(nonatomic, assign) BOOL showNavBack;
/**
 * 是否开启背景图
 */
@property(nonatomic, assign) BOOL enableBackground;
/**
 *  用url初始化weex页面
 */
-(instancetype) initWithURLString:(NSString*)url NS_DESIGNATED_INITIALIZER;
-(instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
/**
 *  更新currentHash
 *  重新生成url 重新加载页面
 */
-(void) loadHash:(NSString*) hash;
@end
