//
//  DTASafetyTipsViewController.m
//  DatingApp
//
//  Created by VLADISLAV KIRIN on 10/28/15.
//  Copyright © 2015 Cleveroad Inc. All rights reserved.
//

#import "DTASafetyTipsViewController.h"
#import "DTASafetyTipsTableViewCell.h"

@interface DTASafetyTipsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableTips;

@end

@implementation DTASafetyTipsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavBarWithTitle:@"Safety Tips"];
    self.tableTips.separatorColor = [UIColor clearColor];
}

#pragma mark - TableView delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
};

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DTASafetyTipsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kDTASafetyTipsTableViewCell];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
