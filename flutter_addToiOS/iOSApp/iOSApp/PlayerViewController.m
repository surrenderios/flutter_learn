//
//  PlayerViewController.m
//  iOSApp
//
//  Created by Alex_Wu on 5/21/19.
//  Copyright © 2019 Alex. All rights reserved.
//

#import "PlayerViewController.h"
#import "AppDelegate.h"
#import <Masonry.h>

static NSString *PLAYER_CHANNEL_NAME = @"com.iosapp.demo/my_player";
static const FlutterMethodChannel *PLAYER_PLATFORM_CHANNEL;

static NSString *PLAYER_EVENT_CHANNEL_NAME = @"com.iosapp.demo/my_player_event";
static const FlutterEventChannel *PLAYER_EVENT_CHANNEL;

static NSString *playerUrl = @"http://61.138.254.167:5000/nn_vod/nn_x64/aWQ9NWJiZWM1OWExODM2OTg1NWJjOWQ0NWFmMDMxYjM2ZDUmdXJsX2MxPTdhNjg2ZjZlNjc2Nzc1NjE2ZTY3NjM2ODc1NjE2ZTYyNmYyZjMyMzAzMTM4MzEzMDMxMzEyZjM1NjI2MjY1NjMzNTY0MzUzMzYxMzAzMTY0MzgzMTYxNjUzOTYzMzE2MjM0MzA2NDYzMzAzNjY1MzAzMDMxMzUyZjM1NjI2MjY1NjMzNTM5NjEzMTM4MzMzNjM5MzgzNTM1NjI2MzM5NjQzNDM1NjE2NjMwMzMzMTYyMzMzNjY0MzUyZTc0NzMwMCZubl9haz0wMTljNjFlZjk5MDFmNjUyNjkyODA2NjYyNGQwMzlhZjBiJm50dGw9MyZucGlwcz0xOTIuMTY4LjIwNC4xMTI6NTEwMCZuY21zaWQ9MTYwMTAxJm5ncz01Y2MyNzUzNDIzNDY0MThhYTY2YjE0ZjRkMWY0NDY1NyZubmQ9dGVzdC50cy5zdGFyY29yJm5zZD1jbi56Z2R4LmFsbCZuZnQ9dHMmbm5fdXNlcl9pZD13dXl1amluZyZuZHQ9cGhvbmUmbmRpPTBjYjMyZjNlNmJlZWRkMWU5ODhlNTE2NTMxY2IxMTc3Jm5kdj0xLjUuMC4wLjIuU0MtSHVhQ2FpVFYtSVBIT05FLjAuMF9SZWxlYXNlJm5zdD1pcHR2Jm5jYT0lMjZuYWklM2Q1NDc5NjElMjZubl9jcCUzZHpob25nZ3VhbmdjaHVhbmJvJm5hbD0wMTM0NzVjMjVjMDYwN2UwMzU5OTkzOGJmYTNiODExNzg0MTdlNWEzZGM1ZDQy/5bbec59a18369855bc9d45af031b36d5.m3u8";

@interface PlayerViewController ()<FlutterStreamHandler>
@end

@implementation PlayerViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (instancetype)initWithEngine:(FlutterEngine *)engine nibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithEngine:engine nibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self initPlayerEventChannel];
        [self initMethodChannelAndHandleMethodCall];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    /* it is also ok
    // flutter player aspectradio is 16:9
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    CGFloat height = width * 9 / 16;
    
    UIView *subView = [[UIView alloc] initWithFrame:CGRectZero];
    subView.backgroundColor = [UIColor redColor];
    [self.view addSubview:subView];
    [subView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).with.offset(height);
    }];
     */
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    if (self.isMovingFromParentViewController) {
        [PLAYER_PLATFORM_CHANNEL setMethodCallHandler:nil];
        [PLAYER_EVENT_CHANNEL setStreamHandler:nil];
        [self.engine setViewController:nil];
    }
}

#pragma mark - handle init
- (void)initPlayerEventChannel
{
    // why weakSelf not work ???
    // need to set [EVENT_CHANNEL setStreamHandler:nil];
    PLAYER_EVENT_CHANNEL = [FlutterEventChannel eventChannelWithName:PLAYER_EVENT_CHANNEL_NAME binaryMessenger:kAppEngine];
    [PLAYER_EVENT_CHANNEL setStreamHandler:self];
}


- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    return nil;
}

- (FlutterError* _Nullable)onListenWithArguments:(id _Nullable)arguments
                                       eventSink:(nonnull FlutterEventSink)events {
    if ([arguments isEqualToString:PLAYER_EVENT_CHANNEL_NAME]) {
        events(playerUrl);
    }
    return nil;
}

#pragma mark - handle method call
- (void)initMethodChannelAndHandleMethodCall
{
    __weak typeof(self)weakSelf = self;
    PLAYER_PLATFORM_CHANNEL = [FlutterMethodChannel methodChannelWithName:PLAYER_CHANNEL_NAME binaryMessenger:kAppEngine];
    [PLAYER_PLATFORM_CHANNEL setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        if ([call.method isEqualToString:@"flutterCallNative"]) {
            [weakSelf flutterCallNative:call result:result];
        }
        else if ([call.method isEqualToString:@"askForUrlToPlay"]){
            [weakSelf askForUrlToPlay:call result:result];
        }
        else if ([call.method isEqualToString:@"pop"]){
            [weakSelf.navigationController popViewControllerAnimated:self];
        }
        else{
            result(FlutterMethodNotImplemented);
        }
    }];
}

- (void)flutterCallNative:(FlutterMethodCall *)methodCall result:(FlutterResult)result
{
    result(@(YES));
}

- (void)askForUrlToPlay:(FlutterMethodCall *)methodCall result:(FlutterResult)result
{
    result(playerUrl);
}

#pragma mark - 请求影片信息
- (void)requestVideoInfo:(FlutterMethodCall *)call result:(FlutterResult)result
{
    NSDictionary *videoInfo = @{
                                @"name":@"天外飞仙",
                                @"playCount":@(12345),
                                };
    result(videoInfo);
}

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}
@end
