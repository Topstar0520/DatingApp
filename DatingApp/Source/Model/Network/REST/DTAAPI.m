//
//  DTAAPI.m
//  DatingApp
//
//  Created by VLADISLAV KIRIN on 8/5/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import "User+Extension.h"
#import "DTARKError.h"
#import "Location.h"
//#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import "Image.h"
#import "DTAProspectsPage.h"
#import "Session+Extensions.h"
#import "DTASearchOptionsManager.h"
#import "AppDelegate.h"

@implementation DTAAPI

#pragma mark - Authentification

+ (void)registerViaEmail:(NSString *)email password:(NSString *)password completion: (DTAAPISuccessErrorCompletionBlock)completion {
    
    DTAAPISuccessErrorCompletionBlock completionCopy = [completion copy];
    
    NSString *deviceToken = ((AppDelegate *)[UIApplication sharedApplication].delegate).deviceToken;
    
    //deviceToken = @"1234567890";
    
    NSURLRequest *request = [[DTAObjectManager sharedManager] requestWithObject: nil method: RKRequestMethodPOST path:DTAAPIRegisterViaEmailEndpoint parameters:@{@"email": email, @"password": password, @"deviceToken": deviceToken}];

    RKManagedObjectRequestOperation *operation = [[DTAObjectManager sharedManager] managedObjectRequestOperationWithRequest:request managedObjectContext:[[[DTAObjectManager sharedManager] managedObjectStore] newChildManagedObjectContextWithConcurrencyType:NSPrivateQueueConcurrencyType tracksChanges:NO] success:^(RKObjectRequestOperation *rkObjectRequestOperation, RKMappingResult *mappingResult) {
        
        [self handleResult:mappingResult withCompletion:completionCopy];
    } failure:^(RKObjectRequestOperation *rkObjectRequestOperation, NSError *error) {
        
        [self handleError:error withCompletion:completionCopy];
    }];
    
    [[DTAObjectManager sharedManager] enqueueObjectRequestOperation:operation];
}
//+ (void)registerViaAppleToken:(NSString *)appleToken completion:(DTAAPISuccessErrorCompletionBlock)completion {
+ (void)registerViaAppleToken:(NSMutableDictionary *)appleDict completion:(DTAAPISuccessErrorCompletionBlock)completion {
    
    DTAAPISuccessErrorCompletionBlock completionCopy = [completion copy];
    
    NSString *deviceToken = ((AppDelegate *)[UIApplication sharedApplication].delegate).deviceToken;
    appleDict[@"deviceToken"] = deviceToken;
    
    //deviceToken = @"1234567890";
  
    NSURLRequest *request = [[DTAObjectManager sharedManager] requestWithObject:nil method:RKRequestMethodPOST path:DTAAPIRegisterViaAppleEndpoint parameters:appleDict];
    
//    NSURLRequest *request = [[DTAObjectManager sharedManager] requestWithObject:nil method:RKRequestMethodPOST path:DTAAPIRegisterViaAppleEndpoint parameters:@{@"appleId":appleToken, @"deviceToken":deviceToken, @"email": @""}];

    RKManagedObjectRequestOperation *operation = [[DTAObjectManager sharedManager] managedObjectRequestOperationWithRequest:request managedObjectContext:[[[DTAObjectManager sharedManager] managedObjectStore] newChildManagedObjectContextWithConcurrencyType:NSPrivateQueueConcurrencyType tracksChanges:NO] success:^(RKObjectRequestOperation *rkObjectRequestOperation, RKMappingResult *mappingResult) {
        [self handleResult:mappingResult withCompletion:completionCopy];
    
    } failure:^(RKObjectRequestOperation *rkObjectRequestOperation, NSError *error) {
        [self handleError:error withCompletion:completionCopy];
    }];
    
    [[DTAObjectManager sharedManager] enqueueObjectRequestOperation:operation];
}

+ (void)registerViaFacebookToken:(NSString *)facebookToken completion:(DTAAPISuccessErrorCompletionBlock)completion {
    
    DTAAPISuccessErrorCompletionBlock completionCopy = [completion copy];
    
    NSString *deviceToken = ((AppDelegate *)[UIApplication sharedApplication].delegate).deviceToken;
    
    //deviceToken = @"1234567890";
    
    NSURLRequest *request = [[DTAObjectManager sharedManager] requestWithObject:nil method:RKRequestMethodPOST path:DTAAPIRegisterViaFacebookEndpoint parameters:@{@"facebookToken":facebookToken, @"deviceToken":deviceToken, @"email": @""}];

    RKManagedObjectRequestOperation *operation = [[DTAObjectManager sharedManager] managedObjectRequestOperationWithRequest:request managedObjectContext:[[[DTAObjectManager sharedManager] managedObjectStore] newChildManagedObjectContextWithConcurrencyType:NSPrivateQueueConcurrencyType tracksChanges:NO] success:^(RKObjectRequestOperation *rkObjectRequestOperation, RKMappingResult *mappingResult) {
        [self handleResult:mappingResult withCompletion:completionCopy];
    
    } failure:^(RKObjectRequestOperation *rkObjectRequestOperation, NSError *error) {
        [self handleError:error withCompletion:completionCopy];
    }];
    
    [[DTAObjectManager sharedManager] enqueueObjectRequestOperation:operation];
}

+ (void)registerViaInstagramToken:(NSString *)instagramToken andInstagramId:(NSString *)instagramId completion:(DTAAPISuccessErrorCompletionBlock)completion {
    
    DTAAPISuccessErrorCompletionBlock completionCopy = [completion copy];
    
    NSString *deviceToken = ((AppDelegate *)[UIApplication sharedApplication].delegate).deviceToken;
    
    //deviceToken = @"1234567890";
    
    NSURLRequest *request = [[DTAObjectManager sharedManager] requestWithObject:nil method:RKRequestMethodPOST path:DTAAPIRegisterViaInstagramEndpoint parameters:@{@"instagramToken": instagramToken, @"instagramId": instagramId, @"email": @"", @"deviceToken":deviceToken}];
    
    RKManagedObjectRequestOperation *operation = [[DTAObjectManager sharedManager] managedObjectRequestOperationWithRequest:request managedObjectContext:[[[DTAObjectManager sharedManager] managedObjectStore] newChildManagedObjectContextWithConcurrencyType:NSPrivateQueueConcurrencyType tracksChanges:NO] success:^(RKObjectRequestOperation *rkObjectRequestOperation, RKMappingResult *mappingResult) {
        
        [self handleResult:mappingResult withCompletion:completionCopy];
    } failure:^(RKObjectRequestOperation *rkObjectRequestOperation, NSError *error) {
        [self handleError:error withCompletion:completionCopy];
    }];
    
    [[DTAObjectManager sharedManager] enqueueObjectRequestOperation:operation];
}

