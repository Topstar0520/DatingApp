//
//  DTAConstantsAPI.m
//

#import "DTAConstantsAPI.h"

//NSString *const DTAAPIServerHostname = @"http://192.168.1.26:3123";
//NSString *const DTAAPIServerHostname = @"http://192.168.0.224:3133";

//NSString *const DTAAPIServerHostname = @"http://54.68.94.110:3000";
//NSString *const DTAAPIServerHostname = @"http://52.10.6.169:3134";

// local server
//NSString *const DTAAPIServerHostname = @"http://192.168.0.135:3134";
//NSString *const DTAAPIServerHostname = @"http://192.168.0.23:3134";

// staging server
//NSString *const DTAAPIServerHostname = @"http://202.157.76.22:3134";

//NSString *const DTAAPIServerHostname = @"http://mymeetingdesk.com:3134"; // staging

NSString *const DTAAPIServerHostname = @"https://api.jollofdate.com"; // Live Server


NSString *const DTAAPIClientKey = @"";

#pragma mark - API paths 
NSString *const DTAAPILoginViaAppleEndpoint = @"/api/v1/signin/apple";
NSString *const DTAAPILoginViaFacebookEndpoint = @"/api/v1/signin/facebook";
NSString *const DTAAPILoginViaInstagramEndpoint = @"/api/v1/signin/instagram";
NSString *const DTAAPILoginViaEmailEndpoint = @"/api/v1/signin/basic";

NSString *const DTAAPIRegisterViaAppleEndpoint = @"/api/v1/signup/apple";
NSString *const DTAAPIRegisterViaFacebookEndpoint = @"/api/v1/signup/facebook";
NSString *const DTAAPIRegisterViaInstagramEndpoint = @"/api/v1/signup/instagram";
NSString *const DTAAPIRegisterViaEmailEndpoint = @"/api/v1/signup/basic";

NSString *const DTAAPILogoutEndpoint = @"/api/v1/logout";

NSString *const DTAAPIRefreshAccessTokenEndpoint = @"/api/v1/token";
NSString *const DTAAPIStaticResourcesEndpoint = @"/api/v1/resource/{resource}";
NSString *const DTAAPIFetchUserProfileEndpoint = @"/api/v1/profile/:userId";
NSString *const DTAAPIFetchUserFullProfileEndpoint = @"/api/v1/profile/:userId/full";
NSString *const DTAAPIEditUserProfileEndpoint = @"/api/v1/profile";
NSString *const DTAAPIBlockedUsersListEndPoint = @"/api/v1/block_users_list";
NSString *const DTAAPIUpdateBadgeEndpoint = @"/api/v1/user/badge";
NSString *const DTAAPIUpdateUserLocationEndpoint = @"/api/v1/user/location";
NSString *const DTAAPILoadUserImagesEndpoint = @"/api/v1/attachment";
NSString *const DTAAPIBrowseUsersEndpoint = @"/api/v1/browse";
NSString *const DTAAPIRemoveUsersEndpoint = @"/api/v1/user/match";
NSString *const DTAAPIChangeImagesOrderEndpoint = @"/api/v1/attachments/order";
NSString *const DTAAPIMatchUserEndpoint = @"/api/v1/user/match/:userId";
NSString *const DTAAPIListOfMatchedUsersEndpoint = @"/api/v1/user/matched/:pageLimit/:pageNumber";
NSString *const DTAAPIListOfMatchesEndpoint = @"/api/v1/user/matches/:pageLimit/:pageNumber";

NSString *const DTAAPIFetchUserSubscriptionStatusEndpoint = @"/api/v1/user/subscription_status/:id";


NSString *const DTAAPIPrivacyEndpoint = @"/privacy";
NSString *const DTAAPITermsEndpoint = @"/terms";
NSString *const DTAAPITermsIAPEndpoint = @"/termsiap";

NSString *const DTAAPIReportsEndpoint = @"/api/v1/reports";

NSString *const DTAAPIBlockUserEndpoint = @"/api/v1/block_user";
NSString *const DTAAPIUnBlockUserEndpoint = @"/api/v1/unblock_user";
#pragma mark - API response keys

NSString *const DTAAPIUserResponseKeyPath = @"user";
NSString *const DTAAPIBrowsingUsersResponseKeyPath = @"users";
NSString *const DTAAPISessionResponseKeyPath = @"session";

#pragma mark routes
NSString *const kDTAAPIFetchUserFullProfileRoute = @"kDTAAPIFetchUserFullProfileRoute";
NSString *const kDTAAPIFetchUserProfileRoute = @"kDTAAPIFetchUserProfileRoute";
NSString *const kDTAAPIEditUserProfileRoute = @"kDTAAPIEditUserProfileRoute";
NSString *const kDTAAPIFetchMatchedUsersRoute = @"kDTAAPIFetchMatchedUsersRoute";
NSString *const kDTAAPIFetchMatchesRoute = @"kDTAAPIFetchMatchesRoute";
NSString *const kDTAAPIMatchUserRoute = @"kDTAAPIMatchUserRoute";
NSString *const kDTAAPIDeleteMatchUserRoute = @"kDTAAPIDeleteMatchUserRoute";

#pragma mark Subscription
NSString *const DTAAPIPlanListEndpoint = @"/api/v1/plan_list";
NSString *const DTAAPIPurchasePlanEndpoint = @"/api/v1/user/purchase_plan";


