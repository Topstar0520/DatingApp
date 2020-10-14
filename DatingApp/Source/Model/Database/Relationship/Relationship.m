//
//  Relationship.m
//  
//
//  Created by  Artem Kalinovsky on 8/13/15.
//
//

#import "Relationship.h"
#import "NSManagedObjectContext+MagicalRecordRestKit.h"

@implementation Relationship

@dynamic relationshipId;
@dynamic relationshipTitle;
@dynamic isDefault;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    Relationship *relationship = (Relationship *) [NSEntityDescription insertNewObjectForEntityForName:@"Relationship" inManagedObjectContext:[NSManagedObjectContext MR_temporaryContext]];
 
    relationship.relationshipId = dictionary[@"id"];
    
    relationship.relationshipTitle = dictionary[@"title"];
    
    NSNumber *number = [NSNumber numberWithBool:dictionary[@"isDefault"]];
    relationship.isDefault = number;

    return relationship;
}

@end
