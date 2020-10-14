//
//  DTAProfileTableViewCell.m
//  DatingApp
//
//  Created by VLADISLAV KIRIN on 8/10/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import "DTAProfileTableViewCell.h"
#import "User+Extension.h"
#import "Location.h"

static CGFloat const kFieldValueFontSize = 18.0f;

@interface DTAProfileTableViewCell ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labelOption;

@end

@implementation DTAProfileTableViewCell

#pragma mark - Life Cycle

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.fieldValue.userInteractionEnabled = YES;
    self.labelOption.text = @"";

    //    self.fieldValue.text = @"";
}


#pragma mark - Public

- (void)configureCellWithType:(DTAProfileCellType)type inputView:(UIView *)inputView sender:(id)sender {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
    
    self.fieldValue.tag = type;
    self.fieldValue.delegate = sender;
    self.fieldValue.placeholder = @"Select value";
    
    switch ((DTAProfileCellType)type) {
        case DTAProfileCellTypeBirth:
            self.labelOption.text = @"Date of birth";
            break;
    
        case DTAProfileCellTypeSex:
            self.labelOption.text = @"Sex";
            break;

        //        case DTAProfileCellTypeLocation:
        //        {
        //            self.labelOption.text = @"Location";
        //            self.fieldValue.text = [User currentUser].location.locationTitle;
        //            self.fieldValue.inputView = nil;
        //            break;
        //        }
        
        case DTAProfileCellTypeInterests:
            self.labelOption.text = @"Interested in";
            break;
        
        case DTAProfileCellTypeEthnitic:
            self.labelOption.text = @"Ethnicity";
            break;
        
        case DTAProfileCellTypeRelationship:
            self.labelOption.text = @"Relationship Status";
            break;
        
        case DTAProfileCellTypeProfession:
            self.labelOption.text = @"Profession";
            break;
        
        case DTAProfileCellTypeEducation:
            self.labelOption.text = @"Education";
            break;
        
        case DTAProfileCellTypeCountryOrigin:
            self.labelOption.text = @"Country origin";
            break;
        
        case DTAProfileCellTypeReligion:
            self.labelOption.text = @"Religion";
            break;
            
        //DEV
        case DTAProfileCellTypeGoals:
            self.labelOption.text = @"Relationship Goals";
            break;
            
            case DTAProfileCellTypeWantKids:
            self.labelOption.text = @"Want Kids";
            break;
            
            case DTAProfileCellTypeHaveKids:
            self.labelOption.text = @"Have Kids";
            break;
            
            
            case DTAProfileCellTypeOrientation:
            self.labelOption.text = @"Orientation";
            break;
            
            

        //        case DTAProfileCellTypeHeight:
        //            self.labelOption.text = @"Height";
        //            break;
        //        case DTAProfileCellTypeMeasurement:
        //            self.labelOption.text = @"Height Change";
        //            break;
        
        case DTAProfileCellTypeSummary:
//            self.labelOption.text = @"My Summary";
            self.labelOption.text = @"About Me";
            self.fieldValue.placeholder = @"Type about yourself";
            self.fieldValue.inputView = nil;
            break;
            
            case DTAProfileCellTypeFavoriteThings:
                        self.labelOption.text = @"What are your 5 favorite things?";
                        self.fieldValue.placeholder = @"Type your 5 favorite things";
                        self.fieldValue.inputView = nil;
                        break;
            
            
            case DTAProfileCellTypeFavoriteJollOf:
            self.labelOption.text = @"What is your favorite jollof?";
            self.fieldValue.placeholder = @"Type your favorite JollOf";
            self.fieldValue.inputView = nil;
            break;
            
            
            case DTAProfileCellTypeBringJoy:
            self.labelOption.text = @"What brings you joy?";
            self.fieldValue.placeholder = @"Type your joy";
            self.fieldValue.inputView = nil;
            break;
            
            case DTAProfileCellTypeDreamParent:
            self.labelOption.text = @"Parent dreams for you?";
            self.fieldValue.placeholder = @"Type your dream parent";
            self.fieldValue.inputView = nil;
            break;
            
            
            
        
        default:
            break;
    }
    
    NSMutableAttributedString *attrText;
    
    attrText = [[NSMutableAttributedString alloc] initWithAttributedString:self.labelOption.attributedText];
    
    [attrText addAttribute:NSFontAttributeName value:[UIFont fontWithName:self.labelOption.font.fontName size:self.labelOption.font.pointSize * scaleCoefficient] range:NSMakeRange(0, attrText.length)];
    
    [self.labelOption setAttributedText:attrText];
    
    [self.fieldValue setFont:[UIFont fontWithName:self.fieldValue.font.fontName size:kFieldValueFontSize * scaleCoefficient]];
}

- (void)updateFieldValue:(NSString *)value {
    self.fieldValue.text = value;
}

- (void)makeFieldFirstResponder {
    [self.fieldValue becomeFirstResponder];
}

- (void)disableCell:(BOOL)state {
    self.fieldValue.enabled = !state;
    
    if (state) {
        NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithAttributedString: self.fieldValue.attributedPlaceholder];
      
        [attrText addAttribute:NSForegroundColorAttributeName value:colorMercury range:NSMakeRange(0, [attrText length])];
        
        self.fieldValue.attributedPlaceholder = attrText;
    }
    else {
        NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithAttributedString: self.fieldValue.attributedPlaceholder];
       
        [attrText addAttribute:NSForegroundColorAttributeName value:colorTin range:NSMakeRange(0, [attrText length])];
       
        self.fieldValue.attributedPlaceholder = attrText;
    }
}

- (NSString *)getFieldValue {
    return self.fieldValue.text;
}

- (void)pickerViewActionDone:(id)sender {
    [self.fieldValue resignFirstResponder];
    
    if([self.delegate respondsToSelector:@selector(didTapDoneButtonOnCell:)]) {
        [self.delegate didTapDoneButtonOnCell:self];
    }
}

#pragma mark -

@end