+ (void)loginViaEmail:(NSString *)email password:(NSString *)password completion:(DTAAPICompletionBlock)completion {
    
    DTAAPICompletionBlock completionCopy = [completion copy];
    
    NSString *deviceToken = ((AppDelegate *)[UIApplication sharedApplication].delegate).deviceToken;
    
    NSURLRequest *request = [[DTAObjectManager sharedManager] requestWithObject:nil method:RKRequestMethodPOST path:DTAAPILoginViaEmailEndpoint parameters:@{@"email":email, @"password":password, @"deviceToken":deviceToken}];

    RKManagedObjectRequestOperation *operation = [[DTAObjectManager sharedManager] managedObjectRequestOperationWithRequest:request managedObjectContext:[[[DTAObjectManager sharedManager] managedObjectStore] newChildManagedObjectContextWithConcurrencyType:NSPrivateQueueConcurrencyType tracksChanges:NO] success:^(RKObjectRequestOperation *rkObjectRequestOperation, RKMappingResult *mappingResult) {
        
//        [self handleResult:mappingResult withCompletion:completionCopy];
        
        if (completionCopy) {
            completionCopy(nil, mappingResult);
        }
        
    } failure:^(RKObjectRequestOperation *rkObjectRequestOperation, NSError *error) {
//        [self handleError:error withCompletion:completionCopy];
        completionCopy(error, nil);

    }];
    
    [[DTAObjectManager sharedManager] enqueueObjectRequestOperation:operation];
}

+ (void)loginViaApple:(NSMutableDictionary *)appleDict completion:(DTAAPISuccessErrorResultCompletionBlock)completion {
    
    DTAAPISuccessErrorResultCompletionBlock completionCopy = [completion copy];
    
    NSString *deviceToken = ((AppDelegate *)[UIApplication sharedApplication].delegate).deviceToken;
    appleDict[@"deviceToken"] = deviceToken;
    //deviceToken = @"1234567890";
    
    NSURLRequest *request = [[DTAObjectManager sharedManager] requestWithObject:nil method:RKRequestMethodPOST path:DTAAPILoginViaAppleEndpoint parameters:appleDict];
 
    RKManagedObjectRequestOperation *operation = [[DTAObjectManager sharedManager] managedObjectRequestOperationWithRequest:request managedObjectContext:[[[DTAObjectManager sharedManager] managedObjectStore] newChildManagedObjectContextWithConcurrencyType:NSPrivateQueueConcurrencyType tracksChanges:NO] success:^(RKObjectRequestOperation *rkObjectRequestOperation, RKMappingResult *mappingResult) {
        [self handleResult:mappingResult withCompletionReturningResult:completionCopy];
    } failure:^(RKObjectRequestOperation *rkObjectRequestOperation, NSError *error) {
        [self handleError:error withCompletionReturningResult:completionCopy];
    }];
    
    [[DTAObjectManager sharedManager] enqueueObjectRequestOperation:operation];
}

+ (void)loginViaFacebookToken:(NSString *)facebookToken completion:(DTAAPISuccessErrorResultCompletionBlock)completion {
    
    DTAAPISuccessErrorResultCompletionBlock completionCopy = [completion copy];
    
    NSString *deviceToken = ((AppDelegate *)[UIApplication sharedApplication].delegate).deviceToken;
 
    //deviceToken = @"1234567890";
    
    NSURLRequest *request = [[DTAObjectManager sharedManager] requestWithObject:nil method:RKRequestMethodPOST path:DTAAPILoginViaFacebookEndpoint parameters:@{@"facebookToken": facebookToken, @"deviceToken": deviceToken}];
 
    RKManagedObjectRequestOperation *operation = [[DTAObjectManager sharedManager] managedObjectRequestOperationWithRequest:request managedObjectContext:[[[DTAObjectManager sharedManager] managedObjectStore] newChildManagedObjectContextWithConcurrencyType:NSPrivateQueueConcurrencyType tracksChanges:NO] success:^(RKObjectRequestOperation *rkObjectRequestOperation, RKMappingResult *mappingResult) {
        [self handleResult:mappingResult withCompletionReturningResult:completionCopy];
    } failure:^(RKObjectRequestOperation *rkObjectRequestOperation, NSError *error) {
        [self handleError:error withCompletionReturningResult:completionCopy];
    }];
    
    [[DTAObjectManager sharedManager] enqueueObjectRequestOperation:operation];
}

+ (void)loginViaInstagramToken:(NSString *)instagramToken completion:(DTAAPISuccessErrorResultCompletionBlock)completion {
    
    DTAAPISuccessErrorResultCompletionBlock completionCopy = [completion copy];
    
    NSString *deviceToken = ((AppDelegate *)[UIApplication sharedApplication].delegate).deviceToken;
    
    //deviceToken = @"1234567890";
    
    NSURLRequest *request = [[DTAObjectManager sharedManager] requestWithObject:nil method:RKRequestMethodPOST path:DTAAPILoginViaInstagramEndpoint parameters:@{@"instagramToken": instagramToken, @"deviceToken": deviceToken}];
    
    AFRKJSONRequestOperation *operation = [AFRKJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {

        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:JSON options:NSJSONWritingPrettyPrinted error:nil];
        
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"response = %@", response);
        
        NSMutableArray *users = [[NSMutableArray alloc] init];
        users = jsonResponse[@"user"];
        
        if (completionCopy) {
            completionCopy(nil, users);
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self handleErrorAFNetworking:error withCompletionReturningResult:completionCopy];
    }];
    
    [operation start];
}

+ (void)logoutWithCompletion: (DTAAPISuccessErrorCompletionBlock)completion {
    DTAAPISuccessErrorCompletionBlock completionCopy = [completion copy];
    
    NSLog(@"logout url = %@", DTAAPILogoutEndpoint);
    
    NSURLRequest *request = [[DTAObjectManager sharedManager] requestWithObject:nil method:RKRequestMethodPOST path:DTAAPILogoutEndpoint parameters:nil];
    
    AFRKJSONRequestOperation *operation = [AFRKJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//        [[NSUserDefaults standardUserDefaults]setObject:0 forKey:@"matchCount"];
//        [[NSUserDefaults standardUserDefaults] setObject:0 forKey:@"isSubsribed"];
//        [[NSUserDefaults standardUserDefaults]synchronize];
        
         [self handleResult:nil withCompletion:completionCopy];
    
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
         [self handleErrorAFNetworking:error withCompletion:completionCopy];
    }];
    
    [operation start];
}

+ (void)blockMatchedUserWithUserId:(NSString *)userId andBlockedByUserId:(NSString *)blockedByUserId completion:(DTAAPISuccessErrorCompletionBlock)completion {
    
    DTAAPISuccessErrorCompletionBlock completionCopy = [completion copy];
    
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    NSURLRequest *request = [[DTAObjectManager sharedManager] requestWithObject: nil method: RKRequestMethodPOST path: DTAAPIBlockUserEndpoint parameters: @{@"user_id": userId, @"blocked_by": blockedByUserId}];
    
    RKManagedObjectRequestOperation *operation = [[DTAObjectManager sharedManager] managedObjectRequestOperationWithRequest: request managedObjectContext: [[[DTAObjectManager sharedManager] managedObjectStore] newChildManagedObjectContextWithConcurrencyType: NSPrivateQueueConcurrencyType tracksChanges: NO] success: ^(RKObjectRequestOperation *rkObjectRequestOperation, RKMappingResult *mappingResult) {
     
        [self handleResult:mappingResult withCompletion:completionCopy];
    } failure:^(RKObjectRequestOperation *rkObjectRequestOperation, NSError *error) {
        
        [self handleError:error withCompletion:completionCopy];
    }];
    
    [[DTAObjectManager sharedManager] enqueueObjectRequestOperation:operation];
}

