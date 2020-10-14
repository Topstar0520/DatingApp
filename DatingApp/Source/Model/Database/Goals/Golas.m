//
//  Goals.m
//  
//
//  Created by  Artem Kalinovsky on 8/13/15.
//
//

#import "Goals.h"
#import "NSManagedObjectContext+MagicalRecordRestKit.h"

@implementation Goals

@dynamic goalId;
@dynamic goalTitle;
@dynamic isDefault;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    Goals *goals = (Goals *) [NSEntityDescription insertNewObjectForEntityForName:@"Goals" inManagedObjectContext:[NSManagedObjectContext MR_temporaryContext]];
   
    goals.goalId = dictionary[@"id"];
    
    goals.goalTitle = dictionary[@"title"];
    
    NSNumber *number = [NSNumber numberWithBool:dictionary[@"isDefault"]];
    goals.isDefault = number;

    return goals;
}

@end
