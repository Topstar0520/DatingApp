//
//  DTASearchOptionsViewController.m
//  DatingApp
//
//  Created by VLADISLAV KIRIN on 8/3/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import "DTASearchOptionsViewController.h"
#import "DTAAdditionalInfoCell.h"
#import "DTADistanceLimitCell.h"
#import "DTAAgesLimitCell.h"
#import "DTAHeightLimitCell.h"
#import "DTASearchOptionsManager.h"
#import "Ethnic.h"
#import "SearchOptions.h"
#import "Relationship+Extensions.h"
#import "Profession+Extensions.h"
#import "Education.h"
#import "Country+Extensions.h"
#import "Religion+Extensions.h"
#import "Goals+Extensions.h"
#import "WantKids+Extensions.h"
#import "HaveKids+Extensions.h"
#import "Orientation+Extensions.h"
#import "DTASelectCityViewController.h"
#import "Location.h"
#import "User+Extension.h"
#import "DAKeyboardControl.h"
#import "REDRangeSlider.h"
@import GooglePlaces;

typedef NS_ENUM(NSUInteger, DTASearchOptionsTableSectionType) {
    DTASearchOptionsTableSectionTypeBasicOptions = 0,
    DTASearchOptionsTableSectionTypeAdvancedOptions
};

typedef NS_ENUM(NSUInteger, DTABasicSearchOptionsCellType) {
    DTABasicSearchOptionsCellTypeDistanceLimit = 0,
    DTABasicSearchOptionsCellTypeAgesLimit
};

@interface DTASearchOptionsViewController () < UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate, DTACitySelectionVCDelegate, DTAAdditionalInfoCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (assign, nonatomic, getter=isAdvancedOptionsButtonTapped) BOOL advancedOptionsButtonTapped;
@property (weak, nonatomic) IBOutlet UIButton *advancedSearchOptionsButton;
@property (weak, nonatomic) IBOutlet UIButton *saveFilterButton;
@property (weak, nonatomic) IBOutlet UIButton *resetFilterButton;
@property (nonatomic, assign) DTAAdditionalInfoCellType pickerState;
@property (weak, nonatomic) IBOutlet UISegmentedControl *prefferedGenderSegmentedControl;
@property (strong, nonatomic) DTASelectCityViewController *citySelectionVC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomConstraint;

@end