+ (void)refreshExpiredAccessTokenWithCompletionBlock: (DTAAPISuccessErrorCompletionBlock)completion {
    
    DTAAPISuccessErrorCompletionBlock completionCopy = [completion copy];

    NSURLRequest *request = [[DTAObjectManager sharedManager] requestWithObject:nil method:RKRequestMethodPOST path:DTAAPIRefreshAccessTokenEndpoint parameters:@{@"refreshToken":[User currentUser].refreshToken}];

    RKManagedObjectRequestOperation *operation = [[DTAObjectManager sharedManager] managedObjectRequestOperationWithRequest:request managedObjectContext:[[[DTAObjectManager sharedManager] managedObjectStore] newChildManagedObjectContextWithConcurrencyType:NSPrivateQueueConcurrencyType tracksChanges:NO] success:^(RKObjectRequestOperation *rkObjectRequestOperation, RKMappingResult *mappingResult) {
        
        [self handleResult:mappingResult withCompletion:completionCopy];
    
    } failure:^(RKObjectRequestOperation *rkObjectRequestOperation, NSError *error) {
        [self handleError:error withCompletion:completionCopy];
    }];
    
    [[DTAObjectManager sharedManager] enqueueObjectRequestOperation:operation];
}

#pragma mark -  Static resources

+ (void)fetchStaticResourceWithKey:(DTAAPIStaticResourcesType)type completion:(DTAAPISuccessErrorResultCompletionBlock)completion {
    
    DTAAPISuccessErrorResultCompletionBlock completionCopy = [completion copy];
    
    NSString *resourceType = nil;
    
    switch (type) {
    
        case DTAAPIStaticResourcesTypeCountries:
            resourceType = @"countries";
            break;
        
        case DTAAPIStaticResourcesTypeEducations:
            resourceType = @"educations";
            break;
        
        case DTAAPIStaticResourcesTypeEthnics:
            resourceType = @"ethnics";
            break;
        
        case DTAAPIStaticResourcesTypeProfessions:
            resourceType = @"professions";
            break;
        
        case DTAAPIStaticResourcesTypeRelationships:
            resourceType = @"relationships";
            break;
        
        case DTAAPIStaticResourcesTypeReligions:
            resourceType = @"religions";
            break;
            
        case DTAAPIStaticResourcesTypeGoals:
            resourceType = @"relationshipgoals";
            break;
            
            case DTAAPIStaticResourcesTypeWantKids:
            resourceType = @"wantkids";
            break;
            
            case DTAAPIStaticResourcesTypeHaveKids:
            resourceType = @"havekids";
            break;
            
            case DTAAPIStaticResourcesTypeOrientation:
            resourceType = @"orientations";
            break;
        
        default:
            break;
    }
    
    NSString *teampRequestPath = [[NSString alloc] initWithString:DTAAPIStaticResourcesEndpoint];
    
    NSString *requestPath = [teampRequestPath stringByReplacingOccurrencesOfString: @"{resource}" withString: resourceType];
    
    NSLog(@"requestPath ----------> %@", requestPath);
    
    NSURLRequest *request = [[DTAObjectManager sharedManager] requestWithObject:nil method:RKRequestMethodGET path:requestPath parameters:nil];
    
    AFRKJSONRequestOperation *operation = [AFRKJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
    
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:JSON options:NSJSONWritingPrettyPrinted error:nil];
        
        NSArray *jsonResponse = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"response = %@", response);
        
        if (completionCopy) {
            completionCopy(nil, jsonResponse);
        }
    
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self handleErrorAFNetworking:error withCompletionReturningResult:completionCopy];
    }];
    
    [operation start];
}

+ (void)fetchCityNamesForQuery: (NSString *)query completion: (DTAAPISuccessErrorResultCompletionBlock)completion {
    
    GMSPlacesClient *googlePlacesClient = [[GMSPlacesClient alloc] init];
    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
    filter.type = kGMSPlacesAutocompleteTypeFilterCity;

    NSMutableArray *citiesList = [[NSMutableArray alloc] init];
    
    [googlePlacesClient autocompleteQuery:query bounds:nil filter:filter callback:^(NSArray *results, NSError *error) {
        
        if (error != nil) {
            NSLog(@"Autocomplete error %@", [error localizedDescription]);
            completion(error, nil);
            return;
        }

        for (GMSAutocompletePrediction *result in results) {
            NSLog(@"Result : ---- %@",result);
            NSLog(@"Resulsts : ---- %@",results);
            NSLog(@"Result '%@' with placeID %@", result.attributedFullText.string, result.placeID);
                    
            
            NSDictionary *dict = @{@"placeId":result.placeID, @"city":result.attributedFullText.string};
            [citiesList addObject:dict];
        }
        
        completion(nil, citiesList);
        return;
    }];
}

+ (void)fetchCityCoordsByPlaceId:(NSString *)placeId completion:(DTAAPISuccessErrorResultCompletionBlock)completion; {
    
    DTAAPISuccessErrorResultCompletionBlock completionCopy = [completion copy];
    
    GMSPlacesClient *googlePlacesClient = [[GMSPlacesClient alloc] init];
   
    [googlePlacesClient lookUpPlaceID:placeId callback:^(GMSPlace *result, NSError *error) {
        CLLocationCoordinate2D coords = [result coordinate];
        NSNumber *latitude = @(coords.latitude);
        NSNumber *longitude = @(coords.longitude);
        
        completionCopy(error, @[latitude,longitude]);
    }];
}

#pragma mark - Profile

+ (void)profileFetchForUserId:(NSString *)userId completion:(DTAAPISuccessErrorCompletionBlock)completion {
    
    DTAAPISuccessErrorCompletionBlock completionCopy = [completion copy];
    
    if (!userId) {
        userId = @"";
    }

    NSString *apiPath = [NSString stringWithFormat:@"%@/%@",DTAAPIEditUserProfileEndpoint,userId];
    
    NSURLRequest *request = [[DTAObjectManager sharedManager] requestWithObject:nil method:RKRequestMethodGET path:apiPath parameters:nil];
    
    RKManagedObjectRequestOperation *operation = [[DTAObjectManager sharedManager] managedObjectRequestOperationWithRequest:request managedObjectContext:[[[DTAObjectManager sharedManager] managedObjectStore] newChildManagedObjectContextWithConcurrencyType:NSPrivateQueueConcurrencyType tracksChanges:NO] success:^(RKObjectRequestOperation *rkObjectRequestOperation, RKMappingResult *mappingResult) {
         [self handleResult:mappingResult withCompletion:completionCopy];
    
     } failure:^(RKObjectRequestOperation *rkObjectRequestOperation, NSError *error) {
         [self handleError:error withCompletion:completionCopy];
     }];
    
    [[DTAObjectManager sharedManager] enqueueObjectRequestOperation:operation];
}



+ (void)profileUpdateWithParameters:(NSDictionary *)parameters avatar:(UIImage *)image completionBlock:(DTAAPISuccessErrorCompletionBlock)completion {
    
    DTAAPISuccessErrorCompletionBlock completionCopy = [completion copy];

    NSMutableURLRequest *request = [[DTAObjectManager sharedManager] requestWithObject:nil method:RKRequestMethodPOST path:DTAAPIEditUserProfileEndpoint parameters:parameters];

    RKManagedObjectRequestOperation *operation = [[DTAObjectManager sharedManager] managedObjectRequestOperationWithRequest:request managedObjectContext:[[[DTAObjectManager sharedManager] managedObjectStore] newChildManagedObjectContextWithConcurrencyType:NSPrivateQueueConcurrencyType tracksChanges:NO] success:^(RKObjectRequestOperation *rkObjectRequestOperation, RKMappingResult *mappingResult) {
        
        if (image) {
            [DTAAPI uploadProfileImage:image WithCompletion:^(NSError *error, id result) {
                if (!error) {
                    NSString *avatarId = result[@"id"];
                    [DTAAPI setAvatarProfileImageId:avatarId WithCompletion:^(NSError *error) {
                        if (!error) {
                            [self handleResult:mappingResult withCompletion:completionCopy];
                        }
                        else {
                            [self handleError:error withCompletion:completionCopy];
                        }
                    }];
                }
                else {
                    [self handleError:error withCompletion:completionCopy];
                }
            }];
        }
        else {
            [self handleResult:mappingResult withCompletion:completionCopy];
        }
    
    } failure:^(RKObjectRequestOperation *rkObjectRequestOperation, NSError *error) {
        [self handleError:error withCompletion:completionCopy];
    }];
    
    [[DTAObjectManager sharedManager] enqueueObjectRequestOperation:operation];
}


