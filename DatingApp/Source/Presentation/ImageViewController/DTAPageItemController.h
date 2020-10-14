//
//  DTAImageViewController.h
//  DatingApp
//
//  Created by Maksim on 16.09.15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTAPageItemController : UIViewController

// Item controller information
@property (nonatomic) NSInteger itemIndex;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSURL *imageUrl;

// IBOutlets
@property (nonatomic, weak) IBOutlet UIImageView *contentImageView;

@end
