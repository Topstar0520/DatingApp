//
//  DTAProfileMyInfoViewController.m
//  DatingApp
//
//  Created by  Artem Kalinovsky on 8/25/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import "DTAProfileMyInfoViewController.h"
#import "User.h"
#import "User+Extension.h"
#import "Religion.h"
#import "Goals.h"
#import "WantKids.h"
#import "HaveKids.h"
#import "Orientation.h"
#import "Relationship.h"
#import "Education.h"
#import "Ethnic.h"
#import "Profession.h"
#import "Country.h"
#import "UIViewController+ECSlidingViewController.h"
#import "MEDynamicTransition.h"
#import "DTAEditProfileViewController.h"
#import "MBProgressHUD.h"
#import "NSString+Email.h"
#import "DTAImageViewController.h"
#import "DTASwipeImages.h"

@interface DTAProfileMyInfoViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameAndAgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastActiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *personalStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *heightLabel;
@property (weak, nonatomic) IBOutlet UILabel *educationLabel;
@property (weak, nonatomic) IBOutlet UILabel *interestedInLabel;

@property (weak, nonatomic) IBOutlet UILabel *ethnicGroupLabel;
@property (weak, nonatomic) IBOutlet UILabel *religionLabel;
@property (strong, nonatomic) IBOutlet UILabel *goalLabel;
@property (strong, nonatomic) IBOutlet UILabel *wantKidsLabel;
@property (strong, nonatomic) IBOutlet UILabel *haveKidsLabel;
@property (strong, nonatomic) IBOutlet UILabel *orientationLabel;


//What are your 5 favorite things
@property (weak, nonatomic) IBOutlet UILabel *favThingLabel;
@property (weak, nonatomic) IBOutlet UILabel *favThingValue;

//What is your favorite jollof?
@property (weak, nonatomic) IBOutlet UILabel *favJollLabel;
@property (weak, nonatomic) IBOutlet UILabel *favJollValue;

//What brings you joy?
@property (weak, nonatomic) IBOutlet UILabel *joyLabel;
@property (weak, nonatomic) IBOutlet UILabel *joyValue;

//Parent dreams for you? Doctor, Lawyer or Engineer?
@property (weak, nonatomic) IBOutlet UILabel *dreamParentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dreamParentValue;

//About Me
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *professionLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryOfOriginLabel;
@property (weak, nonatomic) IBOutlet UIView *noPhotoView;
@property (weak, nonatomic) IBOutlet DTASwipeImages *swipeImages;
@property (weak, nonatomic) IBOutlet UILabel *numberOfImagesLbl;

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) MEDynamicTransition *dynamicTransition;
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;

@end

@implementation DTAProfileMyInfoViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user = [User currentUser];
    
    //[self updateProfileUI];
    
    if(!self.user.summary.length) {
        self.summaryLabel.hidden = YES;
        self.summaryTitleLabel.hidden = YES;
    }
    
    self.dynamicTransition.slidingViewController = self.slidingViewController;
    
    self.navigationController.navigationBar.barTintColor = colorCreamCan;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName :[UIColor whiteColor]};
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    __weak typeof(self) weakSelf = self;
    [DTAAPI profileFullFetchForUserId:self.user.userId completion:^(NSError *error, NSArray *dataArr) {
        if (!error) {
            User *tmpUser = [[User alloc] initWithDictionary:dataArr[0]];
            self.user = tmpUser;
            [weakSelf updateProfileUI];
        }
    }];
    
//    [DTAAPI profileFullFetchForUserId:self.user.userId completion:^(NSError *error) {
//         if (!error) {
//             [weakSelf updateProfileUI];
//         }
//     }];
}

#pragma mark -

- (IBAction)pressEditeButton:(id)sender {
    [self performSegueWithIdentifier:@"showEditeController" sender:nil];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showEditeController"]) {
        [(DTAEditProfileViewController *)segue.destinationViewController setIsFromRegisterVC:NO];
        [(DTAEditProfileViewController *)segue.destinationViewController setEditingUser:self.user];
        
    }
    else if ([segue.identifier isEqualToString:@"presentImageViewController"]) {
        DTAImageViewController *destVC = segue.destinationViewController;
        destVC.imageArray = [self.user.image allObjects];
        destVC.startImageIndex = self.swipeImages.currentImageIndex;
    }
}


#pragma mark - Gesture Delegate Methods

- (IBAction)pressPhotoButton:(id)sender {
    [self performSegueWithIdentifier:@"presentImageViewController" sender:self];
}

- (UIPanGestureRecognizer *)dynamicTransitionPanGesture {
    if (_dynamicTransitionPanGesture) {
        return _dynamicTransitionPanGesture;
    }
    
    _dynamicTransitionPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.dynamicTransition action:@selector(handlePanGesture:)];
    
    return _dynamicTransitionPanGesture;
}

