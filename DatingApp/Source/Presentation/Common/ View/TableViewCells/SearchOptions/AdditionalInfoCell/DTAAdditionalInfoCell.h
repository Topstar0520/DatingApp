//
//  DTAAdditionalInfoCell.h
//  DatingApp
//
//  Created by  Artem Kalinovsky on 9/15/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DTAAdditionalInfoCellType) {
    DTAAdditionalInfoCellTypeLocation = 0,
    DTAAdditionalInfoCellTypeEthnicGroup,
    DTAAdditionalInfoCellTypeRelationship,
    DTAAdditionalInfoCellTypeProfession,
    DTAAdditionalInfoCellTypeEducation,
    DTAAdditionalInfoCellTypeCountryOfOrigin,
    DTAAdditionalInfoCellTypeReligion,
    DTAAdditionalInfoCellTypeGoals,
    DTAAdditionalInfoCellTypeWantKids,
    DTAAdditionalInfoCellTypeHaveKids,
    DTAAdditionalInfoCellTypeOrientation
};

@protocol DTAAdditionalInfoCellDelegate;

@interface DTAAdditionalInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelOption;
@property (weak, nonatomic) IBOutlet UITextField *fieldValue;
@property (nonatomic, strong) NSDictionary *valueDictionary;
@property (weak, nonatomic) id<DTAAdditionalInfoCellDelegate> delegate;

+ (NSString *)reuseIdentifier;

- (void)updateFieldValue:(NSString *)value;
- (void)configureCellAtIndex:(NSInteger)index inputView:(UIView *)inputView sender:(id)sender;
- (void)makeFieldFirstResponder;
//- (void)disableCell:(BOOL)state; - NOT used

@end

@protocol DTAAdditionalInfoCellDelegate <NSObject>

- (void)didTapDoneButtonOnCell:(DTAAdditionalInfoCell *)cell;

@end
