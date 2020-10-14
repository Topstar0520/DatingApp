//
//  FacebookImageVC.h
//  DatingApp
//
//  Created by Apple on 13/02/20.
//  Copyright © 2020 Cleveroad Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FacebookImageVC : UIViewController<UICollectionViewDelegateFlowLayout>

/**
 Reference to NSString holds image Url From FB
 */
@property (strong, nonatomic) NSString *imgUrlSring;
@property (nonatomic, strong) User *user;

@end

NS_ASSUME_NONNULL_END
