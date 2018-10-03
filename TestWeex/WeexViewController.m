//
//  WeexViewController.m
//  btciOS
//
//  Created by AntiMoron on 2018/5/30.
//  Copyright © 2018年 AntiMoron. All rights reserved.
//

#import "WeexViewController.h"
#import <WeexSDK/WeexSDK.h>
#import "WXBundleBaseURL.h"
#import <WeexSDK/WXSDKInstance.h>

@interface WeexViewController ()

@property(nonatomic, strong) WXSDKInstance* instance;

@property(nonatomic, strong) NSURL* url;

@property(nonatomic, strong) UIView* weexView;
// 修复weex bug在getComponentRect后iOS端会吧weexView的frame.origin.y置0
@property(nonatomic, assign) CGRect originWeexViewFrame;
// 背景图
@property(nonatomic, strong) UIImageView* bgImageView;

@property(nonatomic, assign) BOOL hasKVOStarted;

#ifdef DEBUG

@property(nonatomic, strong) UIButton* reloadBtn;

#endif

@end

@implementation WeexViewController

-(instancetype)initWithURLString:(NSString *)url {
    self = [super initWithNibName:nil bundle:nil];
    NSLog(@"weex url: %@", url);
    self.url = [NSURL URLWithString:url];
    return self;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(self.url && !self.instance) {
        [self initWeexInstance];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
//    self.view.backgroundColor = UIColor.whiteColor;
//    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"whiteblock"] forBarMetrics:UIBarMetricsDefault];
    
    self.bgImageView = [[UIImageView alloc] init];
    self.bgImageView.image = [UIImage imageNamed:@"background"];
    self.bgImageView.frame = self.view.bounds;
    self.bgImageView.hidden = YES;
    [self.view addSubview:self.bgImageView];
    self.view.clipsToBounds = YES;
    
    [self initWeexInstance];
    if(self.url) {
        [self initWeexInstance];
    }
#ifdef DEBUG
    self.reloadBtn = [[UIButton alloc] init];
    [self.reloadBtn setTitle:@"Refresh" forState:UIControlStateNormal];
    [self.reloadBtn addTarget:self action:@selector(reload:) forControlEvents:UIControlEventTouchUpInside];
    [self.reloadBtn setTitleColor:UIColor.orangeColor forState:UIControlStateNormal];
    self.reloadBtn.frame = CGRectMake(330, 30, 100, 100);
//    [self.view addSubview:self.reloadBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.reloadBtn];
#endif
    [self addObserver:self forKeyPath:@"view.frame" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"weexView.frame" options:NSKeyValueObservingOptionNew context:nil];
    self.hasKVOStarted = YES;
}

-(void)setEnableBackground:(BOOL)enableBackground {
    _enableBackground = enableBackground;
    self.bgImageView.hidden = !enableBackground;
}

-(void)setShowNavBack:(BOOL)showNavBack {
    _showNavBack = showNavBack;
}

-(void) dealloc {
    [_instance destroyInstance];
    if(self.hasKVOStarted) {
        [self removeObserver:self forKeyPath:@"view.frame"];
        [self removeObserver:self forKeyPath:@"weexView.frame"];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if([keyPath isEqualToString:@"weexView.frame"]) {
        [self layoutWeexView];
        NSLog(@"%@", NSStringFromCGRect(self.weexView.frame));
    } else if([keyPath isEqualToString:@"view.frame"]) {
        [self layoutWeexView];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:!self.showNavBack animated:YES];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutWeexView];
}

// 布局weex view.
-(void) layoutWeexView {
    if(self.weexView && CGRectEqualToRect(self.originWeexViewFrame, self.weexView.frame) && !CGRectEqualToRect(self.weexView.frame, CGRectZero)) {
        return ;
    }
    CGFloat statusBarHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    CGRect frame = self.view.bounds;
    if(!self.navigationController || self.navigationController.navigationBarHidden) {
        frame.origin.y = statusBarHeight;
        frame.size.height -= statusBarHeight;// + navbarHeight;
    }
    self.originWeexViewFrame = frame;
    self.weexView.frame = frame;
    self.weexView.backgroundColor = UIColor.clearColor;
    [self.view bringSubviewToFront:self.weexView];
}

-(void) initWeexInstance {
    _instance = [[WXSDKInstance alloc] init];
    _instance.viewController = self;
    __weak typeof(self) weakSelf = self;
    _instance.onCreate = ^(UIView *view) {
        [weakSelf.weexView removeFromSuperview];
        weakSelf.weexView = view;
        [weakSelf.view addSubview:weakSelf.weexView];
        [weakSelf layoutWeexView];
#ifdef DEBUG
        [weakSelf.view bringSubviewToFront:weakSelf.reloadBtn];
#endif
    };
    
    _instance.onFailed = ^(NSError *error) {
        //process failure
        NSLog(@"weex page error %@", error);
    };
    
    _instance.renderFinish = ^ (UIView *view) {
        //process renderFinish
        //        NSLog(@"%@", view);
    };
    if(self.url) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.instance renderWithURL:self.url];
        });
    }
}

#ifdef DEBUG

-(void) reload:(id) sender {
    [self.instance destroyInstance];
    self.instance = nil;
    [self initWeexInstance];
}

#endif


-(void) navBack {
    if(self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
/**
 *  更新currentHash
 *  重新生成url 重新加载页面
 */
-(void) loadHash:(NSString*) hash {
    self.currentHash = hash;
    self.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", WXBundleBaseURL(), hash]];
    [self initWeexInstance];
}

@end
