//
//  DTAConversationsTableViewCell.m
//  DatingApp
//
//  Created by Maksim on 23.10.15.
//  Copyright © 2015 Cleveroad Inc. All rights reserved.
//

#import "DTAConversationsTableViewCell.h"
#include "DTAconversation.h"
#import "NSDate+ChatTimeFormat.h"

typedef NS_ENUM(NSUInteger, DTAChatEnum) {
    DTAChatEnumImage = 1,
    DTAChatEnumName,
    DTAChatEnumDate,
    DTAChatEnumMessage,
    DTAChatEnumUnReadView,
    DTAChatEnumUnReadCount
};

@implementation DTAConversationsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIImageView *userPhoto = (UIImageView *)[self viewWithTag:DTAChatEnumImage];
    userPhoto.layer.cornerRadius = (userPhoto.layer.bounds.size.width * ([[UIScreen mainScreen] bounds].size.width / 375)) / 2;
    [userPhoto.layer setMasksToBounds:YES];
    [userPhoto.layer setBorderColor:colorCreamCan.CGColor];
    [userPhoto.layer setBorderWidth:1.5];
}

- (void)configureWithUser:(DTAconversation *)conversation {
    
    UIImageView *userPhoto = (UIImageView *)[self viewWithTag:DTAChatEnumImage];
    
    UILabel *date = (UILabel *)[self viewWithTag:DTAChatEnumDate];
    date.text = [NSDate relativeDateStringForDate:conversation.date];

    UILabel *name = (UILabel *)[self viewWithTag:DTAChatEnumName];
    name.text = conversation.nameAge;

    UILabel *message = (UILabel *)[self viewWithTag:DTAChatEnumMessage];
    message.text = conversation.lastTextMessage;

    if (conversation.isFriendDeleted) {
        [userPhoto setImage:[UIImage imageNamed:@"deletedUser"]];
    }
    else if (conversation.avatarUrl) {
        [userPhoto sd_setImageWithURL:conversation.avatarUrl placeholderImage:[UIImage imageNamed:@"drefaultImage"] options:SDWebImageDelayPlaceholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
            
        }];
    }
    else {
        userPhoto.image = [UIImage imageNamed:@"drefaultImage"];
    }
    
    UIView *unReadCountView = (UIView *)[self viewWithTag:DTAChatEnumUnReadView];
    [unReadCountView setHidden:YES];
    
    //UILabel *unReadCountLavel = (UILabel *)[self viewWithTag:DTAChatEnumUnReadCount];
    //message.text = conversation.lastTextMessage;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
