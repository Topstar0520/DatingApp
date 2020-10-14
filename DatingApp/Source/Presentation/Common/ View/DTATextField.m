//
//  DTATextField.m
//
//  Created by VLADISLAV KIRIN on 7/2/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import "DTATextField.h"

@implementation DTATextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 50.0f, 0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

- (void)setupLeftViewWithImageNamed:(NSString *)imageName; {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
   
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, (self.frame.size.height - imageView.frame.size.height) /2, imageView.frame.size.width, imageView.frame.size.height)];
    
    [view addSubview:imageView];
    
    [self addSubview:view];
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds {
    CGRect textRect = [super rightViewRectForBounds:bounds];
    textRect.origin.x -= 10;

    return textRect;
}

@end