+ (void)profileUpdateLocationWithLocation:(CLLocation *)location {
    
    CLGeocoder *ceo = [[CLGeocoder alloc] init];
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    
    [ceo reverseGeocodeLocation: loc completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (error == nil) {
            
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSLog(@"placemark %@",placemark);
            
            //String to hold address
            //NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
            
            NSLog(@"placemark region = %@", placemark.region);
            NSLog(@"placemark country = %@", placemark.country);  // Give Country Name
            NSLog(@"placemark locality = %@", placemark.locality); // Extract the city name
            NSLog(@"placemark administrative area = %@", placemark.administrativeArea); // state, eg. CA
            NSLog(@"placemark name = %@", placemark.name);
            NSLog(@"placemark ocean = %@", placemark.ocean);
            NSLog(@"placemark postalCode = %@", placemark.postalCode);
            NSLog(@"placemark subLocality = %@", placemark.subLocality);
            
            NSLog(@"placemark location = %@", placemark.location);
            //Print the location to console
            //NSLog(@"I am currently at = %@", locatedAt);
            
//            NSString *str1 = [NSString stringWithFormat:@"%@, %@, %@", placemark.country,placemark.locality]; //DEV
            
            //DEV state (administrativeArea) added by me
            
            NSString *str1 = [NSString stringWithFormat:@"%@, %@, %@", placemark.locality, placemark.administrativeArea,placemark.country];
            
            if ([placemark.country isEqualToString:@"United States"]) {
                str1 = [NSString stringWithFormat:@"%@, %@, %@", placemark.locality, placemark.administrativeArea,@"USA"];
            }
            if ([placemark.country isEqualToString:@"United Kingdom"]) {
                str1 = [NSString stringWithFormat:@"%@, %@, %@", placemark.locality, placemark.administrativeArea,@"UK"];
            }
            
            
            
            NSLog(@"location.coordinate.latitude = %f", location.coordinate.latitude);
            NSLog(@"location.coordinate.longitude = %f", location.coordinate.longitude);
            
            NSURLRequest *request = [[DTAObjectManager sharedManager] requestWithObject:nil method:RKRequestMethodPUT path:DTAAPIUpdateUserLocationEndpoint parameters:@{@"lat": [NSString stringWithFormat:@"%f", location.coordinate.latitude], @"lng": [NSString stringWithFormat:@"%f", location.coordinate.longitude], @"title": str1}];
            
            AFRKJSONRequestOperation *operation = [AFRKJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:JSON options:NSJSONWritingPrettyPrinted error:nil];
                
                NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
//                NSLog(@"profileUpdateLocationWithLocation response = %@", jsonResponse);
                
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                
            }];
            [operation start];
        }
        else {
            NSLog(@"error = %@", [error localizedDescription]);
            
            NSLog(@"location.coordinate.latitude = %f", location.coordinate.latitude);
            NSLog(@"location.coordinate.longitude = %f", location.coordinate.longitude);
            
            NSURLRequest *request = [[DTAObjectManager sharedManager] requestWithObject:nil method:RKRequestMethodPUT path:DTAAPIUpdateUserLocationEndpoint parameters:@{@"lat": [NSString stringWithFormat:@"%f", location.coordinate.latitude], @"lng": [NSString stringWithFormat:@"%f", location.coordinate.longitude], @"title": @""}];
            
            AFRKJSONRequestOperation *operation = [AFRKJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:JSON options:NSJSONWritingPrettyPrinted error:nil];
                
                NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
                NSLog(@"profileUpdateLocationWithLocation response = %@", jsonResponse);
                
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                
            }];
            [operation start];
        }
    }];
}

+ (void)getBlockedUserListData: (DTAAPISuccessErrorResultCompletionBlock)completion {
    
    DTAAPISuccessErrorResultCompletionBlock completionCopy = [completion copy];
    
    NSURLRequest *request = [[DTAObjectManager sharedManager] requestWithObject:nil method:RKRequestMethodPOST path:DTAAPIBlockedUsersListEndPoint parameters:@{@"user_id": [User currentUser].userId}];
    
    AFRKJSONRequestOperation *operation = [AFRKJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
    
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:JSON options:NSJSONWritingPrettyPrinted error:nil];
        
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"getBlockedUserListData response = %@", jsonResponse);
        
        NSMutableArray *users = [[NSMutableArray alloc] init];
        users = jsonResponse[@"users"];
        
        completionCopy(nil, users);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self handleErrorAFNetworking:error withCompletionReturningResult:completionCopy];
    }];
    
    [operation start];
}

+ (void)unblockUserFromAPI:(NSString *)userId  completion:(DTAAPISuccessErrorCompletionBlock)completion {
    
    DTAAPISuccessErrorCompletionBlock completionCopy = [completion copy];
    
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    NSURLRequest *request = [[DTAObjectManager sharedManager] requestWithObject: nil method: RKRequestMethodPOST path: DTAAPIUnBlockUserEndpoint parameters: @{@"user_id": userId, @"blocked_by": [User currentUser].userId}];
    
    RKManagedObjectRequestOperation *operation = [[DTAObjectManager sharedManager] managedObjectRequestOperationWithRequest: request managedObjectContext: [[[DTAObjectManager sharedManager] managedObjectStore] newChildManagedObjectContextWithConcurrencyType: NSPrivateQueueConcurrencyType tracksChanges: NO] success: ^(RKObjectRequestOperation *rkObjectRequestOperation, RKMappingResult *mappingResult) {
        
        [self handleResult:mappingResult withCompletion:completionCopy];
    } failure:^(RKObjectRequestOperation *rkObjectRequestOperation, NSError *error) {
        
        [self handleError:error withCompletion:completionCopy];
    }];
    
    [[DTAObjectManager sharedManager] enqueueObjectRequestOperation:operation];
}

+ (void)profileDeleteWithCompletion: (DTAAPISuccessErrorCompletionBlock)completion {
    
    DTAAPISuccessErrorCompletionBlock completionCopy = [completion copy];
    
    NSURLRequest *request = [[DTAObjectManager sharedManager] requestWithObject:nil method:RKRequestMethodDELETE path:DTAAPIEditUserProfileEndpoint parameters:nil];
    
    AFRKJSONRequestOperation *operation = [AFRKJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {

        [self handleResult:nil withCompletion:completionCopy];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self handleErrorAFNetworking:error withCompletion:completionCopy];
    }];
    
    [operation start];
}

