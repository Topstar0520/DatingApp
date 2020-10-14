//
//  DTAConstantsUserDefaults.h
//

#import <Foundation/Foundation.h>

#define NS_USER_DEFAULTS(key) [NSUserDefaults standardUserDefaults][key]

extern NSString *const DTACurrentUserDatabaseNameUserDefaultsKey;

extern NSString * const DTADeviceTokenUserDefaultsKey;
