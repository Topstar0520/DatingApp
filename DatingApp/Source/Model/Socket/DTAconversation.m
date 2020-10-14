//
//  DTAconversation.m
//  DatingApp
//
//  Created by Maksim on 12.10.15.
//  Copyright © 2015 Cleveroad Inc. All rights reserved.
//

#import "DTAconversation.h"
#import "User+Extension.h"

@implementation DTAconversation

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {

    if (self = [super init]) {
        
        NSLog(@"dictionary = %@", dictionary);
        
        NSString *userId = [[User currentUser] userId];
    
        NSInteger indexUser = 0;
        //if ([dictionary[@"users"] count] > 1)
        //{
        
        if ([userId isEqualToString:dictionary[@"users"][0][@"id"]]) {
            _idUser = dictionary[@"users"][0][@"id"];
            indexUser = 1;
        }
        else {
            
                _idUser = dictionary[@"users"][1][@"id"];
                indexUser = 0;
            }
           
        //}
        
        if ([dictionary[@"messages"] count] > 0) {
            _date = [dictionary[@"messages"][0][@"timestamp"] doubleValue];
        }
        else {
            _date = 0;
        }
        
        _idFriend = dictionary[@"users"][indexUser][@"id"];
        
        _isFriendDeleted = [dictionary[@"users"][indexUser][@"deleted"] boolValue];
        
        _chatId = dictionary[@"id"];
        
        if ([dictionary[@"messages"] count] > 0) {
            _lastTextMessage = dictionary[@"messages"][0][@"message"];
        }
        else {
            _lastTextMessage = @"";
        }
        
        _unreadMessages = [dictionary[@"unreadMessages"] boolValue];
        
        if ([dictionary[@"users"][indexUser][@"avatar"] length] > 0) {
            _avatarUrl = [NSURL URLWithString:dictionary[@"users"][indexUser][@"avatar"]];
        }
        else {
            _avatarUrl = nil;
        }
        
        NSString* age = dictionary[@"users"][indexUser][@"dateOfBirth"];
        
        NSString* name = dictionary[@"users"][indexUser][@"firstName"];
        
        _nameAge = [NSString stringWithFormat:@"%@, %li", name, (long)[self userAgeFromString:age]];
        
        _blocked = [dictionary[@"users"][indexUser][@"blocked"] boolValue];
        
        _is_matched = [dictionary[@"users"][indexUser][@"is_matched"] boolValue];
    }
    
    return self;
}

- (NSInteger)userAgeFromString:(NSString *)age {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"YYYY-MM-DD";

    NSDate *birthDate = [dateFormatter dateFromString:age];

    NSDate *today = [NSDate date];

    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    NSUInteger units = NSCalendarUnitYear;

    NSDateComponents *components = [gregorian components:units fromDate:birthDate toDate:today options:0];
    
    return [components year];
}

@end
