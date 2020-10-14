//
//  DTASearchOptionsManager.m
//  DatingApp
//
//  Created by  Artem Kalinovsky on 9/14/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import "DTASearchOptionsManager.h"
#import "SearchOptions.h"
#import "Country.h"
#import "Education.h"
#import "Ethnic.h"
#import "Religion.h"
#import "Goals.h"
#import "WantKids.h"
#import "HaveKids.h"
#import "Orientation.h"
#import "Profession.h"
#import "Relationship.h"
#import "Location+Extensions.h"
#import "NSManagedObjectContext+MagicalRecordRestKit.h"
#import "User+Extension.h"

static DTASearchOptionsManager *sharedInstance = nil;

@interface DTASearchOptionsManager()

@property (nonatomic, strong, readwrite) SearchOptions *searchOptions;

@end

@implementation DTASearchOptionsManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^ {
        sharedInstance = [[DTASearchOptionsManager alloc] init];
    });
    
    return sharedInstance;
}

+ (void)resetSharedManager {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        [SearchOptions MR_truncateAllInContext:localContext];
    
    } completion:^(BOOL contextDidSave, NSError *error) {
        [self loadDefaults];
    }];
}

- (instancetype)init {
    if (self = [super init]) {
        
        self.searchOptions = [SearchOptions MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userId == %@", [User currentUser].userId]];
        
        if (!self.searchOptions) {
            self.searchOptions = [[SearchOptions alloc] initInManagedObjectContext:[NSManagedObjectContext MR_temporaryContext]];
           
            self.searchOptions.ageFrom = @(18);
            self.searchOptions.ageTo = @(80);
            self.searchOptions.heightFrom = @(48.0f);
            self.searchOptions.heightTo = @(95.0f);
            self.searchOptions.nearbyRadius = @(100);
        }
    }
    
    return self;
}

- (NSDictionary *)browsingParameters {
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];

    if (self.searchOptions.country.countryId) {
        if ([self.searchOptions.country.countryId isEqualToString:@""]) {
        }
        else {
            parameters[@"country"] = self.searchOptions.country.countryId;
        }
    }
    
    if (self.searchOptions.education.educationId) {
        if ([self.searchOptions.education.educationId isEqualToString:@""]) {
        }
        else {
            parameters[@"education"] = self.searchOptions.education.educationId;
        }
    }
    
    if (self.searchOptions.ethnic.ethnicId) {
        if ([self.searchOptions.ethnic.ethnicId isEqualToString:@""]) {
        }
        else {
            parameters[@"ethnic"] = self.searchOptions.ethnic.ethnicId;
        }
    }
    
    if (self.searchOptions.religion.religionId) {
        if ([self.searchOptions.religion.religionId isEqualToString:@""]) {
        }
        else {
            parameters[@"religion"] = self.searchOptions.religion.religionId;
        }
    }
    
    if (self.searchOptions.goals.goalId) {
           if ([self.searchOptions.goals.goalId isEqualToString:@""]) {
           }
           else {
               parameters[@"relationshipgoal"] = self.searchOptions.goals.goalId;
           }
       }

    if (self.searchOptions.wantKids.wantKidsId) {
           if ([self.searchOptions.wantKids.wantKidsId isEqualToString:@""]) {
           }
           else {
               parameters[@"wantkid"] = self.searchOptions.wantKids.wantKidsId;
           }
       }

    if (self.searchOptions.haveKids.haveKidsId) {
           if ([self.searchOptions.haveKids.haveKidsId isEqualToString:@""]) {
           }
           else {
               parameters[@"havekid"] = self.searchOptions.haveKids.haveKidsId;
           }
       }

    if (self.searchOptions.orientation.orientationId) {
           if ([self.searchOptions.orientation.orientationId isEqualToString:@""]) {

           }
           else {
               parameters[@"orientation"] = self.searchOptions.orientation.orientationId;
           }
       }
    
    
    if (self.searchOptions.profession.professionId) {
        if ([self.searchOptions.profession.professionId isEqualToString:@""]) {
            
        }
        else {
            parameters[@"profession"] = self.searchOptions.profession.professionId;
        }
    }
    
    if (self.searchOptions.relationship.relationshipId) {
        if ([self.searchOptions.relationship.relationshipId isEqualToString:@""]) {
            
        }
        else {
            parameters[@"relationship"] = self.searchOptions.relationship.relationshipId;
        }
    }
    
//    if (self.searchOptions.nearbyRadius.integerValue <= 300) {
//        parameters[@"distance"] = self.searchOptions.nearbyRadius;
//    }
    
    if (self.searchOptions.location.locationTitle) {
       parameters[@"location"] = self.searchOptions.location.locationTitle;
    }

    // parameters[@"height[from]"] = self.searchOptions.heightFrom;
    // parameters[@"height[to]"] = self.searchOptions.heightTo;
    
    parameters[@"age[from]"] = self.searchOptions.ageFrom;
    parameters[@"age[to]"] = self.searchOptions.ageTo;
    
    parameters[@"interestedIn"] = self.searchOptions.interestedIn ?: ([User currentUser].interestedIn ?: @"");

    NSLog(@"browse parameters = %@", parameters);
    
    return parameters;
}

- (NSDictionary *)nearbyParameters {
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
   
    parameters[@"distance"] = @25;
    parameters[@"age[from]"] = self.searchOptions.ageFrom;
    parameters[@"age[to]"] = self.searchOptions.ageTo;
    parameters[@"interestedIn"] = self.searchOptions.interestedIn ? : [User currentUser].interestedIn;
    
    return parameters;
}

- (void)saveChanges {
    [self.searchOptions.managedObjectContext MR_saveToPersistentStoreAndWait];
    [self.searchOptions.managedObjectContext MR_saveOnlySelfAndWait];
}

#pragma mark - private

+ (void)loadDefaults; {
    
    sharedInstance.searchOptions = [[SearchOptions alloc] initInManagedObjectContext:[NSManagedObjectContext MR_temporaryContext]];
    
    sharedInstance.searchOptions.ageFrom = @(18);
    sharedInstance.searchOptions.ageTo = @(80);
    sharedInstance.searchOptions.heightFrom = @(48.0f);
    sharedInstance.searchOptions.heightTo = @(95.0f);
    sharedInstance.searchOptions.nearbyRadius = @(100);
}

- (void)loadDefaultsFilter {
    
    sharedInstance.searchOptions = [[SearchOptions alloc] initInManagedObjectContext:[NSManagedObjectContext MR_temporaryContext]];
    
    sharedInstance.searchOptions.ageFrom = @(18);
    sharedInstance.searchOptions.ageTo = @(80);
    sharedInstance.searchOptions.heightFrom = @(48.0f);
    sharedInstance.searchOptions.heightTo = @(95.0f);
    sharedInstance.searchOptions.nearbyRadius = @(100);
}

- (void)resetFilter {
    
    self.searchOptions.ageFrom = @(18);
    self.searchOptions.ageTo = @(80);
    self.searchOptions.heightFrom = @(48.0f);
    self.searchOptions.heightTo = @(95.0f);
    self.searchOptions.nearbyRadius = @(100);
    
    //[MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
    //    [SearchOptions MR_truncateAllInContext:localContext];
    //} completion:^(BOOL contextDidSave, NSError *error) {
    //    [self loadDefaultsFilter];
    //    [self saveChanges];
    //}];
}

@end
