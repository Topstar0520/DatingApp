//
//  DTAEditProfileViewController.h
//  DatingApp
//
//  Created by VLADISLAV KIRIN on 8/25/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import "DTABaseViewController.h"

@interface DTAEditProfileViewController : DTABaseViewController

@property (nonatomic, assign) BOOL isFromRegisterVC;
@property (strong, nonatomic) User *editingUser;

@end
