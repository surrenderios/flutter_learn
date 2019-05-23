//
//  TraceLog.h
//  iOSApp
//
//  Created by Alex_Wu on 5/21/19.
//  Copyright © 2019 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TraceLog(fmt, ...) NSLog((@"%@, %s (%d) => " fmt), [TraceLog lastCallMethod], __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

NS_ASSUME_NONNULL_BEGIN

@interface TraceLog : NSObject
+ (NSString *)lastCallMethod;
@end

NS_ASSUME_NONNULL_END
