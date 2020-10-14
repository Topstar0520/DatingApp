//
//  UserDetailedInfoViewController.h
//  DatingApp
//
//  Created by  Artem Kalinovsky on 9/3/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTABaseViewController.h"
@class User;

typedef NS_OPTIONS(NSUInteger, DTAButtonsHideState) {
    // 1 - button hidden, 0 - visible
    DTAButtonsHideStateLike = 1 << 0,
    DTAButtonsHideStateChat = 1 << 1,
    DTAButtonsHideStateDislike = 1 << 2
};

@protocol UserDetailedInfoSelectUser <NSObject>

@optional

- (void)selectUser:(User *)user;

@end

@interface UserDetailedInfoViewController : DTABaseViewController

@property (strong, nonatomic) User *detailedUser;
@property (nonatomic, assign) DTAButtonsHideState hideButtons;
@property (nonatomic, weak) id<UserDetailedInfoSelectUser>delegate;

@end
