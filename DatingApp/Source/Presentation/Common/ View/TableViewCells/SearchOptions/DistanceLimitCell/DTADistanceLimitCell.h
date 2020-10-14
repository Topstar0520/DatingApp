//
//  DTADistanceLimitCell.h
//  DatingApp
//
//  Created by  Artem Kalinovsky on 9/15/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTADistanceLimitCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *selectedDistaceLabel;
@property (weak, nonatomic) IBOutlet UISlider *distanceSlider;

+ (NSString *)reuseIdentifier;

- (void)configureCellWithInputView:(UIView *)inputView sender:(id)sender;

@end
