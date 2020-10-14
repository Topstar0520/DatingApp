//
//  DTAImageViewController.h
//  DatingApp
//
//  Created by Maksim on 16.09.15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#import "DTAPageItemController.h"
#import "MBProgressHUD.h"

@interface DTAPageItemController ()

@end

@implementation DTAPageItemController

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [MBProgressHUD showHUDAddedTo:self.contentImageView animated:YES];

    __weak typeof(self) weakSelf = self;

    dispatch_async(kBgQueue, ^{
        NSData *dataImage = [NSData dataWithContentsOfURL:self.imageUrl];
    
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:weakSelf.contentImageView animated:YES];
        });
        
        if(dataImage) {
            UIImage *image = [UIImage imageWithData:dataImage];
        
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.contentImageView.image = image;
            });
        }
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark -
#pragma mark Content

@end
