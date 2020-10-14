//
//  DTAMenuViewController.m
//  DatingApp
//
//  Created by VLADISLAV KIRIN on 8/3/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import "DTAMenuViewController.h"
#import "DTAMenuTableViewCell.h"
#import "DTAMenuAvatarTableViewCell.h"
#import "DTASlidingViewController.h"
#import "DTABrowseViewController.h"
#import "DTALocationManager.h"
#import "DTAAPI.h"
#import "DTAProspectsViewController.h"
#import "User.h"
#import "User+Extension.h"
#import "DTAConstants.h"
#import "Session.h"
#import "DTASocket.h"

typedef NS_ENUM(NSUInteger, DTAMenuSectionType) {
    DTAMenuSectionTypeAvatar = 0,
    DTAMenuSectionTypeItem
};

@interface DTAMenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableMenu;
@property (nonatomic, assign) BOOL changeAvatarImage;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) DTALocationManager *locationManager;
@property (nonatomic, assign) int currentMenuItemIndex;

@end

@implementation DTAMenuViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeAvatar) name:@"changeAvatar" object:nil]; //changeAvatar
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openBouse) name:@"userLogOut" object:nil]; //userLogOut
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openSearchController) name:@"openSearchController" object:nil]; //openSearchController
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remoteNotification) name:@"remoteNotification" object:nil]; //remoteNotification
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needToReloadMenu) name:@"needToReloadMenu" object:nil]; //needToReloadMenu
    
    self.changeAvatarImage = NO;
    
    if(!_timer) {
        _timer = [NSTimer timerWithTimeInterval:300.0 target:self selector:@selector(updateLocation) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    
    self.tableMenu.separatorColor = [UIColor clearColor];
    
    [self updateLocation];
}

- (void)remoteNotification {
    DTAMenuItems item;
    DTAPushType pushType;

    switch (APP_DELEGATE.currentPushType) {
        case DTAPushNewMessages:
            item = DTAMenuItemConversations;
            pushType = DTAPushNewMessages;
            break;
        
        case DTAPushNewMatchs:
            item = DtaMenuItemMatches;
            pushType = DTAPushNewMatchs;
            break;
        
        case DTAPushNewLikes:
            item = DTAMenuItemLikesYou;
            pushType = DTAPushNewLikes;
            break;
        
        default:
            item = DTAMenuItemBrowse;
            break;
    }
    
    if (pushType) {
        [DTAAPI badgeUpdateWithPushType:pushType сompletion:^(NSError *error) {
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        }];
        
        [DTAAPI badgeUpdateWithPushType:pushType сompletion:^(NSError *error) {
            
            NSInteger badgeNumber;
        
            if (pushType == DTAPushNewMessages) {
                [User currentUser].messagesBadge = @0;
                badgeNumber = [[User currentUser].likesBadge integerValue] + [[User currentUser].matchesBadge integerValue];
            }
            else if (pushType == DTAPushNewMatchs) {
                [User currentUser].matchesBadge = @0;
                badgeNumber = [[User currentUser].likesBadge integerValue] + [[User currentUser].messagesBadge integerValue];
            }
            else {
                [User currentUser].likesBadge = @0;
                badgeNumber = [[User currentUser].matchesBadge integerValue] + [[User currentUser].messagesBadge integerValue];
            }
            
            [UIApplication sharedApplication].applicationIconBadgeNumber = badgeNumber;
        }];
    }

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:item inSection:DTAMenuSectionTypeItem];
    [self tableView:self.tableMenu didSelectRowAtIndexPath:indexPath];
    [self.tableMenu reloadData];
}

