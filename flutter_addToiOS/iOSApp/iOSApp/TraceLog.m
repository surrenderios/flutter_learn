//
//  TraceLog.m
//  iOSApp
//
//  Created by Alex_Wu on 5/21/19.
//  Copyright © 2019 Alex. All rights reserved.
//

#import "TraceLog.h"

@implementation TraceLog
+ (NSString *)lastCallMethod;
{
    NSArray *symbols = [NSThread callStackSymbols];
    NSUInteger maxCount = symbols.count;
    NSString *secondSymbol = maxCount > 2 ? symbols[2] : (maxCount > 1 ? symbols[1] : symbols[0]);
    if (secondSymbol.length == 0) {
        return @"";
    }
    
    NSString *pattern = @"[+-]\\[.{0,}\\]";
    NSError *error;
    NSRegularExpression *exp = [NSRegularExpression regularExpressionWithPattern:pattern options:kNilOptions error:&error];
    if (error) {
        NSLog(@"error");
        return @"";
    }
    
    NSTextCheckingResult *check = [[exp matchesInString:secondSymbol options:NSMatchingReportCompletion range:NSMakeRange(0, secondSymbol.length)] lastObject];
    NSString *findStr = [secondSymbol substringWithRange:check.range];
    return findStr ?: @"";
}
@end
