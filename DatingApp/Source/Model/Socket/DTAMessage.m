//
//  DTAMessage.m
//  DatingApp
//
//  Created by Maksim on 13.10.15.
//  Copyright © 2015 Cleveroad Inc. All rights reserved.
//

#import "DTAMessage.h"

@implementation DTAMessage

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    if (self = [super init]) {
        _from = dictionary[@"from"];
        _messageId = dictionary[@"id"];
        _message = dictionary[@"message"];
        _time = [dictionary[@"timestamp"] doubleValue];
    }
    
    return self;
}

@end
