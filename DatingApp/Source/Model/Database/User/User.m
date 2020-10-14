//
//  User.m
//  
//
//  Created by Maksim on 03.09.15.
//
//

#import "User.h"
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
#import "Session.h"
#import "Image.h"
#import "NSManagedObjectContext+MagicalRecordRestKit.h"

@implementation User

@dynamic avatar;
@dynamic email;
@dynamic expiresTokenAt;
@dynamic facebookToken;
@dynamic firstName;
@dynamic gender;
@dynamic heightUnit;
@dynamic heightValue;
@dynamic interestedIn;
@dynamic lastName;
@dynamic refreshToken;
@dynamic stringDateOfBirth;
@dynamic summary;
@dynamic favoriteThings;
@dynamic favoriteJoll;
@dynamic bringJoy;
@dynamic dreamParents;
@dynamic userId;
@dynamic country;
@dynamic education;
@dynamic ethnic;
@dynamic image;
@dynamic location;
@dynamic profession;
@dynamic relationship;
@dynamic religion;
@dynamic goals;
@dynamic session;
@dynamic distance;
@dynamic messagesNotifications;
@dynamic matchesNotifications;
@dynamic likesNotifications;
@dynamic messagesBadge;
@dynamic matchesBadge;
@dynamic matchCount;
@dynamic likesBadge;
@dynamic isFull;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    User *user = (User*)[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[NSManagedObjectContext MR_temporaryContext]];
   
//    user.matchCount = dictionary[@"matchedCount"];
    
    user.userId = dictionary[@"id"];
    
    user.firstName = dictionary[@"firstName"];
    
    user.lastName = dictionary[@"lastName"];
    
    user.avatar = dictionary[@"avatar"];
    
    user.stringDateOfBirth = dictionary[@"dateOfBirth"];
    
    user.email = dictionary[@"email"];
    
    user.summary = dictionary[@"summary"];    
    user.favoriteThings = dictionary[@"favorite_things"];
    user.favoriteJoll = dictionary[@"favorite_jollofs"];
    user.bringJoy = dictionary[@"brings_joy"];
    user.dreamParents = dictionary[@"your_dream"];
    
    
    user.interestedIn = dictionary[@"interestedIn"];
    
    user.gender = dictionary[@"gender"];
    
    user.heightUnit = dictionary[@"height"][@"unit"];
    
    user.heightValue = dictionary[@"height"][@"value"];
    
    if (dictionary[@"distance"] != [NSNull null]) {
        user.distance = dictionary[@"distance"];
    }
    
    if (dictionary[@"location"] != [NSNull null]) {
        user.location = [[Location alloc] initWithDictionary:dictionary[@"location"]];
    }

    if (dictionary[@"country"] != [NSNull null]) {
        user.country = [[Country alloc] initWithDictionary:dictionary[@"country"]];
    }

    if (dictionary[@"education"] != [NSNull null]) {
        user.education = [[Education alloc] initWithDictionary:dictionary[@"education"]];
    }

    if (dictionary[@"relationship"] != [NSNull null]) {
        user.relationship = [[Relationship alloc] initWithDictionary:dictionary[@"relationship"]];
    }

    if (dictionary[@"ethnic"] != [NSNull null]) {
        user.ethnic = [[Ethnic alloc] initWithDictionary:dictionary[@"ethnic"]];
    }

    if (dictionary[@"profession"] != [NSNull null]) {
        user.profession = [[Profession alloc] initWithDictionary:dictionary[@"profession"]];
    }

    if (dictionary[@"religion"] != [NSNull null]) {
        user.religion = [[Religion alloc] initWithDictionary:dictionary[@"religion"]];
    }
    //DEV
    if (dictionary[@"relationshipgoal"] != [NSNull null]) {
        user.goals = [[Goals alloc] initWithDictionary:dictionary[@"relationshipgoal"]];
    }
    
    if (dictionary[@"wantkid"] != [NSNull null]) {
        user.wantKids = [[WantKids alloc] initWithDictionary:dictionary[@"wantkid"]];
    }
    
    if (dictionary[@"havekid"] != [NSNull null]) {
        user.haveKids = [[HaveKids alloc] initWithDictionary:dictionary[@"havekid"]];
    }
    
    if (dictionary[@"orientation"] != [NSNull null]) {
        user.orientation = [[Orientation alloc] initWithDictionary:dictionary[@"orientation"]];
    }
    
    
    if (dictionary[@"attachments"] != [NSNull null]) {
        NSSet *attachments = dictionary[@"attachments"];
       
        for (NSDictionary *attachmentDictionary in attachments) {
            Image *image = [[Image alloc] initWithDictionary:attachmentDictionary];
            [user addImageObject:image];
        }
    }
    
    return user;
}

@end
