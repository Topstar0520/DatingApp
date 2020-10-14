//
//  DTAconversation.h
//  DatingApp
//
//  Created by Maksim on 12.10.15.
//  Copyright © 2015 Cleveroad Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTAconversation : NSObject

@property (nonatomic, readonly) NSString * idUser;
@property (nonatomic, readonly) NSString *idFriend;
@property (nonatomic, assign) BOOL isFriendDeleted;
@property (nonatomic, strong) NSString *lastTextMessage;
@property (nonatomic, readonly) NSURL *avatarUrl;
@property (nonatomic, assign) double date;
@property (nonatomic, readonly) BOOL unreadMessages;
@property (nonatomic, readonly) NSString *nameAge;
@property (nonatomic, readonly) NSString *chatId;
@property (nonatomic, readonly) BOOL blocked;
@property (nonatomic, readonly) BOOL is_matched;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
