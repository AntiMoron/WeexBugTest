//
//  WeexImageHandler.m
//  btciOS
//
//  Created by AntiMoron on 2018/5/30.
//  Copyright © 2018年 AntiMoron. All rights reserved.
//

#import "WeexImageHandler.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define MIN_IMAGE_WIDTH 36
#define MIN_IMAGE_HEIGHT 36

#if OS_OBJECT_USE_OBJC
#undef  WXDispatchQueueRelease
#undef  WXDispatchQueueSetterSementics
#define WXDispatchQueueRelease(q)
#define WXDispatchQueueSetterSementics strong
#else
#undef  WXDispatchQueueRelease
#undef  WXDispatchQueueSetterSementics
#define WXDispatchQueueRelease(q) (dispatch_release(q))
#define WXDispatchQueueSetterSementics assign
#endif

@interface WeexImageDownloader:NSObject<WXImageOperationProtocol>

@property(nonatomic, strong) SDWebImageDownloadToken* token;

@end

@implementation WeexImageDownloader

-(instancetype) initWithToken: (SDWebImageDownloadToken*) token {
    self = [super init];
    self.token = token;
    return self;
}

-(void) cancel {
    [[[SDWebImageManager sharedManager] imageDownloader] cancel:self.token];
}

@end

// 加载本地图片站位用
@interface LocalImagePlaceHolder: NSObject<WXImageOperationProtocol>

@end

@implementation LocalImagePlaceHolder

-(void) cancel {}
@end

@interface WeexImageHandler()

@property (WXDispatchQueueSetterSementics, nonatomic) dispatch_queue_t ioQueue;

@end


@implementation WeexImageHandler

#pragma mark -
#pragma mark WXImgLoaderProtocol

- (id<WXImageOperationProtocol>)downloadImageWithURL:(NSString *)url imageFrame:(CGRect)imageFrame userInfo:(NSDictionary *)userInfo completed:(void(^)(UIImage *image,  NSError *error, BOOL finished))completedBlock
{
    static NSDictionary* localImageDisk = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 维护一个url和本地资源名称的字典
        localImageDisk = @{};
    });
    NSString* localImageName = [localImageDisk objectForKey:url];
    if(localImageName) {
        completedBlock([UIImage imageNamed:localImageName], nil, YES);
        return [[LocalImagePlaceHolder alloc] init];
    }
    NSLog(@"Loaded: %@", url);
    if ([url hasPrefix:@"//"]) {
        url = [@"http:" stringByAppendingString:url];
    }
    SDWebImageDownloadToken* token = [[[SDWebImageManager sharedManager] imageDownloader] downloadImageWithURL:[NSURL URLWithString:url] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        if (completedBlock) {
            completedBlock(image, error, finished);
        }
    }];
    WeexImageDownloader* downloader = [[WeexImageDownloader alloc] initWithToken:token];
    return (id<WXImageOperationProtocol>)downloader;
}

@end
