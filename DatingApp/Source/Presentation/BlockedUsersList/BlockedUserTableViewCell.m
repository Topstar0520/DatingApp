//
//  BlockedUserTableViewCell.m
//  DatingApp
//
//  Created by Apple on 04/05/19.
//  Copyright © 2019 Cleveroad Inc. All rights reserved.
//

#import "BlockedUserTableViewCell.h"

@implementation BlockedUserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.userImageView.layer setCornerRadius:(self.userImageView.frame.size.width * ([[UIScreen mainScreen] bounds].size.width/375))/2];
    [self.userImageView.layer setMasksToBounds:YES];
    [self.userImageView.layer setBorderColor:colorCreamCan.CGColor];
    [self.userImageView.layer setBorderWidth:1.5];
    
    [self.unBlockUserButton.layer setCornerRadius:self.unBlockUserButton.frame.size.height / 2];
    [self.unBlockUserButton.layer setMasksToBounds:YES];
    [self.unBlockUserButton.layer setBorderColor:colorCreamCan.CGColor];
    [self.unBlockUserButton.layer setBorderWidth:1.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)unBlockUserButtonAction:(id)sender {
    [self.delegate unBlockUserButtonClicked:self];
}

@end
