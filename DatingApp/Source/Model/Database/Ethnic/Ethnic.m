//
//  Ethnic.m
//  
//
//  Created by  Artem Kalinovsky on 8/13/15.
//
//

#import "Ethnic.h"
#import "NSManagedObjectContext+MagicalRecordRestKit.h"

@implementation Ethnic

@dynamic ethnicId;
@dynamic ethnicTitle;
@dynamic isDefault;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    Ethnic *ethnic = (Ethnic *) [NSEntityDescription insertNewObjectForEntityForName:@"Ethnic" inManagedObjectContext:[NSManagedObjectContext MR_temporaryContext]];
  
    ethnic.ethnicId = dictionary[@"id"];
    
    ethnic.ethnicTitle = dictionary[@"title"];
    
    NSNumber *number = [NSNumber numberWithBool:dictionary[@"isDefault"]];
    ethnic.isDefault = number;

    return ethnic;
}

@end
