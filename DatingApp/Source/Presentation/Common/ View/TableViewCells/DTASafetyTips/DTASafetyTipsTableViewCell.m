//
//  DTASafetyTipsTableViewCell.m
//  DatingApp
//
//  Created by VLADISLAV KIRIN on 10/28/15.
//  Copyright © 2015 Cleveroad Inc. All rights reserved.
//

#import "DTASafetyTipsTableViewCell.h"

NSString * const kDTASafetyTipsTableViewCell = @"DTASafetyTipsTableViewCell";

@interface DTASafetyTipsTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelText;

@end

@implementation DTASafetyTipsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
