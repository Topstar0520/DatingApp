//
//  DTAObjectManager.m
//  DatingApp
//
//  Created by VLADISLAV KIRIN on 8/3/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import "User.h"
#import "User+Extension.h"
#import "NSManagedObjectContext+MagicalRecordRestKit.h"
#import "Location+Extensions.h"
#import "Country+Extensions.h"
#import "Education+Extensions.h"
#import "Ethnic+Extensions.h"
#import "Profession+Extensions.h"
#import "Relationship+Extensions.h"
#import "Religion+Extensions.h"
#import "Session+Extensions.h"
#import "Image+Extensions.h"
//#import "Image+Extensions.h"

@implementation DTAObjectManager

+ (void)setup {
    NSURL *baseURL = [NSURL URLWithString:DTAAPIServerHostname];
    DTAObjectManager *objectManager = [DTAObjectManager managerWithBaseURL:baseURL];
    
    objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
}

+ (void)setupCoreDataWithPersistentStoreName:(NSString *)persistentStoreName {
    
    // Initialize managed object store
    DTAObjectManager *objectManager = [DTAObjectManager sharedManager];
    
    //remove current settings
    [objectManager.responseDescriptors enumerateObjectsUsingBlock:^(RKResponseDescriptor *responseDescriptor, NSUInteger idx, BOOL *stop) {
        [objectManager removeResponseDescriptor:responseDescriptor];
    }];
    
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    if (!managedObjectModel) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DatingAppWithPushNotifications" withExtension:@"momd"];
        managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    
    objectManager.managedObjectStore = managedObjectStore;
    
    [managedObjectStore createPersistentStoreCoordinator];
    
    NSDictionary *options = @{ NSMigratePersistentStoresAutomaticallyOption : @YES, NSInferMappingModelAutomaticallyOption : @YES };
    
    NSString *storePath = [[APP_DELEGATE applicationSupportDirectory] stringByAppendingPathComponent:[persistentStoreName stringByAppendingPathExtension:@"sqlite"]];
    NSError *error;
    NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:nil withConfiguration:nil options:options error:&error];
    NSAssert(persistentStore, @"Failed to add persistent store with error: %@", error);
    
    // Create the managed object contexts
    [managedObjectStore createManagedObjectContexts];
    
    // Configure a managed object cache to ensure we do not create duplicate objects
    //managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];
    
    managedObjectStore.managedObjectCache = [RKFetchRequestManagedObjectCache new];
    
    // Initialize MR
    
    // Setup Magical Record with managed object model
    [NSManagedObjectModel MR_setDefaultManagedObjectModel:managedObjectStore.managedObjectModel];
    
    // Setup Magical Record with persistent store coordinator
    [NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:managedObjectStore.persistentStoreCoordinator];
    
    
    // Setup Magical Record with managed object contexts
    [NSManagedObjectContext MR_setDefaultContext:managedObjectStore.mainQueueManagedObjectContext];
    [NSManagedObjectContext MR_setRootSavingContext:managedObjectStore.persistentStoreManagedObjectContext];
    
    [self setupUserRoutes];
    [self setupUserMapping];
}

#pragma mark - Overrided

- (NSMutableURLRequest *)requestWithObject:(id)object method:(RKRequestMethod)method path:(NSString *)path parameters:(NSDictionary *)parameters {
    
    NSMutableURLRequest *request = [super requestWithObject:object method:method path:path parameters:parameters];
    
    if ([self needToAddHeadersTorequestPath:path]) {
        [self addCustomHeadersToRequest:request];
    }
    
    request.timeoutInterval = 30;

    //if ([path isEqualToString:DTAAPIAlbumsAddEndpoint]) {
    //    request.timeoutInterval = 120;
    //}
    
    return request;
}

- (NSMutableURLRequest *)requestWithPathForRouteNamed:(NSString *)routeName object:(id)object parameters:(NSDictionary *)parameters {
    NSMutableURLRequest *request = [super requestWithPathForRouteNamed:routeName object:object parameters:parameters];
    
    [self addCustomHeadersToRequest:request];
    
    return request;
}

//- (NSMutableURLRequest *)multipartFormRequestWithObject:(id)object method:(RKRequestMethod)method path:(NSString *)path parameters:(NSDictionary *)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block {

-(NSMutableURLRequest *)multipartFormRequestWithObject:(id)object method:(RKRequestMethod)method path:(NSString *)path parameters:(NSDictionary *)parameters constructingBodyWithBlock:(void (^)(id <AFRKMultipartFormData> formData))block {

    NSMutableURLRequest *request = [super multipartFormRequestWithObject:object method:method path:path parameters:parameters constructingBodyWithBlock:block];
    
    if ([self needToAddHeadersTorequestPath:path]) {
        [self addCustomHeadersToRequest:request];
    }
    
    request.timeoutInterval = 30;
    
    return request;
}

