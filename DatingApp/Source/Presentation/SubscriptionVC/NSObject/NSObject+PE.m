//
//  NSObject+PE.m
//  iPhoneChatterPlug
//
//  NSObject category to determine
//
//  Created by Josh on 5/8/11.
//  Copyright 2011 Productive Edge. All rights reserved.
//

#import "NSObject+PE.h"
@implementation NSObject (PE)
- (BOOL) isNull:(NSObject*) object {
    if (!object)
        return YES;
    else if (object == [NSNull null])
        return YES;
    else if ([object isKindOfClass: [NSString class]]) {
        return ([((NSString*)object) isEqualToString:@""]
                || [((NSString*)object) isEqualToString:@"nil"]
                 || [((NSString*)object) isEqualToString:@"null"]
                 ||[((NSString*)object) isEqualToString:@"(null)"]
                 || [((NSString*)object) isEqualToString:@"<null>"]);
    }
    return NO;
}
- (BOOL) isNotNull:(NSObject*) object {
    return ![self isNull:object];
}
@end
