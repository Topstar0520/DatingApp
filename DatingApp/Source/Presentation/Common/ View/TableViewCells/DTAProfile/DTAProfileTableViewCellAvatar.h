//
//  DTAProfileTableViewCellAvatar.h
//  DatingApp
//
//  Created by VLADISLAV KIRIN on 8/10/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const kDTAProfileTableViewCellAvatar = @"DTAProfileTableViewCellAvatar";
static CGFloat kDTAProfileTableViewCellAvatarHeight = 160.f;

typedef NS_ENUM(NSInteger, DTAProfileTextFieldType) {
    DTAProfileTextFieldTypeFirstName = 20,
    DTAProfileTextFieldTypeLastName  = 21
};

@protocol DTAProfileTableViewCellAvatarDelegate <NSObject>

- (void)addAvatar:(id)sender;

@end

@interface DTAProfileTableViewCellAvatar : UITableViewCell

@property (weak, nonatomic) id <DTAProfileTableViewCellAvatarDelegate> delegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarTopSpaceConstraint;

- (void)configureCell:(id)sender user:(User *)user editedAvatar:(UIImage *)avatar fromRegisterVC:(BOOL)isFromRegisterVC;
- (void)setAvatar:(UIImage *)image;
- (NSString *)getFirstName;
- (NSString *)getLastName;
- (void)hideAvatar;

@end
