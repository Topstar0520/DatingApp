//
//  DTAAgesLimitCell.m
//  DatingApp
//
//  Created by  Artem Kalinovsky on 9/15/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import "DTAAgesLimitCell.h"
#import "REDRangeSlider.h"
#import "DTASearchOptionsManager.h"
#import "SearchOptions.h"

@interface DTAAgesLimitCell()

@end

static float kMaxAgeValue = 80.0f;

@implementation DTAAgesLimitCell

+ (NSString *)reuseIdentifier {
    return  @"searchAgeBoundsCellIdentifier";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.agesIntervalSlider.handleImage = [UIImage imageNamed:@"ico_slider_handle"];
   
    self.agesIntervalSlider.handleHighlightedImage = [UIImage imageNamed:@"ico_slider_handle"];
    
    self.agesIntervalSlider.trackBackgroundImage = [[UIImage imageNamed:@"ico_slider_track_empty"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 5, 4, 5)];
    
    self.agesIntervalSlider.trackFillImage = [[UIImage imageNamed:@"ico_slider_track_filled"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 5, 4, 5)];

    self.agesIntervalSlider.minValue = DTAMinAgeValue;
    self.agesIntervalSlider.maxValue = kMaxAgeValue;
    self.agesIntervalSlider.minimumSpacing = 0.0f;
    
    self.selectedAgeRangeLabel.text = @"0-80";
    
    [self.agesIntervalSlider addTarget:self action:@selector(rangeSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configureCellWithInputView:(UIView *)inputView sender:(id)sender {
    self.agesIntervalSlider.rightValue = kMaxAgeValue;
    self.agesIntervalSlider.leftValue = DTAMinAgeValue;
}

- (IBAction)rangeSliderValueChanged:(id)sender {
    int minimalAge = (int) self.agesIntervalSlider.leftValue;
    int maximalAge = (int) self.agesIntervalSlider.rightValue;
    self.selectedAgeRangeLabel.text = [NSString stringWithFormat:@"%i-%i", minimalAge, maximalAge];
   
    [DTASearchOptionsManager sharedManager].searchOptions.ageFrom = @(minimalAge);
    [DTASearchOptionsManager sharedManager].searchOptions.ageTo = @(maximalAge);
}

@end
