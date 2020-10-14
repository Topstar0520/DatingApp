//
//  SubHeaderCell.m
//  AudioBook
//
//  Created by Tushar  on 02/10/18.
//  Copyright © 2018 KanhaiyaKIPL. All rights reserved.
//

#import "SubHeaderCell.h"

@implementation SubHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.view1.layer.cornerRadius = 5;
    self.view1.clipsToBounds = YES;
    
    self.view2.layer.cornerRadius = 5;
    self.view2.clipsToBounds = YES;
    
    self.view3.layer.cornerRadius = 5;
    self.view3.clipsToBounds = YES;
    
    self.headerLbl.text = @"JollofDate+ Packages";
    self.unlimitedLbl.text = @"Unlimited match for subscribed period";
    self.downloadLbl.text = @"Unlimited number of likes to use";
    self.firstMonthLbl.text = @"Option to see all the other members who liked you at the same time";

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
