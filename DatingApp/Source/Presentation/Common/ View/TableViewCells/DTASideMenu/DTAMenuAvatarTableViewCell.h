//
//  DTAMenuAvatarTableViewCell.h
//  DatingApp
//
//  Created by VLADISLAV KIRIN on 8/14/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const kDTAMenuAvatarTableViewCell = @"DTAMenuAvatarTableViewCell";
static CGFloat const kDTAMenuAvatarTableViewCellHeight = 135.f;

@interface DTAMenuAvatarTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *avatarButton;

- (void)configureCell;

@end
