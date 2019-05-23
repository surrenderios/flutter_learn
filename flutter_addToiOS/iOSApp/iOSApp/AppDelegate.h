//
//  AppDelegate.h
//  iOSApp
//
//  Created by Alex_Wu on 5/20/19.
//  Copyright © 2019 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Flutter/Flutter.h>

#define kAppEngine ((AppDelegate *)[[UIApplication sharedApplication] delegate]).flutterEngine

#define kAppReloadMessageChannel ((AppDelegate *)[[UIApplication sharedApplication] delegate]).reloadMessageChannel

@interface AppDelegate : FlutterAppDelegate
@property (nonatomic, strong) FlutterEngine *flutterEngine;
@property (nonatomic, strong) FlutterBasicMessageChannel* reloadMessageChannel;
@end