+ (void)loadProfileImagesWithCompletion: (DTAAPISuccessErrorCompletionBlock)completion {
    
    DTAAPISuccessErrorCompletionBlock completionCopy = [completion copy];
    
    NSURLRequest *request = [[DTAObjectManager sharedManager] requestWithObject:nil method:RKRequestMethodGET path:DTAAPILoadUserImagesEndpoint parameters:nil];
    
    RKManagedObjectRequestOperation *operation = [[DTAObjectManager sharedManager] managedObjectRequestOperationWithRequest:request managedObjectContext:[[[DTAObjectManager sharedManager] managedObjectStore] newChildManagedObjectContextWithConcurrencyType:NSPrivateQueueConcurrencyType tracksChanges:NO] success:^(RKObjectRequestOperation *rkObjectRequestOperation, RKMappingResult *mappingResult) {
        
        [self handleResult:mappingResult withCompletion:completionCopy];
         
     } failure:^(RKObjectRequestOperation *rkObjectRequestOperation, NSError *error) {
        [self handleError:error withCompletion:completionCopy];
     }];
    
    [[DTAObjectManager sharedManager] enqueueObjectRequestOperation:operation];
}

+ (void)deleteProfileImageForId:(NSString *)inageId WithCompletion:(DTAAPISuccessErrorCompletionBlock)completion {
    
    DTAAPISuccessErrorCompletionBlock completionCopy = [completion copy];

    NSString *path = [DTAAPILoadUserImagesEndpoint stringByAppendingPathComponent:inageId];
    
    NSURLRequest *request = [[DTAObjectManager sharedManager] requestWithObject:nil method:RKRequestMethodDELETE path:path parameters:nil];
    
    RKManagedObjectRequestOperation *operation = [[DTAObjectManager sharedManager] managedObjectRequestOperationWithRequest:request managedObjectContext:[[[DTAObjectManager sharedManager] managedObjectStore] newChildManagedObjectContextWithConcurrencyType:NSPrivateQueueConcurrencyType tracksChanges:NO] success:^(RKObjectRequestOperation *rkObjectRequestOperation, RKMappingResult *mappingResult) {
         [self handleResult:mappingResult withCompletion:completionCopy];
         
     } failure:^(RKObjectRequestOperation *rkObjectRequestOperation, NSError *error) {
         [self handleError:error withCompletion:completionCopy];
     }];
    
    [[DTAObjectManager sharedManager] enqueueObjectRequestOperation:operation];
}

+ (void)setAvatarProfileImageId:(NSString *)imageId WithCompletion:(DTAAPISuccessErrorCompletionBlock)completion {
    
    DTAAPISuccessErrorCompletionBlock completionCopy = [completion copy];
    
    NSString *path = [DTAAPILoadUserImagesEndpoint stringByAppendingPathComponent:imageId];
    
    NSURLRequest *request = [[DTAObjectManager sharedManager] requestWithObject:nil method:RKRequestMethodPUT path:path parameters:@{@"isAvatar":@1}];
    
    AFRKJSONRequestOperation *operation = [AFRKJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {

        if (completionCopy) {
            completionCopy(nil);
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (completionCopy) {
            completionCopy(error);
        }
    }];
    
    [operation start];
}

+ (void)uploadProfileImage:(UIImage *)image WithCompletion:(DTAAPICompletionBlock)completion {
    
    DTAAPICompletionBlock completionCopy = [completion copy];

    NSMutableURLRequest *request;

    NSString *imageFileName = [NSString stringWithFormat:@"img%@.png", [User currentUser].userId];
    NSLog(@"image filename = %@", imageFileName);
    
    NSLog(@"upload image url = %@", DTAAPILoadUserImagesEndpoint);

    request = [[DTAObjectManager sharedManager] multipartFormRequestWithObject:nil method:RKRequestMethodPOST path:DTAAPILoadUserImagesEndpoint parameters:nil constructingBodyWithBlock:^(id <AFRKMultipartFormData> formData) {
        [formData appendPartWithFileData: UIImagePNGRepresentation(image) name: @"avatar" fileName: imageFileName mimeType: @"image/png"];
    }];
    
    AFRKJSONRequestOperation *operation = [AFRKJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:JSON options:NSJSONWritingPrettyPrinted error:nil];
        
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"response = %@", jsonResponse);
                                             
        if (completionCopy) {
            completionCopy(nil, jsonResponse);
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        [self handleErrorAFNetworking:error withCompletionReturningResult:completionCopy];
    }];
    
    [operation start];
}

+ (void)setImagesOrder:(NSArray *)orderArray withCompletion:(DTAAPISuccessErrorResultCompletionBlock)completion {
    
    DTAAPISuccessErrorResultCompletionBlock completionCopy = [completion copy];
    
    NSDictionary *params = @{ @"ids" : orderArray };
    NSLog(@"parameters = %@", params);
    
    NSLog(@"url = %@", DTAAPIChangeImagesOrderEndpoint);
    
    NSURLRequest *request = [[DTAObjectManager sharedManager] requestWithObject:nil method:RKRequestMethodPUT path:DTAAPIChangeImagesOrderEndpoint parameters:params];
    
    AFRKJSONRequestOperation *operation = [AFRKJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            
            int i = 1;
                                                  
            for (NSString *imageId in orderArray) {
                Image *image = [Image MR_findFirstByAttribute:@"imageId" withValue:imageId];
                image.index = @(i);
                                                     
                ++i;
            }
            
        } completion:^(BOOL success, NSError *error) {
            if (completionCopy) {
                completionCopy(nil, nil);
            }
        }];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self handleErrorAFNetworking:error withCompletionReturningResult:completionCopy];
    }];
    
    [operation start];
}

+ (void)badgeUpdateWithPushType:(DTAPushType)pushType сompletion:(DTAAPISuccessErrorCompletionBlock)completion {
    
    DTAAPISuccessErrorCompletionBlock completionCopy = [completion copy];
    
    NSString *key;
    
    switch (pushType) {
        case DTAPushNewMessages:
            key = @"messagesBadge";
            break;
    
        case DTAPushNewMatchs:
            key = @"matchesBadge";
            break;
        
        case DTAPushNewLikes:
            key = @"likesBadge";
            break;
    }
    
    NSDictionary *params = @{key:@0};
    
    NSURLRequest *request = [[DTAObjectManager sharedManager] requestWithObject:nil method:RKRequestMethodPOST path:DTAAPIUpdateBadgeEndpoint parameters:params];
    
    AFRKJSONRequestOperation *operation = [AFRKJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [self handleResult:nil withCompletion:completionCopy];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self handleErrorAFNetworking:error withCompletion:completionCopy];
    }];
    
    [operation start];
}

#pragma mark - Nearby
+ (void)loadArrayOfUsersCompletion: (DTAAPICompletionBlock)completion {
    
    DTAAPICompletionBlock completionCopy = [completion copy];
    
    NSDictionary *param = [[DTASearchOptionsManager sharedManager] nearbyParameters];
    NSLog(@"nearby param = %@", param);
    
    NSURLRequest *request = [[DTAObjectManager sharedManager] requestWithObject:nil method:RKRequestMethodGET path:DTAAPIBrowseUsersEndpoint parameters:param];
    
    AFRKJSONRequestOperation *operation = [AFRKJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"json = %@", JSON);
        
        NSMutableArray *users = [NSMutableArray new];
        
        [JSON[@"users"] enumerateObjectsUsingBlock:^(NSDictionary *userDictionary, NSUInteger idx, BOOL *stop) {
            User *tmpUser = [[User alloc]initWithDictionary:userDictionary];
            [users addObject:tmpUser];
        }];
        
        if (completionCopy) {
            completionCopy(nil, users);
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (completionCopy) {
            completionCopy(error, nil);
        }
    }];
    
    [operation start];
}

