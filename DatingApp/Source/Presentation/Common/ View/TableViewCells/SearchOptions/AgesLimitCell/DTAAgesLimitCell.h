//
//  DTAAgesLimitCell.h
//  DatingApp
//
//  Created by  Artem Kalinovsky on 9/15/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class REDRangeSlider;

@interface DTAAgesLimitCell : UITableViewCell

@property (weak, nonatomic) IBOutlet REDRangeSlider *agesIntervalSlider;
@property (weak, nonatomic) IBOutlet UILabel *selectedAgeRangeLabel;

+ (NSString *)reuseIdentifier;

- (void)configureCellWithInputView:(UIView *)inputView sender:(id)sender;

@end
