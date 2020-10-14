//
//  DTANearbyViewController.m
//  DatingApp
//
//  Created by VLADISLAV KIRIN on 8/3/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#import "DTANearbyViewController.h"
#import "UserDetailedInfoViewController.h"
#import "DTAAPI.h"
#import "User+Extension.h"
#import "Country+Extensions.h"
#import "Location+Extensions.h"
#import "MBProgressHUD.h"
#import "DTANearbyTableViewCell.h"

@interface DTANearbyViewController ()<UITableViewDelegate, UITableViewDataSource, UserDetailedInfoSelectUser>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, weak) IBOutlet UIImageView *bgImage;
@property (nonatomic, weak) IBOutlet UILabel *infoBgLabel;
@property (nonatomic, assign) BOOL logOut;

@end

@implementation DTANearbyViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barTintColor = colorCreamCan;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName :[UIColor whiteColor]};
    
    self.logOut = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [DTAAPI loadArrayOfUsersCompletion:^(NSError *error, NSArray *arr) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        weakSelf.dataArr = arr;
        [weakSelf.tableView reloadData];
        
        if (weakSelf.dataArr.count > 0) {
            [weakSelf.tableView setHidden:NO];
        }
        else {
            [weakSelf.tableView setHidden:YES];
        }
        
        [weakSelf showDefaultImage];
    }];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [refreshControl endRefreshing];
}

- (void)userLogOut {
    self.logOut = YES;
}

- (void)selectUser:(User *)user {
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:self.dataArr];
    [array removeObject:user];

    self.dataArr = array;
    [self.tableView reloadData];
 }

- (void)showDefaultImage {
    if(self.dataArr.count > 0) {
        self.bgImage.hidden = YES;
        self.infoBgLabel.hidden = YES;
    }
    else {
        self.bgImage.hidden = NO;
        self.infoBgLabel.hidden = NO;
    }
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DTANearbyTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"nearbyCell" forIndexPath:indexPath];
    
    User *user = _dataArr[indexPath.row];
    [cell configureWithUser:user];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:toDetailedUserInfoSegue sender:self];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:toDetailedUserInfoSegue]) {
        UserDetailedInfoViewController *destVC = segue.destinationViewController;
        destVC.detailedUser = _dataArr[[_tableView indexPathForSelectedRow].row];
        destVC.delegate = self;
        destVC.hideButtons = DTAButtonsHideStateChat;
    }
}

#pragma mark -

@end
