//
//  Religion.m
//  
//
//  Created by  Artem Kalinovsky on 8/13/15.
//
//

#import "Religion.h"
#import "NSManagedObjectContext+MagicalRecordRestKit.h"

@implementation Religion

@dynamic religionId;
@dynamic religionTitle;
@dynamic isDefault;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    Religion *religion = (Religion *) [NSEntityDescription insertNewObjectForEntityForName:@"Religion" inManagedObjectContext:[NSManagedObjectContext MR_temporaryContext]];
   
    religion.religionId = dictionary[@"id"];
    
    religion.religionTitle = dictionary[@"title"];
    
    NSNumber *number = [NSNumber numberWithBool:dictionary[@"isDefault"]];
    religion.isDefault = number;

    return religion;
}

@end
