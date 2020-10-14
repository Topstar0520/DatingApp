//
//  Education.m
//  
//
//  Created by  Artem Kalinovsky on 8/13/15.
//
//

#import "Education.h"
#import "NSManagedObjectContext+MagicalRecordRestKit.h"

@implementation Education

@dynamic educationId;
@dynamic educationTitle;
@dynamic isDefault;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    Education *education = (Education *) [NSEntityDescription insertNewObjectForEntityForName:@"Education" inManagedObjectContext:[NSManagedObjectContext MR_temporaryContext]];
   
    education.educationId = dictionary[@"id"];
    
    education.educationTitle = dictionary[@"title"];
    
    NSNumber *number = [NSNumber numberWithBool:dictionary[@"isDefault"]];
    education.isDefault = number;

    return education;
}

@end
