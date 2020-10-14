//
//  DTASettingsActionsTableViewCell.h
//  DatingApp
//
//  Created by VLADISLAV KIRIN on 10/28/15.
//  Copyright © 2015 Cleveroad Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kDTASettingsActionsTableViewCell;
extern CGFloat const kDTASettingsActionsTableViewCellHeight;

@protocol DTASettingsActionCellDelegate <NSObject>

- (void)actionLogoutButtonPressed:(id)sender;
- (void)actionDeleteAccountButtonPressed:(id)sender;

@end

@interface DTASettingsActionsTableViewCell : UITableViewCell

@property (nonatomic, weak) id <DTASettingsActionCellDelegate> delegate;

@end
