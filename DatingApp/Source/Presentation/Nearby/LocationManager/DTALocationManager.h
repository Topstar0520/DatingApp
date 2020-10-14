//
//  DTALocationManager.h
//  DatingApp
//
//  Created by Maksim on 14.09.15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;

typedef void(^DTALocationBlock)(CLLocation* location);

@interface DTALocationManager : NSObject

- (void)trackLocationWithCompletionBlock:(DTALocationBlock )handler;

+ (instancetype)sharedInstance;

@end