#pragma mark - private

- (BOOL)needToAddHeadersTorequestPath:(NSString *)requestPath {
    return ![requestPath isEqualToString:DTAAPILoginViaFacebookEndpoint] && ![requestPath isEqualToString:DTAAPILoginViaEmailEndpoint] && ![requestPath isEqualToString:DTAAPIRegisterViaFacebookEndpoint] && ![requestPath isEqualToString:DTAAPIRegisterViaAppleEndpoint] && ![requestPath isEqualToString:DTAAPIRegisterViaEmailEndpoint] && ![requestPath isEqualToString:DTAAPIRegisterViaInstagramEndpoint] && ![requestPath isEqualToString:DTAAPILoginViaInstagramEndpoint];
}

- (void)addCustomHeadersToRequest:(NSMutableURLRequest*)request {
    
    [request setValue:DTAAPIClientKey forHTTPHeaderField:@"X-Application-Key"];
    
    NSString *accessToken = [User currentUser].session.accessToken;
    NSLog(@"accessToken = %@", accessToken);
    
    if (accessToken) {
        [request setValue:accessToken forHTTPHeaderField:@"Authorization"];
    }
}

#pragma mark - routes setup

+ (void)setupUserRoutes {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^ {
        
        [[DTAObjectManager sharedManager].router.routeSet addRoute:[RKRoute routeWithName:kDTAAPIFetchUserFullProfileRoute pathPattern:DTAAPIFetchUserFullProfileEndpoint method:RKRequestMethodGET]];
        
        [[DTAObjectManager sharedManager].router.routeSet addRoute:[RKRoute routeWithName:kDTAAPIFetchUserProfileRoute pathPattern:DTAAPIFetchUserProfileEndpoint method:RKRequestMethodGET]];
        
        [[DTAObjectManager sharedManager].router.routeSet addRoute:[RKRoute routeWithName:kDTAAPIEditUserProfileRoute pathPattern:DTAAPIEditUserProfileEndpoint method:RKRequestMethodPOST]];

        [[DTAObjectManager sharedManager].router.routeSet addRoute:[RKRoute routeWithName:kDTAAPIFetchMatchedUsersRoute pathPattern:DTAAPIListOfMatchedUsersEndpoint method:RKRequestMethodGET]];

        [[DTAObjectManager sharedManager].router.routeSet addRoute:[RKRoute routeWithName:kDTAAPIFetchMatchesRoute pathPattern:DTAAPIListOfMatchesEndpoint method:RKRequestMethodGET]];

        [[DTAObjectManager sharedManager].router.routeSet addRoute:[RKRoute routeWithName:kDTAAPIMatchUserRoute pathPattern:DTAAPIMatchUserEndpoint method:RKRequestMethodPOST]];

        [[DTAObjectManager sharedManager].router.routeSet addRoute:[RKRoute routeWithName:kDTAAPIDeleteMatchUserRoute pathPattern:DTAAPIMatchUserEndpoint method:RKRequestMethodDELETE]];
    });
}

#pragma mark - add response descriptor