- (MEDynamicTransition *)dynamicTransition {
    if (_dynamicTransition) {
        return _dynamicTransition;
    }
    
    _dynamicTransition = [[MEDynamicTransition alloc] init];
    
    return _dynamicTransition;
}

#pragma mark - Procedures

- (void)updateProfileUI {
    
    NSString *name = [NSString stringWithFormat:@"%@, %li", self.user.firstName, (long) self.user.userAge];
    //DEV
//    NSString *location = [NSString stringWithFormat:@"(%@)", [self.user fetchCityNameFromLocation]];
    NSString *location = [NSString stringWithFormat:@"%@", [self.user fetchCityNameFromLocation]];
    if ([self.user fetchCityNameFromLocation].length > 0) {
        location = [NSString stringWithFormat:@"(%@)", [self.user fetchCityNameFromLocation]];
    }
    
    self.nameAndAgeLabel.attributedText = [NSString generateStringFormName:name location:location];
    
    self.personalStatusLabel.text = self.user.relationship.relationshipTitle;
    
    //  self.heightLabel.text = [self.user convertHeightToString];
    
    self.educationLabel.text = self.user.education.educationTitle;
    self.interestedInLabel.text = self.user.interestedIn;
    self.religionLabel.text = self.user.religion.religionTitle;
    
    self.ethnicGroupLabel.text = self.user.ethnic.ethnicTitle;
    self.professionLabel.text = self.user.profession.professionTitle;
    self.countryOfOriginLabel.text = self.user.country.countryTitle;
    
    //DEV
    self.goalLabel.text = self.user.goals.goalTitle;
    self.wantKidsLabel.text = self.user.wantKids.wantKidsTitle;
    self.haveKidsLabel.text = self.user.haveKids.haveKidsTitle;
    self.orientationLabel.text = self.user.orientation.orientationTitle;
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.firstLineHeadIndent = 0.f;
    
    if (self.user.summary.length) {
        self.summaryLabel.attributedText = [[NSAttributedString alloc] initWithString:self.user.summary attributes:@{NSParagraphStyleAttributeName : paragraphStyle}];
        
        self.summaryLabel.hidden = NO;
        self.summaryTitleLabel.hidden = NO;
    }
    else {
        self.summaryLabel.hidden = YES;
        self.summaryTitleLabel.hidden = YES;
    }
    
    if (self.user.favoriteThings.length) {
        self.favThingValue.attributedText = [[NSAttributedString alloc] initWithString:self.user.favoriteThings attributes:@{NSParagraphStyleAttributeName : paragraphStyle}];
        
        self.favThingValue.hidden = NO;
        self.favThingLabel.hidden = NO;
    }
    else {
        self.favThingValue.hidden = YES;
        self.favThingLabel.hidden = YES;
    }
    
    
    if (self.user.favoriteJoll.length) {
        self.favJollValue.attributedText = [[NSAttributedString alloc] initWithString:self.user.favoriteJoll attributes:@{NSParagraphStyleAttributeName : paragraphStyle}];
        
        self.favJollValue.hidden = NO;
        self.favJollLabel.hidden = NO;
    }
    else {
        self.favJollValue.hidden = YES;
        self.favJollLabel.hidden = YES;
    }
    
    
    if (self.user.bringJoy.length) {
        self.joyValue.attributedText = [[NSAttributedString alloc] initWithString:self.user.bringJoy attributes:@{NSParagraphStyleAttributeName : paragraphStyle}];
        
        self.joyValue.hidden = NO;
        self.joyLabel.hidden = NO;
    }
    else {
        self.joyValue.hidden = YES;
        self.joyLabel.hidden = YES;
    }
    
    
    if (self.user.dreamParents.length) {
        self.dreamParentValue.attributedText = [[NSAttributedString alloc] initWithString:self.user.dreamParents attributes:@{NSParagraphStyleAttributeName : paragraphStyle}];
        
        self.dreamParentValue.hidden = NO;
        self.dreamParentLabel.hidden = NO;
    }
    else {
        self.dreamParentValue.hidden = YES;
        self.dreamParentLabel.hidden = YES;
    }
    
    
    
    
    NSArray *userImages = [self.user.image allObjects];
    NSLog(@"user images = %@", userImages);
    
    if (!self.swipeImages.images.count) {
        if (userImages.count > 0) {
            [self.swipeImages setHidden:NO];
            [self.noPhotoView setHidden:YES];
            [self.swipeImages addImages:userImages animated:NO];
        }
        else {
            [self.swipeImages setHidden:YES];
            [self.noPhotoView setHidden:NO];
        }
    }
    else if (![self.swipeImages isArrayOfImagesEqualToCurrentArray:userImages]) {
        [self.swipeImages cleanImagesWithAnimation:NO onComplete:^(NSError *error) {
            [self.swipeImages addImages:userImages animated:NO];
        }];
    }
    
    self.numberOfImagesLbl.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.user.image.count];
}

@end
