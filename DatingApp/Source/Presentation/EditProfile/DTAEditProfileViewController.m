//
//  DTAEditProfileViewController.m
//  DatingApp
//
//  Created by VLADISLAV KIRIN on 8/25/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import "DTAEditProfileViewController.h"
#import "DTAProfileTableViewCell.h"
#import "DTAProfileTableViewCellAvatar.h"
#import "DTAProfileNavigationTableViewCell.h"
#import "DTASelectCityViewController.h"
#import "DTAProfileSummaryTableViewCell.h"
#import "User+Extension.h"
#import "Location+Extensions.h"
#import "Ethnic+Extensions.h"
#import "Relationship+Extensions.h"
#import "Profession+Extensions.h"
#import "Education+Extensions.h"
#import "Country+Extensions.h"
#import "Religion+Extensions.h"
#import "Goals+Extensions.h"
#import "WantKids+Extensions.h"
#import "HaveKids+Extensions.h"
#import "Orientation+Extensions.h"
#import "DTADraggableImages.h"
#import "Image+Extensions.h"
#import "DTALocationManager.h"
#import "DTAAPI.h"
#import "DAKeyboardControl.h"
#import "DTASearchOptionsManager.h"
#import "FacebookImageVC.h"
#import "DTARegisterViewController.h"
#import "NSManagedObjectContext+MagicalRecordRestKit.h"

static NSUInteger const kImagePickerActionSheetTag = 100;
static NSString *const kMeasumentInches = @"inch";

@interface DTAEditProfileViewController () <UITableViewDataSource, UITableViewDelegate, DTAProfileTableViewCellAvatarDelegate, UIActionSheetDelegate, UIPickerViewDelegate, UITextFieldDelegate, DTAProfileNavigationTableViewCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, DTACitySelectionVCDelegate,UITextViewDelegate, DTAPressAddImage, DTAProfileTableViewCellDelegate>

@property (nonatomic, strong) NSMutableDictionary *profileDict;
@property (nonatomic, strong) UIImage *avatarImage;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) BOOL firstRun;
@property (nonatomic, weak) DTADraggableImages *draggableImages;
@property (nonatomic, strong) DTALocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UITableView *tableOptions;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, assign) DTAProfileCellType pickerState;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, assign) BOOL updateLoc;

@property (strong, nonatomic) NSArray *arrayOfGender;
@property (strong, nonatomic) NSArray *arrayOfInterests;
@property (strong, nonatomic) NSArray *arrayOfEthnitic;
@property (strong, nonatomic) NSArray *arrayOfRelationship;
@property (strong, nonatomic) NSArray *arrayOfProfession;
@property (strong, nonatomic) NSArray *arrayOfEducation;
@property (strong, nonatomic) NSArray *arrayOfCountryOrigin;
@property (strong, nonatomic) NSArray *arrayOfReligion;
@property (strong, nonatomic) NSArray *arrayOfGoals;
@property (strong, nonatomic) NSArray *arrayOfWantKids;
@property (strong, nonatomic) NSArray *arrayOfHaveKids;
@property (strong, nonatomic) NSArray *arrayOfOrientation;
@property (strong, nonatomic) NSMutableArray *arrayOfHeightInches;
@property (strong, nonatomic) NSArray *arrayOfMeasurement;
@property (strong, nonatomic) NSString *selectedCityName;
@property (strong, nonatomic) DTASelectCityViewController *citySelectionVC;
@property (strong, nonatomic) NSString *selectedInterests;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTableOptionsDistanceToBottom;
@property (strong, nonatomic) NSManagedObjectContext *editingContext;
@property (nonatomic, strong) User *user;
@end

@implementation DTAEditProfileViewController

#pragma mark - LifeCycle

- (void)dealloc {
    [self.draggableImages setStopLoad:YES];
}

- (void)updateLocation {
    
    self.locationManager = nil;
    self.updateLoc = NO;
    
    self.locationManager = [DTALocationManager new];
    
    [self.locationManager trackLocationWithCompletionBlock:^(CLLocation *location) {
        if(location) {
            self.updateLoc = YES;
            [DTAAPI profileUpdateLocationWithLocation:location];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationController setNavigationBarHidden:NO];

    [self updateLocation];
    //DEV
    self.user = self.editingUser;
    
    self.firstRun = YES;
//    self.editingContext = [NSManagedObjectContext MR_context];
    
    
    self.editingContext = [NSManagedObjectContext MR_temporaryContext];
    
    //DEV
//    self.editingUser = [[User currentUser] MR_inContext:self.editingContext];
//    self.editingUser = [self.editingUser MR_inContext:self.editingContext];
    
    
    if(self.isFromRegisterVC) {
        self.editingUser = [[User currentUser] MR_inContext:self.editingContext];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bt_back_y"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
        [self setupNavBarWithTitle:@"My Profile"];
        
        if (!self.avatarImage) {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.editingUser.avatar]];
            UIImage *img = [[UIImage alloc] initWithData:data];
            self.avatarImage = img;
        }
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:@YES forKey:@"Logout"];
        [ud synchronize];
    }
    else {
        [self setupNavBarWithTitle:@"Edit Profile"];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bt_nb_apply"] style:UIBarButtonItemStylePlain target:self action:@selector(saveProfile)];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
        self.draggableImages = [[NSBundle mainBundle] loadNibNamed:@"DTADraggableImages" owner:self options:nil][0];
        self.tableOptions.tableHeaderView = self.draggableImages;
        
//        self.draggableImages.user = self.editingUser;
        self.draggableImages.user = self.editingUser;
        [self.draggableImages setImage];
        self.draggableImages.delegate = self;
    }
    
    [self setupBackButton];
    self.tableOptions.separatorColor = [UIColor clearColor];
    
    //--- picker view preset
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.backgroundColor = [UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:0.6];
    self.pickerView.delegate = self;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    [dateComponents setYear:dateComponents.year - 18];
    
    self.datePicker = [[UIDatePicker alloc] init];
    [self.datePicker setDatePickerMode:UIDatePickerModeDate];
    [self.datePicker setMaximumDate:[calendar dateFromComponents:dateComponents]];
    [self.datePicker addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    //--- Set Color of Date Picker
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker setValue:colorCreamCan forKeyPath:@"textColor"];
    [self.datePicker setBackgroundColor:[UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:0.6]];
    SEL selector = NSSelectorFromString(@"setHighlightsToday:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDatePicker instanceMethodSignatureForSelector:selector]];
    BOOL no = NO;
    //[invocation setSelector:selector];
    //[invocation setArgument:&no atIndex:2];
    //[invocation invokeWithTarget:self.datePicker];
    
    [self fetchAllTheResources];
}
 

