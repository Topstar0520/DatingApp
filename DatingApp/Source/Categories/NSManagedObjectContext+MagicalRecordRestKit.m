//
//  NSManagedObjectContext (MagicalRecordRestKit).m
//  DatingApp
//
//  Created by  Artem Kalinovsky on 9/11/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import "NSManagedObjectContext+MagicalRecordRestKit.h"

@implementation NSManagedObjectContext (MagicalRecordTempContext)

+ (NSManagedObjectContext *)MR_temporaryContext {
    
    static NSManagedObjectContext *moc = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        moc = [NSManagedObjectContext MR_context];
    });
    
    return moc;
}

@end
