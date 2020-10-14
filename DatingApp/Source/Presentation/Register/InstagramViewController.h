//
//  InstagramViewController.h
//  DatingApp
//
//  Created by Apple on 30/04/19.
//  Copyright © 2019 Cleveroad Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol InstagramViewControllerDelegate <NSObject>
- (void) getInstagramLoginToken: (NSString *) accessToken;
@end

@interface InstagramViewController : UIViewController

@property (weak, nonatomic) NSString *authString;
@property (weak) id <InstagramViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
