//
//  NSDate+ChatTimeFormat.h
//  DatingApp
//
//  Created by VLADISLAV KIRIN on 11/4/15.
//  Copyright © 2015 Cleveroad Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ChatTimeFormat)

+ (NSString *)relativeDateStringForDate:(NSTimeInterval)timeStamp;

@end