//+ (void)profileFullFetchForUserId:(NSString *)userId completion:(DTAAPISuccessErrorCompletionBlock)completion {
//
//        DTAAPISuccessErrorCompletionBlock completionCopy = [completion copy];
//
//    if (!userId) {
//        userId = @"";
//    }
//
//    NSLog(@"user id = %@", userId);
//
//    NSString *apiPath = [DTAAPIFetchUserFullProfileEndpoint stringByReplacingOccurrencesOfString:@":userId" withString:userId];
//    NSLog(@"apiPath = %@", apiPath);
//
//    NSURLRequest *request = [[DTAObjectManager sharedManager] requestWithObject:nil method:RKRequestMethodGET path:apiPath parameters:nil];
//
//    RKManagedObjectRequestOperation *operation = [[DTAObjectManager sharedManager] managedObjectRequestOperationWithRequest:request managedObjectContext:[[[DTAObjectManager sharedManager] managedObjectStore] newChildManagedObjectContextWithConcurrencyType:NSPrivateQueueConcurrencyType tracksChanges:NO] success:^(RKObjectRequestOperation *rkObjectRequestOperation, RKMappingResult *mappingResult) {
//        [self handleResult:mappingResult withCompletion:completionCopy];
//    } failure:^(RKObjectRequestOperation *rkObjectRequestOperation, NSError *error) {
//        [self handleError:error withCompletion:completionCopy];
//    }];
//
//    [[DTAObjectManager sharedManager] enqueueObjectRequestOperation:operation];
//}

+ (void)getUserSubscriptonStaus:(NSString *)userId completion:(DTAAPISuccessErrorResultCompletionBlock)completion {
    
    DTAAPISuccessErrorResultCompletionBlock completionCopy = [completion copy];
    
    if (!userId) {
        userId = @"";
    }
    
    NSLog(@"user id = %@", userId);
    
    NSString *apiPath = [DTAAPIFetchUserSubscriptionStatusEndpoint stringByReplacingOccurrencesOfString:@":id" withString:userId];
    
    NSURLRequest *request = [[DTAObjectManager sharedManager] requestWithObject:nil method:RKRequestMethodGET path:apiPath parameters:nil];
    
    NSLog(@"user status apiPath = %@", request);
    
    
    AFRKJSONRequestOperation *operation = [AFRKJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:JSON options:NSJSONWritingPrettyPrinted error:nil];
        
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"get user subscription response = %@", jsonResponse);
        [[NSUserDefaults standardUserDefaults] setObject:[[[jsonResponse objectForKey:@"users"]objectAtIndex:0]objectForKey:@"matchedCount"] forKey:@"matchCount"];
        [[NSUserDefaults standardUserDefaults] setObject:[[[jsonResponse objectForKey:@"users"]objectAtIndex:0]objectForKey:@"subscribed"] forKey:@"isSubsribed"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
//        NSMutableArray *dataArr = [[NSMutableArray alloc] init];
//        [dataArr addObject:jsonResponse];
        
        completionCopy(nil, nil);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self handleErrorAFNetworking:error withCompletionReturningResult:completionCopy];
    }];
    
    [operation start];
}

+ (void)profileFullFetchForUserId:(NSString *)userId completion:(DTAAPISuccessErrorResultCompletionBlock)completion {
    
    DTAAPISuccessErrorResultCompletionBlock completionCopy = [completion copy];
    
    if (!userId) {
        userId = @"";
    }
    
    NSLog(@"user id = %@", userId);
    
    NSString *apiPath = [DTAAPIFetchUserFullProfileEndpoint stringByReplacingOccurrencesOfString:@":userId" withString:userId];
    
    NSURLRequest *request = [[DTAObjectManager sharedManager] requestWithObject:nil method:RKRequestMethodGET path:apiPath parameters:nil];
    
    NSLog(@"apiPath = %@", request);
    
    
    AFRKJSONRequestOperation *operation = [AFRKJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:JSON options:NSJSONWritingPrettyPrinted error:nil];
        
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"full profile response = %@", jsonResponse);
        
        NSMutableArray *users = [NSMutableArray new];
        
        [JSON[@"users"] enumerateObjectsUsingBlock:^(NSDictionary *userDictionary, NSUInteger idx, BOOL *stop) {
            User *tmpUser = [[User alloc] initWithDictionary:userDictionary];
            [users addObject:tmpUser];
        }];
        
        NSMutableArray *dataArr = [[NSMutableArray alloc] init];
        [dataArr addObject:jsonResponse];
        
        completionCopy(nil, dataArr);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self handleErrorAFNetworking:error withCompletionReturningResult:completionCopy];
    }];
    
    [operation start];
}

#pragma mark - Browse
+ (void)fetchBrowsingUsersWithParameters:(NSDictionary *)parameters completion:(DTAAPISuccessErrorResultCompletionBlock)completion {
    
    DTAAPISuccessErrorResultCompletionBlock completionCopy = [completion copy];

    NSLog(@"browse api url = %@", DTAAPIBrowseUsersEndpoint);
    
    NSURLRequest *request = [[DTAObjectManager sharedManager] requestWithObject:nil method:RKRequestMethodGET path:DTAAPIBrowseUsersEndpoint parameters:parameters];
    
    AFRKJSONRequestOperation *operation = [AFRKJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
    
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:JSON options:NSJSONWritingPrettyPrinted error:nil];
                                             
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
//        NSLog(@"browse response = %@", jsonResponse);
        
        NSMutableArray *users = [[NSMutableArray alloc] init];
        
        [jsonResponse[@"users"] enumerateObjectsUsingBlock:^(NSDictionary *userDictionary, NSUInteger idx, BOOL *stop) {
            
            User *tmpUser = [[User alloc] initWithDictionary:userDictionary];
            [users addObject:tmpUser];
        }];
                                             
        completionCopy(nil, users);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self handleErrorAFNetworking:error withCompletionReturningResult:completionCopy];
    }];
    
    [operation start];
}

#pragma mark - Match
+ (void)matchUser:(User *)user completion:(DTAAPISuccessErrorResultCompletionBlock)completion {
    
    DTAAPISuccessErrorResultCompletionBlock completionCopy = [completion copy];
    
    NSURLRequest *request = [[DTAObjectManager sharedManager] requestWithPathForRouteNamed:kDTAAPIMatchUserRoute object:user parameters:nil];
    
    AFRKJSONRequestOperation *operation = [AFRKJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:JSON options:NSJSONWritingPrettyPrinted error:nil];
        
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"Like response = %@", jsonResponse);
        
        NSMutableArray *dataArr = [[NSMutableArray alloc] init];
        [dataArr addObject:[jsonResponse objectForKey:@"matchedCount"]];
        
        if (completionCopy) {
            completionCopy(nil, dataArr);
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self handleErrorAFNetworking:error withCompletionReturningResult:completionCopy];
    }];
    
    [operation start];
}

+ (void)deleteMatchForUser:(User *)user completion:(DTAAPISuccessErrorResultCompletionBlock)completion {
    
    DTAAPISuccessErrorResultCompletionBlock completionCopy = [completion copy];
    
    NSURLRequest *request = [[DTAObjectManager sharedManager] requestWithPathForRouteNamed:kDTAAPIDeleteMatchUserRoute object:user parameters:nil];
    
    AFRKJSONRequestOperation *operation = [AFRKJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:JSON options:NSJSONWritingPrettyPrinted error:nil];
        
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"dislike response = %@", jsonResponse);
        
        NSMutableArray *dataArr = [[NSMutableArray alloc] init];
        [dataArr addObject:[jsonResponse objectForKey:@"matchedCount"]];
        
        if (completionCopy) {
            completionCopy(nil, dataArr);
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self handleErrorAFNetworking:error withCompletionReturningResult:completionCopy];
    }];
    
    [operation start];
}

