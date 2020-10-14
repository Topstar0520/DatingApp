//
//  Image.h
//  DatingApp


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Image : NSManagedObject

@property (nonatomic, retain) NSString * imageId;
@property (nonatomic, retain) NSNumber * isAvatar;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) User *user;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
