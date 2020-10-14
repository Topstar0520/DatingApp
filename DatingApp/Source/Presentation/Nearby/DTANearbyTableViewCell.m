//
//  DTANearbyTableViewCell.m
//  DatingApp
//
//  Created by Maksim on 23.10.15.
//  Copyright © 2015 Cleveroad Inc. All rights reserved.
//

#import "DTANearbyTableViewCell.h"
#import "User+Extension.h"
#import "Country+Extensions.h"
#import "Location+Extensions.h"

@implementation DTANearbyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configureWithUser:(User *)user {
    UILabel *name = (UILabel *)[self viewWithTag:1];
    name.text = [NSString stringWithFormat:@"%@, %li", user.firstName, (long)user.userAge];

    UILabel *city = (UILabel *)[self viewWithTag:2];
    city.text = [NSString stringWithFormat:@"%@", user.location.locationTitle];

    UILabel *activity = (UILabel *)[self viewWithTag:3];
    activity.text = [NSString stringWithFormat:@"Last Active: %@", @"online"];

    UILabel *distance = (UILabel *)[self viewWithTag:4];
    distance.text = @"";

    UIImageView *imageView = (UIImageView *)[self viewWithTag:5];

    imageView.image = [UIImage imageNamed:@"drefaultImage"];
    [imageView.layer setCornerRadius:65.0];
    imageView.layer.masksToBounds = YES;
    [imageView.layer setBorderColor:colorCreamCan.CGColor];
    [imageView.layer setBorderWidth:2.0];
    [imageView.layer setShadowColor:[UIColor blackColor].CGColor];
    [imageView.layer setShadowOpacity:0.8];
    [imageView.layer setShadowRadius:3.0];
    [imageView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];

    NSURL *url = [NSURL URLWithString:user.avatar];
    
    [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"drefaultImage"] options:SDWebImageDelayPlaceholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){}];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
