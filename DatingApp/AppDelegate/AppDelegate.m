//
//  AppDelegate.m
//  DatingApp
//
//  Created by VLADISLAV KIRIN on 7/31/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "User+Extension.h"
#import "DTASearchOptionsManager.h"
#import <GooglePlaces/GooglePlaces.h>

// for google maps
//@import GoogleMaps;

#import "TestFairy.h"
#import "DTALocationManager.h"
#import "DTARegisterViewController.h"

// imports for facebook login
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import "DTASocket.h"

// for firebase notifications
@import Firebase;

#define MAX_CONCURRENT_IMAGES_DOWNLOAD 10

@interface AppDelegate ()

@property (nonatomic, strong) DTALocationManager *manager;

@property (nonatomic, strong) NSDictionary *userInfo;


@end

@implementation AppDelegate {
    Reachability *theReachability;
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.firstRun = YES;
    
    // [TestFairy begin:@"91a52ae6aaa2e9484e7e2694daf94035c3ab60e4"];

    [self registerForPushNotifications];
    
    // facebook setup
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];

//    NSLog(@"%@", [UIFont familyNames]);
//    NSLog(@"%@", [UIFont fontNamesForFamilyName:@"Helvetica Neue"]);
    //[GMSServices provideAPIKey:@"AIzaSyAB1yaNRzuJJDd-KGcumOa7rJXv9Y8_YBs"];
    //[GMSServices provideAPIKey:@"AIzaSyA6bgeG8LoVeDqYAosx5MQ2ZvWYgcOMTKo"];
//    [GMSPlacesClient provideAPIKey:@"YOUR_API_KEY"];
    
//    [GMSPlacesClient provideAPIKey:@"AIzaSyAB1yaNRzuJJDd-KGcumOa7rJXv9Y8_YBs"];

//    [GMSPlacesClient provideAPIKey:@"AIzaSyAlqMcmxPtUUbxDsYSUJJhRC_Hmdf1Z5bI"]; // cleanline
    
    [GMSPlacesClient provideAPIKey:@"AIzaSyD1-CV5pv3CL4TcXb0DhOsERnQzbJcpyZA"];

    //--- reachability pod deploying
    theReachability = [Reachability reachabilityForInternetConnection];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangedInternetConnectionStatus:) name:kReachabilityChangedNotification object:nil];
    
    self.isInternetConnected = ([theReachability currentReachabilityStatus] != NotReachable);
    
    [theReachability startNotifier];
    
    [self internetAlertHandle];
    
    //--- Restkit & db deploying
    [DTAObjectManager setup];

    #ifdef DEBUG
        RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    #endif
    
    NSString *dbName = @"DTABase";
    [DTAObjectManager setupCoreDataWithPersistentStoreName:@"DTABase"];
    NS_USER_DEFAULTS(DTACurrentUserDatabaseNameUserDefaultsKey) = dbName;
    
    // firebase setup
    [FIRApp configure];
    
    if (launchOptions) {
        self.currentPushType = [launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey][@"aps"][@"alert"][@"type"] integerValue];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"remoteNotification" object:nil];
    }
    
    if ([UNUserNotificationCenter class] != nil) {
        
        // iOS 10 or later
        // For iOS 10 display notification (sent via APNS)
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        
        UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
        
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
            NSLog(@"granted = %d", granted);
         }];
    }
    else {
        // iOS 10 notifications aren't available; fall back to iOS 8-9 notifications.
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
    [application registerForRemoteNotifications];
    
    [FIRMessaging messaging].delegate = self;
    
    [self redirectScreen];
    
    return YES;
}

- (void) redirectScreen {
    
    if ([User currentUser].userId) {
//        [DTAAPI profileFullFetchForUserId:[User currentUser].userId completion:nil];
        [DTAAPI profileFullFetchForUserId:[User currentUser].userId completion:^(NSError *error, NSArray *dataArr) {
//            NSLog(@"%@", [[dataArr objectAtIndex:0]objectForKey:@"matchedCount"]);
//            [[NSUserDefaults standardUserDefaults]setObject:[[dataArr objectAtIndex:0]objectForKey:@"matchedCount"] forKey:@"matchCount"];
//            [[NSUserDefaults standardUserDefaults]synchronize];
        }];
        
    }
    
    if (self.userInfo) {
        
        self.currentPushType = [self.userInfo[@"aps"][@"alert"][@"type"] integerValue];
        self.userInfo = nil;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"remoteNotification" object:nil];
    }
    
    [FBSDKAppEvents activateApp];
    
    self.manager = [DTALocationManager new];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}

#pragma mark - Push Notifications Section

- (NSString *)deviceToken {
    if (!_deviceToken) {
        _deviceToken = @"Failed to get token";
    }
    
    return _deviceToken;
}
    
- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken
{
    NSLog(@"fcmToken = %@", fcmToken);
    self.deviceToken = fcmToken;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *token = [deviceToken description];
//    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
//    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
//    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];

    if (@available(iOS 10.0, *)){
        NSUInteger length = deviceToken.length;
        if (length == 0) {

        }
        const unsigned char *buffer = deviceToken.bytes;
        NSMutableString *hexString  = [NSMutableString stringWithCapacity:(length * 2)];
        for (int i = 0; i < length; ++i) {
            [hexString appendFormat:@"%02x", buffer[i]];
        }
        token = [hexString copy];
    } else {
         token = [[[[deviceToken description]
          stringByReplacingOccurrencesOfString: @"<" withString: @""]
         stringByReplacingOccurrencesOfString: @">" withString: @""]
        stringByReplacingOccurrencesOfString: @" " withString: @""];
    }
    
    NS_USER_DEFAULTS(DTADeviceTokenUserDefaultsKey) = token;

    NSLog(@"token = %@", token);
    
    //self.deviceToken = token;
    
    [FIRMessaging messaging].APNSToken = deviceToken;
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"Failed to get token, error: %@", error);
    self.deviceToken = @"Failed to get token";
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    NSLog(@"Received notification: %@", userInfo);
    
    if ([application applicationState] != UIApplicationStateActive) {
        self.userInfo = userInfo;
    }
    
    if (self.userInfo) {
        
        self.currentPushType = [self.userInfo[@"type"] integerValue];
        self.userInfo = nil;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"remoteNotification" object:nil];
    }
    
    if ([application applicationState] == UIApplicationStateActive) {
        [DTAAPI profileFullFetchForUserId:[User currentUser].userId completion:^(NSError *error, NSArray *dataArr) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"needToReloadMenu" object:nil];
        }];
    }
}

#pragma mark - Reachability

- (void)didChangedInternetConnectionStatus:(NSNotification *)notification {
    Reachability *reach = [notification object];
    
    self.isInternetConnected = ([reach currentReachabilityStatus] != NotReachable);
    
    [self internetAlertHandle];
}

- (BOOL) isHostReachable {
    return ([theReachability currentReachabilityStatus] != NotReachable);
}

- (void)internetAlertHandle {
    
    static UIAlertView *alert;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^ {
        alert = [[UIAlertView alloc] initWithTitle:@"Warning!" message:@"You have lost internet connection. Please connect to internet and alert will disappear." delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    });
    
    if (!self.isInternetConnected) {
        [alert show];
    }
    else {
        [alert dismissWithClickedButtonIndex:-1 animated:YES];
    }
}

#pragma mark - Facebook

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

#pragma mark - procedures

- (void)registerForPushNotifications {
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
}

- (void) naviagteToStartScreen {

    [APP_DELEGATE.hudLogout dismiss];
    [APP_DELEGATE.hud dismiss];
    
    UIStoryboard *stotyboad = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *registerNVC = [stotyboad instantiateViewControllerWithIdentifier:@"DTARegisterNavigationControllerID"];
    
    DTARegisterViewController *registerVC = [registerNVC viewControllers][0];
    registerVC.isTokenExpired = @"1";
    
    [self.window.rootViewController presentViewController:registerNVC animated:YES completion:^{
        
        [[DTASocket sharedInstance] disconnect];
        NS_USER_DEFAULTS(DTACurrentUserDatabaseNameUserDefaultsKey) = nil;
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        
        [DTASearchOptionsManager resetSharedManager];
        
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            User *user = [[User currentUser] MR_inContext:localContext];
            
            user.session = nil;
            user.facebookToken = nil;
            
            [User MR_truncateAllInContext:localContext];
            
        } completion:^(BOOL success, NSError *error) {
            
        }];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userLogOut" object:self];
    }];
}

- (void)logoutToStartScreen; {
    [DTAAPI logoutWithCompletion:^(NSError *error) {
        if (!error) {
            NSLog(@"Logout request success");
             
            NS_USER_DEFAULTS(DTACurrentUserDatabaseNameUserDefaultsKey) = nil;
            
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
            //[FBSession.activeSession closeAndClearTokenInformation];
             
            [DTASearchOptionsManager resetSharedManager];
            
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                User *user = [[User currentUser] MR_inContext:localContext];
                
                user.session = nil;
                user.facebookToken = nil;
                
                [User MR_truncateAllInContext:localContext];
                
            } completion:^(BOOL success, NSError *error) {
                [self dismissLogoutHud];
            }];
        }
        else {
            NSLog(@"Logout request fail");
            [self dismissLogoutHud];
        }
     }];
}

- (void)dismissLogoutHud {
    UINavigationController *nc = ((UINavigationController *)[[[[UIApplication sharedApplication] windows] objectAtIndex:0] rootViewController]);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.50 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^ {
        [nc dismissViewControllerAnimated:YES completion:nil];
        
        APP_DELEGATE.isLogoutProcced = NO;
        [APP_DELEGATE.hudLogout dismiss];
        [APP_DELEGATE.hud dismiss];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userLogOut" object:self];
    });
}

- (NSString *)applicationSupportDirectory {
    NSFileManager *sharedFM = [NSFileManager defaultManager];
    
    NSArray *possibleURLs = [sharedFM URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask];
    
    NSURL *appSupportDir = nil;
    NSURL *appDirectory = nil;
    
    if ([possibleURLs count] >= 1) {
        appSupportDir = [possibleURLs objectAtIndex:0];
    }
    
    if (appSupportDir) {
        appDirectory = [appSupportDir URLByAppendingPathComponent:[[[NSBundle mainBundle] executablePath] lastPathComponent]];
        
        BOOL isDirectory;
        
        if (![sharedFM fileExistsAtPath:appDirectory.path isDirectory:&isDirectory]) {
            NSError *error;
           
            [sharedFM createDirectoryAtPath:appDirectory.path withIntermediateDirectories:YES attributes:nil error:&error];
            
            if (error) {
                return nil;
            }
        }
        
        return [appDirectory path];
    }
    
    return nil;
}

#pragma mark -

@end
