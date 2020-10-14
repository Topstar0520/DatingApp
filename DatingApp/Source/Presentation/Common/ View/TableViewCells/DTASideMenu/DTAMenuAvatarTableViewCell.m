//
//  DTAMenuAvatarTableViewCell.m
//  DatingApp
//
//  Created by VLADISLAV KIRIN on 8/14/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import "DTAMenuAvatarTableViewCell.h"
#import "User+Extension.h"

@interface DTAMenuAvatarTableViewCell  ()

@property (weak, nonatomic) IBOutlet UIImageView *imageAvatar;

@end

@implementation DTAMenuAvatarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.imageAvatar.layer.cornerRadius = (self.imageAvatar.layer.bounds.size.width * ([[UIScreen mainScreen] bounds].size.width / 375)) / 2;
    self.imageAvatar.layer.masksToBounds = YES;
    self.imageAvatar.layer.borderWidth = 2;
    self.imageAvatar.layer.borderColor = colorCreamCan.CGColor;
}

- (void)configureCell {
    
    __weak typeof(self) weakSelf = self;
    [DTAAPI profileFullFetchForUserId:[User currentUser].userId completion:^(NSError *error, NSArray *dataArr) {
         if (!error) {
             
             //DEV
             User *tmpUser = [[User alloc] initWithDictionary:dataArr[0]];
             
             if(tmpUser.avatar.length != 0) {
                 
                 [weakSelf.imageAvatar sd_setImageWithURL:[NSURL URLWithString:tmpUser.avatar] placeholderImage:[UIImage imageNamed:@"drefaultImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                     if ([[User currentUser].avatar length]) {
                     if ([tmpUser.avatar length]) {
                          if (error) {
                              NSLog(@"MenuAvatarTableViewCell sdwebimage imageAvatar download error: \n %@",error);
                          }
                      }
                      
                      if (image && !error) {
                          weakSelf.imageAvatar.image = image;
                      }
                  }];
             }
             else {
                     weakSelf.imageAvatar.image = [UIImage imageNamed:@"drefaultImage"];
             }
         }
         else {
             NSLog(@"here");
         }
     }];
}

@end
