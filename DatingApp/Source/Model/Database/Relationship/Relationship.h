//
//  Relationship.h
//  
//
//  Created by  Artem Kalinovsky on 8/13/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Relationship : NSManagedObject

@property (nonatomic, retain) NSString * relationshipId;
@property (nonatomic, retain) NSString * relationshipTitle;
@property (nonatomic, retain) NSNumber * isDefault;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
