//
//  DTAObjectManager.h
//  DatingApp
//
//  Created by VLADISLAV KIRIN on 8/3/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import "RKObjectManager.h"

@interface DTAObjectManager : RKObjectManager

+ (void)setup;
+ (void)setupCoreDataWithPersistentStoreName:(NSString *)persistentStoreName;

- (NSMutableURLRequest *)requestWithObject:(id)object method:(RKRequestMethod)method path:(NSString *)path parameters:(NSDictionary *)parameters;

@end
