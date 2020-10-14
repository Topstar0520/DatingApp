//
//  DTASelectCityViewController.m
//  DatingApp
//
//  Created by  Artem Kalinovsky on 8/18/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import "DTASelectCityViewController.h"
@import GooglePlaces;

@interface DTASelectCityViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *cities;
@property (strong, nonatomic) NSDictionary *selectedCity;

@end

@implementation DTASelectCityViewController

- (NSArray *)cities {
    if (!_cities) {
        _cities = [[NSArray alloc] init];
    }
    
    return _cities;
}

- (NSDictionary *)selectedCityName {
    if (!_selectedCity) {
        _selectedCity = [[NSDictionary alloc]init];
    }
    
    return _selectedCity;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (![searchText isEqualToString:@""]) {
        __weak typeof(self) weakSelf = self;
        [DTAAPI fetchCityNamesForQuery:searchText completion:^(NSError *error, NSArray *cityNames) {
            if (!error) {
                weakSelf.cities = cityNames;
                [weakSelf.tableView reloadData];
            }
            else {
                NSLog(@"%@",error.localizedDescription);
            }
        }];
    }
    else {
        self.cities = nil;
        [self.tableView reloadData];
        [searchBar resignFirstResponder];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger catIndex = [self.cities indexOfObject:self.selectedCity];
    
    if(catIndex == indexPath.row) {
        self.selectedCity = nil;
        self.selecedCityStr = nil;
    }
    
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:catIndex inSection:0];
    
    if (newCell.accessoryType == UITableViewCellAccessoryNone) {
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.selectedCity = (NSDictionary *)self.cities[(NSUInteger) indexPath.row];
        self.selecedCityStr = self.selectedCity[@"city"];
    }
    
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
    
    if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
        oldCell.accessoryType = UITableViewCellAccessoryNone;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cityCell" forIndexPath:indexPath];

    NSDictionary *dict = self.cities[(NSUInteger)indexPath.row];
    cell.textLabel.text = dict[@"city"];
    
    if([dict[@"city"] isEqualToString:self.selecedCityStr]) {
        self.selectedCity = (NSDictionary *)self.cities[(NSUInteger) indexPath.row];
        self.selecedCityStr = self.selectedCity[@"city"];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - IBActions

- (IBAction)tapOnDoneBarButtonItem:(UIBarButtonItem *)sender {
    if (self.selectedCity) {
        [DTAAPI fetchCityCoordsByPlaceId:self.selectedCity[@"placeId"] completion:^(NSError *error, NSArray *result) {
             if (!error) {
                 if ([(NSObject*)self.delegate respondsToSelector:@selector(citySelectionCompletedWithCity:)]) {
                     
                     NSDictionary *dict = @{@"latitude": [result firstObject], @"longitude": [result lastObject], @"city": self.selectedCity[@"city"]};
                     
                     [self.delegate citySelectionCompletedWithCity:dict];
                 }
                 
                 [self. navigationController popViewControllerAnimated:YES];
             }
             else {
                 
             }
         }];
    }
    else {
        if ([(NSObject*)self.delegate respondsToSelector:@selector(citySelectionCompletedWithCity:)]) {
            NSDictionary *dict = @{@"latitude": @0, @"longitude": @0, @"city": @""};
            [self.delegate citySelectionCompletedWithCity:dict];
        }
        
        [self. navigationController popViewControllerAnimated:YES];
    }
}

@end
