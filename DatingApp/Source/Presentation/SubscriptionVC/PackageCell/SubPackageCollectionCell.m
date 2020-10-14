//
//  SubPackageCollectionCell.m
//  AudioBook
//
//  Created by Tushar  on 03/10/18.
//  Copyright © 2018 KanhaiyaKIPL. All rights reserved.
//

#import "SubPackageCollectionCell.h"

@implementation SubPackageCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setShadowInBackground];
    [self setOuterViewBorders];
}

-(void)setShadowInBackground {
    self.outerView.layer.masksToBounds = NO;
    // *** Set light gray color as shown in sample ***
    self.shadowView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
//    // *** *** Use following to add Shadow top, left ***
//    self.outerView.layer.shadowOffset = CGSizeMake(-5.0f, -5.0f);
    
    // *** Use following to add Shadow bottom, right ***
    //self.avatarImageView.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
    
    // *** Use following to add Shadow top, left, bottom, right ***
     self.shadowView.layer.shadowOffset = CGSizeZero;
     self.shadowView.layer.shadowRadius = 5.0f;
    
    // *** Set shadowOpacity to full (1) ***
    self.shadowView.layer.shadowOpacity = 1.0f;
}

-(void)setOuterViewBorders {
    self.outerView.layer.cornerRadius = 10;
    self.outerView.clipsToBounds = YES;
//    self.outerView.layer.borderWidth = 0.8;
//    self.outerView.layer.borderColor = [UIColor redColor].CGColor;
}

-(void)expandCell:(BOOL)isSelected {
    self.topConstraint.constant = (isSelected) ?  12.0f : 23.5f;
    self.bottomConstraint.constant = (isSelected) ?  12.0f : 23.5f;
    [self updateConstraintsIfNeeded];
    [self setNeedsLayout];
}

@end
