//
//  DTAProfileTableViewCellAvatar.m
//  DatingApp
//
//  Created by VLADISLAV KIRIN on 8/10/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import "DTAProfileTableViewCellAvatar.h"
#import "User+Extension.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DTAProfileTableViewCellAvatar ()

@property (weak, nonatomic) IBOutlet UIImageView *imageAvatarExternal;
@property (weak, nonatomic) IBOutlet UIImageView *imageAvatarInternal;
@property (weak, nonatomic) IBOutlet UIButton *buttonAddAvatar;

@property (weak, nonatomic) IBOutlet UITextField *fieldFirstName;
@property (weak, nonatomic) IBOutlet UITextField *fieldLastName;

- (IBAction)actionPressAvatar:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintImageAvatarWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintImageAvatarOffsetTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintImageAvatarOffsetRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintImageAvatarOffsetBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintImageAvatarOffsetLeft;

@end

@implementation DTAProfileTableViewCellAvatar

#pragma mark - LifeCycle

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.avatarHeight.constant /= scaleCoefficient;
    self.constraintImageAvatarWidth.constant /= scaleCoefficient;
    self.constraintImageAvatarOffsetTop.constant /= scaleCoefficient;
    self.constraintImageAvatarOffsetRight.constant /= scaleCoefficient;
    self.constraintImageAvatarOffsetBottom.constant /= scaleCoefficient;
    self.constraintImageAvatarOffsetLeft.constant /= scaleCoefficient;
    
    [self.fieldFirstName setFont:[UIFont fontWithName:self.fieldFirstName.font.fontName size:self.fieldFirstName.font.pointSize / scaleCoefficient]];
    [self.fieldLastName setFont:[UIFont fontWithName:self.fieldLastName.font.fontName size:self.fieldLastName.font.pointSize / scaleCoefficient]];
}

#pragma mark - public

- (void)hideAvatar {
    self.imageAvatarExternal.hidden = YES;
    self.imageAvatarInternal.hidden = YES;
    self.buttonAddAvatar.hidden = YES;
}

- (void)configureCell:(id)sender user:(User *)user editedAvatar:(UIImage *)avatar fromRegisterVC:(BOOL)isFromRegisterVC {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.fieldFirstName.delegate = sender;
    self.fieldLastName.delegate = sender;
    
    self.fieldFirstName.tag = DTAProfileTextFieldTypeFirstName;
    self.fieldLastName.tag  = DTAProfileTextFieldTypeLastName;
    
    self.avatarHeight.constant *= scaleCoefficient;
    self.constraintImageAvatarWidth.constant *= scaleCoefficient;
    self.constraintImageAvatarOffsetTop.constant *= scaleCoefficient;
    self.constraintImageAvatarOffsetRight.constant *= scaleCoefficient;
    self.constraintImageAvatarOffsetBottom.constant *= scaleCoefficient;
    self.constraintImageAvatarOffsetLeft.constant *= scaleCoefficient;
    [self layoutIfNeeded];
    
    self.imageAvatarExternal.layer.cornerRadius = self.imageAvatarExternal.layer.bounds.size.height / 2;
    self.imageAvatarInternal.layer.cornerRadius = self.imageAvatarInternal.layer.bounds.size.height / 2;
    self.imageAvatarInternal.layer.masksToBounds = YES;
    
    if (![self.fieldFirstName.text length]) {
        self.fieldFirstName.text = user.firstName;
    }
    
    if (![self.fieldLastName.text length]) {
        self.fieldLastName.text = user.lastName;
    }
    
    [self.fieldFirstName setFont:[UIFont fontWithName:self.fieldFirstName.font.fontName size:self.fieldFirstName.font.pointSize * scaleCoefficient]];
    [self.fieldLastName setFont:[UIFont fontWithName:self.fieldLastName.font.fontName size:self.fieldLastName.font.pointSize * scaleCoefficient]];
    
    if(avatar) {
        [self.imageAvatarInternal setImage:avatar];
    }
    else {
        [self.imageAvatarInternal sd_setImageWithURL:[NSURL URLWithString:user.avatar] completed:nil];
        
    }
    
    if(avatar || user.avatar) {
        self.buttonAddAvatar.alpha = 0.05;
    }
    
    if(!isFromRegisterVC) {
        self.avatarHeight.constant = 5.0f;
        self.avatarTopSpaceConstraint.constant = 0.0f;
    }
}

- (void)setAvatar:(UIImage *)image; {
    self.imageAvatarInternal.image = image;
    [self.buttonAddAvatar setImage:nil forState:UIControlStateNormal];
}

- (NSString *)getFirstName; {
    return self.fieldFirstName.text;
}

- (NSString *)getLastName; {
    return self.fieldLastName.text;
}

#pragma mark - private

- (IBAction)actionPressAvatar:(id)sender {
    if ([self.delegate respondsToSelector:@selector(addAvatar:)]) {
        [self.delegate addAvatar:self];
    }
}

#pragma mark -

@end
