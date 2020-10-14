//
//  DTAProfileNavigationTableViewCell.h
//  DatingApp
//
//  Created by VLADISLAV KIRIN on 8/11/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTAProfileTableViewCell.h"

static NSString * const kDTAProfileNavigationTableViewCell = @"DTAProfileNavigationTableViewCell";
static CGFloat DTAProfileNavigationTableViewCellHeight = 90.f;

@protocol DTAProfileNavigationTableViewCellDelegate <NSObject>

@optional

- (void)toNextVC:(id)sender;
- (void)toPreviousVC:(id)sender;

@end

@interface DTAProfileNavigationTableViewCell : UITableViewCell

@property (weak, nonatomic) id <DTAProfileNavigationTableViewCellDelegate> delegate;

- (void)configureCell;
- (void)hideNextButton;

@end
