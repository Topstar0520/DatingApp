//
//  ProspectsTableViewCell.m
//  DatingApp
//
//  Created by  Artem Kalinovsky on 9/2/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import "ProspectsTableViewCell.h"
#import "User.h"
#import "Location.h"
#import "User+Extension.h"

@interface ProspectsTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *profilePhotoBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameAndAgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLocationLabel;

@end

@implementation ProspectsTableViewCell

- (void)configureWithUser:(User *)user {
    //    self.profilePhotoBackgroundView.backgroundColor = colorCreamCan;
    //    self.profilePhotoBackgroundView.layer.cornerRadius = 27.0f;
    
    self.userAvatarImageView.layer.cornerRadius = 27.0f;
    self.userAvatarImageView.layer.borderWidth = 2.5f;
    self.userAvatarImageView.clipsToBounds = YES;
    self.userAvatarImageView.layer.borderColor = [colorCreamCan CGColor];
    
    self.userNameAndAgeLabel.text = [NSString stringWithFormat:@"%@, %li", user.firstName, (long)[user userAge]];;
    
    self.userLocationLabel.text = user.location.locationTitle;

    [self.userAvatarImageView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"drefaultImage"] options:SDWebImageDelayPlaceholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            self.userAvatarImageView.image = [UIImage imageNamed:@"drefaultImage"];
        }
    }];
}

@end
