//
//  DTASettingsViewController.m
//  DatingApp
//
//  Created by VLADISLAV KIRIN on 8/3/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import "DTASettingsViewController.h"
#import "DTASettingsDetailTableViewCell.h"
#import "DTASettingsActionsTableViewCell.h"
#import "DTABlockedUsersListVC.h"
#import "DTAFAQViewController.h"
#import "DTAEmailUsViewController.h"
#import "DTASafetyTipsViewController.h"
#import "DTATermsConditionsViewController.h"
#import "DTAPrivacyPolicyViewController.h"
#import "DTAAPI.h"

typedef NS_ENUM(NSUInteger, DTASettingsSection) {
    DTASettingsSectionTop = 0,
    DTASettingsSectionMiddle,
    DTASettingsSectionBottom
};

static const NSUInteger kDTASettingsSectionCount = 3;

@interface DTASettingsViewController () <UITableViewDelegate, UITableViewDataSource, DTASettingsActionCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableSettings;

- (IBAction)actionSaveButtonPressed:(id)sender;

@end

@implementation DTASettingsViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    self.navigationController.navigationBar.barTintColor = colorCreamCan;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName :[UIColor whiteColor]};
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.tableSettings.separatorColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableSettings reloadData];
}

#pragma mark - TableView delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kDTASettingsSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case DTASettingsSectionTop:
            return 3;
        
        case DTASettingsSectionMiddle:
            return kDTASettingsDetailCellsCount;
        
        case DTASettingsSectionBottom:
            return 1;
        
        default:
            return 0;
    };
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
    
        case DTASettingsSectionTop: {
            DTASettingsDetailTableViewCell *cell = [self.tableSettings dequeueReusableCellWithIdentifier:kDTASettingsDetailTableViewCell forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell configureCellWithType:indexPath.row];
           
            return cell;
        }
            
        case DTASettingsSectionMiddle: {
            
            DTASettingsDetailTableViewCell *cell = [self.tableSettings dequeueReusableCellWithIdentifier:kDTASettingsDetailTableViewCell forIndexPath:indexPath];
           
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell configureCellWithType:indexPath.row + 3];
            
            return cell;
        }
            
        case DTASettingsSectionBottom: {
            
            DTASettingsActionsTableViewCell * cell = [self.tableSettings dequeueReusableCellWithIdentifier:kDTASettingsActionsTableViewCell forIndexPath:indexPath];
           
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            
            return cell;
        }
            
        default:
            NSLog(@"Wrong indexpath section");
            return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case DTASettingsSectionTop:
            return kDTASettingsDetailCellsHeight;
        
        case DTASettingsSectionMiddle:
            return kDTASettingsDetailCellsHeight;
        
        case DTASettingsSectionBottom:
            return kDTASettingsActionsTableViewCellHeight;
        
        default:
            return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
    if (indexPath.section == DTASettingsSectionMiddle) {
        
        switch (indexPath.row + 3) {
        
            case DTASettingsDetailCellEmailUs:
                [self performSegueWithIdentifier:toEmailUsVC sender:self];
                break;
            
            case DTASettingsDetailCellTerms: {
                DTATermsConditionsViewController *termsVC = [self.storyboard instantiateViewControllerWithIdentifier:DTATermsConditionsViewControllerID];
                [self.navigationController pushViewController:termsVC animated:YES];
                break;
            }
            
            case DTASettingsDetailCellPrivacyPolicy: {
                DTAPrivacyPolicyViewController *privacyVC = [self.storyboard instantiateViewControllerWithIdentifier:DTAPrivacyPolicyViewControllerID];
                [self.navigationController pushViewController:privacyVC animated:YES];
                break;
            }
                
            case DTASettingsDetailCellBlockedUsers: {
                DTABlockedUsersListVC *blockedVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DTABlockedUsersListVC"];
                [self.navigationController pushViewController:blockedVC animated:YES];
                break;
            }
            
            default:
                break;
        }
    }
}

#pragma mark - DTASettingsActionCellDelegate

- (void)actionLogoutButtonPressed:(id)sender {
    APP_DELEGATE.hudLogout = [[SAMHUDView alloc] initWithTitle:@"Logout" loading:YES];
    [APP_DELEGATE.hudLogout show];
    [APP_DELEGATE logoutToStartScreen];
}

- (void)actionDeleteAccountButtonPressed:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Are you realy want do delete your account?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        APP_DELEGATE.hudLogout = [[SAMHUDView alloc] initWithTitle:@"Deleting account" loading:YES];
        [APP_DELEGATE.hudLogout show];
        
        [DTAAPI profileDeleteWithCompletion:^(NSError *error) {
             if (error) {
                 NSLog(@"FAIL profileDeleteWithCompletion request performing");
                 [APP_DELEGATE.hudLogout dismiss];
             }
             else {
                 NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                 [ud setObject:@YES forKey:@"Logout"];
                 [ud synchronize];
                 NSLog(@"Succes profileDeleteWithCompletion request performing");
                 [APP_DELEGATE logoutToStartScreen];
             }
         }];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:yesAction];
    [alertController addAction:cancelAction];
    
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}

#pragma mark -

- (IBAction)actionSaveButtonPressed:(id)sender {
    NSMutableArray *cells = [NSMutableArray new];

    for (NSInteger i = 0; i < 3; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:DTASettingsSectionTop];
        DTASettingsDetailTableViewCell *cell = [self.tableSettings cellForRowAtIndexPath:indexPath];
        [cells addObject:cell];
    }
    
    NSDictionary *notifications = @{@"messagesNotifications":@([cells[DTASettingsDetailCellPushNewMessages] switcherState]), @"matchesNotifications":@([cells[DTASettingsDetailCellPushNewMatchs] switcherState]), @"likesNotifications":@([cells[DTASettingsDetailCellPushNewLikes] switcherState])};
    
    APP_DELEGATE.hud = [[SAMHUDView alloc] initWithTitle:nil];
    [APP_DELEGATE.hud show];
    
    [DTAAPI profileUpdateWithParameters:notifications avatar:nil completionBlock:^(NSError *error) {
        [APP_DELEGATE.hud dismiss];
    }];
}

@end