- (void) fetchAllTheResources {
    
    // gender data
    self.arrayOfGender = @[@"Male", @"Female"];
    
    // interested data
    self.arrayOfInterests = @[@"Male", @"Female"];
    
    __weak typeof(self) weakSelf = self;
    
    //  ethnicity data
    [DTAAPI fetchStaticResourceWithKey : DTAAPIStaticResourcesTypeEthnics completion:^(NSError *error, NSArray *result) {
        if (!error) {
            
            NSLog(@"Success fetchStaticResource Ethnitic request");
            weakSelf.arrayOfEthnitic = result;
            [weakSelf.pickerView reloadAllComponents];
            [weakSelf disableCell:NO forNumber:DTAProfileCellTypeEthnitic];
            
//            NSLog(@"arrayOfEthnitic = %@", weakSelf.arrayOfEthnitic);
        }
        else {
            NSLog(@"Fail fetchStaticResource Ethnitic request");
            [weakSelf disableCell:YES forNumber:DTAProfileCellTypeEthnitic];
        }
    }];
    
    //--- relationship data
    [DTAAPI fetchStaticResourceWithKey : DTAAPIStaticResourcesTypeRelationships completion:^(NSError *error, NSArray *result) {
        if (!error) {
            
            NSLog(@"Success fetchStaticResource Relationship request");
            weakSelf.arrayOfRelationship = result;
            [weakSelf.pickerView reloadAllComponents];
            [weakSelf disableCell:NO forNumber:DTAProfileCellTypeRelationship];
        }
        else {
            NSLog(@"Fail fetchStaticResource Relationships request");
            [weakSelf disableCell:YES forNumber:DTAProfileCellTypeRelationship];
        }
    }];
    
    // profession data
    [DTAAPI fetchStaticResourceWithKey : DTAAPIStaticResourcesTypeProfessions completion:^(NSError *error, NSArray *result) {
        if (!error) {
            
            NSLog(@"Success fetchStaticResource Professions request");
            weakSelf.arrayOfProfession = result;
            [weakSelf.pickerView reloadAllComponents];
            [weakSelf disableCell:NO forNumber:DTAProfileCellTypeProfession];
            
//            NSLog(@"arrayOfProfession = %@", weakSelf.arrayOfProfession);
        }
        else {
            NSLog(@"Fail fetchStaticResource Professions request");
            [weakSelf disableCell:YES forNumber:DTAProfileCellTypeProfession];
        }
    }];
    
    // education data
    [DTAAPI fetchStaticResourceWithKey : DTAAPIStaticResourcesTypeEducations completion:^(NSError *error, NSArray *result) {
        
        if (!error) {
            NSLog(@"Success fetchStaticResource Educations request");
            weakSelf.arrayOfEducation = result;
            [weakSelf.pickerView reloadAllComponents];
            [weakSelf disableCell:NO forNumber:DTAProfileCellTypeEducation];
            
//            NSLog(@"arrayOfEducation = %@", weakSelf.arrayOfEducation);
        }
        else {
            NSLog(@"Fail fetchStaticResource Educations request");
            [weakSelf disableCell:YES forNumber:DTAProfileCellTypeEducation];
        }
    }];
    
    // country origin data
    [DTAAPI fetchStaticResourceWithKey : DTAAPIStaticResourcesTypeCountries completion:^(NSError *error, NSArray *result) {
        if (!error) {
            
            NSLog(@"Success fetchStaticResource Countries request");
            weakSelf.arrayOfCountryOrigin = result;
            [weakSelf.pickerView reloadAllComponents];
            [weakSelf disableCell:NO forNumber:DTAProfileCellTypeCountryOrigin];
            
//            NSLog(@"arrayOfCountryOrigin = %@", weakSelf.arrayOfCountryOrigin);
        }
        else {
            NSLog(@"Fail fetchStaticResource Countries request");
            [weakSelf disableCell:YES forNumber:DTAProfileCellTypeCountryOrigin];
        }
    }];
    
    // religion data
    [DTAAPI fetchStaticResourceWithKey : DTAAPIStaticResourcesTypeReligions completion:^(NSError *error, NSArray *result) {
        if (!error) {
            
            NSLog(@"Success fetchStaticResource Religion request");
            weakSelf.arrayOfReligion = result;
            [weakSelf.pickerView reloadAllComponents];
            [weakSelf disableCell:NO forNumber:DTAProfileCellTypeReligion];
            
//            NSLog(@"arrayOfReligion = %@", weakSelf.arrayOfReligion);
        }
        else {
            NSLog(@"Fail fetchStaticResource Religion request");
            [weakSelf disableCell:YES forNumber:DTAProfileCellTypeReligion];
        }
    }];
    
    
    //DEV Goals data
    [DTAAPI fetchStaticResourceWithKey : DTAAPIStaticResourcesTypeGoals completion:^(NSError *error, NSArray *result) {

        if (!error) {
            NSLog(@"Success fetchStaticResource Goals request");
            weakSelf.arrayOfGoals = result;
            [weakSelf.pickerView reloadAllComponents];
            [weakSelf disableCell:NO forNumber:DTAProfileCellTypeGoals];

            NSLog(@"arrayOfGoals = %@", weakSelf.arrayOfGoals);
        }
        else {
            NSLog(@"Fail fetchStaticResource Goals request");
            [weakSelf disableCell:YES forNumber:DTAProfileCellTypeGoals];
        }
    }];
    
    //DEV WantKids data
    [DTAAPI fetchStaticResourceWithKey : DTAAPIStaticResourcesTypeWantKids completion:^(NSError *error, NSArray *result) {
        if (!error) {
            NSLog(@"Success fetchStaticResource WantKids request");
            weakSelf.arrayOfWantKids = result;
            [weakSelf.pickerView reloadAllComponents];
            [weakSelf disableCell:NO forNumber:DTAProfileCellTypeWantKids];

            NSLog(@"arrayOfWantKids = %@", weakSelf.arrayOfWantKids);
        }
        else {
            NSLog(@"Fail fetchStaticResource WantKids request");
            [weakSelf disableCell:YES forNumber:DTAProfileCellTypeWantKids];
        }
    }];

    //DEV HaveKids data
    [DTAAPI fetchStaticResourceWithKey : DTAAPIStaticResourcesTypeHaveKids completion:^(NSError *error, NSArray *result) {

        if (!error) {

            NSLog(@"Success fetchStaticResource HaveKids request");
            weakSelf.arrayOfHaveKids = result;
            [weakSelf.pickerView reloadAllComponents];
            [weakSelf disableCell:NO forNumber:DTAProfileCellTypeHaveKids];

            NSLog(@"arrayOfHaveKids = %@", weakSelf.arrayOfHaveKids);
        }
        else {
            NSLog(@"Fail fetchStaticResource HaveKids request");
            [weakSelf disableCell:YES forNumber:DTAProfileCellTypeHaveKids];
        }
    }];
    
    //DEV Orientation data
    [DTAAPI fetchStaticResourceWithKey : DTAAPIStaticResourcesTypeOrientation completion:^(NSError *error, NSArray *result) {

        if (!error) {

            NSLog(@"Success fetchStaticResource Orientation request");
            weakSelf.arrayOfOrientation = result;
            [weakSelf.pickerView reloadAllComponents];
            [weakSelf disableCell:NO forNumber:DTAProfileCellTypeOrientation];

            NSLog(@"arrayOfOrientation = %@", weakSelf.arrayOfOrientation);
        }
        else {
            NSLog(@"Fail fetchStaticResource Orientation request");
            [weakSelf disableCell:YES forNumber:DTAProfileCellTypeOrientation];
        }
    }];
    
    
    // height data
    self.arrayOfHeightInches = [NSMutableArray new];
    
    for (int i = 4; i <= 7; i++) {
        for (int j = 0; j < 12; j++) {
            CGFloat value = ((i * 12) + j);
            NSDictionary *dict = @{ @"text": [NSString stringWithFormat:@"%i %@ %i %@", i, i != 1 ? @"footes" : @"foot", j, j != 1 ? @"inches" : @"inch"], @"value": @(value).stringValue, @"unit": kMeasumentInches};
            
            [self.arrayOfHeightInches addObject:dict];
        }
    }
    
    // measurement data
    self.arrayOfMeasurement = @[@"Feet/inch"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if(self.isFromRegisterVC && self.firstRun) {
        [self chekDataToNexVC];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    __weak typeof(self) weakSelf = self;
    
    [self.view addKeyboardPanningWithFrameBasedActionHandler:nil constraintBasedActionHandler:^(CGRect keyboardFrameInView, BOOL opening, BOOL closing) {
        
         static CGFloat y;
         
         if (opening || y == 0) {
             y = keyboardFrameInView.origin.y + keyboardFrameInView.size.height;
         }
         
         if (closing) {
             weakSelf.constraintTableOptionsDistanceToBottom.constant = 0;
         }
         else {
             weakSelf.constraintTableOptionsDistanceToBottom.constant = y - keyboardFrameInView.origin.y;
         }
         
     }];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view removeKeyboardControl];
}


- (void)backAction
{
    //    APP_DELEGATE.hudLogout = [[SAMHUDView alloc] initWithTitle:@"Logout" loading:YES];
    //    [APP_DELEGATE.hudLogout show];
    //    [APP_DELEGATE logoutToStartScreen];
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        [User MR_truncateAllInContext:localContext];
    }];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)pressAddImageButton {
    [self addAvatar:self];
}

#pragma mark - Private methods

- (void)chekDataToNexVC {
    
    BOOL error = NO;
    
    //    if (!error && ![self.editingUser.lastName length])
    //    {
    //        error = YES;
    //    }
    //    else
    
    if (!error && ![self.editingUser.firstName length]) {
        error = YES;
    }
    else if (!error && ![self.editingUser.stringDateOfBirth length]) {
        error = YES;
    }
    else if (!error && ![self.editingUser.gender length]) {
        error = YES;
    }
    
    //    else if (!error && !self.editingUser.location)
    //    {
    //        error = YES;
    //    }
    
    else if (!error && ![self.editingUser.interestedIn length]) {
        error = YES;
    }
    else if (!error && !self.editingUser.ethnic) {
        error = YES;
    }
    else if (!error && !self.editingUser.relationship) {
        error = YES;
    }
    else if (!error && !self.editingUser.profession) {
        error = YES;
    }
    else if (!error && !self.editingUser.education) {
        error = YES;
    }
    else if (!error && !self.editingUser.country) {
        error = YES;
    }
    else if (!error && !self.editingUser.religion) {
        error = YES;
    }
    
    //    else if (!error && !self.editingUser.heightValue.intValue)
    //    {
    //        error = YES;
    //    }
    
    if(!error && self.updateLoc) {
        [self toNextVC:self];
    }
}

