//
//  SearchOptions.m
//  
//
//  Created by  Artem Kalinovsky on 9/14/15.
//
//

#import "SearchOptions.h"
#import "Country.h"
#import "Education.h"
#import "Ethnic.h"
#import "Location.h"
#import "Profession.h"
#import "Relationship.h"
#import "Religion.h"
#import "Goals.h"
#import "WantKids.h"
#import "HaveKids.h"
#import "Orientation.h"
#import "User+Extension.h"

@implementation SearchOptions

@dynamic nearbyRadius;
@dynamic ageFrom;
@dynamic ageTo;
@dynamic heightFrom;
@dynamic heightTo;
@dynamic interestedIn;
@dynamic userId;
@dynamic country;
@dynamic education;
@dynamic ethnic;
@dynamic profession;
@dynamic location;
@dynamic relationship;
@dynamic religion;
@dynamic goals;
@dynamic wantKids;
@dynamic haveKids;
@dynamic orientation;

- (instancetype)initInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    
    self = (SearchOptions *) [NSEntityDescription insertNewObjectForEntityForName:@"SearchOptions" inManagedObjectContext:managedObjectContext];

    self.userId = [User currentUser].userId;

    self.country = (Country *) [NSEntityDescription insertNewObjectForEntityForName:@"Country" inManagedObjectContext:managedObjectContext];

    self.education = (Education *) [NSEntityDescription insertNewObjectForEntityForName:@"Education" inManagedObjectContext:managedObjectContext];

    self.ethnic = (Ethnic *) [NSEntityDescription insertNewObjectForEntityForName:@"Ethnic" inManagedObjectContext:managedObjectContext];

    self.location = (Location *) [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:managedObjectContext];

    self.profession = (Profession *) [NSEntityDescription insertNewObjectForEntityForName:@"Profession" inManagedObjectContext:managedObjectContext];

    self.relationship = (Relationship *) [NSEntityDescription insertNewObjectForEntityForName:@"Relationship" inManagedObjectContext:managedObjectContext];

    self.religion = (Religion *) [NSEntityDescription insertNewObjectForEntityForName:@"Religion" inManagedObjectContext:managedObjectContext];
    
    
    self.goals = (Goals *) [NSEntityDescription insertNewObjectForEntityForName:@"Goals" inManagedObjectContext:managedObjectContext];
    
    self.wantKids = (WantKids *) [NSEntityDescription insertNewObjectForEntityForName:@"WantKids" inManagedObjectContext:managedObjectContext];
    
    self.haveKids = (HaveKids *) [NSEntityDescription insertNewObjectForEntityForName:@"HaveKids" inManagedObjectContext:managedObjectContext];
    
    self.orientation = (Orientation *) [NSEntityDescription insertNewObjectForEntityForName:@"Orientation" inManagedObjectContext:managedObjectContext];
    
    
    return self;
}

@end
