//
//  HaveKids.m
//  
//
//  Created by  Artem Kalinovsky on 8/13/15.
//
//

#import "HaveKids.h"
#import "NSManagedObjectContext+MagicalRecordRestKit.h"

@implementation HaveKids

@dynamic haveKidsId;
@dynamic haveKidsTitle;
@dynamic isDefault;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    HaveKids *haveKids = (HaveKids *) [NSEntityDescription insertNewObjectForEntityForName:@"HaveKids" inManagedObjectContext:[NSManagedObjectContext MR_temporaryContext]];
   
    haveKids.haveKidsId = dictionary[@"id"];
    
    haveKids.haveKidsTitle = dictionary[@"title"];
    
    NSNumber *number = [NSNumber numberWithBool:dictionary[@"isDefault"]];
    haveKids.isDefault = number;

    return haveKids;
}

@end