- (void)saveProfile {
    self.firstRun = NO;
    [self toNextVC:self];
}

#pragma mark - TableView delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kDTAProfileSectionTypeCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
            
        case DTAProfileSectionTypeTop:
            return 1;
        
        case DTAProfileSectionTypeMiddle:
            return kProfileCellsCount - 3;
        
        case DTAProfileSectionTypeBottom:
            return 1;
        
        default:
            break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
    
        case DTAProfileSectionTypeTop: {
            
            DTAProfileTableViewCellAvatar *cell = [self.tableOptions dequeueReusableCellWithIdentifier:kDTAProfileTableViewCellAvatar forIndexPath:indexPath];
            
            cell.delegate = self;
            [cell configureCell:self user:self.editingUser editedAvatar:self.avatarImage fromRegisterVC:self.isFromRegisterVC];
            if(!self.isFromRegisterVC) {
                [cell hideAvatar];
            }
            return cell;
        }
            
        case DTAProfileSectionTypeMiddle: {
             if(indexPath.row == DTAProfileCellTypeFavoriteThings) {
                DTAProfileSummaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDTAProfileSummaryTableViewCell];
                 if ([self.editingUser.favoriteThings isEqualToString:@""] || self.editingUser.favoriteThings == nil)
                     [cell configureCellWithSummary:@"Enter are your 5 favorite things   " sender:self row:indexPath.row];
                 else
                     [cell configureCellWithSummary:self.editingUser.favoriteThings sender:self row:indexPath.row];
                
                 cell.labelQuestion.text = @"What are your 5 favorite things?";
                return cell;
            }
           
            else if(indexPath.row == DTAProfileCellTypeFavoriteJollOf) {
                DTAProfileSummaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDTAProfileSummaryTableViewCell];
                if ([self.editingUser.favoriteJoll isEqualToString:@""] || self.editingUser.favoriteJoll == nil)
                    [cell configureCellWithSummary:@"Enter your favorite jollof   " sender:self row:indexPath.row];
                else
                    [cell configureCellWithSummary:self.editingUser.favoriteJoll sender:self row:indexPath.row];
                cell.labelQuestion.text = @"What is your favorite jollof?";
                return cell;
            }
            
            else if(indexPath.row == DTAProfileCellTypeBringJoy) {
                DTAProfileSummaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDTAProfileSummaryTableViewCell];
                if ([self.editingUser.bringJoy isEqualToString:@""] || self.editingUser.bringJoy == nil)
                    [cell configureCellWithSummary:@"Enter what brings you joy   " sender:self row:indexPath.row];
                else
                    [cell configureCellWithSummary:self.editingUser.bringJoy sender:self row:indexPath.row];
                cell.labelQuestion.text = @"What brings you joy?";
                return cell;
            }
            
            else if(indexPath.row == DTAProfileCellTypeDreamParent) {
                DTAProfileSummaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDTAProfileSummaryTableViewCell];
                if ([self.editingUser.dreamParents isEqualToString:@""] || self.editingUser.dreamParents == nil)
                    [cell configureCellWithSummary:@"Enter Parent dreams for you  " sender:self row:indexPath.row];
                else
                [cell configureCellWithSummary:self.editingUser.dreamParents sender:self row:indexPath.row];
                cell.labelQuestion.text = @"What were your parents dream for you? A doctor, lawyer, or an engineer?";
                return cell;
            }
            
            else if(indexPath.row == DTAProfileCellTypeSummary) {
                DTAProfileSummaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDTAProfileSummaryTableViewCell];
                if ([self.editingUser.summary isEqualToString:@""])
                    [cell configureCellWithSummary:@"About Me   " sender:self row:indexPath.row];
                else
                    [cell configureCellWithSummary:self.editingUser.summary sender:self row:indexPath.row];
                cell.labelQuestion.text = @"About Me";
                return cell;
            }
            
            
            else {
                DTAProfileTableViewCell *cell = [self.tableOptions dequeueReusableCellWithIdentifier:kDTAProfileTableViewCell forIndexPath:indexPath];
                cell.delegate = self;
                BOOL disableCell = NO;
                if (indexPath.row == DTAProfileCellTypeBirth) {
                    [cell configureCellWithType:indexPath.row inputView:self.datePicker sender:self];
                    [cell updateFieldValue:self.editingUser.stringDateOfBirth];
                }
                else {
                    
                    [cell configureCellWithType:indexPath.row inputView:self.pickerView sender:self];
                    
                    //if (indexPath.row == DTAProfileCellTypeLocation) {
                    //    cell.fieldValue.userInteractionEnabled = NO;
                    //    [cell updateFieldValue:self.editingUser.location.locationTitle];
                    //} else
                    
                    if (indexPath.row == DTAProfileCellTypeInterests) {
                        [cell updateFieldValue:self.editingUser.interestedIn];
                    }
                    else if (indexPath.row == DTAProfileCellTypeSummary) {
                        [cell updateFieldValue:self.editingUser.summary];
                    }
                    else if (indexPath.row == DTAProfileCellTypeFavoriteThings) {
                        [cell updateFieldValue:self.editingUser.favoriteThings];
                    }
                    
                    else if (indexPath.row == DTAProfileCellTypeFavoriteJollOf) {
                        [cell updateFieldValue:self.editingUser.favoriteJoll];
                    }
                    
                    else if (indexPath.row == DTAProfileCellTypeBringJoy) {
                        [cell updateFieldValue:self.editingUser.bringJoy];
                    }
                    
                    else if (indexPath.row == DTAProfileCellTypeDreamParent) {
                        [cell updateFieldValue:self.editingUser.dreamParents];
                    }
                    
                    
                    
                    else if (indexPath.row == DTAProfileCellTypeSex) {
                        [cell updateFieldValue:self.editingUser.gender];
                    }
                    else if (indexPath.row == DTAProfileCellTypeEthnitic) {
                        [cell updateFieldValue:self.editingUser.ethnic.ethnicTitle];
                        disableCell = !self.arrayOfEthnitic.count;
                    }
                    else if (indexPath.row == DTAProfileCellTypeRelationship) {
                        [cell updateFieldValue:self.editingUser.relationship.relationshipTitle];
                        disableCell = !self.arrayOfRelationship.count;
                    }
                    else if (indexPath.row == DTAProfileCellTypeProfession) {
                        [cell updateFieldValue:self.editingUser.profession.professionTitle];
                        disableCell = !self.arrayOfProfession.count;
                    }
                    else if (indexPath.row == DTAProfileCellTypeEducation) {
                        [cell updateFieldValue:self.editingUser.education.educationTitle];
                        disableCell = !self.arrayOfEducation.count;
                    }
                    else if (indexPath.row == DTAProfileCellTypeCountryOrigin) {
                        [cell updateFieldValue:self.editingUser.country.countryTitle];
                        disableCell = !self.arrayOfCountryOrigin.count;
                    }
                    else if (indexPath.row == DTAProfileCellTypeReligion) {
                        [cell updateFieldValue:self.editingUser.religion.religionTitle];
                        disableCell = !self.arrayOfReligion.count;
                    }
                    else if (indexPath.row == DTAProfileCellTypeGoals) {
                        [cell updateFieldValue:self.editingUser.goals.goalTitle];
                        disableCell = !self.arrayOfReligion.count;
                    }
                    
                    else if (indexPath.row == DTAProfileCellTypeWantKids) {
                        [cell updateFieldValue:self.editingUser.wantKids.wantKidsTitle];
                        disableCell = !self.arrayOfWantKids.count;
                    }
                    
                    else if (indexPath.row == DTAProfileCellTypeHaveKids) {
                        [cell updateFieldValue:self.editingUser.haveKids.haveKidsTitle];
                        disableCell = !self.arrayOfHaveKids.count;
                    }
                    
                    else if (indexPath.row == DTAProfileCellTypeOrientation) {
                        [cell updateFieldValue:self.editingUser.orientation.orientationTitle];
                        disableCell = !self.arrayOfOrientation.count;
                    }
                    
                    
                    //else if (indexPath.row == DTAProfileCellTypeHeight) {
                    //    [cell updateFieldValue:[[[self.arrayOfHeightInches filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"value == %@", self.editingUser.heightValue.stringValue]] firstObject] valueForKey:@"text"]];
                    //    disableCell = NO;
                    //}
                }
                
                [cell disableCell:disableCell];
                
                return cell;
            }
        }
            
        case DTAProfileSectionTypeBottom: {
            
            DTAProfileNavigationTableViewCell *cell = [self.tableOptions dequeueReusableCellWithIdentifier:kDTAProfileNavigationTableViewCell forIndexPath:indexPath];
            
            if(!self.isFromRegisterVC) {
                [cell hideNextButton];
            }
            
            [cell configureCell];
            cell.delegate = self;
            
            return  cell;
        }
            
        default:
            break;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    switch (indexPath.section) {
    
        case DTAProfileSectionTypeTop:
            if (self.isFromRegisterVC) {
                return  kDTAProfileTableViewCellAvatarHeight * scaleCoefficient;
            }
            else {
                return (kDTAProfileSummaryTableViewCellHeight - 105) * scaleCoefficient;
            }
            
        case DTAProfileSectionTypeMiddle:
            if (indexPath.row == DTAProfileCellTypeSummary) {
                return kDTAProfileSummaryTableViewCellHeight * scaleCoefficient;
            }
            else if (indexPath.row == DTAProfileCellTypeFavoriteThings || indexPath.row == DTAProfileCellTypeFavoriteJollOf || indexPath.row == DTAProfileCellTypeBringJoy || indexPath.row == DTAProfileCellTypeDreamParent) {
                return (110.0f * SCREEN_WIDTH) / 375.0f;
            }
            
            else {
                return kDTAProfileTableViewCellHeight * scaleCoefficient;
            }
            
        case DTAProfileSectionTypeBottom:
            return DTAProfileNavigationTableViewCellHeight * scaleCoefficient;
        
        default:
            break;
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section != DTAProfileSectionTypeMiddle) {
        [self.view endEditing:YES];
    }
    
    if (indexPath.section == DTAProfileSectionTypeMiddle) {
        
        //if (indexPath.row == DTAProfileCellTypeLocation) {
        //    [self.view endEditing:YES];
        //    [self performSegueWithIdentifier:pushCityPickerSegue sender:self];
        //} else
        
        if (indexPath.row != DTAProfileCellTypeSummary || indexPath.row != DTAProfileCellTypeFavoriteThings || indexPath.row != DTAProfileCellTypeFavoriteJollOf || indexPath.row != DTAProfileCellTypeBringJoy || indexPath.row != DTAProfileCellTypeDreamParent) {
            self.pickerState = indexPath.row;
            [self.pickerView reloadAllComponents];
            //DEV commented due to crash issue
//            DTAProfileTableViewCell *cell = (DTAProfileTableViewCell *)[self.tableOptions cellForRowAtIndexPath:indexPath];
//            [cell makeFieldFirstResponder];
        }
    }
}

