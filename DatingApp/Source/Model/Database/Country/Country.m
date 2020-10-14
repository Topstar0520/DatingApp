//
//  Country.m
//  
//
//  Created by  Artem Kalinovsky on 8/13/15.
//
//

#import "Country.h"
#import "NSManagedObjectContext+MagicalRecordRestKit.h"

@implementation Country

@dynamic countryId;
@dynamic countryTitle;
@dynamic isDefault;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    Country *country = (Country *) [NSEntityDescription insertNewObjectForEntityForName:@"Country" inManagedObjectContext:[NSManagedObjectContext MR_temporaryContext]];
  
    country.countryId = dictionary[@"id"];
    
    country.countryTitle = dictionary[@"title"];
    
    NSNumber *number = [NSNumber numberWithBool:dictionary[@"isDefault"]];
    country.isDefault = number;

    return country;
}

@end
