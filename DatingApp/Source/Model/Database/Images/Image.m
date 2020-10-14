//
//  Image.m
//  DatingApp


#import "Image.h"
#import "User.h"
#import "NSManagedObjectContext+MagicalRecordRestKit.h"

@implementation Image

@dynamic imageId;
@dynamic isAvatar;
@dynamic name;
@dynamic path;
@dynamic index;
@dynamic user;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    Image *image = (Image *) [NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:[NSManagedObjectContext MR_temporaryContext]];
    
    image.imageId = dictionary[@"id"];
    
    image.isAvatar = dictionary[@"isAvatar"];
    
    image.name = dictionary[@"name"];
    
    image.path = dictionary[@"path"];
    
    image.index = dictionary[@"index"];
    
    return image;
}

@end
