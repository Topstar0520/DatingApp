//
//  DTAAdditionalInfoViewController.m
//  DatingApp
//
//  Created by Maksim on 29.09.15.
//  Copyright © 2015 Cleveroad Inc. All rights reserved.
//

#import "DTAAdditionalInfoViewController.h"
#import "User+Extension.h"
#import "Relationship+Extensions.h"
#import "Country+Extensions.h"
#import "Education.h"
#import "Religion+Extensions.h"
#import "Ethnic.h"
#import "Profession+Extensions.h"
#import "NSString+Email.h"
#import "Goals.h"
#import "WantKids.h"
#import "HaveKids.h"
#import "Orientation.h"


@interface DTAAdditionalInfoViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameAndAgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *personalStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *educationLabel;
@property (weak, nonatomic) IBOutlet UILabel *religionLabel;
@property (weak, nonatomic) IBOutlet UILabel *ethnicGroupLabel;
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

@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *professionLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryOfOriginLabel;
@property (weak, nonatomic) IBOutlet UILabel *milesFromYouLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *likeBtnTopSpacingConstraint;

@end

@implementation DTAAdditionalInfoViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)scroolToTop {
    [self.rootScroll setContentOffset:CGPointMake(0, -self.rootScroll.contentInset.top) animated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)reloadUserDataFromUserModel:(User *)user {
    
    self.detailedUser = user;
    NSString *name = [NSString stringWithFormat:@"%@, %li", self.detailedUser.firstName, (long) self.detailedUser.userAge];
    //DEV
//    NSString *location = [NSString stringWithFormat:@"(%@)", [self.detailedUser fetchCityNameFromLocation]];
    NSString *location = [NSString stringWithFormat:@"%@", [self.detailedUser fetchCityNameFromLocation]];
    if ([self.detailedUser fetchCityNameFromLocation].length > 0) {
        location = [NSString stringWithFormat:@"(%@)", [self.detailedUser fetchCityNameFromLocation]];
    }
    self.nameAndAgeLabel.attributedText = [NSString generateStringFormName:name location:location];
    self.personalStatusLabel.text = self.detailedUser.relationship.relationshipTitle;
    self.educationLabel.text = self.detailedUser.education.educationTitle;
    self.religionLabel.text = self.detailedUser.religion.religionTitle;
    self.ethnicGroupLabel.text = self.detailedUser.ethnic.ethnicTitle;
    self.professionLabel.text = self.detailedUser.profession.professionTitle;
    self.countryOfOriginLabel.text = self.detailedUser.country.countryTitle;
    self.milesFromYouLabel.text = @"";
    
    if (self.detailedUser.distance) {
        self.milesFromYouLabel.text = [NSString stringWithFormat:@"%@ miles from you", self.detailedUser.distance];
    }
    
    //DEV
    self.goalLabel.text = self.detailedUser.goals.goalTitle;
    self.wantKidsLabel.text = self.detailedUser.wantKids.wantKidsTitle;
    self.haveKidsLabel.text = self.detailedUser.haveKids.haveKidsTitle;
    self.orientationLabel.text = self.detailedUser.orientation.orientationTitle;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.firstLineHeadIndent = 0.f;

    if (self.detailedUser.summary) {
        self.summaryLabel.attributedText = [[NSAttributedString alloc] initWithString:self.detailedUser.summary attributes:@{NSParagraphStyleAttributeName : paragraphStyle}];
        self.likeBtnTopSpacingConstraint.constant = 55.0f;
        self.summaryLabel.hidden = NO;
        self.summaryTitle.hidden = NO;
    }
    else {
        self.summaryLabel.hidden = YES;
        self.summaryTitle.hidden = YES;
        self.likeBtnTopSpacingConstraint.constant = -14.0f;
    }
    
    if (self.detailedUser.favoriteThings.length) {
        self.favThingValue.attributedText = [[NSAttributedString alloc] initWithString:self.detailedUser.favoriteThings attributes:@{NSParagraphStyleAttributeName : paragraphStyle}];
        
        self.favThingValue.hidden = NO;
        self.favThingLabel.hidden = NO;
    }
    else {
        self.favThingValue.hidden = YES;
        self.favThingLabel.hidden = YES;
    }
    
    
    if (self.detailedUser.favoriteJoll.length) {
        self.favJollValue.attributedText = [[NSAttributedString alloc] initWithString:self.detailedUser.favoriteJoll attributes:@{NSParagraphStyleAttributeName : paragraphStyle}];
        
        self.favJollValue.hidden = NO;
        self.favJollLabel.hidden = NO;
    }
    else {
        self.favJollValue.hidden = YES;
        self.favJollLabel.hidden = YES;
    }
    
    
    if (self.detailedUser.bringJoy.length) {
        self.joyValue.attributedText = [[NSAttributedString alloc] initWithString:self.detailedUser.bringJoy attributes:@{NSParagraphStyleAttributeName : paragraphStyle}];
        
        self.joyValue.hidden = NO;
        self.joyLabel.hidden = NO;
    }
    else {
        self.joyValue.hidden = YES;
        self.joyLabel.hidden = YES;
    }
    
    
    if (self.detailedUser.dreamParents.length) {
        self.dreamParentValue.attributedText = [[NSAttributedString alloc] initWithString:self.detailedUser.dreamParents attributes:@{NSParagraphStyleAttributeName : paragraphStyle}];
        
        self.dreamParentValue.hidden = NO;
        self.dreamParentLabel.hidden = NO;
    }
    else {
        self.dreamParentValue.hidden = YES;
        self.dreamParentLabel.hidden = YES;
    }
    
    [self.rootScroll layoutSubviews];
    
    [self scroolToTop];
}

- (IBAction)pressLikeButton:(id)sender {
    [self.delegate pressLikeButton];
}

- (IBAction)pressDislikeButton:(id)sender {
    [self.delegate pressDislikeButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
