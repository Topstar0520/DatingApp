//
//  User.h
//  
//
//  Created by Maksim on 03.09.15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Country, Education, Ethnic, Location, NSManagedObject, Profession, Relationship, Religion, Session,Goals,WantKids,HaveKids,Orientation;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * avatar;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSDate * expiresTokenAt;
@property (nonatomic, retain) NSString * facebookToken;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * heightUnit;
@property (nonatomic, retain) NSNumber * heightValue;
@property (nonatomic, retain) NSString * interestedIn;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * refreshToken;
@property (nonatomic, retain) NSString * stringDateOfBirth;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * favoriteThings;
@property (nonatomic, retain) NSString * favoriteJoll;
@property (nonatomic, retain) NSString * bringJoy;
@property (nonatomic, retain) NSString * dreamParents;





@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSNumber * messagesNotifications;
@property (nonatomic, retain) NSNumber * matchesNotifications;
@property (nonatomic, retain) NSNumber * likesNotifications;
@property (nonatomic, retain) NSNumber * messagesBadge;
@property (nonatomic, retain) NSNumber * matchesBadge;
@property (nonatomic, retain) NSNumber * likesBadge;
@property (nonatomic, retain) NSNumber * matchCount;
@property (nonatomic, assign) BOOL isFull;
@property (nonatomic, retain) Country *country;
@property (nonatomic, retain) Education *education;
@property (nonatomic, retain) Ethnic *ethnic;
@property (nonatomic, retain) NSSet *image;
@property (nonatomic, retain) Location *location;
@property (nonatomic, retain) Profession *profession;
@property (nonatomic, retain) Relationship *relationship;
@property (nonatomic, retain) Religion *religion;
@property (nonatomic, retain) Goals *goals;
@property (nonatomic, retain) WantKids *wantKids;
@property (nonatomic, retain) HaveKids *haveKids;
@property (nonatomic, retain) Orientation *orientation;
@property (nonatomic, retain) Session *session;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addImageObject:(NSManagedObject *)value;
- (void)removeImageObject:(NSManagedObject *)value;
- (void)addImage:(NSSet *)values;
- (void)removeImage:(NSSet *)values;

@end