+ (void)addResponseDescriptorWithMapping:(RKMapping*)mapping requestMethod:(RKRequestMethod)method pathPatterns:(NSArray*)pathPatterns keyPath:(NSString*)keyPath {
    
    [pathPatterns enumerateObjectsUsingBlock:^(NSString *pathPattern, NSUInteger idx, BOOL *stop) {
    
        RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:method pathPattern:pathPattern keyPath:keyPath statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
      
        [[DTAObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
     }];
}

#pragma mark - mappings setup

+ (void)setupUserMapping {
    
    RKEntityMapping *userMappingSession = [self userMapping];
    
    RKEntityMapping *userMapping = [self userMapping];
    
    [userMappingSession addRelationshipMappingWithSourceKeyPath:@"session" mapping:[self sessionMapping]];
    
    [userMappingSession addRelationshipMappingWithSourceKeyPath:@"location" mapping:[self locationMapping]];
    
    [userMappingSession addRelationshipMappingWithSourceKeyPath:@"country" mapping:[self countryMapping]];
    
    [userMappingSession addRelationshipMappingWithSourceKeyPath:@"education" mapping:[self educationMapping]];
    
    [userMappingSession addRelationshipMappingWithSourceKeyPath:@"ethnic" mapping:[self ethnicsMapping]];
    
    [userMappingSession addRelationshipMappingWithSourceKeyPath:@"profession" mapping:[self professionMapping]];
    
    [userMappingSession addRelationshipMappingWithSourceKeyPath:@"relationship" mapping:[self relationshipMapping]];
    
    [userMappingSession addRelationshipMappingWithSourceKeyPath:@"religion" mapping:[self religionMapping]];
    
    [userMappingSession addRelationshipMappingWithSourceKeyPath:@"image" mapping:[self imagesMapping]];
    
    [userMapping addRelationshipMappingWithSourceKeyPath:@"location" mapping:[self locationMapping]];
    
    [userMapping addRelationshipMappingWithSourceKeyPath:@"country" mapping:[self countryMapping]];
    
    [userMapping addRelationshipMappingWithSourceKeyPath:@"education" mapping:[self educationMapping]];
    
    [userMapping addRelationshipMappingWithSourceKeyPath:@"ethnic" mapping:[self ethnicsMapping]];
    
    [userMapping addRelationshipMappingWithSourceKeyPath:@"profession" mapping:[self professionMapping]];
    
    [userMapping addRelationshipMappingWithSourceKeyPath:@"relationship" mapping:[self relationshipMapping]];
    
    [userMapping addRelationshipMappingWithSourceKeyPath:@"religion" mapping:[self religionMapping]];
    
    [userMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"attachments" toKeyPath:@"image" withMapping:[self imagesMapping]]];
    
    [self addResponseDescriptorWithMapping:userMappingSession requestMethod:RKRequestMethodPOST pathPatterns:@[DTAAPILoginViaFacebookEndpoint, DTAAPILoginViaEmailEndpoint, DTAAPIRegisterViaFacebookEndpoint, DTAAPIRegisterViaAppleEndpoint,DTAAPIRegisterViaEmailEndpoint, DTAAPIRegisterViaInstagramEndpoint, DTAAPIRefreshAccessTokenEndpoint] keyPath:DTAAPIUserResponseKeyPath];
    
    [self addResponseDescriptorWithMapping:userMapping requestMethod:RKRequestMethodGET pathPatterns:@[DTAAPIFetchUserProfileEndpoint, DTAAPIFetchUserFullProfileEndpoint] keyPath:nil];
    
    [self addResponseDescriptorWithMapping:userMapping requestMethod:RKRequestMethodPOST pathPatterns:@[DTAAPIEditUserProfileEndpoint] keyPath:nil];

    [self addResponseDescriptorWithMapping:userMapping requestMethod:RKRequestMethodGET pathPatterns:@[DTAAPIBrowseUsersEndpoint, DTAAPIListOfMatchedUsersEndpoint, DTAAPIListOfMatchesEndpoint] keyPath:DTAAPIBrowsingUsersResponseKeyPath];

    [self addResponseDescriptorWithMapping:userMapping requestMethod:RKRequestMethodPUT pathPatterns:@[DTAAPIUpdateUserLocationEndpoint] keyPath:nil];
}

#pragma mark - basic mappings

+ (RKEntityMapping *)userMapping {
    
    RKEntityMapping *userMapping;
   
    if (!userMapping) {
        
        userMapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([User class]) inManagedObjectStore:[DTAObjectManager sharedManager].managedObjectStore];
        
        [userMapping addAttributeMappingsFromDictionary:@{@"id": @"userId", @"avatar": @"avatar", @"email": @"email", @"gender": @"gender", @"firstName": @"firstName", @"lastName": @"lastName", @"dateOfBirth": @"stringDateOfBirth", @"summary": @"summary", @"interestedIn": @"interestedIn", @"height.value": @"heightValue", @"height.unit": @"heightUnit", @"isFull": @"isFull", @"messagesNotifications": @"messagesNotifications", @"matchesNotifications": @"matchesNotifications", @"likesNotifications": @"likesNotifications", @"likesBadge": @"likesBadge", @"messagesBadge": @"messagesBadge", @"matchesBadge": @"matchesBadge"}];
        
        userMapping.identificationAttributes = @[@"userId"];
    }
    
    return userMapping;
}

+ (RKEntityMapping *)sessionMapping {
    
    static RKEntityMapping *userSessionMapping;
   
    if (!userSessionMapping) {
        
        userSessionMapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([Session class]) inManagedObjectStore:[DTAObjectManager sharedManager].managedObjectStore];
        
        [userSessionMapping addAttributeMappingsFromDictionary:@{ @"accessToken": @"accessToken", @"refreshToken": @"refreshToken", @"expiresAt": @"expiresAtDateString" }];
    }
    
    return userSessionMapping;
}

