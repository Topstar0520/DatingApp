//
//  BlockedUserTableViewCell.h
//  DatingApp
//
//  Created by Apple on 04/05/19.
//  Copyright © 2019 Cleveroad Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BlockedUserTableViewCellDelegate;

@interface BlockedUserTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIButton *unBlockUserButton;

@property (weak, nonatomic) id <BlockedUserTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

@protocol BlockedUserTableViewCellDelegate

@optional

- (void)unBlockUserButtonClicked: (BlockedUserTableViewCell *_Nullable) cell;

@end
