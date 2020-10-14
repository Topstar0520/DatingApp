//
//  DTAReportView.h
//  DatingApp
//
//  Created by VLADISLAV KIRIN on 12/9/15.
//  Copyright © 2015 Cleveroad Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DTAReportViewDelegate <NSObject>

- (void)proceedReportWithText:(NSString *)text image:(UIImage *)image;
- (void)cancelButtonPressed:(id)sender;

@end

@interface DTAReportView : UIView

@property (weak, nonatomic) id <DTAReportViewDelegate> delegate;

+ (DTAReportView *)showInView:(UIView *)parentView delegate:(id <DTAReportViewDelegate>)delegate;

- (void)dismissReportView;

@end
