//
//  DTASelectCityViewController.h
//  DatingApp
//
//  Created by  Artem Kalinovsky on 8/18/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DTACitySelectionVCDelegate;

@interface DTASelectCityViewController : UIViewController

@property (weak, nonatomic) id <DTACitySelectionVCDelegate> delegate;
@property (strong, nonatomic) NSString *selecedCityStr;

@end

@protocol DTACitySelectionVCDelegate

@optional

- (void)citySelectionCompletedWithCity:(NSDictionary *)city;

@end
