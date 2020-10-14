//
//  Session+Extensions.m
//  DatingApp
//
//  Created by VLADISLAV KIRIN on 8/14/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import "Image+Extensions.h"

@implementation Image (Extensions)

- (NSURL *)fetchPictureUrl {
    return [NSURL URLWithString:self.path];
}

@end
