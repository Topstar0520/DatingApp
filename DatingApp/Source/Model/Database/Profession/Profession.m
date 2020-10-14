//
//  Profession.m
//  
//
//  Created by  Artem Kalinovsky on 8/13/15.
//
//

#import "Profession.h"
#import "NSManagedObjectContext+MagicalRecordRestKit.h"

@implementation Profession

@dynamic professionId;
@dynamic professionTitle;
@dynamic isDefault;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    Profession *profession = (Profession *) [NSEntityDescription insertNewObjectForEntityForName:@"Profession" inManagedObjectContext:[NSManagedObjectContext MR_temporaryContext]];
    
    profession.professionId = dictionary[@"id"];
    
    profession.professionTitle = dictionary[@"title"];
    
    NSNumber *number = [NSNumber numberWithBool:dictionary[@"isDefault"]];
    profession.isDefault = number;

    return profession;
}

@end