- (void)openSearchController {
    self.sidePanelController.centerPanel = self.dataArray.firstObject;

    [self.tableMenu selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1] animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (void)updateLocation {
    self.locationManager = nil;
    self.locationManager = [DTALocationManager new];

    [self.locationManager trackLocationWithCompletionBlock:^(CLLocation *location) {
        if(location) {
            [DTAAPI profileUpdateLocationWithLocation:location];
        }
    }];
}

- (NSMutableArray *)dataArray {
    if(!_dataArray) {
        _dataArray = [NSMutableArray new];
        
        [_dataArray addObject:[self.storyboard instantiateViewControllerWithIdentifier:@"DTASearchOptionsNavigationControllerID"]];

        [_dataArray addObject:[self.storyboard instantiateViewControllerWithIdentifier:@"DTAProspectsNavigationControllerID"]];

        [_dataArray addObject:[self.storyboard instantiateViewControllerWithIdentifier:@"DTAProspectsNavigationControllerID"]];

        [_dataArray addObject:self.sidePanelController.centerPanel];

        [_dataArray addObject:[self.storyboard instantiateViewControllerWithIdentifier:@"DTANearbyNavigationControllerID"]];

        [_dataArray addObject:[self.storyboard instantiateViewControllerWithIdentifier:@"DTAConversationsNavigationControllerID"]];

        [_dataArray addObject:[self.storyboard instantiateViewControllerWithIdentifier:@"DTASettingsNavigationControllerID"]];
    }

    return _dataArray;
}

- (void)changeAvatar {
    self.changeAvatarImage = YES;
    [self.tableMenu reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.currentMenuItemIndex = !self.currentMenuItemIndex ? DTAMenuItemBrowse : self.currentMenuItemIndex;
    
    [self.tableMenu reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
  
    NSComparisonResult result = [[NSDate date] compare:[User currentUser].expiresTokenAt];
    
    if (result == NSOrderedDescending) {
        [DTAAPI refreshExpiredAccessTokenWithCompletionBlock:^(NSError *error) {
             if (!error) {
                 NSLog(@"Expired access token have been refreshed");
             }
         }];
    }
    
    if ([[User currentUser].avatar length]) {
        [self.tableMenu reloadData];
        [self updateLocation];
    }
}

- (void)openBouse {
    UINavigationController *nav = self.dataArray[DTAMenuItemBrowse];
    self.sidePanelController.centerPanel  = nav;
    
    id loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DTARegisterNavigationControllerID"];
    [self presentViewController:loginVC animated:YES completion:^ {
        [[DTASocket sharedInstance] disconnect];
    }];
}

#pragma mark - TableView Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; {
    return  2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case DTAMenuSectionTypeAvatar:
            return 1;
        
        case DTAMenuSectionTypeItem:
            return self.dataArray.count;
        
        default:
            break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
            
        case DTAMenuSectionTypeAvatar: {
            
            DTAMenuAvatarTableViewCell *cell = [self.tableMenu dequeueReusableCellWithIdentifier:kDTAMenuAvatarTableViewCell forIndexPath:indexPath];
            
            [cell configureCell];
            [cell.avatarButton addTarget:self action:@selector(pressAvatarButton) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }
       
        case DTAMenuSectionTypeItem: {
            
            DTAMenuTableViewCell *cell = [self.tableMenu dequeueReusableCellWithIdentifier:kDTAMenuTableViewCell forIndexPath:indexPath];
            [cell configureCellForType:indexPath.row isCurrent:indexPath.row == self.currentMenuItemIndex];
            
            return cell;
        }
        
        default:
            break;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == DTAMenuSectionTypeItem) {
        
        switch (indexPath.row) {
                
            case DTAMenuItemLikesYou: {
                // likes
                DTAProspectsViewController *prospectsVC = [(UINavigationController *)self.dataArray[indexPath.row]viewControllers][0];
                prospectsVC.isLikesYou = YES;
                self.sidePanelController.centerPanel = self.dataArray[indexPath.row];
            }
            break;
          
            case DtaMenuItemMatches: {
                // matches
                DTAProspectsViewController *prospectsVC = [(UINavigationController *)self.dataArray[indexPath.row]viewControllers][0];
                prospectsVC.isLikesYou = NO;
                self.sidePanelController.centerPanel = self.dataArray[indexPath.row];
            }
            break;
            
            default: {
                self.sidePanelController.centerPanel = self.dataArray[indexPath.row];
            }
            break;
        }
        
        self.currentMenuItemIndex = (int)indexPath.row;
        [tableView reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case DTAMenuSectionTypeAvatar:
            return kDTAMenuAvatarTableViewCellHeight;
    
        case DTAMenuSectionTypeItem:
            return kDTAMenuTableViewCellHeight;
    }
    
    return 0;
}

#pragma mark - PRESS ON PROFILE IMAGE OF SIDE MENU
- (IBAction)pressAvatarButton {
    self.currentMenuItemIndex = -1;
    [self.tableMenu reloadData];
    
    self.sidePanelController.centerPanel = [self.storyboard instantiateViewControllerWithIdentifier:@"DTAProfileInfoNavigationControllerID"];
}

#pragma mark - DTASlidingViewControllerDelegate
- (void)needToReloadMenu {
    [self.tableMenu reloadData];
}

@end
