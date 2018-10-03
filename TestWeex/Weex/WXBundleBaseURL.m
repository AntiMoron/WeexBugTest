//
//  WXBundleBaseURL.c
//  btciOS
//
//  Created by AntiMoron on 2018/9/20.
//  Copyright © 2018年 AntiMoron. All rights reserved.
//

#include "WXBundleBaseURL.h"

NSString* WXBundleBaseURL(void) {
    NSString* url = @"http://192.168.0.101:8081/dist/index.js";
    //#ifndef DEBUG
//        NSString *path = [[NSBundle mainBundle]pathForResource:@"index" ofType:@"js"];
//        url = [NSURL fileURLWithPath:path].absoluteString;
    //#endif
    return url;
}
