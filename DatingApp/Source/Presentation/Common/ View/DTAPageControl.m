//
//  DTAPageControl.m
//  DatingApp
//
//  Created by VLADISLAV KIRIN on 8/10/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import "DTAPageControl.h"

@implementation DTAPageControl

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    activeImage = [UIImage imageNamed:@"bt_circle_edit"];
    inactiveImage = [UIImage imageNamed:@"bt_circle_nofill"];
    
    return self;
}

-(void) updateDots {
    for (int i = 0; i < [self.subviews count]; i++) {
        UIImageView * dot = [self imageViewForSubview:  [self.subviews objectAtIndex: i]];
        
        if (i == self.currentPage) {
            dot.image = activeImage;
        }
        else {
            dot.image = inactiveImage;
        }
    }
}

- (void)setCurrentPage:(NSInteger)page {
    [super setCurrentPage:page];
    
    [self updateDots];
}

- (UIImageView *) imageViewForSubview: (UIView *) view {
    UIImageView * dot = nil;
    
    if ([view isKindOfClass: [UIView class]]) {
        for (UIView* subview in view.subviews) {
            if ([subview isKindOfClass:[UIImageView class]]) {
                dot = (UIImageView *)subview;
                break;
            }
        }
        
        if (dot == nil) {
            dot = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, view.frame.size.width, view.frame.size.height)];
            [view addSubview:dot];
        }
    }
    else {
        dot = (UIImageView *) view;
    }
    
    return dot;
}

@end
