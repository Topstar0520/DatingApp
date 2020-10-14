//
//  DTANearbyTableViewCell.h
//  DatingApp
//
//  Created by Maksim on 23.10.15.
//  Copyright © 2015 Cleveroad Inc. All rights reserved.
//

@import UIKit;
@class User;

@interface DTANearbyTableViewCell : UITableViewCell

- (void)configureWithUser:(User *)user;

@end