#pragma mark - DTAProfileTableViewCellDelegate methods

- (void)didTapDoneButtonOnCell:(DTAProfileTableViewCell *)cell {
    
    if([self.tableOptions indexPathForCell:cell].row != DTAProfileCellTypeBirth) {
        NSInteger selectedRow = [self.pickerView selectedRowInComponent:0];
        [self pickerView:self.pickerView didSelectRow:selectedRow inComponent:0];
    }
    else {
        [self onDatePickerValueChanged:self.datePicker];
    }
}

#pragma mark - DTAProfileTableViewCellAvatarDelegate

- (void)addAvatar:(id)sender;
{
    UIAlertController *alertControlller = [UIAlertController alertControllerWithTitle:@"" message:@"Select Option" preferredStyle:UIAlertControllerStyleActionSheet];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Take Photo", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self presentImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
        }];
        
        [alertControlller addAction:takePhotoAction];
    }
    
    UIAlertAction *choosePhotoAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Choose Photo", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self presentImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    
//    UIAlertAction *chooseFbAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Select Fb Images", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
//        FacebookImageVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FacebookImageVC"];
//        vc.user = self.editingUser;
//        [self.navigationController pushViewController:vc animated:YES];
        
//    }];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertControlller addAction:choosePhotoAction];
    [alertControlller addAction:cancelAction];
//    [alertControlller addAction:chooseFbAction];
    
    [self.navigationController presentViewController:alertControlller animated:YES completion:nil];
}

- (void) showAlertWithTitle: (NSString *)title andMessage: (NSString *)message {
    
    UIAlertController *alertControlller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OkAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertControlller addAction:OkAction];
    
    [self.navigationController presentViewController:alertControlller animated:YES completion:nil];
}

#pragma mark - DTAProfileNavigationTableViewCell Delegate

