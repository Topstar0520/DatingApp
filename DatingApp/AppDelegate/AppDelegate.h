//
//  AppDelegate.h
//  DatingApp
//
//  Created by VLADISLAV KIRIN on 7/31/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <Reachability/Reachability.h>
#import <UserNotifications/UserNotifications.h>
#import <FirebaseMessaging.h>

#define APP_DELEGATE ((AppDelegate*)[[UIApplication sharedApplication] delegate])
#define IS_HOST_REACHABLE [APP_DELEGATE isHostReachable]

typedef NS_ENUM(NSUInteger, DTAPushType) {
    DTAPushNewMessages = 1,
    DTAPushNewMatchs,
    DTAPushNewLikes
};

@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate, FIRMessagingDelegate>

@property(nonatomic,strong) NSString *userIdentifierApple;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSArray *inAppIdentifireArr;

@property (nonatomic) BOOL isInternetConnected;
@property (nonatomic) BOOL isLogoutProcced;

@property (nonatomic) BOOL firstRun;
@property (nonatomic) DTAPushType currentPushType;

@property (strong, nonatomic) NSString *deviceToken;

@property (strong, nonatomic) SAMHUDView *hud;
@property (strong, nonatomic) SAMHUDView *hudLogout;

- (NSString *)applicationSupportDirectory;
- (BOOL)isHostReachable;
- (void)logoutToStartScreen;
- (void)naviagteToStartScreen;

@end
