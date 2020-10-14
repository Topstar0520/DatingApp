//
//  NSObject+PE.h
//  iPhoneChatterPlug
//
//  Created by Josh on 5/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (PE)

- (BOOL) isNull:(NSObject*) object;
- (BOOL) isNotNull:(NSObject*) object;

@end