+ (void)fetchMatchedUsersOnPage:(DTAProspectsPage *)page completion:(DTAAPISuccessErrorResultCompletionBlock)completion {
    
    DTAAPISuccessErrorResultCompletionBlock completionCopy = [completion copy];
    
    NSURLRequest *request = [[DTAObjectManager sharedManager] requestWithPathForRouteNamed:kDTAAPIFetchMatchedUsersRoute object:page parameters:nil];

    AFRKJSONRequestOperation *operation = [AFRKJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
    
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:JSON options:NSJSONWritingPrettyPrinted error:nil];
                                             
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"jsonResponse matched users = %@", jsonResponse);
        
        NSMutableArray *users = [[NSMutableArray alloc] init];
        
        [jsonResponse[@"users"] enumerateObjectsUsingBlock:^(NSDictionary *userDictionary, NSUInteger idx, BOOL *stop) {
            User *tmpUser = [[User alloc] initWithDictionary:userDictionary];
            [users addObject:tmpUser];
        }];
                                             
        completionCopy(nil, users);
                                             
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self handleErrorAFNetworking:error withCompletionReturningResult:completionCopy];
    }];
    
    [operation start];
}

+ (void)fetchMatchesOnPage:(DTAProspectsPage *)page completion:(DTAAPISuccessErrorResultCompletionBlock)completion {
    
    DTAAPISuccessErrorResultCompletionBlock completionCopy = [completion copy];

    NSURLRequest *request = [[DTAObjectManager sharedManager] requestWithPathForRouteNamed:kDTAAPIFetchMatchesRoute object:page parameters:nil];

    AFRKJSONRequestOperation *operation = [AFRKJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:JSON options:NSJSONWritingPrettyPrinted error:nil];

        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];

        NSMutableArray *users = [[NSMutableArray alloc] init];
        
        [jsonResponse[@"users"] enumerateObjectsUsingBlock:^(NSDictionary *userDictionary, NSUInteger idx, BOOL *stop) {
            User *tmpUser = [[User alloc]initWithDictionary:userDictionary];
            [users addObject:tmpUser];
        }];

        completionCopy(nil, users);
                                             
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self handleErrorAFNetworking:error withCompletionReturningResult:completionCopy];
    }];
    
    [operation start];
}

+ (void)removeUserFromMatchUserId:(NSString *)userId andCompletion:(DTAAPICompletionBlock)completion {
    
    DTAAPICompletionBlock completionCopy = [completion copy];
  
    NSString *deletePath = [DTAAPIRemoveUsersEndpoint stringByAppendingPathComponent:userId];
  
    NSURLRequest *request = [[DTAObjectManager sharedManager] requestWithObject:nil method:RKRequestMethodDELETE path:deletePath parameters:nil];

    AFRKJSONRequestOperation *operation = [AFRKJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
    
        if (completionCopy) {
            completionCopy(nil, nil);
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (completionCopy) {
            completionCopy(error, nil);
        }
    }];
 
    [operation start];
}

+ (void)tsetAPI {
    
    NSURLRequest *request = [[DTAObjectManager sharedManager] requestWithObject:nil method:RKRequestMethodGET path:@"/api/v1/user/matches/50/1" parameters:nil];
    
    RKManagedObjectRequestOperation *operation = [[DTAObjectManager sharedManager] managedObjectRequestOperationWithRequest:request managedObjectContext:[[[DTAObjectManager sharedManager] managedObjectStore] newChildManagedObjectContextWithConcurrencyType:NSPrivateQueueConcurrencyType tracksChanges:NO] success:^(RKObjectRequestOperation *rkObjectRequestOperation, RKMappingResult *mappingResult) {
    
        [self handleResult:mappingResult withCompletionReturningResult:nil];
         
    } failure:^(RKObjectRequestOperation *rkObjectRequestOperation, NSError *error) {
         [self handleError:error withCompletionReturningResult:nil];
    }];
    
    [[DTAObjectManager sharedManager] enqueueObjectRequestOperation:operation];
}

#pragma mark - Reports

+ (void)reportUser:(User *)user reportText:(NSString *)text attachedImage:(UIImage *)image completion:(DTAAPISuccessErrorCompletionBlock)completion; {
    
    DTAAPISuccessErrorCompletionBlock completionCopy = [completion copy];
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    if (user) {
        dict[@"reportTo"] = user.userId;
    }
    
    if (text) {
        dict[@"description"] = text;
    }
    
    NSURLRequest *request = [[DTAObjectManager sharedManager] multipartFormRequestWithObject:nil method:RKRequestMethodPOST path:DTAAPIReportsEndpoint parameters:dict constructingBodyWithBlock:^(id<AFRKMultipartFormData> formData) {
        if (image) {
            [formData appendPartWithFileData:UIImagePNGRepresentation(image) name:@"Report" fileName:@"reportAttachedImage" mimeType:@"image/png"];
        }
    }];
    
    AFRKJSONRequestOperation *operation = [AFRKJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
       
        [self handleResult:nil withCompletion:completionCopy];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self handleErrorAFNetworking:error withCompletion:completionCopy];
    }];
    
    [operation start];
}

#pragma mark - error management

+ (NSError*)errorFromErrorObject:(DTARKError *)errorObj {
    return [NSError errorWithDomain:DTAAPIErrorDomain code:[errorObj.code integerValue] userInfo:@{@"message":errorObj.message?:@""}];
}

+ (NSError*)errorFromErrorObjectAFNetworking: (NSDictionary*)errorDict {
    
    NSInteger code = errorDict[@"error"] ? [errorDict[@"error"] integerValue] : 0;
    
    if (errorDict[@"status"]) {
        code = [errorDict[@"status"] integerValue];
    }

    NSString *message;
    
    if (errorDict[@"message"]) {
        message = errorDict[@"message"];
    }
    
    return [NSError errorWithDomain:DTAAPIErrorDomain code:code userInfo:@{@"message": message ? : @""}];
}

#pragma mark - handlers

+ (void)handleErrorAFNetworking:(NSError*)error withCompletion:(DTAAPISuccessErrorCompletionBlock)completion {
    
    if (completion) {
        
        NSString *errorString = [error localizedRecoverySuggestion];
        
        if (errorString) {
            
            NSData *data = [errorString dataUsingEncoding:NSUTF8StringEncoding];
            id jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSDictionary * errorDict;
            
            if ([jsonDict isKindOfClass:[NSDictionary class]]) {
                errorDict = [NSDictionary dictionaryWithDictionary:jsonDict];
            }
            
            NSError *errorFromDict = [self errorFromErrorObjectAFNetworking:errorDict];
            
            [self showAlertIfNeededForError:errorFromDict];
            
            completion(errorFromDict);
        }
        else {
            completion(error);
        }
    }
}

