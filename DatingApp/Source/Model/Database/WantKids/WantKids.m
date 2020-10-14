//
//  WantKids.m
//  
//
//  Created by  Artem Kalinovsky on 8/13/15.
//
//

#import "WantKids.h"
#import "NSManagedObjectContext+MagicalRecordRestKit.h"

@implementation WantKids

@dynamic wantKidsId;
@dynamic wantKidsTitle;
@dynamic isDefault;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    WantKids *wantKids = (WantKids *) [NSEntityDescription insertNewObjectForEntityForName:@"WantKids" inManagedObjectContext:[NSManagedObjectContext MR_temporaryContext]];
   
    wantKids.wantKidsId = dictionary[@"id"];
    
    wantKids.wantKidsTitle = dictionary[@"title"];
    
    NSNumber *number = [NSNumber numberWithBool:dictionary[@"isDefault"]];
    wantKids.isDefault = number;

    return wantKids;
}

@end
