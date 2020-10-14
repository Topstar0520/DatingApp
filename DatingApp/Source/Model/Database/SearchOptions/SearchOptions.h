//
//  SearchOptions.h
//  
//
//  Created by  Artem Kalinovsky on 9/14/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Country, Education, Ethnic, Location, Profession, Relationship, Religion,Goals,WantKids,HaveKids,Orientation;

@interface SearchOptions : NSManagedObject

@property (nonatomic, retain) NSNumber * nearbyRadius;
@property (nonatomic, retain) NSNumber * ageFrom;
@property (nonatomic, retain) NSNumber * ageTo;
@property (nonatomic, retain) NSNumber * heightFrom;
@property (nonatomic, retain) NSNumber * heightTo;
@property (nonatomic, retain) NSString * interestedIn;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) Country *country;
@property (nonatomic, retain) Education *education;
@property (nonatomic, retain) Ethnic *ethnic;
@property (nonatomic, retain) Profession *profession;
@property (nonatomic, retain) Location *location;
@property (nonatomic, retain) Relationship *relationship;
@property (nonatomic, retain) Religion *religion;
@property (nonatomic, retain) Goals *goals;
@property (nonatomic, retain) WantKids *wantKids;
@property (nonatomic, retain) HaveKids *haveKids;
@property (nonatomic, retain) Orientation *orientation;

- (instancetype)initInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
