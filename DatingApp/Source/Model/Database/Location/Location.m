//
//  Location.m
//  
//
//  Created by  Artem Kalinovsky on 8/13/15.
//
//

#import "Location.h"
#import "NSManagedObjectContext+MagicalRecordRestKit.h"

@implementation Location

@dynamic locationTitle;
@dynamic latitude;
@dynamic longitude;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    Location *location = (Location *) [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:[NSManagedObjectContext MR_temporaryContext]];
    
    location.locationTitle = dictionary[@"title"];

    //    location.latitude = dictionary[@"lat"];
    //    location.longitude = dictionary[@"lng"];

    return location;
}

@end
