//
//  DTASlidingViewController.m
//  DatingApp
//
//  Created by Maksim on 07.09.15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import "DTASlidingViewController.h"
#import "DTALocationManager.h"

@interface DTASlidingViewController ()

@end

@implementation DTASlidingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.recognizesPanGesture = NO;
    self.panningLimitedToTopViewController = NO;
}

- (UIBarButtonItem *)leftButtonForCenterPanel {
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithImage:[[self class] defaultImage] style:UIBarButtonItemStylePlain target:self action:@selector(pressMenuButton)];
    return btn;
}

- (void)pressMenuButton {
    [self.centerPanel.view endEditing:YES];
    [self showLeftPanelAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"needToReloadMenu" object:nil];
}

-(void) awakeFromNib {
    [super awakeFromNib];
    
    [self setLeftPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"DTAMenuViewControllerID"]];
    [self.leftPanel viewDidLoad];
    [self setCenterPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"DTABrowseNavigationControllerID"]];
    [self setRightPanel:nil];
    
    DTALocationManager *manager = [DTALocationManager new];
    [manager trackLocationWithCompletionBlock:^(CLLocation *location) {
        
    }];
}

//- (void)styleContainer:(UIView *)container animate:(BOOL)animate duration:(NSTimeInterval)duration {
//
//}

- (void)stylePanel:(UIView *)panel {
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

- (void)_addPanGestureToView:(UIView *)view {
    
}

- (void)_handlePan:(UIGestureRecognizer *)sender {
    
}

- (void)_completePan:(CGFloat)deltaX {
    
}

- (void)_undoPan {
    
}

@end
