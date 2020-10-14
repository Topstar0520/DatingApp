//
//  DTASearchOptionsManager.h
//  DatingApp
//
//  Created by  Artem Kalinovsky on 9/14/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SearchOptions;

@interface DTASearchOptionsManager : NSObject

@property (nonatomic, strong) NSArray *arrayOfCountries;
@property (nonatomic, strong) NSArray *arrayOfEducations;
@property (nonatomic, strong) NSArray *arrayOfEthnics;
@property (nonatomic, strong) NSArray *arrayOfProfessions;
@property (nonatomic, strong) NSArray *arrayOfRelationships;
@property (nonatomic, strong) NSArray *arrayOfReligions;
@property (nonatomic, strong) NSArray *arrayOfGoals;
@property (nonatomic, strong) NSArray *arrayOfWantKids;
@property (nonatomic, strong) NSArray *arrayOfHaveKids;
@property (nonatomic, strong) NSArray *arrayOfOrientations;

@property (nonatomic, strong, readonly) NSArray *arrayOfAges;
@property (nonatomic, strong, readonly) NSArray *arrayOfHeights;
@property (nonatomic, strong, readonly) NSArray *arrayOfNearbyDistances;
@property (nonatomic, strong, readonly) SearchOptions *searchOptions;

+ (instancetype) sharedManager;
+ (void) resetSharedManager;
- (NSDictionary *) browsingParameters;
- (NSDictionary *) nearbyParameters;
- (void) saveChanges;
- (void) resetFilter;
- (void) loadDefaultsFilter;

@end