- (void)toNextVC:(id)sender;
{
    [self.view endEditing:YES];
    
    BOOL error = NO;
    
    // if (!error && ![self.editingUser.lastName length]) {
    //     SHOWALLERT(@"Error", @"Please input your last name");
    //     error = YES;
    // }
    // else
    
    self.editingUser.firstName = [self.editingUser.firstName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //DEV
//    if(!error && (!self.editingUser.avatar.length && !self.avatarImage)) {
    if(!error && (!self.editingUser.avatar.length && !self.avatarImage)) {
        [self showAlertWithTitle:@"Error" andMessage:@"Please select your profile image"];
        error = YES;
    }
    
    // else if (!error && !self.editingUser.location) {
    //     [self showAlertWithTitle:@"Error" andMessage:@"Please select your location"];
    //     error = YES;
    // }
    
    if (!error && ![self.editingUser.firstName length]) {
        [self showAlertWithTitle:@"Error" andMessage:@"Please input your first name"];
        error = YES;
    }
    else if (!error && ![self.editingUser.stringDateOfBirth length]) {
        [self showAlertWithTitle:@"Error" andMessage:@"Please select your birth day"];
        error = YES;
    }
    else if (!error && ![self.editingUser.gender length]) {
        [self showAlertWithTitle:@"Error" andMessage:@"Please select your gender"];
        error = YES;
    }
    else if (!error && ![self.editingUser.interestedIn length]) {
        [self showAlertWithTitle:@"Error" andMessage:@"Please select your interests"];
        error = YES;
    }
    else if (!error && !self.editingUser.ethnic) {
        [self showAlertWithTitle:@"Error" andMessage:@"Please select your ethnitic"];
        error = YES;
    }
    else if (!error && !self.editingUser.relationship) {
        [self showAlertWithTitle:@"Error" andMessage:@"Please select your relationship"];
        error = YES;
    }
    else if (!error && !self.editingUser.profession) {
        [self showAlertWithTitle:@"Error" andMessage:@"Please select your profession"];
        error = YES;
    }
    else if (!error && !self.editingUser.education) {
        [self showAlertWithTitle:@"Error" andMessage:@"Please select your education"];
        error = YES;
    }
    else if (!error && !self.editingUser.country) {
        [self showAlertWithTitle:@"Error" andMessage:@"Please select your country origin"];
        error = YES;
    }
    else if (!error && !self.editingUser.religion) {
        [self showAlertWithTitle:@"Error" andMessage:@"Please select your religion"];
        error = YES;
    }
    //DEV
    else if (!error && !self.editingUser.goals) {
        [self showAlertWithTitle:@"Error" andMessage:@"Please select your relationship goals"];
        error = YES;
    }
    
    else if (!error && !self.editingUser.wantKids) {
        [self showAlertWithTitle:@"Error" andMessage:@"Please select for want kids"];
        error = YES;
    }
    
    else if (!error && !self.editingUser.haveKids) {
        [self showAlertWithTitle:@"Error" andMessage:@"Please select have kids"];
        error = YES;
    }
    
    else if (!error && !self.editingUser.orientation) {
        [self showAlertWithTitle:@"Error" andMessage:@"Please select orientations"];
        error = YES;
    }
    
    

    if (!error) {
        
        NSDictionary *locationDict = @{
//                                        @"title": self.editingUser.location.locationTitle
//                                        @"lat" :@"0",
//                                        @"lng" :@"0"
                                    };
        
        NSDictionary *ethnicDict = @{
                                     @"id" : self.editingUser.ethnic.ethnicId,
                                     @"title" : self.editingUser.ethnic.ethnicTitle,
                                     @"isDefault" : self.editingUser.ethnic.isDefault
                                     };
        
        NSDictionary *relationshipDict =  @{
                                            @"id" : self.editingUser.relationship.relationshipId,
                                            @"title" : self.editingUser.relationship.relationshipTitle,
                                            @"isDefault" : self.editingUser.relationship.isDefault
                                            };
        
        NSDictionary *professionDict =  @{
                                          @"id" : self.editingUser.profession.professionId,
                                          @"title" : self.editingUser.profession.professionTitle,
                                          @"isDefault" : self.editingUser.profession.isDefault
                                          };
        
        NSDictionary *educationDict =  @{
                                         @"id" : self.editingUser.education.educationId,
                                         @"title" : self.editingUser.education.educationTitle,
                                         @"isDefault" : self.editingUser.education.isDefault
                                         };
        
        NSDictionary *countryDict =  @{
                                       @"id" : self.editingUser.country.countryId,
                                       @"title" : self.editingUser.country.countryTitle,
                                       @"isDefault" : self.editingUser.country.isDefault
                                       };
        
        //self.editingUser.heightUnit = kMeasumentInches;
        //NSDictionary *heightDict = @{
        //                             @"unit" : self.editingUser.heightUnit,
        //                             @"value": self.editingUser.heightValue.stringValue
        //                             };
        
        NSDictionary *religionDict = @{
                                       @"id" : self.editingUser.religion.religionId,
                                       @"title" : self.editingUser.religion.religionTitle,
                                       @"isDefault" : self.editingUser.religion.isDefault
                                       };
        //DEV
        NSDictionary *goalsDict = @{
        @"id" : self.editingUser.goals.goalId,
        @"title" : self.editingUser.goals.goalTitle,
        @"isDefault" : self.editingUser.goals.isDefault
        };
        
        NSDictionary *haveKidsDict = @{
               @"id" : self.editingUser.haveKids.haveKidsId,
               @"title" : self.editingUser.haveKids.haveKidsTitle,
               @"isDefault" : self.editingUser.haveKids.isDefault
               };
        
        
        NSDictionary *orientataionDict = @{
               @"id" : self.editingUser.orientation.orientationId,
               @"title" : self.editingUser.orientation.orientationTitle,
               @"isDefault" : self.editingUser.orientation.isDefault
               };
        
        NSDictionary *wantKidsDict = @{
               @"id" : self.editingUser.wantKids.wantKidsId,
               @"title" : self.editingUser.wantKids.wantKidsTitle,
               @"isDefault" : self.editingUser.wantKids.isDefault
               };
        
        
        self.profileDict = [NSMutableDictionary new];
        
        self.profileDict[@"firstName"]      = self.editingUser.firstName;
        //  self.profileDict[@"lastName"]       = self.editingUser.lastName;
        self.profileDict[@"dateOfBirth"]    = self.editingUser.stringDateOfBirth;
        self.profileDict[@"gender"]         = self.editingUser.gender;
        self.profileDict[@"interestedIn"]   = self.editingUser.interestedIn;
        
        self.profileDict[@"location"]       = locationDict;
        self.profileDict[@"ethnic"]         = ethnicDict;
        self.profileDict[@"relationship"]   = relationshipDict;
        self.profileDict[@"profession"]     = professionDict;
        self.profileDict[@"education"]      = educationDict;
        self.profileDict[@"country"]        = countryDict;
        // self.profileDict[@"height"]         = heightDict;
        self.profileDict[@"religion"]       = religionDict;
        self.profileDict[@"relationshipgoal"]  = goalsDict;
        
        self.profileDict[@"wantkid"]  = wantKidsDict;
        self.profileDict[@"havekid"]  = haveKidsDict;
        self.profileDict[@"orientation"]  = orientataionDict;
        //DEV
        
        self.profileDict[@"summary"]        = self.editingUser.summary.length ? self.editingUser.summary : @"";
        self.profileDict[@"favorite_things"]        = self.editingUser.favoriteThings.length ? self.editingUser.favoriteThings : @"";
        self.profileDict[@"favorite_jollofs"]        = self.editingUser.favoriteJoll.length ? self.editingUser.favoriteJoll : @"";
        self.profileDict[@"brings_joy"]        = self.editingUser.bringJoy.length ? self.editingUser.bringJoy : @"";
        self.profileDict[@"your_dream"]        = self.editingUser.dreamParents.length ? self.editingUser.dreamParents : @"";
        
        
        APP_DELEGATE.hud = [[SAMHUDView alloc] initWithTitle:nil];
        [APP_DELEGATE.hud show];
        
        
        [DTAAPI profileUpdateWithParameters:self.profileDict avatar:self.avatarImage completionBlock:^(NSError *error)
         {
             if (!error)
             {
                 NSLog(@"Success  profileUpdate request");
                 User *tmpUser = [[User alloc] initWithDictionary:self.profileDict];
                 
                 if (_isFromRegisterVC) {
                     [self dismissViewControllerAnimated:YES completion:nil];
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"changeAvatar" object:nil];
                 }
                 else {
                     [self.navigationController popViewControllerAnimated:YES];
                 }
             }
             else {
                 NSLog(@"Fail  profileUpdate request");
                  [self showAlertWithTitle:@"Error" andMessage:error.userInfo[@"message"]];
             }
             
             [APP_DELEGATE.hud dismiss];
         }];
    }
}

