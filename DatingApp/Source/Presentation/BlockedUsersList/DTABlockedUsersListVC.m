//
//  DTABlockedUsersListVC.m
//  DatingApp
//
//  Created by Apple on 04/05/19.
//  Copyright © 2019 Cleveroad Inc. All rights reserved.
//

#import "DTABlockedUsersListVC.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "BlockedUserTableViewCell.h"

@interface DTABlockedUsersListVC () <UITableViewDelegate, UITableViewDataSource, BlockedUserTableViewCellDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UILabel *noRecordData;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation DTABlockedUsersListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.noRecordData setHidden:YES];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    self.dataArr = [NSMutableArray new];
    
    [self setupNavBarWithTitle:@"Blocked Users"];
    [self setupBackButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getBlockedUserDataFromAPI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (APP_DELEGATE.firstRun) {
        id loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DTARegisterNavigationControllerID"];
        [self presentViewController:loginVC animated:YES completion:nil];
        APP_DELEGATE.firstRun = NO;
    }
}

- (void) getBlockedUserDataFromAPI {

    __weak typeof(self) weakSelf = self;
    
    APP_DELEGATE.hud = [[SAMHUDView alloc] initWithTitle:nil];
    [APP_DELEGATE.hud show];
    
    [DTAAPI getBlockedUserListData:^(NSError *error, NSArray *result) {
        
        [APP_DELEGATE.hud dismiss];
        
        if (!error) {
            weakSelf.dataArr = [NSMutableArray arrayWithArray:result];
            [weakSelf.tableView reloadData];
            
            if (weakSelf.dataArr.count > 0) {
                [weakSelf.noRecordData setHidden:YES];
                [weakSelf.tableView setHidden:NO];
            }
            else {
                [weakSelf.noRecordData setHidden:NO];
                [weakSelf.tableView setHidden:YES];
            }
        }
        else {
            
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - TableViewDelegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BlockedUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BlockedUserTableViewCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.tag = indexPath.row;

    NSDictionary *dict = [self.dataArr objectAtIndex:indexPath.row];
    
    cell.usernameLabel.text = [NSString stringWithFormat:@"%@, %ld", [dict objectForKey:@"firstName"], (long)[self getUserAgeFromDOB:[dict objectForKey:@"dateOfBirth"]]];
    
    [cell.userImageView sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"drefaultImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    
    }];
    
    return cell;
}

- (NSInteger) getUserAgeFromDOB: (NSString *) dob {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"YYYY-MM-DD";
    
    NSDate *birthDate = [dateFormatter dateFromString:dob];
    
    NSDate *today = [NSDate date];
    
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSUInteger units = NSCalendarUnitYear;
    
    NSDateComponents *components = [gregorian components:units fromDate:birthDate toDate:today options:0];
    
    return [components year];
}

- (void)unBlockUserButtonClicked: (BlockedUserTableViewCell *) cell {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure to unblock this user?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        APP_DELEGATE.hud = [[SAMHUDView alloc] initWithTitle:nil];
        [APP_DELEGATE.hud show];
        
        NSDictionary *dict = [self.dataArr objectAtIndex:cell.tag];
        
        [DTAAPI unblockUserFromAPI:[dict objectForKey:@"id"] completion:^(NSError *error) {
            
            [APP_DELEGATE.hud completeAndDismissWithTitle:nil];
            
            if(!error) {
                [self getBlockedUserDataFromAPI];
            }
            else {
                UIAlertController *newAlert = [UIAlertController alertControllerWithTitle:@"UnBlock User Error" message:nil preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *okNewAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
                
                [newAlert addAction:okNewAction];
                
                [self presentViewController:newAlert animated:YES completion:nil];
            }
        }];
    }];
    
    [alert addAction:yesAction];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:noAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
