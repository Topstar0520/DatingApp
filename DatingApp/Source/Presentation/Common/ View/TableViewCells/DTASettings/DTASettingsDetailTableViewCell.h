//
//  DTASettingsDetailTableViewCell.h
//  DatingApp
//
//  Created by VLADISLAV KIRIN on 10/28/15.
//  Copyright © 2015 Cleveroad Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kDTASettingsDetailTableViewCell;
extern CGFloat const kDTASettingsDetailCellsHeight;

typedef NS_ENUM(NSUInteger, DTASettingsDetailCell) {
    DTASettingsDetailCellPushNewMessages,
    DTASettingsDetailCellPushNewMatchs,
    DTASettingsDetailCellPushNewLikes,
    DTASettingsDetailCellBlockedUsers,
    DTASettingsDetailCellPrivacyPolicy,
    DTASettingsDetailCellTerms,
    DTASettingsDetailCellEmailUs
};

extern const NSUInteger kDTASettingsDetailCellsCount;

@interface DTASettingsDetailTableViewCell : UITableViewCell

- (void)configureCellWithType:(DTASettingsDetailCell)type;
- (NSInteger)switcherState;

@end
