//
//  DTADistanceLimitCell.m
//  DatingApp
//
//  Created by  Artem Kalinovsky on 9/15/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import "DTADistanceLimitCell.h"
#import "DTASearchOptionsManager.h"
#import "SearchOptions.h"

@interface DTADistanceLimitCell()

@end

@implementation DTADistanceLimitCell

+ (NSString *)reuseIdentifier {
    return  @"searchDistanceLimitCellIdentifier";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.distanceSlider.continuous = YES;
    self.distanceSlider.value = 1.0;
   
    self.selectedDistaceLabel.text = @"1 miles";
    
    [self.distanceSlider setThumbImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"ico_slider_handle"].CGImage scale:1.76f orientation:UIImageOrientationUp] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)configureCellWithInputView:(UIView *)inputView sender:(id)sender {

}

- (IBAction)changeValueOfDistanceSlider:(UISlider *)sender {
    int result = (int) roundf(sender.value);
    
    if (result <= 300) {
        self.selectedDistaceLabel.text = [NSString stringWithFormat:@"%i miles", result];
    }
    else {
        self.selectedDistaceLabel.text = @"300+ miles";
    }
   
    [DTASearchOptionsManager sharedManager].searchOptions.nearbyRadius = @(result);
}

@end
