//
//  Orientation.m
//  
//
//  Created by  Artem Kalinovsky on 8/13/15.
//
//

#import "Orientation.h"
#import "NSManagedObjectContext+MagicalRecordRestKit.h"

@implementation Orientation

@dynamic orientationId;
@dynamic orientationTitle;
@dynamic isDefault;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    Orientation *orientation = (Orientation *) [NSEntityDescription insertNewObjectForEntityForName:@"Orientation" inManagedObjectContext:[NSManagedObjectContext MR_temporaryContext]];
   
    orientation.orientationId = dictionary[@"id"];
    
    orientation.orientationTitle = dictionary[@"title"];
    
    NSNumber *number = [NSNumber numberWithBool:dictionary[@"isDefault"]];
    orientation.isDefault = number;

    return orientation;
}

@end
