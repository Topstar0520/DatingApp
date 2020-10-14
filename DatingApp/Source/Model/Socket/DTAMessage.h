//
//  DTAMessage.h
//  DatingApp
//
//  Created by Maksim on 13.10.15.
//  Copyright © 2015 Cleveroad Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTAMessage : NSObject

@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSString *messageId;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, assign) double time;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
