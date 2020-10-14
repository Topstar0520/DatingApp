//
//  DTAAPI.h
//  DatingApp
//
//  Created by VLADISLAV KIRIN on 8/5/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//
@class CLLocation;

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

typedef NS_ENUM(NSUInteger, DTAAPIStaticResourcesType) {
    DTAAPIStaticResourcesTypeCountries = 0,
    DTAAPIStaticResourcesTypeEducations,
    DTAAPIStaticResourcesTypeEthnics,
    DTAAPIStaticResourcesTypeProfessions,
    DTAAPIStaticResourcesTypeRelationships,
    DTAAPIStaticResourcesTypeReligions,
    DTAAPIStaticResourcesTypeGoals,
    DTAAPIStaticResourcesTypeWantKids,
    DTAAPIStaticResourcesTypeHaveKids,
    DTAAPIStaticResourcesTypeOrientation
};

typedef void (^DTAAPISuccessErrorCompletionBlock)(NSError *error);
typedef void (^DTAAPISuccessErrorResultCompletionBlock)(NSError *error, NSArray *result);
typedef void (^DTAAPICompletionBlock)(NSError *error, id result);

@class User, DTAProspectsPage;

@interface DTAAPI : NSObject

#pragma mark - Authentification

+ (void)registerViaEmail:(NSString *)email password:(NSString *)password completion:(DTAAPISuccessErrorCompletionBlock)completion;

//+ (void)registerViaAppleToken:(NSString *)appleToken completion:(DTAAPISuccessErrorCompletionBlock)completion;
+ (void)registerViaAppleToken:(NSMutableDictionary *)appleDict completion:(DTAAPISuccessErrorCompletionBlock)completion;
+ (void)registerViaFacebookToken:(NSString *)facebookToken completion:(DTAAPISuccessErrorCompletionBlock)completion;

+ (void)getBlockedUserListData: (DTAAPISuccessErrorResultCompletionBlock)completion;

+ (void)registerViaInstagramToken:(NSString *)instagramToken andInstagramId:(NSString *)instagramId completion:(DTAAPISuccessErrorCompletionBlock)completion;

+ (void)loginViaEmail:(NSString *)email password:(NSString *)password completion:(DTAAPICompletionBlock)completion;
+ (void)loginViaApple:(NSMutableDictionary *)appleDict completion:(DTAAPISuccessErrorResultCompletionBlock)completion;
+ (void)loginViaFacebookToken:(NSString *)facebookToken completion:(DTAAPISuccessErrorResultCompletionBlock)completion;


+ (void)loginViaInstagramToken:(NSString *)instagramToken completion:(DTAAPISuccessErrorResultCompletionBlock)completion;

+ (void)logoutWithCompletion: (DTAAPISuccessErrorCompletionBlock)completion;

+ (void)blockMatchedUserWithUserId:(NSString *)userId andBlockedByUserId:(NSString *)blockedByUserId completion:(DTAAPISuccessErrorCompletionBlock)completion;

+ (void)unblockUserFromAPI:(NSString *)userId  completion:(DTAAPISuccessErrorCompletionBlock)completion;

+ (void)refreshExpiredAccessTokenWithCompletionBlock: (DTAAPISuccessErrorCompletionBlock)completion;

#pragma mark -  Static resources

+ (void)fetchStaticResourceWithKey:(DTAAPIStaticResourcesType)type completion:(DTAAPISuccessErrorResultCompletionBlock)completion;

+ (void)fetchCityNamesForQuery:(NSString *)query completion:(DTAAPISuccessErrorResultCompletionBlock)completion;

+ (void)fetchCityCoordsByPlaceId:(NSString *)placeId completion:(DTAAPISuccessErrorResultCompletionBlock)completion;

#pragma mark - Profile

+ (void)profileFetchForUserId:(NSString *)userId completion:(DTAAPISuccessErrorCompletionBlock)completion;

//DEV
+ (void)profileFullFetchForUserId:(NSString *)userId completion:(DTAAPISuccessErrorResultCompletionBlock)completion;
//+ (void)profileFullFetchForUserId:(NSString *)userId completion:(DTAAPISuccessErrorResultCompletionBlock)completion;
+ (void)getUserSubscriptonStaus:(NSString *)userId completion:(DTAAPISuccessErrorResultCompletionBlock)completion;

+ (void)profileUpdateWithParameters:(NSDictionary *)parameters avatar:(UIImage *)image completionBlock:(DTAAPISuccessErrorCompletionBlock)completion;

+ (void)profileUpdateLocationWithLocation:(CLLocation *)location;

+ (void)profileDeleteWithCompletion: (DTAAPISuccessErrorCompletionBlock)completion;

+ (void)loadProfileImagesWithCompletion: (DTAAPISuccessErrorCompletionBlock)completion;

+ (void)deleteProfileImageForId:(NSString *)inageId WithCompletion:(DTAAPISuccessErrorCompletionBlock)completion;

+ (void)setAvatarProfileImageId:(NSString *)imageId WithCompletion:(DTAAPISuccessErrorCompletionBlock)completion;

+ (void)uploadProfileImage:(UIImage *)image WithCompletion:(DTAAPICompletionBlock)completion;

+ (void)setImagesOrder:(NSArray *)orderArray withCompletion:(DTAAPISuccessErrorResultCompletionBlock)completion;

+ (void)badgeUpdateWithPushType:(DTAPushType)pushType сompletion:(DTAAPISuccessErrorCompletionBlock)completion;

#pragma mark - Browse

+ (void)fetchBrowsingUsersWithParameters:(NSDictionary *)parameters completion: (DTAAPISuccessErrorResultCompletionBlock)completion;

#pragma mark - Subscription

//+ (void)fetchPlanListWithParameters:(NSDictionary *)parameters completion: (DTAAPISuccessErrorResultCompletionBlock)completion;

+ (void)fetchPlanListWithParameters: (DTAAPICompletionBlock)completion;
+ (void)apiForPurchasePlan:(NSMutableDictionary *)purchaseDict completion:(DTAAPISuccessErrorResultCompletionBlock)completion;

#pragma mark - Match

+ (void)fetchMatchedUsersOnPage:(DTAProspectsPage *)page completion:(DTAAPISuccessErrorResultCompletionBlock)completion;

+ (void)fetchMatchesOnPage:(DTAProspectsPage *)page completion:(DTAAPISuccessErrorResultCompletionBlock)completion;

//+ (void)matchUser:(User *)user completion:(DTAAPISuccessErrorCompletionBlock)completion;
+ (void)matchUser:(User *)user completion:(DTAAPISuccessErrorResultCompletionBlock)completion;

+ (void)deleteMatchForUser:(User *)user completion:(DTAAPISuccessErrorResultCompletionBlock)completion;

+ (void)tsetAPI;

+ (void)removeUserFromMatchUserId:(NSString *)userId andCompletion:(DTAAPICompletionBlock)completion;

#pragma mark - Nearby

+ (void)loadArrayOfUsersCompletion: (DTAAPICompletionBlock)completion;

#pragma mark - Reports

+ (void)reportUser:(User *)user reportText:(NSString *)text attachedImage:(UIImage *)image completion:(DTAAPISuccessErrorCompletionBlock)completion;

@end
