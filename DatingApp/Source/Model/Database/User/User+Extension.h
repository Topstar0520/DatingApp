//
//  User+Extension.h
//  DatingApp
//
//  Created by VLADISLAV KIRIN on 7/31/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import "User.h"

@interface User (Extension)

+ (User *)currentUser;
- (void)fetchProfilePictureWithCompletionBlock:(void (^)(UIImage *fetchedImage, NSError *error))completionBlock;
- (NSString *)fetchCityNameFromLocation;
- (NSString *)convertHeightToString;
- (NSInteger)userAge;

@end
