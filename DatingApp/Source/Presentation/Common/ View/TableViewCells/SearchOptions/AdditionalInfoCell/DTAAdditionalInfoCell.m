//
//  DTAAdditionalInfoCell.m
//  DatingApp
//
//  Created by  Artem Kalinovsky on 9/15/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import "DTAAdditionalInfoCell.h"
#import "DTASearchOptionsManager.h"
#import "SearchOptions.h"
#import "Location.h"
#import "Ethnic.h"
#import "Relationship.h"
#import "Profession.h"
#import "Education.h"
#import "Country.h"
#import "Religion.h"
#import "Goals.h"
#import "WantKids.h"
#import "HaveKids.h"
#import "Orientation.h"

@implementation DTAAdditionalInfoCell

- (void)prepareForReuse {
    [super prepareForReuse];
   
    self.fieldValue.userInteractionEnabled = YES;

    //    self.labelOption.text = @"";
    //    self.fieldValue.text = @"";
}

+ (NSString *)reuseIdentifier {
    return @"additionalSearchOptionCellIdentifier";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)configureCellAtIndex:(NSInteger)index inputView:(UIView *)inputView sender:(id)sender {
    
    if (inputView) {
        self.fieldValue.inputView = inputView;
        
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        
        [toolBar setBarTintColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.42 alpha:1]];
        toolBar.translucent = NO;
        [toolBar setBarStyle:UIBarStyleDefault];
        
        UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(pickerViewActionDone:)];
     
        UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        toolBar.items = @[flex, barButtonDone];
        barButtonDone.tintColor = colorCreamCan;
        
        self.fieldValue.inputAccessoryView = toolBar;
    }
    
    self.fieldValue.delegate = sender;
    self.fieldValue.tag = index;
    
    self.fieldValue.placeholder = @"No Preference";
    
    switch ((DTAAdditionalInfoCellType) index) {
        case DTAAdditionalInfoCellTypeLocation: {
            self.labelOption.text = @"Location";
            if ([[DTASearchOptionsManager sharedManager].searchOptions.location.locationTitle isEqualToString:@""]) {
                self.fieldValue.text = @"No Preference";
            }
            else {
                self.fieldValue.text = [DTASearchOptionsManager sharedManager].searchOptions.location.locationTitle ?: @"No Preference";
            }
            
            break;
        }
            
        case DTAAdditionalInfoCellTypeEthnicGroup:
            self.labelOption.text = @"Ethnicity";
            if ([[DTASearchOptionsManager sharedManager].searchOptions.ethnic.ethnicTitle isEqualToString:@""]) {
                self.fieldValue.text = @"No Preference";
            }
            else {
                self.fieldValue.text = [DTASearchOptionsManager sharedManager].searchOptions.ethnic.ethnicTitle ?: @"No Preference";
            }
            break;
            
        case DTAAdditionalInfoCellTypeRelationship:
            self.labelOption.text = @"Relationship";
            if ([[DTASearchOptionsManager sharedManager].searchOptions.relationship.relationshipTitle isEqualToString:@""]) {
                self.fieldValue.text = @"No Preference";
            }
            else {
                self.fieldValue.text = [DTASearchOptionsManager sharedManager].searchOptions.relationship.relationshipTitle ?: @"No Preference";
            }
            break;
            
        case DTAAdditionalInfoCellTypeProfession:
            self.labelOption.text = @"Profession";
            if ([[DTASearchOptionsManager sharedManager].searchOptions.profession.professionTitle isEqualToString:@""]) {
                self.fieldValue.text = @"No Preference";
            }
            else {
                self.fieldValue.text = [DTASearchOptionsManager sharedManager].searchOptions.profession.professionTitle ?: @"No Preference";
            }
            break;
            
        case DTAAdditionalInfoCellTypeEducation:
            self.labelOption.text = @"Education";
            if ([[DTASearchOptionsManager sharedManager].searchOptions.education.educationTitle isEqualToString:@""]) {
                self.fieldValue.text = @"No Preference";
            }
            else {
                self.fieldValue.text = [DTASearchOptionsManager sharedManager].searchOptions.education.educationTitle ?: @"No Preference";
            }
            break;
            
        case DTAAdditionalInfoCellTypeCountryOfOrigin:
            self.labelOption.text = @"Country origin";
            if ([[DTASearchOptionsManager sharedManager].searchOptions.country.countryTitle isEqualToString:@""]) {
                self.fieldValue.text = @"No Preference";
            }
            else {
                self.fieldValue.text = [DTASearchOptionsManager sharedManager].searchOptions.country.countryTitle ?: @"No Preference";
            }
            break;
            
        case DTAAdditionalInfoCellTypeReligion:
            self.labelOption.text = @"Religion";
            if ([[DTASearchOptionsManager sharedManager].searchOptions.religion.religionTitle isEqualToString:@""]) {
                self.fieldValue.text = @"No Preference";
            }
            else {
                self.fieldValue.text = [DTASearchOptionsManager sharedManager].searchOptions.religion.religionTitle ?: @"No Preference";
            }
            break;
            
        case DTAAdditionalInfoCellTypeGoals:
            self.labelOption.text = @"Relationship Goals";
            if ([[DTASearchOptionsManager sharedManager].searchOptions.goals.goalTitle isEqualToString:@""]) {
                self.fieldValue.text = @"No Preference";
            }
            else {
                self.fieldValue.text = [DTASearchOptionsManager sharedManager].searchOptions.goals.goalTitle ?: @"No Preference";
            }
            break;
            
        case DTAAdditionalInfoCellTypeWantKids:
            self.labelOption.text = @"Want Kids";
            if ([[DTASearchOptionsManager sharedManager].searchOptions.wantKids.wantKidsTitle isEqualToString:@""]) {
                self.fieldValue.text = @"No Preference";
            }
            else {
                self.fieldValue.text = [DTASearchOptionsManager sharedManager].searchOptions.wantKids.wantKidsTitle ?: @"No Preference";
            }
            break;
            
        case DTAAdditionalInfoCellTypeHaveKids:
            self.labelOption.text = @"Have Kids";
            if ([[DTASearchOptionsManager sharedManager].searchOptions.haveKids.haveKidsTitle isEqualToString:@""]) {
                self.fieldValue.text = @"No Preference";
            }
            else {
                self.fieldValue.text = [DTASearchOptionsManager sharedManager].searchOptions.haveKids.haveKidsTitle ?: @"No Preference";
            }
            break;
            
            
        case DTAAdditionalInfoCellTypeOrientation:
            self.labelOption.text = @"Orientations";
            if ([[DTASearchOptionsManager sharedManager].searchOptions.orientation.orientationTitle isEqualToString:@""]) {
                self.fieldValue.text = @"No Preference";
            }
            else {
                self.fieldValue.text = [DTASearchOptionsManager sharedManager].searchOptions.orientation.orientationTitle ?: @"No Preference";
            }
            break;
            
            
            
        default:
            break;
    }
    
    NSMutableAttributedString *attrText;
    
    attrText = [[NSMutableAttributedString alloc] initWithAttributedString:self.labelOption.attributedText];
  
    [attrText addAttribute:NSFontAttributeName value:[UIFont fontWithName:self.labelOption.font.fontName size:self.labelOption.font.pointSize /* scaleCoefficient*/] range:NSMakeRange(0, attrText.length)];
    
    [self.labelOption setAttributedText:attrText];
    
    [self.fieldValue setFont:[UIFont fontWithName:self.fieldValue.font.fontName size:self.fieldValue.font.pointSize /** scaleCoefficient*/]];
}

- (void)makeFieldFirstResponder {
    [self.fieldValue becomeFirstResponder];
}

- (void)updateFieldValue:(NSString *)value {
    if ([value isEqualToString:@""] && !value) {
        self.fieldValue.textColor = colorGlaucous;
        self.fieldValue.text = @"No Preference";
    }
    else {
        if(value.length <= 2) {
            self.fieldValue.text = @"No Preference";
        }
        else {
            self.fieldValue.text = value;
        }
        
        self.fieldValue.textColor = colorGlaucous;
    }
}

- (void)pickerViewActionDone:(id)sender {
    [self.fieldValue resignFirstResponder];
    
    if([self.delegate respondsToSelector:@selector(didTapDoneButtonOnCell:)]) {
        [self.delegate didTapDoneButtonOnCell:self];
    }
}

@end
