//
//  DTASettingsActionsTableViewCell.m
//  DatingApp
//
//  Created by VLADISLAV KIRIN on 10/28/15.
//  Copyright © 2015 Cleveroad Inc. All rights reserved.
//

#import "DTASettingsActionsTableViewCell.h"

NSString * const kDTASettingsActionsTableViewCell = @"DTASettingsActionsTableViewCell";
const CGFloat kDTASettingsActionsTableViewCellHeight = 120.f;

@interface DTASettingsActionsTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *buttonDeleteAccount;
@property (weak, nonatomic) IBOutlet UIButton *buttonLogout;

- (IBAction)actionPressLogoutButton:(id)sender;
- (IBAction)actionPressDeleteAccountButton:(id)sender;

@end

@implementation DTASettingsActionsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.buttonLogout.layer.cornerRadius = self.buttonLogout.frame.size.height / 2;
    self.buttonLogout.layer.borderColor = colorCreamCan.CGColor;
    self.buttonLogout.layer.borderWidth = 1;
    self.buttonLogout.layer.masksToBounds = YES;

    self.buttonDeleteAccount.layer.cornerRadius = self.buttonDeleteAccount.frame.size.height / 2;
    self.buttonDeleteAccount.layer.borderColor = colorMahogany.CGColor;
    self.buttonDeleteAccount.layer.borderWidth = 1;
    self.buttonDeleteAccount.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

#pragma mark - IBActions

- (IBAction)actionPressLogoutButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(actionLogoutButtonPressed:)]) {
        [self.delegate actionLogoutButtonPressed:self];
    }
}

- (IBAction)actionPressDeleteAccountButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(actionDeleteAccountButtonPressed:)]) {
        [self.delegate actionDeleteAccountButtonPressed:self];
    }
}

@end
