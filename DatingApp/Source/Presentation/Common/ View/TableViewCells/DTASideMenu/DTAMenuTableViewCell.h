//
//  DTAMenuTableViewCell.h
//  DatingApp
//
//  Created by VLADISLAV KIRIN on 8/3/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const kDTAMenuTableViewCell = @"DTAMenuTableViewCell";
static CGFloat const kDTAMenuTableViewCellHeight = 45.f;

typedef NS_ENUM(NSUInteger, DTAMenuItems) {
    DTAMenuItemSearchOptions = 0,
    DTAMenuItemLikesYou,
    DtaMenuItemMatches,
    DTAMenuItemBrowse,
    DTAMenuItemNearby,
    DTAMenuItemConversations,
    DTAMenuItemSettings
};

static NSUInteger const kDTACountMenuItems = 7;

@interface DTAMenuTableViewCell : UITableViewCell

- (void)configureCellForType:(DTAMenuItems)type isCurrent:(BOOL)isCurrent;

@end
