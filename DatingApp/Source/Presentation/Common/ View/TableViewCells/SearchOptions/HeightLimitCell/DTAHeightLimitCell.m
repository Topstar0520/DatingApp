//
//  DTAHeightLimitCell.m
//  DatingApp
//
//  Created by  Artem Kalinovsky on 9/15/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import "DTAHeightLimitCell.h"
#import "REDRangeSlider.h"
#import "DTASearchOptionsManager.h"
#import "SearchOptions.h"

@interface DTAHeightLimitCell()

@end

@implementation DTAHeightLimitCell

+ (NSString *)reuseIdentifier {
    return  @"searchHeightBoundsCellIdentifier";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.heightIntervalSlider.handleImage = [UIImage imageNamed:@"ico_slider_handle"];
   
    self.heightIntervalSlider.handleHighlightedImage = [UIImage imageNamed:@"ico_slider_handle"];
    
    self.heightIntervalSlider.trackBackgroundImage = [[UIImage imageNamed:@"ico_slider_track_empty"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 5, 4, 5)];
    
    self.heightIntervalSlider.trackFillImage = [[UIImage imageNamed:@"ico_slider_track_filled"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 5, 4, 5)];
    
    self.heightIntervalSlider.minValue = 0.0f;
    self.heightIntervalSlider.maxValue = 95.0f;
    self.heightIntervalSlider.minimumSpacing = 0.0f;
    self.selectedHeightRangeLabel.text = @"0 ft 0 inch-7 ft 11 inch";
    
    [self.heightIntervalSlider addTarget:self action:@selector(rangeSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configureCellWithInputView:(UIView *)inputView sender:(id)sender {
    
}

- (IBAction)rangeSliderValueChanged:(id)sender {
    if (self.heightIntervalSlider.leftValue < 48) {
        self.heightIntervalSlider.leftValue = 48;
    }

    int minimalHeightCm = (int) self.heightIntervalSlider.leftValue;
    int maximalHeightCm = (int) self.heightIntervalSlider.rightValue;
    
    NSUInteger minInchesTotal = (NSUInteger) (minimalHeightCm);
    NSUInteger feet = minInchesTotal / 12;
    NSUInteger inches = minInchesTotal % 12;
    NSString *minResult = [NSString stringWithFormat:@"%lu ft %lu inch", (unsigned long)feet, (unsigned long)inches];
    
    NSUInteger maxInchesTotal = (NSUInteger) (maximalHeightCm);
    feet = maxInchesTotal / 12;
    inches = maxInchesTotal % 12;
    NSString *maxResult = [NSString stringWithFormat:@"%lu ft %lu inch", (unsigned long)feet, (unsigned long)inches];
    
    self.selectedHeightRangeLabel.text = [NSString stringWithFormat:@"%@-%@", minResult, maxResult];

    [DTASearchOptionsManager sharedManager].searchOptions.heightFrom = @(minimalHeightCm);
    [DTASearchOptionsManager sharedManager].searchOptions.heightTo = @(maximalHeightCm);
}

@end