#pragma mark - UIPickerView Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView; {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component; {
    
    switch (self.pickerState) {
    
        case DTAProfileCellTypeSex:
            return self.arrayOfGender.count;
        
        case DTAProfileCellTypeInterests:
            return self.arrayOfInterests.count;
        
        case DTAProfileCellTypeEthnitic:
            return self.arrayOfEthnitic.count;
        
        case DTAProfileCellTypeRelationship:
            return self.arrayOfRelationship.count;
        
        case DTAProfileCellTypeProfession:
            return self.arrayOfProfession.count;
        
        case DTAProfileCellTypeEducation:
            return self.arrayOfEducation.count;
        
        case  DTAProfileCellTypeCountryOrigin:
            return self.arrayOfCountryOrigin.count;
        
        case DTAProfileCellTypeReligion:
            return self.arrayOfReligion.count;
            
        case DTAProfileCellTypeGoals:
            return self.arrayOfGoals.count;
        
        case DTAProfileCellTypeWantKids:
            return self.arrayOfWantKids.count;
            
        case DTAProfileCellTypeHaveKids:
            return self.arrayOfHaveKids.count;
            
        case DTAProfileCellTypeOrientation:
        return self.arrayOfOrientation.count;
        
            
        //case DTAProfileCellTypeHeight:
        //    return self.arrayOfHeightInches.count;
        
        default:
            return 0;
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    //   NSInteger num;
    
    switch (self.pickerState) {
            
        case DTAProfileCellTypeSex: {
            self.editingUser.gender = self.arrayOfGender[row];
            NSIndexPath *ip = [NSIndexPath indexPathForRow:DTAProfileCellTypeSex inSection:DTAProfileSectionTypeMiddle];
            DTAProfileTableViewCell *cell = (DTAProfileTableViewCell *)[self.tableOptions cellForRowAtIndexPath:ip];
            [cell updateFieldValue:self.editingUser.gender];
            break;
        }
            
        case DTAProfileCellTypeInterests: {
            self.editingUser.interestedIn = self.arrayOfInterests[row];
            NSIndexPath *ip = [NSIndexPath indexPathForRow:DTAProfileCellTypeInterests inSection:DTAProfileSectionTypeMiddle];
            DTAProfileTableViewCell *cell = (DTAProfileTableViewCell *)[self.tableOptions cellForRowAtIndexPath:ip];
            [cell updateFieldValue:self.editingUser.interestedIn];
            break;
        }
            
        case DTAProfileCellTypeEthnitic: {
            NSDictionary *dict = self.arrayOfEthnitic[row];
            
            Ethnic *ethnic = [Ethnic MR_createEntityInContext:self.editingContext];
            ethnic.ethnicId = dict[@"id"];
            ethnic.ethnicTitle = dict[@"title"];
            NSNumber *number = [NSNumber numberWithBool:dict[@"isDefault"]];
            ethnic.isDefault = number;
            
            self.editingUser.ethnic = ethnic;
            
            NSIndexPath *ip = [NSIndexPath indexPathForRow:DTAProfileCellTypeEthnitic inSection:DTAProfileSectionTypeMiddle];
            DTAProfileTableViewCell *cell = (DTAProfileTableViewCell *)[self.tableOptions cellForRowAtIndexPath:ip];
            
            [cell updateFieldValue:self.editingUser.ethnic.ethnicTitle];
            cell.valueDictionary = @{@"id" : self.editingUser.ethnic.ethnicId};
            break;
        }
            
        case DTAProfileCellTypeRelationship: {
            NSDictionary *dict = self.arrayOfRelationship[row];
            
            Relationship *relationship = [Relationship MR_createEntityInContext:self.editingContext];
            relationship.relationshipId = dict[@"id"];
            relationship.relationshipTitle = dict[@"title"];
            NSNumber *number = [NSNumber numberWithBool:dict[@"isDefault"]];
            relationship.isDefault = number;
            
            self.editingUser.relationship = relationship;
            
            NSIndexPath *ip = [NSIndexPath indexPathForRow:DTAProfileCellTypeRelationship inSection:DTAProfileSectionTypeMiddle];
            DTAProfileTableViewCell *cell = (DTAProfileTableViewCell *)[self.tableOptions cellForRowAtIndexPath:ip];
            [cell updateFieldValue:self.editingUser.relationship.relationshipTitle];
            cell.valueDictionary = @{@"id" : self.editingUser.relationship.relationshipId};
            break;
        }
            
        case DTAProfileCellTypeProfession: {
            NSDictionary *dict = self.arrayOfProfession[row];
            
            Profession *profession = [Profession MR_createEntityInContext:self.editingContext];
            profession.professionId = dict[@"id"];
            profession.professionTitle = dict[@"title"];
            NSNumber *number = [NSNumber numberWithBool:dict[@"isDefault"]];
            profession.isDefault = number;
            
            self.editingUser.profession = profession;
            
            NSIndexPath *ip = [NSIndexPath indexPathForRow:DTAProfileCellTypeProfession inSection:DTAProfileSectionTypeMiddle];
            DTAProfileTableViewCell *cell = (DTAProfileTableViewCell *)[self.tableOptions cellForRowAtIndexPath:ip];
            
            [cell updateFieldValue:self.editingUser.profession.professionTitle];
            cell.valueDictionary = @{@"id" : self.editingUser.profession.professionId};
            break;
        }
            
        case DTAProfileCellTypeEducation: {
            NSDictionary *dict = self.arrayOfEducation[row];
            
            Education *education = [Education MR_createEntityInContext:self.editingContext];
            education.educationId = dict[@"id"];
            education.educationTitle = dict[@"title"];
            NSNumber *number = [NSNumber numberWithBool:dict[@"isDefault"]];
            education.isDefault = number;
            
            self.editingUser.education = education;
            
            NSIndexPath *ip = [NSIndexPath indexPathForRow:DTAProfileCellTypeEducation inSection:DTAProfileSectionTypeMiddle];
            DTAProfileTableViewCell *cell = (DTAProfileTableViewCell *)[self.tableOptions cellForRowAtIndexPath:ip];
            
            [cell updateFieldValue:self.editingUser.education.educationTitle];
            cell.valueDictionary = @{@"id" : self.editingUser.education.educationId};
            break;
        }
            
        case DTAProfileCellTypeCountryOrigin: {
            NSDictionary *dict = self.arrayOfCountryOrigin[row];
            
            Country *country = [Country MR_createEntityInContext:self.editingContext];
            country.countryId = dict[@"id"];
            country.countryTitle = dict[@"title"];
            NSNumber *number = [NSNumber numberWithBool:dict[@"isDefault"]];
            country.isDefault = number;
            
            self.editingUser.country = country;
            
            NSIndexPath *ip = [NSIndexPath indexPathForRow:DTAProfileCellTypeCountryOrigin inSection:DTAProfileSectionTypeMiddle];
            DTAProfileTableViewCell *cell = (DTAProfileTableViewCell *)[self.tableOptions cellForRowAtIndexPath:ip];
            
            [cell updateFieldValue:self.editingUser.country.countryTitle];
            cell.valueDictionary = @{@"id" : self.editingUser.country.countryId};
            
            break;
        }
            
        case DTAProfileCellTypeReligion: {
            NSDictionary *dict = self.arrayOfReligion[row];
            
            Religion *religion = [Religion MR_createEntityInContext:self.editingContext];
            religion.religionTitle = dict[@"title"];
            religion.religionId = dict[@"id"];
            NSNumber *number = [NSNumber numberWithBool:dict[@"isDefault"]];
            religion.isDefault = number;
            
            self.editingUser.religion = religion;
            
            NSIndexPath *ip = [NSIndexPath indexPathForRow:DTAProfileCellTypeReligion inSection:DTAProfileSectionTypeMiddle];
            DTAProfileTableViewCell *cell = (DTAProfileTableViewCell *)[self.tableOptions cellForRowAtIndexPath:ip];
            
            [cell updateFieldValue:self.editingUser.religion.religionTitle];
            cell.valueDictionary = @{@"id" : self.editingUser.religion.religionId};
            
            break;
        }
            
            case DTAProfileCellTypeGoals: {
                NSDictionary *dict = self.arrayOfGoals[row];
                
                Goals *goals = [Goals MR_createEntityInContext:self.editingContext];
                goals.goalTitle = dict[@"title"];
                goals.goalId = dict[@"id"];
                NSNumber *number = [NSNumber numberWithBool:dict[@"isDefault"]];
                goals.isDefault = number;

                self.editingUser.goals = goals;

                NSIndexPath *ip = [NSIndexPath indexPathForRow:DTAProfileCellTypeGoals inSection:DTAProfileSectionTypeMiddle];
                DTAProfileTableViewCell *cell = (DTAProfileTableViewCell *)[self.tableOptions cellForRowAtIndexPath:ip];

                [cell updateFieldValue:self.editingUser.goals.goalTitle];
                cell.valueDictionary = @{@"id" : self.editingUser.goals.goalId};
                
                break;
            }
            
            case DTAProfileCellTypeWantKids: {
                NSDictionary *dict = self.arrayOfWantKids[row];
                
                WantKids *wantKids = [WantKids MR_createEntityInContext:self.editingContext];
                wantKids.wantKidsTitle = dict[@"title"];
                wantKids.wantKidsId = dict[@"id"];
                NSNumber *number = [NSNumber numberWithBool:dict[@"isDefault"]];
                wantKids.isDefault = number;

                self.editingUser.wantKids = wantKids;

                NSIndexPath *ip = [NSIndexPath indexPathForRow:DTAProfileCellTypeWantKids inSection:DTAProfileSectionTypeMiddle];
                DTAProfileTableViewCell *cell = (DTAProfileTableViewCell *)[self.tableOptions cellForRowAtIndexPath:ip];

                [cell updateFieldValue:self.editingUser.wantKids.wantKidsTitle];
                cell.valueDictionary = @{@"id" : self.editingUser.wantKids.wantKidsId};
                
                break;
            }
            
            case DTAProfileCellTypeHaveKids: {
                NSDictionary *dict = self.arrayOfHaveKids[row];
                
                HaveKids *hKids = [HaveKids MR_createEntityInContext:self.editingContext];
                hKids.haveKidsTitle = dict[@"title"];
                hKids.haveKidsId = dict[@"id"];
                NSNumber *number = [NSNumber numberWithBool:dict[@"isDefault"]];
                hKids.isDefault = number;

                self.editingUser.haveKids = hKids;

                NSIndexPath *ip = [NSIndexPath indexPathForRow:DTAProfileCellTypeHaveKids inSection:DTAProfileSectionTypeMiddle];
                DTAProfileTableViewCell *cell = (DTAProfileTableViewCell *)[self.tableOptions cellForRowAtIndexPath:ip];

                [cell updateFieldValue:self.editingUser.haveKids.haveKidsTitle];
                cell.valueDictionary = @{@"id" : self.editingUser.haveKids.haveKidsId};
                
                break;
            }
            
            
            case DTAProfileCellTypeOrientation: {
                NSDictionary *dict = self.arrayOfOrientation[row];
                
                Orientation *orientataion = [Orientation MR_createEntityInContext:self.editingContext];
                orientataion.orientationTitle = dict[@"title"];
                orientataion.orientationId = dict[@"id"];
                NSNumber *number = [NSNumber numberWithBool:dict[@"isDefault"]];
                orientataion.isDefault = number;

                self.editingUser.orientation = orientataion;

                NSIndexPath *ip = [NSIndexPath indexPathForRow:DTAProfileCellTypeOrientation inSection:DTAProfileSectionTypeMiddle];
                DTAProfileTableViewCell *cell = (DTAProfileTableViewCell *)[self.tableOptions cellForRowAtIndexPath:ip];

                [cell updateFieldValue:self.editingUser.orientation.orientationTitle];
                cell.valueDictionary = @{@"id" : self.editingUser.orientation.orientationId};
                
                break;
            }
            
            
            
            
        //case DTAProfileCellTypeHeight: {
        //    NSIndexPath *ip = [NSIndexPath indexPathForRow:DTAProfileCellTypeHeight inSection:DTAProfileSectionTypeMiddle];
        //    DTAProfileTableViewCell *cell = (DTAProfileTableViewCell*)[self.tableOptions cellForRowAtIndexPath:ip];
        //
        //    NSDictionary *dict = self.arrayOfHeightInches[row];
        //
        //    self.editingUser.heightValue = @([dict[@"value"] floatValue]);
        //
        //    [cell updateFieldValue:dict[@"text"]];
        //    cell.valueDictionary = dict;
        //
        //    break;
        //}
        
        default:
            break;
    }
    
    //num++;
    //if (num < self.arrayOfFields.count) {
    //    UITextField *textFieldNext = self.arrayOfFields[num];
    //    [textFieldNext becomeFirstResponder];
    //}
    
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
            
        case DTAProfileCellTypeSex: {
            tView.text = self.arrayOfGender[row];
            break;
        }
            
        case DTAProfileCellTypeInterests: {
            tView.text = self.arrayOfInterests[row];
            break;
        }
            
        case DTAProfileCellTypeEthnitic: {
            NSDictionary *dict = self.arrayOfEthnitic[row];
            tView.text = dict[@"title"];
            break;
        }
            
        case DTAProfileCellTypeRelationship: {
            NSDictionary *dict = self.arrayOfRelationship[row];
            tView.text = dict[@"title"];
            break;
        }
            
        case DTAProfileCellTypeProfession: {
            NSDictionary *dict = self.arrayOfProfession[row];
            tView.text = dict[@"title"];
            break;
        }
            
        case DTAProfileCellTypeEducation: {
            NSDictionary *dict = self.arrayOfEducation[row];
            tView.text = dict[@"title"];
            break;
        }
            
        case DTAProfileCellTypeCountryOrigin: {
            NSDictionary *dict = self.arrayOfCountryOrigin[row];
            tView.text = dict[@"title"];
            break;
        }
            
        case DTAProfileCellTypeReligion: {
            NSDictionary *dict = self.arrayOfReligion[row];
            tView.text = dict[@"title"];
            break;
        }
            
            case DTAProfileCellTypeGoals: {
                NSDictionary *dict = self.arrayOfGoals[row];
                tView.text = dict[@"title"];
                break;
            }
            
            case DTAProfileCellTypeWantKids: {
                NSDictionary *dict = self.arrayOfWantKids[row];
                tView.text = dict[@"title"];
                break;
            }
            
            case DTAProfileCellTypeHaveKids: {
                NSDictionary *dict = self.arrayOfHaveKids[row];
                tView.text = dict[@"title"];
                break;
            }
            
            case DTAProfileCellTypeOrientation: {
                NSDictionary *dict = self.arrayOfOrientation[row];
                tView.text = dict[@"title"];
                break;
            }
            
        //case DTAProfileCellTypeHeight: {
        //    NSDictionary *dict = self.arrayOfHeightInches[row];
        //    tView.text = dict[@"text"];
        //    break;
        //}
        
        default:
            tView.text = @"Undefined";
            break;
    }
    
    //if (row == [self.pickerView selectedRowInComponent:0]){
    //    tView.textColor = colorCreamCan;
    //}
    //else {
    //    tView.textColor = colorMenuItem;
    //}
    
    return tView;
}

