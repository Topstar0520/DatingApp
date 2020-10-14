//
//  DTABaseViewController.h
//  DatingApp
//
//  Created by VLADISLAV KIRIN on 8/3/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTABaseViewController : UIViewController

- (void)setupNavBar;
- (void)setupNavBarInvert;

- (void)setupNavBarWithTitle:(NSString *)title;
- (void)setupNavBarInvertWithTitle:(NSString *)title;

- (void)setupBackButton;
- (void)setupBackButtonInvert;

@end
