//
//  DTAMenuTableViewCell.m
//  DatingApp
//
//  Created by VLADISLAV KIRIN on 8/3/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import "DTAMenuTableViewCell.h"
#import "User+Extension.h"

@interface DTAMenuTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *labelMenuItem;
@property (weak, nonatomic) IBOutlet UIImageView *imageLeftIco;

@property (strong, nonatomic) UIView *indicator;

@end

@implementation DTAMenuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.labelMenuItem.font = [UIFont fontWithName:self.labelMenuItem.font.fontName size:self.labelMenuItem.font.pointSize * scaleCoefficient];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.labelMenuItem.text = @"";
}

- (void)configureCellForType:(DTAMenuItems)type isCurrent:(BOOL)isCurrent {
    BOOL isHaveIndicator = NO;
    
    NSString *imageName;
    
    switch (type) {
        case DTAMenuItemSearchOptions:
            self.labelMenuItem.text = @"Search options";
            imageName = @"sb_search";
            break;
     
        case DTAMenuItemLikesYou:
            self.labelMenuItem.text = @"Likes You";
            imageName = @"sb_matches";
            
            if ([[User currentUser].likesBadge integerValue]) {
                isHaveIndicator = YES;
            }
            
            break;
        
        case DtaMenuItemMatches:
            self.labelMenuItem.text = @"Matches";
            imageName = @"sb_prospects";
            
            if ([[User currentUser].matchesBadge integerValue]) {
                isHaveIndicator = YES;
            }
            
            break;
        
        case DTAMenuItemBrowse:
            self.labelMenuItem.text = @"Browse";
            imageName = @"sb_browse";
            break;
        
        case DTAMenuItemNearby:
            self.labelMenuItem.text = @"Nearby";
            imageName = @"sb_nearby";
            break;
        
        case DTAMenuItemConversations:
            self.labelMenuItem.text = @"Conversations";
            imageName = @"sb_conversations";
            
            if ([[User currentUser].messagesBadge integerValue]) {
                isHaveIndicator = YES;
            }
            
            break;
            
        case DTAMenuItemSettings:
            self.labelMenuItem.text = @"Settings";
            imageName = @"sb_settings";
            break;
            
        default:
            NSLog(@"Wrong DTAMenuITEM index");
            break;
    }
    
    if (isHaveIndicator && !self.indicator) {
        [self.labelMenuItem sizeToFit];
        CGFloat x = self.labelMenuItem.frame.origin.x + self.labelMenuItem.frame.size.width;
        self.indicator = [[UIView alloc] initWithFrame:CGRectMake(x, 16.0, 8.0, 8.0)];
        self.indicator.backgroundColor = [UIColor redColor];
        self.indicator.layer.cornerRadius = 4.0;
        [self addSubview:self.indicator];
    }
    else if (!isHaveIndicator && self.indicator) {
        [self.indicator removeFromSuperview];
        self.indicator = nil;
    }
    
    if(imageName) {
        if(isCurrent) {
            imageName = [imageName stringByAppendingString:@"_a"];
        }
        
        self.imageView.image = [UIImage imageNamed:imageName];
    }
    
    if(isCurrent) {
        [self.contentView setBackgroundColor:[UIColor colorWithRed:0.96 green:0.83 blue:0.44 alpha:1]];
        self.labelMenuItem.textColor = [UIColor whiteColor];
    }
    else {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        self.labelMenuItem.textColor = [UIColor colorWithRed:0.57 green:0.57 blue:0.57 alpha:1];
    }
}

@end
