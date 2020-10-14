//
//  Education.h
//  
//
//  Created by  Artem Kalinovsky on 8/13/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Education : NSManagedObject

@property (nonatomic, retain) NSString * educationId;
@property (nonatomic, retain) NSString * educationTitle;
@property (nonatomic, retain) NSNumber * isDefault;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