+ (RKEntityMapping *)locationMapping {
    
    static RKEntityMapping *userLocationMapping;
   
    if (!userLocationMapping) {
        
        userLocationMapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([Location class]) inManagedObjectStore:[DTAObjectManager sharedManager].managedObjectStore];
        
        [userLocationMapping addAttributeMappingsFromDictionary:@{ @"title": @"locationTitle", @"lat": @"latitude", @"lon": @"longitude" }];
    }
    
    return userLocationMapping;
}

+ (RKEntityMapping *)countryMapping {
    
    static RKEntityMapping *userCountryMapping;
  
    if (!userCountryMapping) {
        
        userCountryMapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([Country class]) inManagedObjectStore:[DTAObjectManager sharedManager].managedObjectStore];
        
        [userCountryMapping addAttributeMappingsFromDictionary:@{ @"id": @"countryId", @"title": @"countryTitle", @"isDefault": @"isDefault" }];
        
        userCountryMapping.identificationAttributes = @[@"countryId"];
    }
    
    return userCountryMapping;
}

+ (RKEntityMapping *)educationMapping {
    
    static RKEntityMapping *userEducationMapping;
  
    if (!userEducationMapping) {
        
        userEducationMapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([Education class]) inManagedObjectStore:[DTAObjectManager sharedManager].managedObjectStore];
        
        [userEducationMapping addAttributeMappingsFromDictionary:@{ @"id": @"educationId", @"title": @"educationTitle", @"isDefault": @"isDefault" }];
        
        userEducationMapping.identificationAttributes = @[@"educationId"];
    }
    
    return userEducationMapping;
}

+ (RKEntityMapping *)ethnicsMapping {
    
    static RKEntityMapping *userEthnicsMapping;
   
    if (!userEthnicsMapping) {
        
        userEthnicsMapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([Ethnic class]) inManagedObjectStore:[DTAObjectManager sharedManager].managedObjectStore];
        
        [userEthnicsMapping addAttributeMappingsFromDictionary:@{ @"id": @"ethnicId", @"title": @"ethnicTitle", @"isDefault": @"isDefault" }];
        
        userEthnicsMapping.identificationAttributes = @[@"ethnicId"];
    }
    
    return userEthnicsMapping;
}

+ (RKEntityMapping *)professionMapping {
    
    static RKEntityMapping *userProfessionMapping;
   
    if (!userProfessionMapping) {
        
        userProfessionMapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([Profession class]) inManagedObjectStore:[DTAObjectManager sharedManager].managedObjectStore];
        
        [userProfessionMapping addAttributeMappingsFromDictionary:@{ @"id": @"professionId", @"title": @"professionTitle", @"isDefault": @"isDefault" }];
        
        userProfessionMapping.identificationAttributes = @[@"professionId"];
    }
    
    return userProfessionMapping;
}

+ (RKEntityMapping *)relationshipMapping {
    
    static RKEntityMapping *userRelationshipMapping;
   
    if (!userRelationshipMapping) {
        
        userRelationshipMapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([Relationship class]) inManagedObjectStore:[DTAObjectManager sharedManager].managedObjectStore];
        
        [userRelationshipMapping addAttributeMappingsFromDictionary:@{ @"id": @"relationshipId", @"title": @"relationshipTitle", @"isDefault": @"isDefault" }];
        
        userRelationshipMapping.identificationAttributes = @[@"relationshipId"];
    }
    
    return userRelationshipMapping;
}

+ (RKEntityMapping *)imagesMapping {
    
    static RKEntityMapping *userImagesMapping;

    if (!userImagesMapping) {
        
        userImagesMapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([Image class]) inManagedObjectStore:[DTAObjectManager sharedManager].managedObjectStore];
        
        [userImagesMapping addAttributeMappingsFromDictionary:@{ @"id": @"imageId", @"name": @"name", @"path": @"path", @"isAvatar": @"isAvatar", @"index": @"index" }];
        
        userImagesMapping.identificationAttributes = @[@"imageId"];
    }

    return userImagesMapping;
}

+ (RKEntityMapping *)religionMapping {
    
    static RKEntityMapping *userReligionMapping;
  
    if (!userReligionMapping) {
    
        userReligionMapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([Religion class]) inManagedObjectStore:[DTAObjectManager sharedManager].managedObjectStore];
        
        [userReligionMapping addAttributeMappingsFromDictionary:@{ @"id": @"religionId", @"title": @"religionTitle", @"isDefault": @"isDefault" }];
        
        userReligionMapping.identificationAttributes = @[@"religionId"];
    }
    
    return userReligionMapping;
}

@end