- (IBAction)tappedToSelectRow:(UITapGestureRecognizer *)tapRecognizer {
    
    CGFloat rowHeight = [self.pickerView rowSizeForComponent:0].height;
    CGRect selectedRowFrame = CGRectInset(self.pickerView.bounds, 0.0, (CGRectGetHeight(self.pickerView.frame) - rowHeight) / 2.0 );
    BOOL userTappedOnSelectedRow = (CGRectContainsPoint(selectedRowFrame, [tapRecognizer locationInView:self.pickerView]));
    
    if (userTappedOnSelectedRow) {
        NSInteger selectedRow = [self.pickerView selectedRowInComponent:0];
        [self pickerView:self.pickerView didSelectRow:selectedRow inComponent:0];
    }
}

- (NSInteger)indexOfSelectedRowForIndexPath:(NSIndexPath *)indexPath {
    
    DTAProfileTableViewCell *cell = (DTAProfileTableViewCell *)[self.tableOptions cellForRowAtIndexPath:indexPath];
    
    switch (indexPath.row) {
            
        case DTAProfileCellTypeSex: {
            if([cell fieldValue].text.length) {
                return [self.arrayOfGender indexOfObject:[cell fieldValue].text];
            }
            else {
                return 0;
            }
        }
            
        case DTAProfileCellTypeInterests: {
            if([cell fieldValue].text.length) {
                return [self.arrayOfInterests indexOfObject:[cell fieldValue].text];
            }
            else {
                return 0;
            }
        }
            
        case DTAProfileCellTypeEthnitic: {
            if([cell fieldValue].text.length) {
                NSArray *filteredarray = [self.arrayOfEthnitic filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(title == %@)", [cell fieldValue].text]];
                return [self.arrayOfEthnitic indexOfObject:filteredarray[0]];
            }
            else {
                return 0;
            }
        }
            
        case DTAProfileCellTypeRelationship: {
            if([cell fieldValue].text.length) {
                NSArray *filteredarray = [self.arrayOfRelationship filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(title == %@)", [cell fieldValue].text]];
                return [self.arrayOfRelationship indexOfObject:filteredarray[0]];
            }
            else {
                return 0;
            }
        }
            
        case DTAProfileCellTypeProfession: {
            if([cell fieldValue].text.length) {
                NSArray *filteredarray = [self.arrayOfProfession filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(title == %@)", [cell fieldValue].text]];
                return [self.arrayOfProfession indexOfObject:filteredarray[0]];
            }
            else {
                return 0;
            }
        }
            
        case DTAProfileCellTypeEducation: {
            if([cell fieldValue].text.length) {
                NSArray *filteredarray = [self.arrayOfEducation filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(title == %@)", [cell fieldValue].text]];
                return [self.arrayOfEducation indexOfObject:filteredarray[0]];
            }
            else {
                return 0;
            }
        }
            
        case DTAProfileCellTypeCountryOrigin: {
            if([cell fieldValue].text.length) {
                NSArray *filteredarray = [self.arrayOfCountryOrigin filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(title == %@)", [cell fieldValue].text]];
                return [self.arrayOfCountryOrigin indexOfObject:filteredarray[0]];
            }
            else {
                return 0;
            }
        }
            
        case DTAProfileCellTypeReligion: {
            if([cell fieldValue].text.length) {
                NSArray *filteredarray = [self.arrayOfReligion filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(title == %@)", [cell fieldValue].text]];
                return [self.arrayOfReligion indexOfObject:filteredarray[0]];
            }
            else {
                return 0;
            }
        }
        
            case DTAProfileCellTypeGoals: {
                if([cell fieldValue].text.length) {
                    NSArray *filteredarray = [self.arrayOfGoals filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(title == %@)", [cell fieldValue].text]];
                    return [self.arrayOfGoals indexOfObject:filteredarray[0]];
                }
                else {
                    return 0;
                }
            }
            
            case DTAProfileCellTypeWantKids: {
                if([cell fieldValue].text.length) {
                    NSArray *filteredarray = [self.arrayOfWantKids filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(title == %@)", [cell fieldValue].text]];
                    return [self.arrayOfWantKids indexOfObject:filteredarray[0]];
                }
                else {
                    return 0;
                }
            }
            
            
            case DTAProfileCellTypeHaveKids: {
                if([cell fieldValue].text.length) {
                    NSArray *filteredarray = [self.arrayOfHaveKids filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(title == %@)", [cell fieldValue].text]];
                    return [self.arrayOfHaveKids indexOfObject:filteredarray[0]];
                }
                else {
                    return 0;
                }
            }
            
            case DTAProfileCellTypeOrientation: {
                if([cell fieldValue].text.length) {
                    NSArray *filteredarray = [self.arrayOfOrientation filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(title == %@)", [cell fieldValue].text]];
                    return [self.arrayOfOrientation indexOfObject:filteredarray[0]];
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

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return true;
}

#pragma mark - UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField; {
    
    if (textField.tag < kProfileCellsCount && textField.tag != DTAProfileCellTypeBirth) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:textField.tag inSection:DTAProfileSectionTypeMiddle];
        self.pickerState = indexPath.row;
        [self.pickerView reloadAllComponents];
        DTAProfileTableViewCell *cell = (DTAProfileTableViewCell *)[self.tableOptions cellForRowAtIndexPath:indexPath];
        [cell makeFieldFirstResponder];
        
        NSInteger index = [self indexOfSelectedRowForIndexPath:indexPath];
        
        if(!index) {
            [self.pickerView selectRow:0 inComponent:0 animated:NO];
            [self pickerView:self.pickerView didSelectRow:0 inComponent:0];
        }
        else {
            [self.pickerView selectRow:[self indexOfSelectedRowForIndexPath:indexPath] inComponent:0 animated:NO];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField; {
    [self.view endEditing:YES];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *newStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField.tag == DTAProfileTextFieldTypeFirstName) {
        self.editingUser.firstName = newStr;
    }
    
    //else if (textField.tag == DTAProfileTextFieldTypeLastName) {
    //    self.editingUser.lastName = newStr;
    //}
    
    return YES;
}

#pragma mark - TextView delegate methods

- (void)textViewDidBeginEditing:(UITextView *)textView {
    CGPoint txtFieldPosition = [textView convertPoint:CGPointZero toView:self.tableOptions];
    NSIndexPath *indexPath = [self.tableOptions indexPathForRowAtPoint:txtFieldPosition];
    
    [self.tableOptions scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
    if(textView.tag == DTAProfileCellTypeSummary){
        if ([textView.text isEqualToString:@"About Me   "]){
            textView.text = @"";
        }
    }
    
    else if(textView.tag == DTAProfileCellTypeFavoriteThings){
        if ([textView.text isEqualToString:@"Enter are your 5 favorite things   "]){
            textView.text = @"";
        }
    }
    else if(textView.tag == DTAProfileCellTypeFavoriteJollOf) {
        if ([textView.text isEqualToString:@"Enter your favorite jollof   "]) {
            textView.text = @"";
        }
    }
    
    else if(textView.tag == DTAProfileCellTypeBringJoy) {
        if ([textView.text isEqualToString:@"Enter what brings you joy   "]) {
            textView.text = @"";
        }
    }
    else if(textView.tag == DTAProfileCellTypeDreamParent) {
        if ([textView.text isEqualToString:@"Enter Parent dreams for you  "]) {
            textView.text = @"";
        }
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    CGPoint txtFieldPosition = [textView convertPoint:CGPointZero toView:self.tableOptions];
    NSIndexPath *indexPath = [self.tableOptions indexPathForRowAtPoint:txtFieldPosition];

    [self.tableOptions scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];

    if(textView.tag == DTAProfileCellTypeSummary){
        if ([textView.text isEqualToString:@""]){
            textView.text = @"About Me   ";
        }
    }

   else if(textView.tag == DTAProfileCellTypeFavoriteThings){
        if ([textView.text isEqualToString:@""]){
            textView.text = @"Enter are your 5 favorite things   ";
        }
    }
    else if(textView.tag == DTAProfileCellTypeFavoriteJollOf) {
        if ([textView.text isEqualToString:@""]) {
            textView.text = @"Enter your favorite jollof   ";
        }
    }
    
    else if(textView.tag == DTAProfileCellTypeBringJoy) {
        if ([textView.text isEqualToString:@""]) {
            textView.text = @"Enter what brings you joy   ";
        }
    }
    else if(textView.tag == DTAProfileCellTypeDreamParent) {
        if ([textView.text isEqualToString:@""]) {
            textView.text = @"Enter Parent dreams for you  ";
        }
    }
    
    [textView resignFirstResponder];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if(textView.tag == DTAProfileCellTypeSummary) {
        NSString *newStr = [textView.text stringByReplacingCharactersInRange:range withString:text];
//        if(newStr.length <= kMaxNumberOfSummarySymbols) {
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:textView.tag inSection:DTAProfileSectionTypeMiddle];
//            DTAProfileSummaryTableViewCell *cell = (DTAProfileSummaryTableViewCell *)[self.tableOptions cellForRowAtIndexPath:indexPath];
//            [cell changeNumberOfSymbols:newStr.length];
//            return YES;
//        }
//        else {
//            return NO;
//        }
        
        if ([newStr isEqualToString:@""]) {
            textView.text = @"About Me   ";
        } else if ([newStr containsString:@"About Me"]){
            textView.text = @"";
        }
        self.editingUser.summary = newStr;
    }
    
    else if(textView.tag == DTAProfileCellTypeFavoriteThings) {
        NSString *newStr = [textView.text stringByReplacingCharactersInRange:range withString:text];
        
        if ([newStr isEqualToString:@""]) {
            textView.text = @"Enter are your 5 favorite things   ";
        } else if ([newStr containsString:@"Enter are your 5 favorite things"]){
            textView.text = @"";
        }
            self.editingUser.favoriteThings = newStr;
    }
    
    else if(textView.tag == DTAProfileCellTypeFavoriteJollOf) {
        NSString *newStr = [textView.text stringByReplacingCharactersInRange:range withString:text];
        
        if ([newStr isEqualToString:@""]) {
            textView.text = @"Enter your favorite jollof   ";
        } else if ([newStr containsString:@"Enter your favorite jollof"]){
            textView.text = @"";
        }
            self.editingUser.favoriteJoll = newStr;
    }
    
    else if(textView.tag == DTAProfileCellTypeBringJoy) {
        NSString *newStr = [textView.text stringByReplacingCharactersInRange:range withString:text];
        if ([newStr isEqualToString:@""]) {
            textView.text = @"Enter what brings you joy   ";
        } else if ([newStr containsString:@"Enter what brings you joy"]){
            textView.text = @"";
        }
            self.editingUser.bringJoy = newStr;
    }
    
    else if(textView.tag == DTAProfileCellTypeDreamParent) {
        NSString *newStr = [textView.text stringByReplacingCharactersInRange:range withString:text];
        if ([newStr isEqualToString:@""]) {
            textView.text = @"Enter Parent dreams for you  ";
        } else if ([newStr containsString:@"Enter Parent dreams for you"]){
            textView.text = @"";
        }
            self.editingUser.dreamParents = newStr;
    }
    
    
    return YES;
}

#pragma mark - Image Picker

- (void)presentImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = sourceType;
    picker.allowsEditing = YES;
    picker.delegate= self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    if (self.isFromRegisterVC) {
        NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:DTAProfileSectionTypeTop];
        DTAProfileTableViewCellAvatar *cell = (DTAProfileTableViewCellAvatar *)[self.tableOptions cellForRowAtIndexPath:ip];
        [cell setAvatar:chosenImage];
        self.avatarImage = chosenImage;
    }
    else {
        [self.draggableImages uploadImage:chosenImage];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIStoryboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:pushCityPickerSegue]) {
        self.citySelectionVC = segue.destinationViewController;
        self.citySelectionVC.delegate = self;
    }
}

#pragma mark - Procedures

-(void)onDatePickerValueChanged:(UIDatePicker *)datePicker {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:datePicker.date];
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:DTAProfileCellTypeBirth inSection:DTAProfileSectionTypeMiddle];
    DTAProfileTableViewCell *cell = (DTAProfileTableViewCell *)[self.tableOptions cellForRowAtIndexPath:ip];
    [cell updateFieldValue:dateString];
    self.editingUser.stringDateOfBirth = dateString;
}

#pragma mark -

- (void)disableCell:(BOOL)state forNumber:(NSUInteger)number; {
    NSIndexPath *ip = [NSIndexPath indexPathForRow:number inSection:DTAProfileSectionTypeMiddle];
    DTAProfileTableViewCell *cell = (DTAProfileTableViewCell *)[self.tableOptions cellForRowAtIndexPath:ip];
    [cell disableCell:state];
}

- (NSString *)valueOfCellWithNumber:(NSUInteger)number {
    NSIndexPath *ip = [NSIndexPath indexPathForRow:number inSection:DTAProfileSectionTypeMiddle];
    DTAProfileTableViewCell *cell = (DTAProfileTableViewCell *)[self.tableOptions cellForRowAtIndexPath:ip];
    return cell.getFieldValue;
}

- (NSDictionary *)dictValueOfCellWithNumber:(NSUInteger)number {
    NSIndexPath *ip = [NSIndexPath indexPathForRow:number inSection:DTAProfileSectionTypeMiddle];
    DTAProfileTableViewCell *cell = (DTAProfileTableViewCell *)[self.tableOptions cellForRowAtIndexPath:ip];
    return cell.valueDictionary;
}

- (void)citySelectionCompletedWithCity:(NSDictionary *)city {
    Location *selectedLocation = [Location MR_createEntityInContext:self.editingContext];
    selectedLocation.locationTitle = city[@"city"];
    selectedLocation.latitude = city[@"latitude"];
    selectedLocation.longitude = city[@"longitude"];
    
    self.editingUser.location = selectedLocation;
    [self.tableOptions reloadData];
}

#pragma mark -

- (IBAction)unwindFromFbImageView:(UIStoryboardSegue *)segue {
    if ([[segue sourceViewController] isKindOfClass:[DTARegisterViewController class]]) {
    }
    else {
        FacebookImageVC *vc = (FacebookImageVC *)[segue sourceViewController];
        NSURL *url = [NSURL URLWithString:vc.imgUrlSring];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [[UIImage alloc] initWithData:data];
        
        if (self.isFromRegisterVC) {
            self.avatarImage = img;
            [self.tableOptions reloadData];
        }else
            [self.draggableImages uploadImage:img];
        
    }
}

@end
