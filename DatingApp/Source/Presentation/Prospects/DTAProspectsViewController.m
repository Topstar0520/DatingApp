//
//  DTAProspectsViewController.m
//  DatingApp
//
//  Created by VLADISLAV KIRIN on 8/3/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import "DTAProspectsViewController.h"
#import "ProspectsTableViewCell.h"
#import "DTAProspectsPage.h"
#import "User.h"
#import "DTASocket.h"
#import "UserDetailedInfoViewController.h"
#import <CCBottomRefreshControl/UIScrollView+BottomRefreshControl.h>
#import "User+Extension.h"

static NSString * const kProspectsCellReuseIdentifier = @"prospectsCell";

@interface DTAProspectsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *people;
@property (strong, nonatomic) DTAProspectsPage *currentPage;
@property (assign, nonatomic) NSUInteger selectedUserIndex;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic, weak) IBOutlet UILabel *infoLabel;

@end

@implementation DTAProspectsViewController

- (UIRefreshControl *)refreshControl {
    if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc] init];

        [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    }
    
    return _refreshControl;
}

- (DTAProspectsPage *)currentPage {
    if (!_currentPage) {
        _currentPage = [[DTAProspectsPage alloc] init];
    }
    
    return _currentPage;
}

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    self.navigationController.navigationBar.barTintColor = colorCreamCan;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.currentPage.pageNumber = @0;
    self.currentPage.pageLimit = @50;
    
    [self.tableView addSubview:self.refreshControl]; // self.tableView.bottomRefreshControl = self.refreshControl;
    
    if(self.isLikesYou) {
        [self setupNavBarWithTitle:NSLocalizedString(@"Likes You", nil)];
        self.bgImageView.image = [UIImage imageNamed:@"L_U"];
    }
    else {
        [self setupNavBarWithTitle:NSLocalizedString(@"Matches", nil)];
        self.bgImageView.image = [UIImage imageNamed:@"M_U"];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateContent) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(![[DTASocket sharedInstance] connectToSoket]) {
        [[DTASocket sharedInstance] connect];
    }

    [self updateContent];
}

- (void)updateContent {
    if (!self.isLikesYou) {
        [self tapOnMatchesButton:nil];
    }
    else {
        [self tapOnLikesYouButton:nil];
    }
    
    [self badgeUpdate];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (APP_DELEGATE.firstRun) {
        id loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DTARegisterNavigationControllerID"];
        [self presentViewController:loginVC animated:YES completion:nil];
        APP_DELEGATE.firstRun = NO;
    }
    
    [self badgeUpdate];
}

- (void)badgeUpdate {
    DTAPushType pushType = self.isLikesYou ? DTAPushNewLikes : DTAPushNewMatchs;
    
    [DTAAPI badgeUpdateWithPushType:pushType сompletion:^(NSError *error) {
        NSInteger badgeNumber;
    
        if (self.isLikesYou) {
            [User currentUser].likesBadge = @0;
            badgeNumber = [[User currentUser].messagesBadge integerValue] + [[User currentUser].matchesBadge integerValue];
        }
        else {
            [User currentUser].matchesBadge = @0;
            badgeNumber = [[User currentUser].likesBadge integerValue] + [[User currentUser].messagesBadge integerValue];
        }
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = badgeNumber;
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:toDetailedUserInfoSegue]) {
        
        UserDetailedInfoViewController *destVC = segue.destinationViewController;
        
        destVC.detailedUser = self.people[self.selectedUserIndex];

        if (!self.isLikesYou) {
            //if from Matches
            destVC.hideButtons = DTAButtonsHideStateDislike + DTAButtonsHideStateLike;
        }
        else {
            // if from Likes You
            destVC.hideButtons = DTAButtonsHideStateChat;
        }
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedUserIndex = (NSUInteger) indexPath.row;
    [self performSegueWithIdentifier:toDetailedUserInfoSegue sender:self];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.people.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProspectsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kProspectsCellReuseIdentifier forIndexPath:indexPath];
    
    User *fetchedUser = self.people[(NSUInteger) indexPath.row];
    [cell configureWithUser:fetchedUser];
    
    return cell;
}

#pragma mark - IBActions

- (IBAction)tapOnMatchesButton:(UIButton *)sender {
    self.currentPage.pageNumber = @0;
 
    __weak typeof(self) weakSelf = self;
    
    APP_DELEGATE.hud = [[SAMHUDView alloc] initWithTitle:nil];
    [APP_DELEGATE.hud show];
    
    [DTAAPI fetchMatchedUsersOnPage:self.currentPage completion:^(NSError *error, NSArray *results) {
        if (!error) {
            weakSelf.people = results;
            [weakSelf.tableView reloadData];
        
            [weakSelf setBgImageToTable];
        }
        
        [APP_DELEGATE.hud dismiss];
    }];
}

- (IBAction)tapOnLikesYouButton:(UIButton *)sender {
    self.currentPage.pageNumber = @0;
    __weak typeof(self) weakSelf = self;
  
    APP_DELEGATE.hud = [[SAMHUDView alloc] initWithTitle:nil];
    [APP_DELEGATE.hud show];
    
    [DTAAPI fetchMatchesOnPage:self.currentPage completion:^(NSError *error, NSArray *results) {
        if (!error) {
            weakSelf.people = results;
            [weakSelf.tableView reloadData];
            
            [weakSelf setBgImageToTable];
        }
        
        [APP_DELEGATE.hud dismiss];
    }];
}

- (IBAction)refresh {
    if (!self.isLikesYou) {
        int value = [self.currentPage.pageNumber intValue];
        self.currentPage.pageNumber = @(value + 1);

        __weak typeof(self) weakSelf = self;
        
        [DTAAPI fetchMatchedUsersOnPage:self.currentPage completion:^(NSError *error, NSArray *results) {
            if (!error) {
                NSMutableArray *newUsers = [weakSelf.people mutableCopy];
                [newUsers addObjectsFromArray:results];
                
                weakSelf.people = newUsers;
                [weakSelf.tableView reloadData];
                
                [weakSelf setBgImageToTable];
            }
            
            [self.refreshControl endRefreshing];
        }];
    }
    else {
        int value = [self.currentPage.pageNumber intValue];
        self.currentPage.pageNumber = @(value + 1);

        __weak typeof(self) weakSelf = self;
  
        [DTAAPI fetchMatchedUsersOnPage:self.currentPage completion:^(NSError *error, NSArray *results) {
            if (!error) {
                NSMutableArray *newUsers = [weakSelf.people mutableCopy];
                [newUsers addObjectsFromArray:results];
                
                weakSelf.people = newUsers;
                [weakSelf.tableView reloadData];
                
                [weakSelf setBgImageToTable];
            }
            
            [self.refreshControl endRefreshing];
        }];
    }
}

- (void)setBgImageToTable {
    if(self.people.count == 0) {
        if(!self.isLikesYou) {
            self.bgImageView.image = [UIImage imageNamed:@"M_U"];
            self.infoLabel.text = @"no matches...";
        }
        else {
            self.bgImageView.image = [UIImage imageNamed:@"L_U"];
            self.infoLabel.text = @"no likes...";
        }
    }
    else {
        self.bgImageView.image = [UIImage imageNamed:@""];
        self.infoLabel.text = @"";
    }
}

@end
