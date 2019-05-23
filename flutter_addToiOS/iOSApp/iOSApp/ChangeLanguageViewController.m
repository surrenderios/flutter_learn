//
//  ChangeLanguageViewController.m
//  iOSApp
//
//  Created by Alex_Wu on 5/22/19.
//  Copyright © 2019 Alex. All rights reserved.
//

#import "ChangeLanguageViewController.h"
#import "AppDelegate.h"

static NSString *LANGUAGE_CHANNEL_NAME = @"com.iosapp.demo/change_language_init";
static const FlutterMethodChannel *LANGUAGE_PLATFORM_CHANNEL;

static NSString *LANGUAGE_EVENT_CHANNEL_NAME = @"com.iosapp.demo/change_language_event";
static const FlutterEventChannel *LANGUAGE_EVENT_CHANNEL;

@interface ChangeLanguageViewController ()<FlutterStreamHandler>
@end

@implementation ChangeLanguageViewController
- (instancetype)initWithEngine:(FlutterEngine *)engine nibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithEngine:engine nibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self initLanguageEventChannel];
        [self initMethodChannelAndHandleMethodCall];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController) {
        [LANGUAGE_EVENT_CHANNEL setStreamHandler:nil];
        [self.engine setViewController:nil];
    }
}

#pragma mark - handle init
- (void)initLanguageEventChannel
{
    // why weakSelf not work ???
    // need to set [EVENT_CHANNEL setStreamHandler:nil];
    __weak typeof(self)weakSelf = self;
    LANGUAGE_EVENT_CHANNEL = [FlutterEventChannel eventChannelWithName:LANGUAGE_EVENT_CHANNEL_NAME binaryMessenger:kAppEngine];
    [LANGUAGE_EVENT_CHANNEL setStreamHandler:weakSelf];
}

- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    return nil;
}

- (FlutterError* _Nullable)onListenWithArguments:(id _Nullable)arguments
                                       eventSink:(nonnull FlutterEventSink)events {
    if ([arguments isEqualToString:LANGUAGE_EVENT_CHANNEL_NAME]) {
        events(@(2));
    }
    return nil;
}

#pragma mark - handle method call
- (void)initMethodChannelAndHandleMethodCall
{
    __weak typeof(self)weakSelf = self;
    LANGUAGE_PLATFORM_CHANNEL = [FlutterMethodChannel methodChannelWithName:LANGUAGE_CHANNEL_NAME binaryMessenger:kAppEngine];
    [LANGUAGE_PLATFORM_CHANNEL setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        if ([call.method isEqualToString:@"changeLanguage"]) {
            [weakSelf changeLanguage:call result:result];
        }
        else{
            result(FlutterMethodNotImplemented);
        }
    }];
}

- (void)changeLanguage:(FlutterMethodCall *)methodCall result:(FlutterResult)result
{
    int index = [(NSNumber *)methodCall.arguments intValue];
    NSLog(@"切换语言到 %d",index);
    
    result(@(YES));
}

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}
@end