+ (void)handleErrorAFNetworking:(NSError*)error withCompletionReturningResult:(DTAAPISuccessErrorResultCompletionBlock)completion {
    
    if (completion) {
        
        NSString *errorString = [error localizedRecoverySuggestion];
    
        if (errorString) {
            
            NSData *data = [errorString dataUsingEncoding:NSUTF8StringEncoding];
            id jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSDictionary * errorDict;
            
            if ([jsonDict isKindOfClass:[NSDictionary class]]) {
                errorDict = [NSDictionary dictionaryWithDictionary:jsonDict];
                NSLog(@"errordict = %@", errorDict);
            }
            
            NSError *errorFromDict = [self errorFromErrorObjectAFNetworking:errorDict];
            [self showAlertIfNeededForError:errorFromDict];
            
            completion(errorFromDict, nil);
        }
        else {
            completion(error, nil);
        }
    }
}

+ (void)handleError:(NSError*)error withCompletion:(DTAAPISuccessErrorCompletionBlock)completion {
    
    if (completion) {
        
        NSString *errorString = [error localizedRecoverySuggestion];
        
        if (!errorString) {
            errorString = [error localizedDescription];
        }
        
        if (errorString) {
            
            NSData *data = [errorString dataUsingEncoding:NSUTF8StringEncoding];
            id jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSDictionary * errorDict;
            
            if ([jsonDict isKindOfClass:[NSDictionary class]]) {
                errorDict = [NSDictionary dictionaryWithDictionary:jsonDict];
            }
            
            if (!errorDict) {
                errorDict = @{@"message":errorString};
            }
            
            NSError *errorFromDict = [self errorFromErrorObjectAFNetworking:errorDict];
            
            [self showAlertIfNeededForError:errorFromDict];
            
            completion(errorFromDict);
        }
        else {
            completion(error);
        }
    }
}

+ (void)handleError:(NSError*)error withCompletionReturningResult:(DTAAPISuccessErrorResultCompletionBlock)completion {
    
    if (completion) {
        
        NSString *errorString = [error localizedRecoverySuggestion];
    
        if (!errorString) {
            errorString = [error localizedDescription];
        }
        
        if (errorString) {
            
            NSData *data = [errorString dataUsingEncoding:NSUTF8StringEncoding];
            id jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSDictionary * errorDict;
            
            if ([jsonDict isKindOfClass:[NSDictionary class]]) {
                errorDict = [NSDictionary dictionaryWithDictionary:jsonDict];
            }
            
            if (!errorDict) {
                errorDict = @{@"message":errorString};
            }
            
            NSError *errorFromDict = [self errorFromErrorObjectAFNetworking:errorDict];
            
            [self showAlertIfNeededForError:errorFromDict];
            
            completion(errorFromDict, nil);
        }
        else {
            completion(error, nil);
        }
    }
}

+ (void)handleResult:(RKMappingResult*)result withCompletion:(DTAAPISuccessErrorCompletionBlock)completion {
   
    if (completion) {
        completion(nil);
    }
}

+ (void)handleResult:(RKMappingResult*)result withCompletionReturningResult:(DTAAPISuccessErrorResultCompletionBlock)completion {
    if (completion) {
        completion(nil, [result array]);
    }
}

+ (void)showAlertIfNeededForError:(NSError *)error {
    
    if (error.code == 666 && !APP_DELEGATE.isLogoutProcced) {
        
        APP_DELEGATE.isLogoutProcced = YES;
        APP_DELEGATE.hudLogout = [[SAMHUDView alloc] initWithTitle:@"Autorisation session expired. Please login to application"];
        [APP_DELEGATE.hudLogout show];
        
        [APP_DELEGATE logoutToStartScreen];
    }
    
    if (error.code == 401 && [error.userInfo[@"message"] isEqualToString:@"Invalid token"]) {
        
        APP_DELEGATE.hudLogout = [[SAMHUDView alloc] initWithTitle:@"Autorisation session expired. Please login to application"];
        [APP_DELEGATE.hudLogout show];
        
        [APP_DELEGATE naviagteToStartScreen];
    }
    
    if (error.code == 403 && !APP_DELEGATE.isLogoutProcced) {
        
        APP_DELEGATE.isLogoutProcced = YES;
        APP_DELEGATE.hudLogout = [[SAMHUDView alloc] initWithTitle:nil];
        [APP_DELEGATE.hudLogout show];
       
        SHOWALLERT(nil, @"You account has been blocked by admin, support email: help@goMerge.com");
        
        [APP_DELEGATE logoutToStartScreen];
    }
}

#pragma mark - Subscription
//+ (void)fetchPlanListWithParameters:(NSDictionary *)parameters completion:(DTAAPISuccessErrorResultCompletionBlock)completion {
+ (void)fetchPlanListWithParameters: (DTAAPICompletionBlock)completion {
        
    DTAAPISuccessErrorResultCompletionBlock completionCopy = [completion copy];
    
    NSLog(@"Plan list api url = %@", DTAAPIPlanListEndpoint);
    
//    int start = 0;
//    int limit = 10;
//    @{@"start": [NSNumber numberWithInt:start], @"limit": [NSNumber numberWithInt:limit] }
    NSURLRequest *request = [[DTAObjectManager sharedManager] requestWithObject:nil method:RKRequestMethodGET path:DTAAPIPlanListEndpoint parameters:nil];
    
    AFRKJSONRequestOperation *operation = [AFRKJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:JSON options:NSJSONWritingPrettyPrinted error:nil];
        
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"plan response = %@", jsonResponse);
        
//        NSMutableArray *users = [[NSMutableArray alloc] init];
//        [users addObject:[jsonResponse objectForKey:@"plans"]];
        
//        [jsonResponse[@"plans"] enumerateObjectsUsingBlock:^(NSDictionary *userDictionary, NSUInteger idx, BOOL *stop) {
//
//            User *tmpUser = [[User alloc] initWithDictionary:userDictionary];
//            [users addObject:jsonResponse[@"plans"]];
//        }];
        
        completionCopy(nil, [jsonResponse objectForKey:@"plans"]);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self handleErrorAFNetworking:error withCompletionReturningResult:completionCopy];
    }];
    
    [operation start];
}


+ (void)apiForPurchasePlan:(NSMutableDictionary *)purchaseDict completion:(DTAAPISuccessErrorResultCompletionBlock)completion {
    
    DTAAPISuccessErrorResultCompletionBlock completionCopy = [completion copy];
    
//    NSString *deviceToken = ((AppDelegate *)[UIApplication sharedApplication].delegate).deviceToken;
//    @{@"instagramToken": instagramToken, @"deviceToken": deviceToken}
    
    NSURLRequest *request = [[DTAObjectManager sharedManager] requestWithObject:nil method:RKRequestMethodPOST path:DTAAPIPurchasePlanEndpoint parameters:purchaseDict];
    
    AFRKJSONRequestOperation *operation = [AFRKJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:JSON options:NSJSONWritingPrettyPrinted error:nil];
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        
        [[NSUserDefaults standardUserDefaults]setObject:[[[jsonResponse objectForKey:@"users"]objectAtIndex:0]valueForKey:@"matchedCount"] forKey:@"matchCount"];
        [[NSUserDefaults standardUserDefaults] setObject:[[[jsonResponse objectForKey:@"users"]objectAtIndex:0]valueForKey:@"subscribed"] forKey:@"isSubsribed"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
//        NSMutableArray *users = [[NSMutableArray alloc] init];
//        [users addObject:[jsonResponse objectForKey:@"users"]];
        NSLog(@"purchase receipt response = %@", jsonResponse);
        
        
        if (completionCopy) {
            completionCopy(nil, nil);
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self handleErrorAFNetworking:error withCompletionReturningResult:completionCopy];
    }];
    
    [operation start];
}

@end