@implementation DTASearchOptionsViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    self.advancedSearchOptionsButton.layer.cornerRadius = 20.0f;
    self.advancedSearchOptionsButton.layer.borderWidth = 1.0f;
    self.advancedSearchOptionsButton.layer.borderColor = [colorCreamCan CGColor];
    
    self.saveFilterButton.layer.cornerRadius = 20.0f;
    self.saveFilterButton.layer.borderWidth = 1.0f;
    self.saveFilterButton.layer.borderColor = [colorCreamCan CGColor];
    self.saveFilterButton.backgroundColor = colorCreamCan;
    
    self.resetFilterButton.layer.cornerRadius = 20.0f;
    self.resetFilterButton.layer.borderWidth = 1.0f;
    self.resetFilterButton.layer.borderColor = [colorCreamCan CGColor];
    
    self.navigationController.navigationBar.barTintColor = colorCreamCan;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName :[UIColor whiteColor]};
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

    //--- picker view preset
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.backgroundColor = [UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:0.6];
    self.pickerView.delegate = self;

    __weak typeof(self) weakSelf = self;
    
    [DTAAPI fetchStaticResourceWithKey:DTAAPIStaticResourcesTypeRelationships completion:^(NSError *error, NSArray *result) {
         if (!error) {
             NSLog(@"Success fetchStaticResource Relationship request");
             
             NSMutableArray *relationships = [NSMutableArray arrayWithArray:result];
             [relationships insertObject:@"No Preference" atIndex:0];
             [DTASearchOptionsManager sharedManager].arrayOfRelationships = relationships;
             [weakSelf.pickerView reloadAllComponents];
         }
         else {
             NSLog(@"Fail fetchStaticResource Relationships request");
         }
     }];
    
    [DTAAPI fetchStaticResourceWithKey:DTAAPIStaticResourcesTypeEthnics completion:^(NSError *error, NSArray *result) {
         if (!error) {
             NSLog(@"Success fetchStaticResource Ethnitic request");
             NSMutableArray *ethnics = [NSMutableArray arrayWithArray:result];
             [ethnics insertObject:@"No Preference" atIndex:0];
             [DTASearchOptionsManager sharedManager].arrayOfEthnics = ethnics;
             [weakSelf.pickerView reloadAllComponents];
         }
         else {
             NSLog(@"Fail fetchStaticResource Ethnitic request");
         }
     }];
    
    [DTAAPI fetchStaticResourceWithKey:DTAAPIStaticResourcesTypeProfessions completion:^(NSError *error, NSArray *result) {
         if (!error) {
             NSLog(@"Success fetchStaticResource Professions request");
             NSMutableArray *professtions = [NSMutableArray arrayWithArray:result];
             [professtions insertObject:@"No Preference" atIndex:0];
             [DTASearchOptionsManager sharedManager].arrayOfProfessions = professtions;
             [weakSelf.pickerView reloadAllComponents];
         }
         else {
             NSLog(@"Fail fetchStaticResource Professions request");
         }
     }];
    
    [DTAAPI fetchStaticResourceWithKey:DTAAPIStaticResourcesTypeEducations completion:^(NSError *error, NSArray *result) {
         if (!error) {
             NSLog(@"Success fetchStaticResource Educations request");
             NSMutableArray *educations = [NSMutableArray arrayWithArray:result];
             [educations insertObject:@"No Preference" atIndex:0];
             [DTASearchOptionsManager sharedManager].arrayOfEducations = educations;
             [weakSelf.pickerView reloadAllComponents];
         }
         else {
             NSLog(@"Fail fetchStaticResource Educations request");
         }
     }];
    
    [DTAAPI fetchStaticResourceWithKey:DTAAPIStaticResourcesTypeCountries completion:^(NSError *error, NSArray *result) {
         if (!error) {
             NSLog(@"Success fetchStaticResource Countries request");
             NSMutableArray *countries = [NSMutableArray arrayWithArray:result];
             [countries insertObject:@"No Preference" atIndex:0];
             [DTASearchOptionsManager sharedManager].arrayOfCountries = countries;
             [weakSelf.pickerView reloadAllComponents];
         }
         else {
             NSLog(@"Fail fetchStaticResource Countries request");
         }
     }];
    
    [DTAAPI fetchStaticResourceWithKey:DTAAPIStaticResourcesTypeReligions completion:^(NSError *error, NSArray *result) {
         if (!error) {
             NSLog(@"Success fetchStaticResource Religion request");
             NSMutableArray *religions = [NSMutableArray arrayWithArray:result];
             [religions insertObject:@"No Preference" atIndex:0];
             [DTASearchOptionsManager sharedManager].arrayOfReligions = religions;
             [weakSelf.pickerView reloadAllComponents];
         }
         else {
             NSLog(@"Fail fetchStaticResource Religion request");
         }
     }];
    
    [DTAAPI fetchStaticResourceWithKey:DTAAPIStaticResourcesTypeGoals completion:^(NSError *error, NSArray *result) {
        if (!error) {
            NSLog(@"Success fetchStaticResource Goals response");
            NSMutableArray *goalsArr = [NSMutableArray arrayWithArray:result];
            [goalsArr insertObject:@"No Preference" atIndex:0];
            [DTASearchOptionsManager sharedManager].arrayOfGoals = goalsArr;
            [weakSelf.pickerView reloadAllComponents];
        }
        else {
            NSLog(@"Fail fetchStaticResource Goals request");
        }
    }];
    
    [DTAAPI fetchStaticResourceWithKey:DTAAPIStaticResourcesTypeWantKids completion:^(NSError *error, NSArray *result) {
        if (!error) {
            NSLog(@"Success fetchStaticResource WantKids Response");
            NSMutableArray *wantKidsArr = [NSMutableArray arrayWithArray:result];
            [wantKidsArr insertObject:@"No Preference" atIndex:0];
            [DTASearchOptionsManager sharedManager].arrayOfWantKids = wantKidsArr;
            [weakSelf.pickerView reloadAllComponents];
        }
        else {
            NSLog(@"Fail fetchStaticResource wantKids request");
        }
    }];
    
    [DTAAPI fetchStaticResourceWithKey:DTAAPIStaticResourcesTypeHaveKids completion:^(NSError *error, NSArray *result) {
        if (!error) {
            NSLog(@"Success fetchStaticResource HaveKids Response");
            NSMutableArray *haveKidsArr = [NSMutableArray arrayWithArray:result];
            [haveKidsArr insertObject:@"No Preference" atIndex:0];
            [DTASearchOptionsManager sharedManager].arrayOfHaveKids = haveKidsArr;
            [weakSelf.pickerView reloadAllComponents];
        }
        else {
            NSLog(@"Fail fetchStaticResource Religion request");
        }
    }];
    
    [DTAAPI fetchStaticResourceWithKey:DTAAPIStaticResourcesTypeOrientation completion:^(NSError *error, NSArray *result) {
        if (!error) {
            NSLog(@"Success fetchStaticResource orientation Response");
            NSMutableArray *orientationArr = [NSMutableArray arrayWithArray:result];
            [orientationArr insertObject:@"No Preference" atIndex:0];
            [DTASearchOptionsManager sharedManager].arrayOfOrientations = orientationArr;
            [weakSelf.pickerView reloadAllComponents];
        }
        else {
            NSLog(@"Fail fetchStaticResource orientation request");
        }
    }];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.view endEditing:YES];
    
    if (![DTASearchOptionsManager sharedManager].searchOptions.interestedIn) {
        if ([[User currentUser].interestedIn isEqualToString:@"Male"]) {
            self.prefferedGenderSegmentedControl.selectedSegmentIndex = 0;
        }
        else if  ([[User currentUser].interestedIn isEqualToString:@"Female"]) {
            self.prefferedGenderSegmentedControl.selectedSegmentIndex = 1;
        }
    }
    else {
        if ([[DTASearchOptionsManager sharedManager].searchOptions.interestedIn isEqualToString:@"Male"]) {
            self.prefferedGenderSegmentedControl.selectedSegmentIndex = 0;
        }
        else if  ([[DTASearchOptionsManager sharedManager].searchOptions.interestedIn isEqualToString:@"Female"]) {
            self.prefferedGenderSegmentedControl.selectedSegmentIndex = 1;
        }
    }
    
    __weak typeof(self) weakSelf = self;
    
    [self.view addKeyboardPanningWithFrameBasedActionHandler:nil constraintBasedActionHandler:^(CGRect keyboardFrameInView, BOOL opening, BOOL closing) {
         static CGFloat y;
         
         if (opening || y == 0) {
             y = keyboardFrameInView.origin.y + keyboardFrameInView.size.height;
         }
         
         if (closing) {
             weakSelf.tableViewBottomConstraint.constant = 0;
         }
         else {
             weakSelf.tableViewBottomConstraint.constant = y - keyboardFrameInView.origin.y;
         }
     }];

    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view removeKeyboardControl];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:pushCityPickerSegue]) {
        self.citySelectionVC = segue.destinationViewController;
        self.citySelectionVC.delegate = self;
        
        if([DTASearchOptionsManager sharedManager].searchOptions.location.locationTitle.length) {
            self.citySelectionVC.selecedCityStr = [DTASearchOptionsManager sharedManager].searchOptions.location.locationTitle;
        }
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section ==  DTASearchOptionsTableSectionTypeBasicOptions) {
        if (indexPath.row ==  DTABasicSearchOptionsCellTypeDistanceLimit) {
            return 102.0f;
        }
        else if (indexPath.row ==  DTABasicSearchOptionsCellTypeAgesLimit) {
            return 124.0f;
        }
        else {
            return 50.0f;
        }
    }
    else {
        return 50.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section != DTASearchOptionsTableSectionTypeAdvancedOptions) {
        [self.view endEditing:YES];
    }

    if (indexPath.section == DTASearchOptionsTableSectionTypeAdvancedOptions) {
        if (indexPath.row == DTAAdditionalInfoCellTypeLocation) {
            [self.view endEditing:YES];
            [self performSegueWithIdentifier:pushCityPickerSegue sender:self];
            //DEV Places presentview
//            GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
//            acController.delegate = self;
//            [self presentViewController:acController animated:YES completion:nil];
        }

        self.pickerState = (DTAAdditionalInfoCellType) indexPath.row;
        [self.pickerView reloadAllComponents];
        DTAAdditionalInfoCell *cell = (DTAAdditionalInfoCell *) [self.tableView cellForRowAtIndexPath:indexPath];
        [cell makeFieldFirstResponder];
        [self.view endEditing:YES];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    static const NSInteger numberOfRowsInFirstSection = 2;
    static const NSInteger numberOfRowsInSecondSection = 11;

    if (section == DTASearchOptionsTableSectionTypeBasicOptions) {
        return numberOfRowsInFirstSection;
    }
    else if (section == DTASearchOptionsTableSectionTypeAdvancedOptions) {
        if (self.isAdvancedOptionsButtonTapped) {
            return numberOfRowsInSecondSection;
        }
        else {
            return 0;
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section ==  DTASearchOptionsTableSectionTypeBasicOptions) {
        if (indexPath.row ==  DTABasicSearchOptionsCellTypeDistanceLimit) {
            DTADistanceLimitCell *cell = [tableView dequeueReusableCellWithIdentifier:[DTADistanceLimitCell reuseIdentifier]];
            
            if (!cell) {
                cell = [[DTADistanceLimitCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[DTADistanceLimitCell reuseIdentifier]];
            }
            
            [cell configureCellWithInputView:nil sender:nil];
            cell.distanceSlider.value = [DTASearchOptionsManager sharedManager].searchOptions.nearbyRadius.floatValue;
            
            if (cell.distanceSlider.value <= 300) {
                  cell.selectedDistaceLabel.text = [NSString stringWithFormat:@"%i miles", (int) cell.distanceSlider.value];
            }
            else {
                cell.selectedDistaceLabel.text = @"300+ miles";
            }
            
            return cell;
        }
        else if (indexPath.row ==  DTABasicSearchOptionsCellTypeAgesLimit) {
            DTAAgesLimitCell *cell = [tableView dequeueReusableCellWithIdentifier:[DTAAgesLimitCell reuseIdentifier]];
          
            if (!cell) {
                cell = [[DTAAgesLimitCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[DTAAgesLimitCell reuseIdentifier]];
            }
            
            [cell configureCellWithInputView:nil sender:nil];

            cell.agesIntervalSlider.rightValue = [DTASearchOptionsManager sharedManager].searchOptions.ageTo.floatValue;
            cell.agesIntervalSlider.leftValue = [DTASearchOptionsManager sharedManager].searchOptions.ageFrom.floatValue;

            cell.selectedAgeRangeLabel.text = [NSString stringWithFormat:@"%i-%i", (int) cell.agesIntervalSlider.leftValue, (int) cell.agesIntervalSlider.rightValue];
            return cell;
        }
        else {
            return nil;
        }
    }
    else if(indexPath.section == DTASearchOptionsTableSectionTypeAdvancedOptions) {
        
        DTAAdditionalInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[DTAAdditionalInfoCell reuseIdentifier]];
        
        if (!cell) {
            cell = [[DTAAdditionalInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[DTAAdditionalInfoCell reuseIdentifier]];
        }

        cell.delegate = self;
        [cell configureCellAtIndex:indexPath.row inputView:self.pickerView sender:self];
        
        if (indexPath.row == DTAAdditionalInfoCellTypeLocation) {
            cell.fieldValue.userInteractionEnabled = NO;
            [cell updateFieldValue:[DTASearchOptionsManager sharedManager].searchOptions.location.locationTitle];
        }
        
        return cell;
    }
    else {
        return nil;
    }
}

#pragma mark - UIPickerView Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView; {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component; {
    switch (self.pickerState) {
        case DTAAdditionalInfoCellTypeLocation:
            return 1;
        
        case DTAAdditionalInfoCellTypeEthnicGroup:
            return [DTASearchOptionsManager sharedManager].arrayOfEthnics.count;
        
        case DTAAdditionalInfoCellTypeRelationship:
            return [DTASearchOptionsManager sharedManager].arrayOfRelationships.count;
        
        case DTAAdditionalInfoCellTypeProfession:
            return [DTASearchOptionsManager sharedManager].arrayOfProfessions.count;
        
        case DTAAdditionalInfoCellTypeEducation:
            return [DTASearchOptionsManager sharedManager].arrayOfEducations.count;
        
        case DTAAdditionalInfoCellTypeCountryOfOrigin:
            return [DTASearchOptionsManager sharedManager].arrayOfCountries.count;
        
        case DTAAdditionalInfoCellTypeReligion:
            return [DTASearchOptionsManager sharedManager].arrayOfReligions.count;
            
            case DTAAdditionalInfoCellTypeGoals:
            return [DTASearchOptionsManager sharedManager].arrayOfGoals.count;
            
            case DTAAdditionalInfoCellTypeWantKids:
            return [DTASearchOptionsManager sharedManager].arrayOfWantKids.count;
            
            case DTAAdditionalInfoCellTypeHaveKids:
            return [DTASearchOptionsManager sharedManager].arrayOfHaveKids.count;
            
            case DTAAdditionalInfoCellTypeOrientation:
            return [DTASearchOptionsManager sharedManager].arrayOfOrientations.count;
        
        default:
            return 0;
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (self.pickerState) {
        case DTAAdditionalInfoCellTypeLocation: {
            return;
        }
 
        case DTAAdditionalInfoCellTypeEthnicGroup: {
            if ([[DTASearchOptionsManager sharedManager].arrayOfEthnics[row] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = [DTASearchOptionsManager sharedManager].arrayOfEthnics[row];
                
                Ethnic *ethnic = [Ethnic MR_createEntityInContext:[DTASearchOptionsManager sharedManager].searchOptions.managedObjectContext];
                ethnic.ethnicId = dict[@"id"];
                ethnic.ethnicTitle = dict[@"title"];
                NSNumber *number = [NSNumber numberWithBool:dict[@"isDefault"]];
                ethnic.isDefault = number;
                
                [DTASearchOptionsManager sharedManager].searchOptions.ethnic = ethnic;
                
                NSIndexPath *ip = [NSIndexPath indexPathForRow:DTAAdditionalInfoCellTypeEthnicGroup inSection:DTASearchOptionsTableSectionTypeAdvancedOptions];
                
                DTAAdditionalInfoCell *cell = ( DTAAdditionalInfoCell *)[self.tableView cellForRowAtIndexPath:ip];
                
                [cell updateFieldValue:[DTASearchOptionsManager sharedManager].searchOptions.ethnic.ethnicTitle];
                cell.valueDictionary = @{@"id" : [DTASearchOptionsManager sharedManager].searchOptions.ethnic.ethnicId};
            }
            else {
                [DTASearchOptionsManager sharedManager].searchOptions.ethnic = nil;
                
                NSIndexPath *ip = [NSIndexPath indexPathForRow:DTAAdditionalInfoCellTypeEthnicGroup inSection:DTASearchOptionsTableSectionTypeAdvancedOptions];
                
                DTAAdditionalInfoCell *cell = ( DTAAdditionalInfoCell *)[self.tableView cellForRowAtIndexPath:ip];
                
                [cell updateFieldValue:@"No Preference"];
                cell.valueDictionary = nil;
            }
            
            break;
        }
            
        case DTAAdditionalInfoCellTypeRelationship: {
            if ([[DTASearchOptionsManager sharedManager].arrayOfRelationships[row] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = [DTASearchOptionsManager sharedManager].arrayOfRelationships[row];

                Relationship *relationship = [Relationship MR_createEntityInContext:[DTASearchOptionsManager sharedManager].searchOptions.managedObjectContext];
                relationship.relationshipId = dict[@"id"];
                relationship.relationshipTitle = dict[@"title"];
                NSNumber *number = [NSNumber numberWithBool:dict[@"isDefault"]];
                relationship.isDefault = number;

                [DTASearchOptionsManager sharedManager].searchOptions.relationship = relationship;

                NSIndexPath *ip = [NSIndexPath indexPathForRow:DTAAdditionalInfoCellTypeRelationship inSection:DTASearchOptionsTableSectionTypeAdvancedOptions];

                DTAAdditionalInfoCell *cell = (DTAAdditionalInfoCell *) [self.tableView cellForRowAtIndexPath:ip];
                [cell updateFieldValue:[DTASearchOptionsManager sharedManager].searchOptions.relationship.relationshipTitle];
                cell.valueDictionary = @{@"id" : [DTASearchOptionsManager sharedManager].searchOptions.relationship.relationshipId};
            }
            else {
                [DTASearchOptionsManager sharedManager].searchOptions.relationship =nil;

                NSIndexPath *ip = [NSIndexPath indexPathForRow:DTAAdditionalInfoCellTypeRelationship inSection:DTASearchOptionsTableSectionTypeAdvancedOptions];

                DTAAdditionalInfoCell *cell = (DTAAdditionalInfoCell *) [self.tableView cellForRowAtIndexPath:ip];
                [cell updateFieldValue:@"No Preference"];
                cell.valueDictionary = nil;
            }
            
            break;
        }
            
        case DTAAdditionalInfoCellTypeProfession: {
            if ([[DTASearchOptionsManager sharedManager].arrayOfProfessions[row] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = [DTASearchOptionsManager sharedManager].arrayOfProfessions[row];

                Profession *profession = [Profession MR_createEntityInContext:[DTASearchOptionsManager sharedManager].searchOptions.managedObjectContext];
                profession.professionId = dict[@"id"];
                profession.professionTitle = dict[@"title"];
                NSNumber *number = [NSNumber numberWithBool:dict[@"isDefault"]];
                profession.isDefault = number;

                [DTASearchOptionsManager sharedManager].searchOptions.profession = profession;

                NSIndexPath *ip = [NSIndexPath indexPathForRow:DTAAdditionalInfoCellTypeProfession inSection:DTASearchOptionsTableSectionTypeAdvancedOptions];

                DTAAdditionalInfoCell *cell = (DTAAdditionalInfoCell *) [self.tableView cellForRowAtIndexPath:ip];

                [cell updateFieldValue:[DTASearchOptionsManager sharedManager].searchOptions.profession.professionTitle];
                cell.valueDictionary = @{@"id" : [DTASearchOptionsManager sharedManager].searchOptions.profession.professionId};
            }
            else {
                [DTASearchOptionsManager sharedManager].searchOptions.profession = nil;

                NSIndexPath *ip = [NSIndexPath indexPathForRow:DTAAdditionalInfoCellTypeProfession inSection:DTASearchOptionsTableSectionTypeAdvancedOptions];

                DTAAdditionalInfoCell *cell = (DTAAdditionalInfoCell *) [self.tableView cellForRowAtIndexPath:ip];

                [cell updateFieldValue:@"No Preference"];
                cell.valueDictionary = nil;
            }
            
            break;
        }
            
        case DTAAdditionalInfoCellTypeEducation: {
            if ([[DTASearchOptionsManager sharedManager].arrayOfEducations[row] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = [DTASearchOptionsManager sharedManager].arrayOfEducations[row];

                Education *education = [Education MR_createEntityInContext:[DTASearchOptionsManager sharedManager].searchOptions.managedObjectContext];
                education.educationId = dict[@"id"];
                education.educationTitle = dict[@"title"];
                NSNumber *number = [NSNumber numberWithBool:dict[@"isDefault"]];
                education.isDefault = number;

                [DTASearchOptionsManager sharedManager].searchOptions.education = education;

                NSIndexPath *ip = [NSIndexPath indexPathForRow:DTAAdditionalInfoCellTypeEducation inSection:DTASearchOptionsTableSectionTypeAdvancedOptions];

                DTAAdditionalInfoCell *cell = (DTAAdditionalInfoCell *) [self.tableView cellForRowAtIndexPath:ip];

                [cell updateFieldValue:[DTASearchOptionsManager sharedManager].searchOptions.education.educationTitle];
                cell.valueDictionary = @{@"id" : [DTASearchOptionsManager sharedManager].searchOptions.education.educationId};
            }
            else {
                [DTASearchOptionsManager sharedManager].searchOptions.education = nil;

                NSIndexPath *ip = [NSIndexPath indexPathForRow:DTAAdditionalInfoCellTypeEducation inSection:DTASearchOptionsTableSectionTypeAdvancedOptions];

                DTAAdditionalInfoCell *cell = (DTAAdditionalInfoCell *) [self.tableView cellForRowAtIndexPath:ip];

                [cell updateFieldValue:@"No Preference"];
                cell.valueDictionary = nil;
            }
            
            break;
        }
            
        case DTAAdditionalInfoCellTypeCountryOfOrigin: {
            if ([[DTASearchOptionsManager sharedManager].arrayOfCountries[row] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = [DTASearchOptionsManager sharedManager].arrayOfCountries[row];

                Country *country = [Country MR_createEntityInContext:[DTASearchOptionsManager sharedManager].searchOptions.managedObjectContext];
                country.countryId = dict[@"id"];
                country.countryTitle = dict[@"title"];
                NSNumber *number = [NSNumber numberWithBool:dict[@"isDefault"]];
                country.isDefault = number;

                [DTASearchOptionsManager sharedManager].searchOptions.country = country;

                NSIndexPath *ip = [NSIndexPath indexPathForRow:DTAAdditionalInfoCellTypeCountryOfOrigin inSection:DTASearchOptionsTableSectionTypeAdvancedOptions];

                DTAAdditionalInfoCell *cell = (DTAAdditionalInfoCell *) [self.tableView cellForRowAtIndexPath:ip];

                [cell updateFieldValue:[DTASearchOptionsManager sharedManager].searchOptions.country.countryTitle];
                cell.valueDictionary = @{@"id" : [DTASearchOptionsManager sharedManager].searchOptions.country.countryId};
            }
            else {
                [DTASearchOptionsManager sharedManager].searchOptions.country = nil;

                NSIndexPath *ip = [NSIndexPath indexPathForRow:DTAAdditionalInfoCellTypeCountryOfOrigin inSection:DTASearchOptionsTableSectionTypeAdvancedOptions];

                DTAAdditionalInfoCell *cell = (DTAAdditionalInfoCell *) [self.tableView cellForRowAtIndexPath:ip];

                [cell updateFieldValue:@"No Preferece"];
                cell.valueDictionary = nil;
            }
            
            break;
        }
            
        case DTAAdditionalInfoCellTypeReligion: {
            if ([[DTASearchOptionsManager sharedManager].arrayOfReligions[row] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = [DTASearchOptionsManager sharedManager].arrayOfReligions[row];

                Religion *religion = [Religion MR_createEntityInContext:[DTASearchOptionsManager sharedManager].searchOptions.managedObjectContext];
                religion.religionTitle = dict[@"title"];
                religion.religionId = dict[@"id"];
                NSNumber *number = [NSNumber numberWithBool:dict[@"isDefault"]];
                religion.isDefault = number;

                [DTASearchOptionsManager sharedManager].searchOptions.religion = religion;

                NSIndexPath *ip = [NSIndexPath indexPathForRow:DTAAdditionalInfoCellTypeReligion inSection:DTASearchOptionsTableSectionTypeAdvancedOptions];

                DTAAdditionalInfoCell *cell = (DTAAdditionalInfoCell *) [self.tableView cellForRowAtIndexPath:ip];

                [cell updateFieldValue:[DTASearchOptionsManager sharedManager].searchOptions.religion.religionTitle];
                cell.valueDictionary = @{@"id" : [DTASearchOptionsManager sharedManager].searchOptions.religion.religionId};
            }
            else {
                [DTASearchOptionsManager sharedManager].searchOptions.religion = nil;

                NSIndexPath *ip = [NSIndexPath indexPathForRow:DTAAdditionalInfoCellTypeReligion inSection:DTASearchOptionsTableSectionTypeAdvancedOptions];

                DTAAdditionalInfoCell *cell = (DTAAdditionalInfoCell *) [self.tableView cellForRowAtIndexPath:ip];

                [cell updateFieldValue:@"No Preference"];
                cell.valueDictionary = nil;
            }

            break;
        }

            case DTAAdditionalInfoCellTypeGoals: {
                if ([[DTASearchOptionsManager sharedManager].arrayOfGoals[row] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dict = [DTASearchOptionsManager sharedManager].arrayOfGoals[row];

                    Goals *goals = [Goals MR_createEntityInContext:[DTASearchOptionsManager sharedManager].searchOptions.managedObjectContext];
                    goals.goalTitle = dict[@"title"];
                    goals.goalId = dict[@"id"];
                    NSNumber *number = [NSNumber numberWithBool:dict[@"isDefault"]];
                    goals.isDefault = number;

                    [DTASearchOptionsManager sharedManager].searchOptions.goals = goals;

                    NSIndexPath *ip = [NSIndexPath indexPathForRow:DTAAdditionalInfoCellTypeGoals inSection:DTASearchOptionsTableSectionTypeAdvancedOptions];

                    DTAAdditionalInfoCell *cell = (DTAAdditionalInfoCell *) [self.tableView cellForRowAtIndexPath:ip];

                    [cell updateFieldValue:[DTASearchOptionsManager sharedManager].searchOptions.goals.goalTitle];
                    cell.valueDictionary = @{@"id" : [DTASearchOptionsManager sharedManager].searchOptions.goals.goalId};
                }
                else {
                    [DTASearchOptionsManager sharedManager].searchOptions.goals = nil;

                    NSIndexPath *ip = [NSIndexPath indexPathForRow:DTAAdditionalInfoCellTypeGoals inSection:DTASearchOptionsTableSectionTypeAdvancedOptions];

                    DTAAdditionalInfoCell *cell = (DTAAdditionalInfoCell *) [self.tableView cellForRowAtIndexPath:ip];

                    [cell updateFieldValue:@"No Preference"];
                    cell.valueDictionary = nil;
                }

                break;
            }
            
            case DTAAdditionalInfoCellTypeWantKids: {
                if ([[DTASearchOptionsManager sharedManager].arrayOfWantKids[row] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dict = [DTASearchOptionsManager sharedManager].arrayOfWantKids[row];

                    WantKids *wantKids = [WantKids MR_createEntityInContext:[DTASearchOptionsManager sharedManager].searchOptions.managedObjectContext];
                    wantKids.wantKidsTitle = dict[@"title"];
                    wantKids.wantKidsId = dict[@"id"];
                    NSNumber *number = [NSNumber numberWithBool:dict[@"isDefault"]];
                    wantKids.isDefault = number;

                    [DTASearchOptionsManager sharedManager].searchOptions.wantKids = wantKids;

                    NSIndexPath *ip = [NSIndexPath indexPathForRow:DTAAdditionalInfoCellTypeWantKids inSection:DTASearchOptionsTableSectionTypeAdvancedOptions];

                    DTAAdditionalInfoCell *cell = (DTAAdditionalInfoCell *) [self.tableView cellForRowAtIndexPath:ip];

                    [cell updateFieldValue:[DTASearchOptionsManager sharedManager].searchOptions.wantKids.wantKidsTitle];
                    cell.valueDictionary = @{@"id" : [DTASearchOptionsManager sharedManager].searchOptions.wantKids.wantKidsId};
                }
                else {
                    [DTASearchOptionsManager sharedManager].searchOptions.wantKids = nil;

                    NSIndexPath *ip = [NSIndexPath indexPathForRow:DTAAdditionalInfoCellTypeWantKids inSection:DTASearchOptionsTableSectionTypeAdvancedOptions];

                    DTAAdditionalInfoCell *cell = (DTAAdditionalInfoCell *) [self.tableView cellForRowAtIndexPath:ip];

                    [cell updateFieldValue:@"No Preference"];
                    cell.valueDictionary = nil;
                }

                break;
            }
            
            case DTAAdditionalInfoCellTypeHaveKids: {
                if ([[DTASearchOptionsManager sharedManager].arrayOfHaveKids[row] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dict = [DTASearchOptionsManager sharedManager].arrayOfHaveKids[row];

                    HaveKids *haveKids = [HaveKids MR_createEntityInContext:[DTASearchOptionsManager sharedManager].searchOptions.managedObjectContext];
                    haveKids.haveKidsTitle = dict[@"title"];
                    haveKids.haveKidsId = dict[@"id"];
                    NSNumber *number = [NSNumber numberWithBool:dict[@"isDefault"]];
                    haveKids.isDefault = number;

                    [DTASearchOptionsManager sharedManager].searchOptions.haveKids = haveKids;

                    NSIndexPath *ip = [NSIndexPath indexPathForRow:DTAAdditionalInfoCellTypeHaveKids inSection:DTASearchOptionsTableSectionTypeAdvancedOptions];

                    DTAAdditionalInfoCell *cell = (DTAAdditionalInfoCell *) [self.tableView cellForRowAtIndexPath:ip];

                    [cell updateFieldValue:[DTASearchOptionsManager sharedManager].searchOptions.haveKids.haveKidsTitle];
                    cell.valueDictionary = @{@"id" : [DTASearchOptionsManager sharedManager].searchOptions.haveKids.haveKidsId};
                }
                else {
                    [DTASearchOptionsManager sharedManager].searchOptions.haveKids = nil;

                    NSIndexPath *ip = [NSIndexPath indexPathForRow:DTAAdditionalInfoCellTypeHaveKids inSection:DTASearchOptionsTableSectionTypeAdvancedOptions];

                    DTAAdditionalInfoCell *cell = (DTAAdditionalInfoCell *) [self.tableView cellForRowAtIndexPath:ip];

                    [cell updateFieldValue:@"No Preference"];
                    cell.valueDictionary = nil;
                }

                break;
            }
            
            case DTAAdditionalInfoCellTypeOrientation: {
                if ([[DTASearchOptionsManager sharedManager].arrayOfOrientations[row] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dict = [DTASearchOptionsManager sharedManager].arrayOfOrientations[row];

                    Orientation *orientation = [Orientation MR_createEntityInContext:[DTASearchOptionsManager sharedManager].searchOptions.managedObjectContext];
                    orientation.orientationTitle = dict[@"title"];
                    orientation.orientationId = dict[@"id"];
                    NSNumber *number = [NSNumber numberWithBool:dict[@"isDefault"]];
                    orientation.isDefault = number;

                    [DTASearchOptionsManager sharedManager].searchOptions.orientation = orientation;

                    NSIndexPath *ip = [NSIndexPath indexPathForRow:DTAAdditionalInfoCellTypeOrientation inSection:DTASearchOptionsTableSectionTypeAdvancedOptions];

                    DTAAdditionalInfoCell *cell = (DTAAdditionalInfoCell *) [self.tableView cellForRowAtIndexPath:ip];

                    [cell updateFieldValue:[DTASearchOptionsManager sharedManager].searchOptions.orientation.orientationTitle];
                    cell.valueDictionary = @{@"id" : [DTASearchOptionsManager sharedManager].searchOptions.orientation.orientationId};
                }
                else {
                    [DTASearchOptionsManager sharedManager].searchOptions.orientation = nil;

                    NSIndexPath *ip = [NSIndexPath indexPathForRow:DTAAdditionalInfoCellTypeOrientation inSection:DTASearchOptionsTableSectionTypeAdvancedOptions];

                    DTAAdditionalInfoCell *cell = (DTAAdditionalInfoCell *) [self.tableView cellForRowAtIndexPath:ip];

                    [cell updateFieldValue:@"No Preference"];
                    cell.valueDictionary = nil;
                }

                break;
            }
        default:
            break;
    }

    [self.pickerView reloadAllComponents];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel* tView = (UILabel*)view;
    
    if (!tView) {
        tView = [[UILabel alloc] init];
        tView.font = [UIFont fontWithName:@"PTSans-Bold" size:24];
        tView.textColor = colorCreamCan;
        tView.textAlignment = NSTextAlignmentCenter;
    }

    switch (self.pickerState) {
        case  DTAAdditionalInfoCellTypeLocation: {
            // NSDictionary *dict = self.arrayOfEthnitic[row];
            // tView.text = @"Select City";
            // break;
        }
            
        case DTAAdditionalInfoCellTypeEthnicGroup: {
            if ([[DTASearchOptionsManager sharedManager].arrayOfEthnics[row] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = [DTASearchOptionsManager sharedManager].arrayOfEthnics[row];
                tView.text = dict[@"title"];
            }
            else {
                tView.text = [DTASearchOptionsManager sharedManager].arrayOfEthnics[row];
            }
            
            break;
        }
            
        case DTAAdditionalInfoCellTypeRelationship: {
            if ([[DTASearchOptionsManager sharedManager].arrayOfRelationships[row] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = [DTASearchOptionsManager sharedManager].arrayOfRelationships[row];
                tView.text = dict[@"title"];
            }
            else {
                tView.text = [DTASearchOptionsManager sharedManager].arrayOfRelationships[row];
            }
            
            break;
        }
            
        case DTAAdditionalInfoCellTypeProfession: {
            if ([[DTASearchOptionsManager sharedManager].arrayOfProfessions[row] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = [DTASearchOptionsManager sharedManager].arrayOfProfessions[row];
                tView.text = dict[@"title"];
            }
            else {
                tView.text = [DTASearchOptionsManager sharedManager].arrayOfProfessions[row];
            }
            
            break;
        }
            
        case DTAAdditionalInfoCellTypeEducation: {
            if ([[DTASearchOptionsManager sharedManager].arrayOfEducations[row] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = [DTASearchOptionsManager sharedManager].arrayOfEducations[row];
                tView.text = dict[@"title"];
            }
            else {
                tView.text = [DTASearchOptionsManager sharedManager].arrayOfEducations[row];
            }
            
            break;
        }
            
        case DTAAdditionalInfoCellTypeCountryOfOrigin: {
            if ([[DTASearchOptionsManager sharedManager].arrayOfCountries[row] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = [DTASearchOptionsManager sharedManager].arrayOfCountries[row];
                tView.text = dict[@"title"];
            }
            else {
                tView.text = [DTASearchOptionsManager sharedManager].arrayOfCountries[row];
            }
            
            break;
        }
            
        case DTAAdditionalInfoCellTypeReligion: {
            if ([[DTASearchOptionsManager sharedManager].arrayOfReligions[row] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = [DTASearchOptionsManager sharedManager].arrayOfReligions[row];
                tView.text = dict[@"title"];
            }
            else {
                tView.text = [DTASearchOptionsManager sharedManager].arrayOfReligions[row];
            }
            
            break;
        }
            
        case DTAAdditionalInfoCellTypeGoals: {
            if ([[DTASearchOptionsManager sharedManager].arrayOfGoals[row] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = [DTASearchOptionsManager sharedManager].arrayOfGoals[row];
                tView.text = dict[@"title"];
            }
            else {
                tView.text = [DTASearchOptionsManager sharedManager].arrayOfGoals[row];
            }
            
            break;
        }
            
        case DTAAdditionalInfoCellTypeWantKids: {
            if ([[DTASearchOptionsManager sharedManager].arrayOfWantKids[row] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = [DTASearchOptionsManager sharedManager].arrayOfWantKids[row];
                tView.text = dict[@"title"];
            }
            else {
                tView.text = [DTASearchOptionsManager sharedManager].arrayOfWantKids[row];
            }
            
            break;
        }
            
        case DTAAdditionalInfoCellTypeHaveKids: {
            if ([[DTASearchOptionsManager sharedManager].arrayOfHaveKids[row] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = [DTASearchOptionsManager sharedManager].arrayOfHaveKids[row];
                tView.text = dict[@"title"];
            }
            else {
                tView.text = [DTASearchOptionsManager sharedManager].arrayOfHaveKids[row];
            }
            
            break;
        }
            
        case DTAAdditionalInfoCellTypeOrientation: {
            if ([[DTASearchOptionsManager sharedManager].arrayOfOrientations[row] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = [DTASearchOptionsManager sharedManager].arrayOfOrientations[row];
                tView.text = dict[@"title"];
            }
            else {
                tView.text = [DTASearchOptionsManager sharedManager].arrayOfOrientations[row];
            }
            
            break;
        }
            
            
        default:
            tView.text = @"Undefined";
            break;
    }
    
    return tView;
}

- (NSInteger)indexOfSelectedRowForIndexPath:(NSIndexPath *)indexPath {
   DTAAdditionalInfoCell *cell = (DTAAdditionalInfoCell *) [self.tableView cellForRowAtIndexPath:indexPath];
    
    switch (indexPath.row) {
        case DTAAdditionalInfoCellTypeEthnicGroup: {
            NSInteger noPreferenceIndex = [[DTASearchOptionsManager sharedManager].arrayOfEthnics indexOfObject:@"No Preference"];
            
            NSMutableArray *tempAr = [NSMutableArray arrayWithArray:[DTASearchOptionsManager sharedManager].arrayOfEthnics];
            
            if(tempAr.count) {
                [tempAr removeObjectAtIndex:noPreferenceIndex];
                
                NSArray *filteredarray = [tempAr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(title == %@)", [cell fieldValue].text]];
                
                if(filteredarray.count > 0) {
                    return [tempAr indexOfObject:filteredarray[0]];
                }
                else {
                    return noPreferenceIndex;
                }
            }
            else {
                return 0;
            }
        }
            
        case DTAAdditionalInfoCellTypeRelationship: {
            NSInteger noPreferenceIndex = [[DTASearchOptionsManager sharedManager].arrayOfRelationships indexOfObject:@"No Preference"];
            
            NSMutableArray *tempAr = [NSMutableArray arrayWithArray:[DTASearchOptionsManager sharedManager].arrayOfRelationships];
            
            if(tempAr.count) {
                [tempAr removeObjectAtIndex:noPreferenceIndex];
                
                NSArray *filteredarray = [tempAr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(title == %@)", [cell fieldValue].text]];
                
                if(filteredarray.count > 0) {
                    return [tempAr indexOfObject:filteredarray[0]];
                }
                else {
                    return noPreferenceIndex;
                }
            }
            else {
                return 0;
            }
        }
            
        case DTAAdditionalInfoCellTypeProfession: {
            NSInteger noPreferenceIndex = [[DTASearchOptionsManager sharedManager].arrayOfProfessions indexOfObject:@"No Preference"];
            
            NSMutableArray *tempAr = [NSMutableArray arrayWithArray:[DTASearchOptionsManager sharedManager].arrayOfProfessions];
            
            if(tempAr.count) {
                [tempAr removeObjectAtIndex:noPreferenceIndex];
                
                NSArray *filteredarray = [tempAr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(title == %@)", [cell fieldValue].text]];
                
                if(filteredarray.count > 0) {
                    return [tempAr indexOfObject:filteredarray[0]];
                }
                else {
                    return noPreferenceIndex;
                }
            }
            else {
                return 0;
            }
        }
            
        case DTAAdditionalInfoCellTypeEducation: {
            NSInteger noPreferenceIndex = [[DTASearchOptionsManager sharedManager].arrayOfEducations indexOfObject:@"No Preference"];
            
            NSMutableArray *tempAr = [NSMutableArray arrayWithArray:[DTASearchOptionsManager sharedManager].arrayOfEducations];
            
            if(tempAr.count) {
                [tempAr removeObjectAtIndex:noPreferenceIndex];
                
                NSArray *filteredarray = [tempAr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(title == %@)", [cell fieldValue].text]];
                
                if(filteredarray.count > 0) {
                    return [tempAr indexOfObject:filteredarray[0]];
                }
                else {
                    return noPreferenceIndex;
                }
            }
            else {
                return 0;
            }
        }
            
        case DTAAdditionalInfoCellTypeCountryOfOrigin: {
            NSInteger noPreferenceIndex = [[DTASearchOptionsManager sharedManager].arrayOfCountries indexOfObject:@"No Preference"];
            
            NSMutableArray *tempAr = [NSMutableArray arrayWithArray:[DTASearchOptionsManager sharedManager].arrayOfCountries];
            
            if(tempAr.count) {
                [tempAr removeObjectAtIndex:noPreferenceIndex];
                
                NSArray *filteredarray = [tempAr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(title == %@)", [cell fieldValue].text]];
                
                if(filteredarray.count > 0) {
                    return [tempAr indexOfObject:filteredarray[0]];
                }
                else {
                    return noPreferenceIndex;
                }
            }
            else {
                return 0;
            }
        }
            
        case DTAAdditionalInfoCellTypeReligion: {
            NSInteger noPreferenceIndex = [[DTASearchOptionsManager sharedManager].arrayOfReligions indexOfObject:@"No Preference"];
            
            NSMutableArray *tempAr = [NSMutableArray arrayWithArray:[DTASearchOptionsManager sharedManager].arrayOfReligions];
            
            if(tempAr.count) {
                [tempAr removeObjectAtIndex:noPreferenceIndex];
                
                NSArray *filteredarray = [tempAr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(title == %@)", [cell fieldValue].text]];
                
                if(filteredarray.count > 0) {
                    return [tempAr indexOfObject:filteredarray[0]];
                }
                else {
                    return noPreferenceIndex;
                }
            }
            else {
                return 0;
            }
        }
            
        case DTAAdditionalInfoCellTypeGoals: {
            NSInteger noPreferenceIndex = [[DTASearchOptionsManager sharedManager].arrayOfGoals indexOfObject:@"No Preference"];
            
            NSMutableArray *tempAr = [NSMutableArray arrayWithArray:[DTASearchOptionsManager sharedManager].arrayOfGoals];
            
            if(tempAr.count) {
                [tempAr removeObjectAtIndex:noPreferenceIndex];
                
                NSArray *filteredarray = [tempAr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(title == %@)", [cell fieldValue].text]];
                
                if(filteredarray.count > 0) {
                    return [tempAr indexOfObject:filteredarray[0]];
                }
                else {
                    return noPreferenceIndex;
                }
            }
            else {
                return 0;
            }
        }
            
        case DTAAdditionalInfoCellTypeWantKids: {
            NSInteger noPreferenceIndex = [[DTASearchOptionsManager sharedManager].arrayOfWantKids indexOfObject:@"No Preference"];
            
            NSMutableArray *tempAr = [NSMutableArray arrayWithArray:[DTASearchOptionsManager sharedManager].arrayOfWantKids];
            
            if(tempAr.count) {
                [tempAr removeObjectAtIndex:noPreferenceIndex];
                
                NSArray *filteredarray = [tempAr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(title == %@)", [cell fieldValue].text]];
                
                if(filteredarray.count > 0) {
                    return [tempAr indexOfObject:filteredarray[0]];
                }
                else {
                    return noPreferenceIndex;
                }
            }
            else {
                return 0;
            }
        }
            
        case DTAAdditionalInfoCellTypeHaveKids: {
            NSInteger noPreferenceIndex = [[DTASearchOptionsManager sharedManager].arrayOfHaveKids indexOfObject:@"No Preference"];
            
            NSMutableArray *tempAr = [NSMutableArray arrayWithArray:[DTASearchOptionsManager sharedManager].arrayOfHaveKids];
            
            if(tempAr.count) {
                [tempAr removeObjectAtIndex:noPreferenceIndex];
                
                NSArray *filteredarray = [tempAr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(title == %@)", [cell fieldValue].text]];
                
                if(filteredarray.count > 0) {
                    return [tempAr indexOfObject:filteredarray[0]];
                }
                else {
                    return noPreferenceIndex;
                }
            }
            else {
                return 0;
            }
        }
            
        case DTAAdditionalInfoCellTypeOrientation: {
            NSInteger noPreferenceIndex = [[DTASearchOptionsManager sharedManager].arrayOfOrientations indexOfObject:@"No Preference"];
            
            NSMutableArray *tempAr = [NSMutableArray arrayWithArray:[DTASearchOptionsManager sharedManager].arrayOfOrientations];
            
            if(tempAr.count) {
                [tempAr removeObjectAtIndex:noPreferenceIndex];
                
                NSArray *filteredarray = [tempAr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(title == %@)", [cell fieldValue].text]];
                
                if(filteredarray.count > 0) {
                    return [tempAr indexOfObject:filteredarray[0]];
                }
                else {
                    return noPreferenceIndex;
                }
            }
            else {
                return 0;
            }
        }
            
            
        default:
            break;
    }
    
    return 0;
}

#pragma mark - DTAAdditionalInfoCellDelegate methods

- (void)didTapDoneButtonOnCell:(DTAAdditionalInfoCell *)cell {
    NSInteger selectedRow = [self.pickerView selectedRowInComponent:0];
    [self pickerView:self.pickerView didSelectRow:selectedRow inComponent:0];
}

#pragma mark - UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField; {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:textField.tag inSection:DTASearchOptionsTableSectionTypeAdvancedOptions];
    
    self.pickerState = (DTAAdditionalInfoCellType) indexPath.row;
    [self.pickerView reloadAllComponents];
    
    DTAAdditionalInfoCell *cell = (DTAAdditionalInfoCell *) [self.tableView cellForRowAtIndexPath:indexPath];
    [cell makeFieldFirstResponder];
    [self.pickerView selectRow:[self indexOfSelectedRowForIndexPath:indexPath] inComponent:0 animated:NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField; {
    [self.view endEditing:YES];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return true;
}

#pragma mark - DTACitySelectionVCDelegate

- (void)citySelectionCompletedWithCity:(NSDictionary *)city {
    [DTASearchOptionsManager sharedManager].searchOptions.location.locationTitle = city[@"city"];
    [DTASearchOptionsManager sharedManager].searchOptions.location.latitude  = city[@"latitude"];
    [DTASearchOptionsManager sharedManager].searchOptions.location.longitude = city[@"longitude"];
    [[DTASearchOptionsManager sharedManager] saveChanges];
    [self.tableView reloadData];
}

#pragma mark - IBActions

- (IBAction)tapOnPrefferedGenderSegmentedControl:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        [DTASearchOptionsManager sharedManager].searchOptions.interestedIn = @"Male";
    }
    else if (sender.selectedSegmentIndex == 1) {
        [DTASearchOptionsManager sharedManager].searchOptions.interestedIn = @"Female";
    }
}

- (IBAction)tappedToSelectRow:(UITapGestureRecognizer *)tapRecognizer {
    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat rowHeight = [self.pickerView rowSizeForComponent:0].height;
    
        CGRect selectedRowFrame = CGRectInset(self.pickerView.bounds, 0.0, (CGRectGetHeight(self.pickerView.frame) - rowHeight) / 2.0 );
        
        BOOL userTappedOnSelectedRow = (CGRectContainsPoint(selectedRowFrame, [tapRecognizer locationInView:self.pickerView]));
        
        if (userTappedOnSelectedRow) {
            NSInteger selectedRow = [self.pickerView selectedRowInComponent:0];
            [self pickerView:self.pickerView didSelectRow:selectedRow inComponent:0];
        }
    }
}

- (IBAction)tapOnAdvancedSearchOptionsButton:(UIButton *)sender {
    if (!self.isAdvancedOptionsButtonTapped) {
        self.advancedOptionsButtonTapped = YES;
        
        //DEV
        [self.advancedSearchOptionsButton setTitle:@"Hide Expand Search" forState:UIControlStateNormal];
        }
        else {
            self.advancedOptionsButtonTapped = NO;
            [self.advancedSearchOptionsButton setTitle:@"Expand Search" forState:UIControlStateNormal];
            
//        [self.advancedSearchOptionsButton setTitle:@"Hide Advanced Search Options" forState:UIControlStateNormal];
//    }
//    else {
//        self.advancedOptionsButtonTapped = NO;
//        [self.advancedSearchOptionsButton setTitle:@"Advanced Search Options" forState:UIControlStateNormal];
    }
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
}

- (IBAction)tapOnSaveFilterButton:(UIButton *)sender {
    
    APP_DELEGATE.hud = [[SAMHUDView alloc] initWithTitle:nil];
    [APP_DELEGATE.hud show];
    [[DTASearchOptionsManager sharedManager] saveChanges];
    [APP_DELEGATE.hud dismiss];
    
    [self.tableView reloadData];
    
    if ([_fromHome isEqualToString:@"1"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"" message:@"Search options updated successfully." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        
        [controller addAction:okAction];
        
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (IBAction)tapOnResetFilterButton:(UIButton *)sender {
    
    APP_DELEGATE.hud = [[SAMHUDView alloc] initWithTitle:nil];
    [APP_DELEGATE.hud show];
    
    [DTASearchOptionsManager sharedManager].searchOptions.ageFrom = @(18);
    [DTASearchOptionsManager sharedManager].searchOptions.ageTo = @(80);
    [DTASearchOptionsManager sharedManager].searchOptions.heightFrom = @(48.0f);
    [DTASearchOptionsManager sharedManager].searchOptions.heightTo = @(95.0f);
    [DTASearchOptionsManager sharedManager].searchOptions.nearbyRadius = @(100);
    
    if ([[User currentUser].interestedIn isEqualToString:@"Male"]) {
        self.prefferedGenderSegmentedControl.selectedSegmentIndex = 0;
        [DTASearchOptionsManager sharedManager].searchOptions.interestedIn = @"Male";
    }
    else if ([[User currentUser].interestedIn isEqualToString:@"Female"]) {
        self.prefferedGenderSegmentedControl.selectedSegmentIndex = 1;
        [DTASearchOptionsManager sharedManager].searchOptions.interestedIn = @"Female";
    }
    
    [DTASearchOptionsManager sharedManager].searchOptions.country.countryId = @"";
    [DTASearchOptionsManager sharedManager].searchOptions.country.countryTitle = @"";
    
    [DTASearchOptionsManager sharedManager].searchOptions.education.educationId = @"";
    [DTASearchOptionsManager sharedManager].searchOptions.education.educationTitle = @"";
    
    [DTASearchOptionsManager sharedManager].searchOptions.ethnic.ethnicId = @"";
    [DTASearchOptionsManager sharedManager].searchOptions.ethnic.ethnicTitle = @"";
    
    [DTASearchOptionsManager sharedManager].searchOptions.profession.professionId = @"";
    [DTASearchOptionsManager sharedManager].searchOptions.profession.professionTitle = @"";
    
    [DTASearchOptionsManager sharedManager].searchOptions.location.locationTitle = @"";
    [DTASearchOptionsManager sharedManager].searchOptions.location.longitude = @(0);
    [DTASearchOptionsManager sharedManager].searchOptions.location.latitude = @(0);
    
    [DTASearchOptionsManager sharedManager].searchOptions.relationship.relationshipId = @"";
    [DTASearchOptionsManager sharedManager].searchOptions.relationship.relationshipTitle = @"";
    
    [DTASearchOptionsManager sharedManager].searchOptions.religion.religionId = @"";
    [DTASearchOptionsManager sharedManager].searchOptions.religion.religionTitle = @"";
    
    [DTASearchOptionsManager sharedManager].searchOptions.goals.goalId = @"";
    [DTASearchOptionsManager sharedManager].searchOptions.goals.goalTitle = @"";
    
    [DTASearchOptionsManager sharedManager].searchOptions.wantKids.wantKidsId = @"";
    [DTASearchOptionsManager sharedManager].searchOptions.wantKids.wantKidsTitle = @"";
    
    [DTASearchOptionsManager sharedManager].searchOptions.haveKids.haveKidsId = @"";
    [DTASearchOptionsManager sharedManager].searchOptions.haveKids.haveKidsTitle = @"";
    
    [DTASearchOptionsManager sharedManager].searchOptions.orientation.orientationId = @"";
    [DTASearchOptionsManager sharedManager].searchOptions.orientation.orientationTitle = @"";
    
    [APP_DELEGATE.hud dismiss];
    
    [self.tableView reloadData];
}

- (IBAction)tapOnSaveBarButtonItem:(UIBarButtonItem *)sender {
    [self.view endEditing:YES];
    
    APP_DELEGATE.hud = [[SAMHUDView alloc] initWithTitle:nil];
    [APP_DELEGATE.hud show];
    [[DTASearchOptionsManager sharedManager] saveChanges];
    [APP_DELEGATE.hud dismiss];
    
    [self.tableView reloadData];
    
    if ([_fromHome isEqualToString:@"1"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
