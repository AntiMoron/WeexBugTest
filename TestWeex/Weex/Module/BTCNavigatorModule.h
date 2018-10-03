//
//  WXNavigatorModule.h
//  btciOS
//
//  Created by AntiMoron on 2018/7/23.
//  Copyright © 2018年 AntiMoron. All rights reserved.
//

#import <WeexSDK/WeexSDK.h>
#import <Foundation/Foundation.h>

@interface BTCNavigatorModule : NSObject<WXModuleProtocol>

-(void) push:(NSDictionary*)option;

@end
