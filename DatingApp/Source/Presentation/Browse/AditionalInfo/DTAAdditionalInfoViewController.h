//
//  DTAAdditionalInfoViewController.h
//  DatingApp
//
//  Created by Maksim on 29.09.15.
//  Copyright © 2015 Cleveroad Inc. All rights reserved.
//

@protocol DTAAdditionalInfoDelgate

- (void)pressLikeButton;
- (void)pressDislikeButton;

@end

#import <UIKit/UIKit.h>
@class User;

@interface DTAAdditionalInfoViewController : UIViewController

@property (strong, nonatomic) User *detailedUser;
@property (nonatomic, weak) IBOutlet UIScrollView *rootScroll;

@property (nonatomic, unsafe_unretained) id<DTAAdditionalInfoDelgate>delegate;

- (void)reloadUserDataFromUserModel:(User *)user;
- (void)scroolToTop;

@end
