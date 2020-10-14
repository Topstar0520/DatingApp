//
//  DTAProfileTableViewCell.h
//  DatingApp
//
//  Created by VLADISLAV KIRIN on 8/10/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const kDTAProfileTableViewCell = @"DTAProfileTableViewCell";
static CGFloat kDTAProfileTableViewCellHeight = 45.f;
static CGFloat kDTAProfileSummaryTableViewCellHeight = 144.f;

typedef NS_ENUM(NSUInteger, DTAProfileSectionType) {
    DTAProfileSectionTypeTop = 0,
    DTAProfileSectionTypeMiddle,
    DTAProfileSectionTypeBottom
};

static NSUInteger const kDTAProfileSectionTypeCount = 3;

typedef NS_ENUM(NSUInteger, DTAProfileCellType) {
    DTAProfileCellTypeBirth,
    DTAProfileCellTypeSex,
    DTAProfileCellTypeInterests,
    DTAProfileCellTypeEthnitic,
    DTAProfileCellTypeRelationship,
    DTAProfileCellTypeProfession,
    DTAProfileCellTypeEducation,
    DTAProfileCellTypeCountryOrigin,
    DTAProfileCellTypeReligion,
    DTAProfileCellTypeGoals,
    DTAProfileCellTypeWantKids,
    DTAProfileCellTypeHaveKids,
    DTAProfileCellTypeOrientation,
    DTAProfileCellTypeFavoriteThings,
    DTAProfileCellTypeFavoriteJollOf,
    DTAProfileCellTypeBringJoy,
    DTAProfileCellTypeDreamParent,
    DTAProfileCellTypeSummary
};




static NSUInteger const kProfileCellsCount = 21;

@protocol DTAProfileTableViewCellDelegate;

@interface DTAProfileTableViewCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *valueDictionary;

- (void)configureCellWithType:(DTAProfileCellType)type inputView:(UIView *)inputView sender:(id)sender;
- (void)updateFieldValue:(NSString *)value;
- (void)makeFieldFirstResponder;
- (void)disableCell:(BOOL)state;
- (NSString *)getFieldValue;

@property (nonatomic, strong) NSString *text;
@property (weak, nonatomic) IBOutlet UITextField *fieldValue;
@property (weak, nonatomic) id<DTAProfileTableViewCellDelegate> delegate;

@end

@protocol DTAProfileTableViewCellDelegate <NSObject>

- (void)didTapDoneButtonOnCell:(DTAProfileTableViewCell *)cell;

@end
